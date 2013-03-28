http = require 'http'
xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require 'colors'
fs = require 'fs'

Encoder = require('node-html-encoder').Encoder
encoder = new Encoder('entity');

NV_CONFIG = 
	table : 
		Songs : "NVSongs"
		Albums : "NVAlbums"
	logPath : "./log/NVLog.txt"

class Nhacvui extends Module
	constructor : (@mysqlConfig, @config = NV_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoNVSongs : "INSERT INTO " + @table.Songs + " SET ?"
			_insertIntoNVAlbums : "INSERT INTO " + @table.Albums + " SET ?"
			_insertIntoNVSongs_Albums : "INSERT INTO " + @table.Songs_Albums + " SET ?"
		@utils = new Utils()
		@parser = new xml2js.Parser();
		super @mysqlConfig
		@logPath = @config.logPath
		@log = {}
		@_readLog()

	createTables : ->
		@connect()
		songsQuery = " create table IF NOT EXISTS " + @table.Songs + " (
					songid int,
					song_name varchar(255),
					artist_name varchar(255),
					annotation varchar(255),
					link varchar(255),
					link320 varchar(255)
					);"
		albumsQuery = "CREATE TABLE IF NOT EXISTS " + @table.Albums + " (
					albumid int,
					album_name varchar(255),
					album_artist varchar(255),
					topic varchar(100),
					plays int,
					song_name varchar(255),
					artist_name varchar(255),					
					link varchar(255)
					);"
		_query = songsQuery + albumsQuery
		
		@connection.query _query, (err, result)=>
			if err then console.log "Cannot create tables" else console.log "Tables: #{@table.Songs}, #{@table.Albums} have been created!"
			@end()

	resetTables : ->
		@connect()
		songsQuery = "truncate table #{@table.Songs} ;"
		albumsQuery = "truncate table #{@table.Albums} ;"
		_query = songsQuery+albumsQuery
		@connection.query _query, (err, result)=>
			if err then console.log "Cannot truncate tables" else console.log "Tables: #{@table.Songs}, #{@table.Albums} have been truncated!"
			@end()

	_storeSong : (id, song) ->
		_item = 
			songid : id
			song_name : encoder.htmlDecode song.title[0].trim()
			artist_name : encoder.htmlDecode song.description[0].replace("Thể hiện: ","").trim()
			link : song['jwplayer:file'][0]
		@connection.query @query._insertIntoNVSongs, _item, (err) =>
		 	if err then console.log "Cannot insert the song into table. ERROR: " + err	
		 	else @_updateSong320 _item.songid
	_storeSong320 : (id, song) ->
		_item = 
			songid : id
			annotation : encoder.htmlDecode song.annotation[0].replace("Thể hiện: ","").trim()
			link320 : song.location[0]
		_query = "update #{@table.Songs} set annotation=#{@connection.escape(_item.annotation)}, link320=#{@connection.escape(_item.link320)} where songid=#{_item.songid}"
		@connection.query _query, (err) ->
		 	if err then console.log "Cannot update the song: #{_item.songid} into table. ERROR: " + err + "....." + _query	
	_storeAlbum : (id,album) ->
		for song in album
			_item = 
				albumid : id
				song_name : encoder.htmlDecode song.title[0].trim()
				artist_name : encoder.htmlDecode song.description[0].replace("Thể hiện: ","").trim()
				link : song['jwplayer:file'][0]
			@connection.query @query._insertIntoNVAlbums,_item,(err) =>
				if err then console.log "Cannot get albumid: #{_item.albumid}. ERROR: ".red + err
				else @_updateAlbumName _item.albumid
	_storeAlbumName : (id, album)->
		_query = "UPDATE #{@table.Albums} SET " +
				" album_name   = #{@connection.escape(album.album_name)},"+
				" album_artist = #{@connection.escape(album.album_artist)}," +
				" topic = #{@connection.escape(album.topic)}," +
				" plays = #{album.plays}" +
				" where albumid = #{id};"
		
		@connection.query _query, (err)->
			if err then console.log "Cant not update albumid: #{id}. ERROR: " + err

	_updateSong : (id) ->
		link = "http://hcm.nhac.vui.vn/asx2.php?type=1&id=" + id
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@parser.parseString data, (err, result) =>
						song = result.rss.channel[0].item[0]
						@stats.totalItemCount+=1
						@utils.printUpdateRunning id, @stats, "Fetching..."
						if typeof song.title[0] isnt 'object'	
							@stats.currentId = id
							@stats.passedItemCount+=1
							@_storeSong id, song
							@log.lastSongId = id
							@_updateSong id+1
						else 
							@stats.failedItemCount+=1
							@temp.totalFail+=1
							@utils.printUpdateRunning id, @stats, "Fetching..."
							if @temp.totalFail < 100
								@_updateSong id+1
							else
								if @stats.passedItemCount is 0
									console.log ""
									console.log "Table: #{@table.Songs} is up-to-date"
								else 
									@utils.printFinalResult @stats
									@_writeLog @log
						
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	_updateSong320 : (id) ->
		link = "http://hcm.nhac.vui.vn/asx2.php?type=5&id=" + id
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@parser.parseString data, (err, result) =>
						song = result.rss.channel[0].track[0]
						data = ""
						if typeof song.title[0] isnt 'object'
							@_storeSong320 id, song
			.on 'error', (e) =>
				console.log  "Got error: " + e.message		
	_updateAlbum : (id) ->
		link = "http://hcm.nhac.vui.vn/asx2.php?type=3&id=" + id
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					transferEncoding =  res.headers['transfer-encoding']
					if res.headers['content-length']? then contentLength = parseInt res.headers['content-length']
					else contentLength = 0
					@stats.totalItemCount+=1
					@utils.printUpdateRunning id, @stats, "Fetching..."
					if transferEncoding is "chunked" or contentLength > 0
						@parser.parseString data, (err, result) =>
							album = result.rss.channel[0].item
							@stats.currentId = id
							@stats.passedItemCount+=1
							@_storeAlbum id, album
							@log.lastAlbumId = id
							@_updateAlbum id+1
					else 
						@stats.failedItemCount+=1
						@temp.totalFail+=1
						@utils.printUpdateRunning id, @stats, "Fetching..."
						if @temp.totalFail < 100
							@_updateAlbum id+1
						else
							if @stats.passedItemCount is 0
								console.log ""
								console.log "Table: #{@table.Albums} is up-to-date"
							else 
								@utils.printFinalResult @stats
								@_writeLog @log	
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	_updateAlbumName : (id) ->
		link = "http://hcm.nhac.vui.vn/-a#{id}p1.html"
		# Album không tồn tại.
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					if data.search('Album không tồn tại.') is -1
						title_artist = data.match(/\<div\sclass=\"nghenhac-baihat\"\>\<h\d\>.+/)[0]
							.replace(/\<div\sclass=\"nghenhac-baihat\"\>\<h\d\>/,'')
							.replace(/\<\/h\d\>\<\/div\>/,'')

						type_plays = data.match(/\<div\sclass=\"nghenhac-info\"\>.+/)[0]
							.replace(/\<div\sclass=\"nghenhac-info\"\>/,'')
							.replace(/Thể loại:\s\<a\shref=\"\/.+\.html\"\stitle=\".+\"\>/,'')
							.replace(/\<\/a\>\s/,'')
							.replace(/Nghe:\s/,'')
							.replace(/\<\/div\>/,'')
						data = ""
						
						#split by dash sign (-) EX: "Cpop Chart (15/6 - 22/6 ) - Various Artists"
						#_name = "Cpop Chart (15/6 - 22/6 )" and _artist="Various Artists"
						_arr = title_artist.split(/\s\-\s/)
						_artist = _arr[_arr.length-1]
						_arr.splice(_arr.length-1,1)
						_name = _arr.join(" - ")
						_arr = ""

						album = 
							album_name : encoder.htmlDecode _name.trim()
							album_artist : encoder.htmlDecode _artist.trim()
							topic : encoder.htmlDecode type_plays.split('|')[0].trim()
							plays : type_plays.split('|')[1].replace(/\,/g,'').trim()

						@_storeAlbumName id, album
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	
	_fetchSong : (id) ->
		link = "http://hcm.nhac.vui.vn/asx2.php?type=1&id=" + id
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@parser.parseString data, (err, result) =>
						song = result.rss.channel[0].item[0]
						@stats.totalItemCount+=1
						if typeof song.title[0] isnt 'object'	
							@stats.currentId = id
							@stats.passedItemCount+=1
							@_storeSong id, song
						else 
							@stats.failedItemCount+=1

						@utils.printRunning @stats

						if @stats.totalItemCount is @stats.totalItems
							@utils.printFinalResult @stats
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	_fetchAlbum : (id) ->
		link = "http://hcm.nhac.vui.vn/asx2.php?type=3&id=" + id
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					transferEncoding =  res.headers['transfer-encoding']
					if res.headers['content-length']? then contentLength = parseInt res.headers['content-length']
					else contentLength = 0
					@stats.totalItemCount+=1
					if transferEncoding is "chunked" or contentLength > 0
						@parser.parseString data, (err, result) =>
							album = result.rss.channel[0].item
							@stats.currentId = id
							@stats.passedItemCount+=1
							@_storeAlbum id, album
					else 
						@stats.failedItemCount+=1
					
					@utils.printRunning @stats
					if @stats.totalItemCount is @stats.totalItems
							@utils.printFinalResult @stats		
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	_fetchAlbumName : (id) ->
		link = "http://hcm.nhac.vui.vn/-a#{id}p1.html"
		# Album không tồn tại.
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					# console.log JSON.stringify data
					@stats.totalItemCount+=1
					if data.search('Album không tồn tại.') is -1
						@stats.passedItemCount+=1
						title_artist = data.match(/\<div\sclass=\"nghenhac-baihat\"\>\<h2\>.+/)[0]
							.replace(/\<div\sclass=\"nghenhac-baihat\"\>\<h2\>/,'')
							.replace(/\<\/h2\>\<\/div\>/,'')

						type_plays = data.match(/\<div\sclass=\"nghenhac-info\"\>.+/)[0]
							.replace(/\<div\sclass=\"nghenhac-info\"\>/,'')
							.replace(/Thể loại:\s\<a\shref=\"\/.+\.html\"\stitle=\".+\"\>/,'')
							.replace(/\<\/a\>\s/,'')
							.replace(/Nghe:\s/,'')
							.replace(/\<\/div\>/,'')
						data = ""
						
						#seperate by dash sign (-) EX: "Cpop Chart (15/6 - 22/6 ) - Various Artists"
						#_name = "Cpop Chart (15/6 - 22/6 )" and _artist="Various Artists"
						_arr = title_artist.split(/\s\-\s/)
						_artist = _arr[_arr.length-1]
						_arr.splice(_arr.length-1,1)
						_name = _arr.join(" - ")
						_arr = ""

						album = 
							album_name : encoder.htmlDecode _name.trim()
							album_artist : encoder.htmlDecode _artist.trim()
							topic : encoder.htmlDecode type_plays.split('|')[0].trim()
							plays : type_plays.split('|')[1].replace(/\,/g,'').trim()

						@_storeAlbumName id, album
						
					else 
						@stats.failedItemCount+=1

					@utils.printRunning @stats
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats	
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	
	fetchSongs : (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching songid: #{range0}..#{range1} to table: #{ @table.Songs}".magenta
		@stats.totalItems = range1 - range0 + 1
		[@stats.range0, @stats.range1] = [range0, range1]
		@stats.currentTable = @table.Songs
		@_fetchSong id for id in [range0..range1]
		null
	fetchAlbums : (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching albumid: #{range0}..#{range1} to table: #{@table.Albums}".magenta
		@stats.totalItems = range1 - range0 + 1
		[@stats.range0, @stats.range1] = [range0, range1]
		@stats.currentTable = @table.Albums
		@_fetchAlbum id for id in [range0..range1]
		null
	fetchAlbumName : (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching album's names from id: #{range0}..#{range1} to table: #{@table.Albums}".magenta
		@stats.totalItems = range1 - range0 + 1
		[@stats.range0, @stats.range1] = [range0, range1]
		@stats.currentTable = @table.Albums
		@_fetchAlbumName id for id in [range0..range1]
		null
	
	updateSongs : ->
		@connect()
		@_readLog()
		@temp = {}
		@temp.totalFail = 0
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating Songs to table: #{@table.Songs}".magenta 
		@_updateSong @log.lastSongId+1

	updateAlbums : ->
		@connect()
		@_readLog()
		@temp = {}
		@temp.totalFail = 0
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating Albums to table: #{@table.Albums}".magenta 
		@_updateAlbum @log.lastAlbumId+1



	showStats : ->
		@_printTableStats NV_CONFIG.table


module.exports = Nhacvui
