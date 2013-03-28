http = require 'http'
xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require 'colors'
fs = require 'fs'

NN_CONFIG = 
	table : 
		Songs : "NNSongs"
	logPath : "./log/NNLog.txt"

class Nghenhac extends Module
	constructor : (@mysqlConfig, @config = NN_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoNNSongs : "INSERT INTO " + @table.Songs + " SET ?"
		@utils = new Utils()
		@parser = new xml2js.Parser();
		super @mysqlConfig
		@logPath = @config.logPath
		@log = {}
		@_readLog()
		

	createTables : ->
		@connect()
		songsQuery = "CREATE TABLE IF NOT EXISTS " + @table.Songs + " (
					id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
					albumid int,
					album_name varchar(255),
					song_name varchar(255),
					artist_name varchar(255),
					album_plays int,
					albumEncodedId varchar(255),
					song_link varchar(255)
					);"
		@connection.query songsQuery, (err, result)=>
			if err then console.log "Cannot create table" else console.log "Tables: #{@table.Songs} have been created!"
			@end()
	resetTables : ->
		@connect()
		songsQuery = "truncate table #{@table.Songs} ;"
		@connection.query songsQuery, (err, result)=>
			if err then console.log "Cannot truncate tables" else console.log "Tables: #{@table.Songs} have been truncated!"
			@end()

	_updateAlbum : (id) ->
		link = "http://nghenhac.info/Album/joke-link/#{id}/.html"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@stats.totalItemCount+=1
					@utils.printUpdateRunning id, @stats, "Fetching..."
					if res.statusCode isnt 304 and res.statusCode isnt 302
						#do something
						try 
							album = 
								id : id
								encodedId : data.match(/PlayAlbumJson\.ashx\?p\=[0-9a-zA-Z]+/g)[0]
											.replace(/PlayAlbumJson\.ashx\?p\=/g,'')
								title :  data.match(/\<span\>Nghe\sAlbum.+\<\/span\>/g)[0]
										.replace(/\<span\>Nghe\sAlbum\s:/g,'')
										.replace(/\<\/span\>/g,'').trim()
							if data.match(/Chưa\sbầu\schọn\slần\snào/g) is null
								album.plays = data.match(/Bầu\schọn\:.+/g)[0]
											.replace(/\<.+\>/g,'')
											.replace(/Bầu\schọn\:\s\(/g,'')
											.replace(/\slần\)/g,'')
											.replace(/\sđiểm/g,'').trim()
											.split(',').reduce((x,y)-> parseInt(x,10)+parseInt(y,10))
							else album.plays = 0
							data = ''
							@stats.passedItemCount +=1
							@temp.totalFail +=0
							@log.lastAlbumId = id
							@_fetchSongs album
							@_updateAlbum id+1
						catch e
							console.log "ERROR: #{e} at album: #{id}".red
							console.log res.statusCode
					else 
						@stats.failedItemCount +=1
						@temp.totalFail +=1
						@utils.printUpdateRunning id, @stats, "Fetching..."
						if @temp.totalFail is 100
							if @stats.passedItemCount isnt 0 
								@utils.printFinalResult @stats
							else 
								console.log ""
								console.log "Table: #{@table.Songs} is up-to-date"
							@_writeLog @log						
						else
							@_updateAlbum id+1
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1

	_fetchAlbum : (id) ->
		link = "http://nghenhac.info/Album/joke-link/#{id}/.html"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@stats.totalItemCount+=1
					if res.statusCode isnt 304 and res.statusCode isnt 302
						#do something
						try 
							album = 
								id : id
								encodedId : data.match(/PlayAlbumJson\.ashx\?p\=[0-9a-zA-Z]+/g)[0]
											.replace(/PlayAlbumJson\.ashx\?p\=/g,'')
								title :  data.match(/\<span\>Nghe\sAlbum.+\<\/span\>/g)[0]
										.replace(/\<span\>Nghe\sAlbum\s:/g,'')
										.replace(/\<\/span\>/g,'').trim()
							if data.match(/Chưa\sbầu\schọn\slần\snào/g) is null
								album.plays = data.match(/Bầu\schọn\:.+/g)[0]
											.replace(/\<.+\>/g,'')
											.replace(/Bầu\schọn\:\s\(/g,'')
											.replace(/\slần\)/g,'')
											.replace(/\sđiểm/g,'').trim()
											.split(',').reduce((x,y)-> parseInt(x,10)+parseInt(y,10))
							else album.plays = 0
							data = ''
							@stats.passedItemCount +=1
							@_fetchSongs album
						catch e
							console.log "ERROR: #{e} at album: #{id}".red
							console.log res.statusCode
					else 
						@stats.failedItemCount +=1

					@utils.printRunning @stats
					if @stats.totalItems is @stats.totalItemCount
							@utils.printFinalResult @stats
			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	_fetchSongs : (album) ->
		link = "http://nghenhac.info/Farm/PlayAlbumJson.ashx?p=#{album.encodedId}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					data = JSON.parse data
					for song in data
						try 
							song = 
								albumid : album.id
								album_name : album.title
								song_name : song.title.trim()
								artist_name : song.artist.trim()
								album_plays : album.plays
								albumEncodedId : album.encodedId
								song_link : song.mp3
							@connection.query @query._insertIntoNNSongs, song, (err)->
								if err then console.log "CANNOT insert songid #{song.songid}".red
						catch e
							console.log "ERROR: #{e} at album: #{album.id}".red
					
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	
	fetchAlbums : (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching songid: #{range0}..#{range1} to table: #{@table.Songs}".magenta
		@stats.totalItems = (range1 - range0 + 1)
		[@stats.range0, @stats.range1] = [range0, range1]
		@stats.currentTable = @table.Songs
		@_fetchAlbum id for id in [range0..range1]
		null

	update : ->
		#update songs and albums
		@connect()
		@_readLog()
		@temp = 
			totalFail : 0
		@stats.currentTable = @table.Songs
		console.log " |"+"Updating Albums + Songs to table: #{@table.Songs}".magenta
		@_updateAlbum(@log.lastAlbumId+1)

	showStats : ->
		@_printTableStats NN_CONFIG.table


module.exports = Nghenhac
