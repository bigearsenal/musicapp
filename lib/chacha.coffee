http = require 'http'
xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require 'colors'
fs = require 'fs'

CC_CONFIG = 
	table : 
		Songs : "CCSongs"
		Albums : "CCAlbums"
	logPath : "./log/CCLog.txt"

class Chacha extends Module
	constructor : (@mysqlConfig, @config = CC_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoCCSongs : "INSERT INTO " + @table.Songs + " SET ?"
			_insertIntoCCAlbums : "INSERT INTO " + @table.Albums + " SET ?"
		@utils = new Utils()
		@parser = new xml2js.Parser();
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

	_storeSong : (song) ->
		if song.thumb.match(/artists\/\/s5\/\d+/) 
			_artistid = parseInt song.thumb.match(/artists\/\/s5\/\d+/)[0].replace(/artists\/\/s5\//,'')
		else _artistid = 0
		_duration = parseInt(song.duration.split(':')[0])*60+parseInt(song.duration.split(':')[1])
		_item = 
			songid : song.id
			song_name : song.name.trim()
			album : song.album.trim()
			artistid : _artistid
			artist_name : song.artist.trim()
			duration : _duration
			bitrate : parseInt song.bitrate
			thumbnail : song.thumb
			link : song.url

		@connection.query @query._insertIntoCCSongs, _item, (err) ->
		 	if err then console.log "Cannot insert the song into table. ERROR: " + err	
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
						else @_updateSong id+1
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	_updateAlbum : (id) ->
		link = "http://www.chacha.vn/album/play/#{id}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@stats.totalItemCount +=1
					@utils.printUpdateRunning id, @stats, "Fetching..."
					if data isnt "[]"
						@stats.passedItemCount +=1
						data = JSON.parse data
						@log.lastAlbumId = id
						@_updateAlbumName id, data
						@_updateAlbum id+1
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
								console.log "Table: #{@table.Albums} is up-to-date"
						else @_updateAlbum id+1
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
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
	updateSongs : ->
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
		@_updateAlbum @log.lastAlbumId+1

	showStats : ->
		@_printTableStats CC_CONFIG.table


module.exports = Chacha
