http = require 'http'
xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require 'colors'
fs = require 'fs'

events = require('events')

Encoder = require('node-html-encoder').Encoder
encoder = new Encoder('entity');


CC_CONFIG = 
	table : 
		Songs : "CCSongs"
		Albums : "CCAlbums"
		Songs_Albums : "CCSongs_Albums"
	logPath : "./log/CCLog.txt"

class Chacha extends Module
	constructor : (@mysqlConfig, @config = CC_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoCCSongs : "INSERT INTO " + @table.Songs + " SET ?"
			_insertIntoCCAlbums : "INSERT INTO " + @table.Albums + " SET ?"
			_insertIntoCCSongs_Albums : "INSERT INTO " + @table.Songs_Albums + " SET ?"
		@utils = new Utils()
		@parser = new xml2js.Parser();
		@eventEmitter = new events.EventEmitter()
		super @mysqlConfig
		@logPath = @config.logPath
		@log = {}
		@_readLog()

	createTables : ->
		@connect()
		songsQuery = "CREATE TABLE IF NOT EXISTS " + @table.Songs + " (
					songid int NOT NULL,
					song_name varchar(255),
					album varchar(200),
					artistid int,
					artist_name varchar(255),
					duration int,
					bitrate int,
					thumbnail varchar(255),
					link varchar(255)
					);"
		albumsQuery = "CREATE TABLE IF NOT EXISTS " + @table.Albums+ " (
					albumid int NOT NULL,
					album_name varchar(255),
					album_artist varchar(200),
					songid int
					);"
		_query = songsQuery +  albumsQuery
		@connection.query _query, (err, result)=>
			if err then console.log "Cannot create table" else console.log "Tables: #{@table.Songs} and #{@table.Albums} have been created!"
			@end()
	resetTables : ->
		@connect()
		songsQuery = "truncate table #{@table.Songs} ;"
		@connection.query songsQuery, (err, result)=>
			if err then console.log "Cannot truncate tables" else console.log "Tables: #{@table.Songs} have been truncated!"
			@end()

	getFileByHTTP : (link, onSucess, onFail, options) ->
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				# onSucess res.headers.location
				if res.statusCode isnt 302
					res.on 'data', (chunk) =>
						data += chunk;
					res.on 'end', () =>
						onSucess data, options
				else onFail("The link is temporarily moved",options)
			.on 'error', (e) =>
				onFail  "Cannot get file from server. ERROR: " + e.message, options


	_storeSong : (song) ->
		if song.thumb.match(/artists\/\/s5\/\d+/) 
			_artistid = parseInt song.thumb.match(/artists\/\/s5\/\d+/)[0].replace(/artists\/\/s5\//,'')
		else _artistid = 0
		_duration = parseInt(song.duration.split(':')[0])*60+parseInt(song.duration.split(':')[1])
		_item = 
			songid : song.id
			song_name : song.name.trim()
			artistid : _artistid
			artist_name : song.artist.trim()
			duration : _duration
			bitrate : parseInt song.bitrate
			thumbnail : song.thumb
			link : song.url

		@connection.query @query._insertIntoCCSongs, _item, (err) ->
		 	if err then console.log "Cannot insert the song into table. ERROR: " + err	
		_item
	_storeAlbum : (id, album, name, artist) ->
		for song, index in album
			if song.thumb.match(/artists\/\/s5\/\d+/) 
				_artistid = parseInt song.thumb.match(/artists\/\/s5\/\d+/)[0].replace(/artists\/\/s5\//,'')
			else _artistid = 0
			_duration = parseInt(song.duration.split(':')[0])*60+parseInt(song.duration.split(':')[1])
			_item = 
				albumid : id
				album_name : name
				album_artist : artist
				songid : song.id
			@connection.query @query._insertIntoCCAlbums, _item, (err) =>
			 	if err then console.log "Cannot insert the song into table: #{@table.Albums}. ERROR: " + err
			 	
	_updateSong : (id) ->
		link = "http://www.chacha.vn/song/play/#{id}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@stats.totalItemCount +=1
					@utils.printUpdateRunning id, @stats, "Fetching..."
					if res.statusCode is 200
						@stats.passedItemCount +=1
						data = JSON.parse data
						@_storeSong data
						@log.lastSongId = id
						@_updateSong id+1
						# if the record fails consecutively 100 times, it would stop
						@temp.totalFail = 0
					else 
						@stats.failedItemCount +=1
						@temp.totalFail +=1
						@utils.printUpdateRunning id, @stats, "Fetching..."
						if @temp.totalFail is 100
							if @stats.passedItemCount isnt 0
								@utils.printFinalResult @stats
								@_writeLog @log
							else 
								console.log ""
								console.log "Table: #{@table.Songs} is up-to-date"
							@resetStats()
							@updateAlbums()
						else @_updateSong id+1
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1

	processAlbum : (data,options)=>
		if data isnt null
			album =
				albumid : options.id
				album_name : ""
				album_artist : ""
				nsongs : 0
				thumbnail : ""
				plays : 0
			arr = data.match(/\<meta\sname\=\"title\".+\/\>/g)[0]
				.replace(/\<meta\sname\=\"title\"\scontent\=\"/,'')
				.match(/^.+\|/)[0].replace(/\|/,'').trim()
				.split('-')
			
			album.album_name = arr[0]?.trim()
			album.album_artist = arr[1]?.trim()

			album.thumbnail = data.match(/album-image.+[\r\n\t]+.+/g)?[0]
			if album.thumbnail isnt undefined
				album.thumbnail = album.thumbnail.replace(/\?.+/g,'').replace(/album-image.+[\r\n\t]+.+\"/g,'')
			else album.thumbnail = ""

			album.description = data.match(/full-desc.+/)?[0]
			if album.description isnt undefined
				album.description = encoder.htmlDecode album.description
												.replace(/<br\/><a.+view-more-full.+$/g,'')
												.replace(/full-desc\">/g,'')
												.replace(/<\/p>$/g,'').replace(/^<p>/g,'')
												.replace(/<\/span>$/g,'').replace(/^<span.+\">/g,'')
												.replace(/<\/p>$/g,'').replace(/^<p.+\">/g,'')
				if album.description.match(/songLyric/) or album.description.match(/Đang cập nhật thông tin/ig) then album.description = ""
			
			plays  = data.match(/total-played.+/g)
			sum = 0
			if plays isnt null
				plays = plays.map (v)-> v.replace(/<\/span>/g,'').replace(/total-played\">/g,'')
				plays.forEach (v)-> if v isnt '' then sum += parseInt(v)
				album.nsongs = plays.length-1
				sum = sum/album.nsongs if plays.length > 1
			album.plays = sum | 0

			songs = data.match(/avatar\sinline\splayer\ssong\d+/g)
			if songs isnt null
				songs = songs.map (v) -> v.replace(/avatar\sinline\splayer\ssong/g,'')
			album.songs = songs
		else 
			album = null

		@eventEmitter.emit 'result', album
		album
	_updateAlbum : (id) ->
		link = "http://www.chacha.vn/album/fake-link,#{id}.html"
		options = 
			id : id
		@stats.totalItemCount +=1
		@utils.printUpdateRunning id, @stats, "Fetching..."
		onFail = (err, options)=>
			@stats.failedItemCount += 1
			@temp.totalFail +=1
			
			if @temp.totalFail < 100
				@_updateAlbum options.id+1
			else
				if @stats.totalItemCount is 100
					console.log ""
					console.log "Table: #{@table.Albums} is up-to-date"
				else 
					@utils.printFinalResult @stats
					@_writeLog @log
		@getFileByHTTP link, @processAlbum, onFail, options

	_updateAlbumName : (id, album) ->
		link = "http://www.chacha.vn/album/fake-link,#{id}.html"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					if res.statusCode is 410
						@stats.passedItemCount -=1
						@stats.failedItemCount +=1
						@utils.printUpdateRunning id, @stats, "Fetching..."
					else
						arr = data.match(/\<meta\sname\=\"title\".+\/\>/g)[0]
							.replace(/\<meta\sname\=\"title\"\scontent\=\"/,'')
							.match(/^.+\|/)[0].replace(/\|/,'').trim()
							.split('-')
						name = arr[0].trim()
						artist = arr[1].trim()
						data = ""
						@_storeAlbum id, album, name, artist
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	_fetchSongs : (id) ->
		link = "http://www.chacha.vn/song/play/#{id}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@stats.totalItemCount +=1
					if res.statusCode is 200
						@stats.passedItemCount +=1
						data = JSON.parse data
						@_storeSong data
						@utils.printRunning @stats
					else @stats.failedItemCount +=1
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	
	fetchAlbums : (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching songid: #{range0}..#{range1} to table: #{@table.Songs}".magenta
		@stats.totalItems = (range1 - range0 + 1)
		[@stats.range0, @stats.range1] = [range0, range1]
		@stats.currentTable = @table.Albums
		@_fetchAlbum id for id in [range0..range1]
		null
	fetchSongs : (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching songid: #{range0}..#{range1} to table: #{@table.Songs}".magenta
		@stats.totalItems = (range1 - range0 + 1)
		[@stats.range0, @stats.range1] = [range0, range1]
		@stats.currentTable = @table.Songs
		for id in [range0..range1]
			do (id) =>
				@_fetchSongs id
		null
	update : ->
		@connect()
		@_readLog()
		@temp = {}
		@temp.totalFail = 0
		@stats.currentTable = @table.Songs
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating Songs to table: #{@table.Songs}".magenta 
		@_updateSong @log.lastSongId+1

	updateAlbums : ->
		@connect()
		@_readLog()
		@temp = {}
		@temp.totalFail = 0
		@stats.currentTable = @table.Albums
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating Albums to table: #{@table.Albums}".magenta 
		@temp = 
			totalFail : 0
		@eventEmitter.on 'result', (result)=>
			if result isnt null
				@stats.passedItemCount +=1
				@temp.totalFail +=0
				@log.lastAlbumId = result.albumid
				songs = result.songs
				delete result.songs
				if songs isnt null
					@connection.query @query._insertIntoCCAlbums, result, (err)=>
						if err then console.log "cannt insert album: #{result.albumid} into table. ERROR #{err}"
						else 
							for song in songs
								do (song)=>
									@connection.query @query._insertIntoCCSongs_Albums, {albumid : result.albumid, songid : song}, (err)->
										if err then console.log "cannt insert song #{song} into table. ERROR #{err}"
				else 
					@stats.passedItemCount -=1
					@stats.failedItemCount +=1
					@temp.totalFail +=1
			else 
				@stats.failedItemCount +=1
				@temp.totalFail +=1
			# console.log result
			
			@_updateAlbum result.albumid+1
			

		@_updateAlbum @log.lastAlbumId+1



	# processItem : (id)->
	# 	try
	# 		if id < 100 then _id = "0#{id}"
	# 		else _id = id
	# 		url = "./chacha/quocte-#{_id}.html"
	# 		topic = '["Nhạc Quốc Tế Remix"]'
	# 		fs.readFile url,"utf8", (err,data)=>
	# 			@stats.totalItemCount +=1
	# 			@stats.currentId = id
	# 			if data isnt undefined
					
	# 				songs = []
	# 				song = {}
	# 				plays  = data.match(/total-played.+/g)
	# 				if plays isnt null
	# 					plays = plays.map (v)-> 
	# 						_t = v.replace(/<\/span>/g,'').replace(/total-played\">|lượt/g,'').trim()
	# 						if _t is ''
	# 							_t = 0
	# 						_t
		
	# 				items = data.match(/song-title.+[\n\t\r]+.+/g)
	# 				if items isnt null
	# 					items = items.map (v)-> v.replace(/\.html\"/g,'').replace(/song-title.+[\n\t\r]+.+,/g,'')
					
	# 				if items isnt null and plays isnt null 
	# 					if items.length is plays.length
	# 						for i in [0..items.length-1]
	# 							@stats.passedItemCount +=1
	# 							# console.log song
	# 							_u = "update #{@table.Songs} SET topic=#{@connection.escape topic}, plays=#{plays[i]} where songid=#{items[i]}"
	# 							@connection.query _u, (err)=>
	# 								if err then console.log "Error while inserting table. ERROR: #{err}"
						

	# 			else @stats.failedItemCount +=1

	# 			if @temp <= 24
	# 				@processItem (id+1)
	# 				@temp += 1
		
	# 			@utils.printRunning @stats
	# 			if @stats.totalItems is @stats.totalItemCount
	# 				@utils.printFinalResult @stats
	# 	catch e
	# 		console.log e
	# getSongsTopic : ->
	# 	@connect()
	# 	console.log "update songs plays and topic"
	# 	@eventEmitter.on 'result', (result)=>
	# 		console.log result

	# 	@temp = 0

	# 	range = [1..24]
		
	# 	@stats.totalItems = range.length
		
	# 	@processItem 1

				

	showStats : ->
		@_printTableStats CC_CONFIG.table


module.exports = Chacha
