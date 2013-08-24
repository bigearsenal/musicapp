http = require 'http'
# xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require '../node_modules/colors'
fs = require 'fs'

events = require('events')

Encoder = require('../node_modules/node-html-encoder').Encoder
encoder = new Encoder('entity');


CC_CONFIG = 
	table : 
		Songs : "ccsongs"
		Albums : "ccalbums"
		Songs_Albums : "ccsongs_albums"
	logPath : "./log/CCLog.txt"

class Chacha extends Module
	constructor : (@mysqlConfig, @config = CC_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoCCSongs : "INSERT IGNORE INTO " + @table.Songs + " SET ?"
			_insertIntoCCAlbums : "INSERT IGNORE INTO " + @table.Albums + " SET ?"
			_insertIntoCCSongs_Albums : "INSERT INTO " + @table.Songs_Albums + " SET ?"
		@utils = new Utils()
		# @parser = new xml2js.Parser();
		String::stripHtmlTags = (tag)->
			if not tag then tag = ""
			@.replace(RegExp("</?" + tag + "[^<>]*>", "gi"), "")
		Array::splitBySeperator = (seperator) ->
			result = []
			for val in @
				_a = val.split(seperator)
				for item in _a
					result.push item.trim()
			return result
		Array::replaceElement = (source,value)->
			for val,index in @
				if val is source
					@[index] = value
			return @
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
		if song.artist.trim()
			artists = song.artist.trim().split().splitBySeperator(' - ').splitBySeperator('- ')
										.splitBySeperator(' ft. ').splitBySeperator(' ft ')
										.splitBySeperator(' _ ')
										.splitBySeperator(',').replaceElement('V.A',"Various Artists")
										.replaceElement('Nhiều ca sĩ',"Various Artists").replaceElement('Nhiều Ca Sĩ',"Various Artists")
		else artists = []
		_item = 
			id : song.id
			title : song.name.trim()
			artistid : _artistid
			artists : artists
			duration : _duration
			bitrate : parseInt song.bitrate
			coverart : song.thumb
			link : song.url

		# console.log _item
		# process.exit 0

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
				id : options.id
				title : ""
				artists : []
				nsongs : 0
				coverart : ""
				plays : 0
				songids : null
			
			title = data.match(/<meta name="title" content="(.+)"/)?[0]
			title = title.replace(/\|.+$/g,'').replace(/<meta name="title" content="/,'').replace(/-[\s]+$/,'').trim() if title 
			artists = data.match(/artist-name[^]+?<\/a>/)?[0]

			if artists
				artists = artists.replace(/^.+>/,'').replace(/<\/a>/,'').trim()
				# to prevent artist name from appearing on title
				try
					pattern = new RegExp(artists.trim(),"g")
					title = title.replace(pattern,'')
					album.title = title.replace(/[-\s]+$/,'').replace(/^[\s-]+/,'').trim()
				catch e
					album.title = title.replace(/[-\s]+$/,'').replace(/^[\s-]+/,'').trim()
				
				artists = artists.trim().split().splitBySeperator(' - ').splitBySeperator('- ')
										.splitBySeperator(' ft. ').splitBySeperator(' ft ')
										.splitBySeperator(' _ ')
										.splitBySeperator(',').replaceElement('V.A',"Various Artists")
										.replaceElement('Nhiều ca sĩ',"Various Artists").replaceElement('Nhiều Ca Sĩ',"Various Artists")
			else 
				artists = []
				album.title = title.replace(/[-\s]+$/,'').replace(/^[\s-]+/,'').trim()
			album.artists = artists

			album.coverart = data.match(/album-image.+[\r\n\t]+.+/g)?[0]
			if album.coverart isnt undefined
				album.coverart = album.coverart.replace(/\?.+/g,'').replace(/album-image.+[\r\n\t]+.+\"/g,'')
			else album.coverart = ""

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
				album.songids = songs.map (v)-> parseInt v,10
		else 
			album = null


		# console.log album
		# process.exit 0
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
		console.log " |"+"Updating Songs to table: #{@table.Songs}, Last ID: #{@log.lastSongId}".magenta 
		@_updateSong @log.lastSongId+1

	updateAlbums : ->
		@connect()
		@_readLog()
		@temp = {}
		@temp.totalFail = 0
		@stats.currentTable = @table.Albums
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating Albums to table: #{@table.Albums}, Last ID: #{@log.lastAlbumId}".magenta 
		@temp = 
			totalFail : 0
		@eventEmitter.on 'result', (result)=>
			if result isnt null
				@stats.passedItemCount +=1
				@temp.totalFail +=0
				@log.lastAlbumId = result.id
				# songs = result.songs
				# delete result.songs

				if result.songids isnt null
					# console.log result
					# process.exit 0
					# console.log "#{@query._insertIntoCCAlbums}"
					@connection.query @query._insertIntoCCAlbums, result, (err)=>
						if err then console.log "cannt insert album: #{result.id} into table. ERROR #{err}"
						# console.log "dsfsfsdafsdf"
						# process.exit 0
				else 
					@stats.passedItemCount -=1
					@stats.failedItemCount +=1
					@temp.totalFail +=1
			else 
				@stats.failedItemCount +=1
				@temp.totalFail +=1
			# console.log result
			
			@_updateAlbum result.id+1
			

		@_updateAlbum @log.lastAlbumId+1
		
		# @_updateAlbum 4047	

	showStats : ->
		@_printTableStats CC_CONFIG.table


module.exports = Chacha
