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
	HTTPGet : (link, options, callback) ->
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				# onSucess res.headers.location
				if res.statusCode isnt 302
					res.on 'data', (chunk) =>
						data += chunk;
					res.on 'end', () =>
						callback null, data, options
				else callback("The link is temporarily moved",null,options)
			.on 'error', (e) =>
				callback  "Cannot get file from server. ERROR: " + e.message, null,options

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
	
	processSongLink : (song,callback)->
		url = "http://beta.chacha.vn/player/songXml/#{song.id}"
		options = {}
		@HTTPGet url, options, (err,data)=>
			if err  
				console.log err
			else 
				if data.match(/label=\"320K\"/)
					song.bitrate = 320
					song.link = data.match(/(http.+?)\".+label="320K"/)?[1]
				else if data.match(/label=\"128K\"/)
						song.bitrate = 128
						song.link = data.match(/(http.+?)\".+label="128K"/)?[1]
					else console.log "Error at song id: #{song.id} in processSongLink() "
			callback song
	processSong : (data,options,callback) ->
		song = 
			id : options.id
			title  : ""
			artistid : 0
			artists : []
			topics : []
			plays : 0
			lyrics : ""
			bitrate : 0
			duration : 0
			link : ""
			coverart  : ""

		try 
			title = data.match(/<h2 class=\"name\">(.+)<\/h2>/)?[1]
			if title
				song.title = encoder.htmlDecode title.trim()
			artists = data.match(/Nghệ sĩ:[^]+?<\/a>/)?[0]

			if artists
				song.artistid = parseInt(artists.match(/([0-9]+)\.html/)?[1],10)
				song.artists = artists.stripHtmlTags().replace(/Nghệ sĩ:/,'').trim().split().splitBySeperator(' - ').splitBySeperator('- ')
										.splitBySeperator(' ft. ').splitBySeperator(' ft ')
										.splitBySeperator(' _ ')
										.splitBySeperator(',').replaceElement('V.A',"Various Artists")
										.replaceElement('Nhiều ca sĩ',"Various Artists").replaceElement('Nhiều Ca Sĩ',"Various Artists")

			coverart = data.match(/og:image.+content=\"(.+)\"/)?[1]
			if coverart
				song.coverart = coverart

			topics = data.match(/Thể loại:[^]+?<\/a>/g)?[0]
			if topics
				song.topics = topics.stripHtmlTags().replace("Thể loại:","").trim().split()

			plays = data.match(/([0-9]+)\s*lượt nghe/)?[1]
			if plays 
				song.plays = parseInt(plays,10)

			lyrics = data.match(/<p class=\"lyric\" id=\"lyric_box\">([^]+)<a class.+lyric_more/)?[1]
			if lyrics 
				song.lyrics = encoder.htmlDecode lyrics.trim().replace(/<\/div>$/,'').trim().replace(/<\/p>$/,'').trim()

			@processSongLink song, callback

		catch e
			console.log "Error at songid : #{song.id}, #{e}"
		return song
	_updateSong : (id) ->
		# id = 716470 850786
		url = "http://beta.chacha.vn/song/joke,#{id}.html"
		options = 
			id : id
		@HTTPGet url , options,(err,response)=>
			@stats.totalItemCount +=1
			if err  
				# console.log err
				@stats.failedItemCount +=1
				@utils.printUpdateRunning id, @stats, "Fetching"
			else 
				if not response.match(/Không tìm thấy bài hát/g)
					@processSong response,options,(song)=>
						# console.log song
						@connection.query @query._insertIntoCCSongs, song, (err)->
							if err then console.log err
					@stats.passedItemCount +=1
					@log.lastSongId = id
					@temp.totalFail = 0
					@utils.printUpdateRunning id, @stats, "Fetching"
					@_updateSong id+1
				else 
					@stats.failedItemCount +=1
					@temp.totalFail +=1
					@utils.printUpdateRunning id, @stats, "Fetching"
					if @temp.totalFail is 500
						if @stats.passedItemCount isnt 0
							@utils.printFinalResult @stats
							@_writeLog @log
						else 
							console.log ""
							console.log "Table: #{@table.Songs} is up-to-date"
						@resetStats()
						console.log "UPDATING ALBUMS...... WAITING......"
						# @updateAlbums()
					else @_updateSong id+1
				
				

	processAlbum : (data,options)=>
		if data isnt null or data.match(/<h1>Lỗi:<\/h1>/)
			album =
				id : options.id
				title : ""
				artists : []
				nsongs : 0
				coverart : ""
				plays : 0
				description : ""
				year_released : 0
				topics : []
				songids : []
			title = data.match(/<h2 class=\"name\">(.+)<\/h2>/)?[1]
			if title
				album.title = encoder.htmlDecode title.trim()

			artists = data.match(/<li>Nghệ sĩ:([^]+?)<\/li>/)?[1]
			if artists
				album.artists = encoder.htmlDecode(artists.stripHtmlTags()).trim().replace(/\r|\t|\n/g,'')
										.replace(/(\s\s\s)+/g,'')
										.split().splitBySeperator(' - ').splitBySeperator('- ')
										.splitBySeperator(' ft. ').splitBySeperator(' ft ')
										.splitBySeperator(' _ ')
										.splitBySeperator(',').replaceElement('V.A',"Various Artists")
										.replaceElement('Nhiều ca sĩ',"Various Artists").replaceElement('Nhiều Ca Sĩ',"Various Artists")
										.map (v)-> return v.trim()
			yearReleased = data.match(/Năm phát hành:(.+?)<\/li>/)?[1]
			if yearReleased
				album.year_released = parseInt yearReleased.stripHtmlTags().trim(),10

			topics = data.match(/<li>Thể loại:([^]+?)<\/li>/)?[1]
			if topics 
				album.topics = topics.stripHtmlTags().trim().split().splitBySeperator(', ').splitBySeperator(' - ')

			plays = data.match(/<i class=\"icon icon_alb_listen\"><\/i>([0-9]+) Lượt nghe<\/p>/)?[1]
			if plays
				album.plays = parseInt(plays,10)

			nsongs = data.match(/Số bài hát:(.+?)<\/li>/)?[1]
			if nsongs
				album.nsongs = parseInt(nsongs.stripHtmlTags().trim(),10)

			desc = data.match(/desc_box.+\">([^]+?)<\/p>/)?[1]
			if desc
				album.description = desc.stripHtmlTags().trim()

			coverart = data.match(/<img class=\"detail\" src=\"(.+?)\"/)?[1]
			if coverart
				album.coverart = coverart

			songids = data.match(/<li id=\"song_[0-9]+\" value=\"[0-9]+\">/g)
			if songids 
				songids = songids.map (v)-> 
					_t = v.match(/value=\"([0-9]+)\"/)?[1]
					if _t then return parseInt(_t) else return 0
				album.songids = songids

			# to find duration of song
			songDurations = data.match(/<div class=\"col4 flr\">(.+)<\/div>/g)
			if songDurations
				songDurations = songDurations.map (v)-> 
					_t = v.match(/<div class=\"col4 flr\">(.+)<\/div>/)?[1]
					if _t.split(":").length isnt 2
						return 0
					else 
						time = _t.split(":")
						mins = time[0]
						secs = time[1]
						return 60*parseInt(mins,10) + parseInt(secs,10)
			
			# define songs
			#  songs = [{id : 123,duration : 232},{id : 123,duration : 232},{id : 123,duration : 232}]
			songs = []
			for value,index in album.songids
				songs.push {id : value,duration : songDurations[index]}
			
			for song in songs
				upd  = "UPDATE #{@table.Songs} SET duration = #{song.duration} WHERE duration = 0 and id = #{song.id}"
				# console.log upd

		else 
			album = null

		# console.log album
		# process.exit 0

		@eventEmitter.emit 'result', album
		album
	_updateAlbum : (id) ->
		link = "http://beta.chacha.vn/album/joke,#{id}.html"

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
				if result.songids.length is 0 then result.songids = null
				if result.songids isnt null
					@connection.query @query._insertIntoCCAlbums, result, (err)=>
						if err then console.log "cannt insert album: #{result.id} into table. ERROR #{err}"
				else 
					@stats.passedItemCount -=1
					@stats.failedItemCount +=1
					@temp.totalFail +=1
			else 
				@stats.failedItemCount +=1
				@temp.totalFail +=1

			if @temp.totalFail < 100
				@_updateAlbum result.id+1
			else
				if @stats.totalItemCount is 100
					console.log ""
					console.log "Table: #{@table.Albums} is up-to-date"
				else 
					@utils.printFinalResult @stats
					@_writeLog @log
					
		@_updateAlbum @log.lastAlbumId+1

	updateAlbumsStats: ->
		@connect()
		@connection.query "SELECT id from #{@table.Albums}", (err,results)=>
			if err then console.log err
			else 
				als = results.map (v) -> return v.id
				# console.log als
				@stats.totalItems = als.length
				for id in als
					do (id)=>
						link = "http://beta.chacha.vn/album/joke,#{id}.html"
						options = 
							id : id
						@HTTPGet link, options, (err,response,options)=>
							@stats.totalItemCount +=1
							if err 
								@stats.failedItemCount +=1
							else 
								album = @processAlbum response,options
								upd = "UPDATE #{@table.Albums} SET year_released=#{album.year_released}, topics=#{@connection.escape JSON.stringify(album.topics).replace(/^\[/,'{').replace(/\]$/,'}')}"
								upd += " WHERE id = #{album.id}"
								@connection.query upd,(err)->
									if err then console.log err
								@stats.passedItemCount +=1

							@utils.printRunning @stats
							if @stats.totalItems is @stats.totalItemCount
								@utils.printFinalResult @stats
								





	showStats : ->
		@_printTableStats CC_CONFIG.table


module.exports = Chacha
