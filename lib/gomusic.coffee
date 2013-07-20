http = require 'http'
fs = require 'fs'
# xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require '../node_modules/colors'
Encoder = require('../node_modules/node-html-encoder').Encoder
encoder = new Encoder('entity');

GM_CONFIG =
	table :
		GMSongs : "gmsongs"
		GMAlbums : "gmalbums"
		GMSongs_Albums : "gmsongs_albums"
	logPath : "./log/GMLog.txt"

class Gomusic extends Module
	constructor : (@mysqlConfig, @config = GM_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoGMSongs : "INSERT INTO " + @table.GMSongs + " SET ?"
			_insertIntoGMAlbums : "INSERT INTO " + @table.GMAlbums + " SET ?"
			_insertIntoGMSongs_Albums : "INSERT INTO " + @table.GMSongs_Albums + " SET ?"
		@utils = new Utils()
		# @parser = new xml2js.Parser();
		super @mysqlConfig
		@logPath = @config.logPath
		@log = {}
		@_readLog()

	_storeSong : (song) ->
		try
			_createTime = song.CreateTime.match(/\/[0-9]+$/g)[0].replace(/\//g,'') + "-" 
			_createTime += song.CreateTime.match(/[0-9]+\//g)[1].replace(/\//g,'') + "-"
			_createTime += song.CreateTime.match(/[0-9]+\//g)[0].replace(/\//g,'')

			_updateTime = song.UpdateTime.match(/\/[0-9]+$/g)[0].replace(/\//g,'') + "-" 
			_updateTime += song.UpdateTime.match(/[0-9]+\//g)[1].replace(/\//g,'') + "-"
			_updateTime += song.UpdateTime.match(/[0-9]+\//g)[0].replace(/\//g,'')

		catch e
			console.log ""
			console.log "Error while creating Record of Column CreateTime and UpdateTime "
		
		_item = 
			SongId : song.Id
			SongName : song.Name.trim()
			ArtistId : song.ArtistId
			ArtistName : song.ArtistName.trim()
			ArtistDisplayName : song.ArtistDisplayName.trim()
			TopicId : song.TopicId
			TopicName : song.TopicName.trim()
			GenreId : song.GenreId
			GenreName  : song.GenreName.trim()
			RegionId : song.RegionId
			RegionName : song.RegionName.trim()
			Thumbnail :song.Thumbnail
			Tags : song.Tags
			Lyric : encoder.htmlDecode song.Lyric
			FilePath : song.FilePath
			Bitrate : song.Bitrate
			Duration : song.Duration
			FileSize : song.FileSize
			PlayCount : song.PlayCount + song.CommentCount*3 + song.LikeCount*3 + song.DownloadCount*2
			CreateTime : _createTime
			UpdateTime : _updateTime

		@connection.query @query._insertIntoGMSongs, _item, (err) ->
		 	if err then console.log "Cannot insert the song into table. ERROR: " + err
		_item
	_storeAlbum : (album) ->		
		
		#convert dd/mm/yyyy to yyyy/mm/dd
		_createTime  = album.CreateTime.match(/\/[0-9]+$/g)[0].replace(/\//g,'') + "-" 
		_createTime += album.CreateTime.match(/[0-9]+\//g)[1].replace(/\//g,'') + "-"
		_createTime += album.CreateTime.match(/[0-9]+\//g)[0].replace(/\//g,'')

		_updateTime  = album.UpdateTime.match(/\/[0-9]+$/g)[0].replace(/\//g,'') + "-" 
		_updateTime += album.UpdateTime.match(/[0-9]+\//g)[1].replace(/\//g,'') + "-"
		_updateTime += album.UpdateTime.match(/[0-9]+\//g)[0].replace(/\//g,'')

		if album.Id is 18429  or album.Id is 19019
			_tempAl = album.Publisher.trim()
			_tempAl = _tempAl.replace(/\./g,'/')
		else 
			_tempAl = album.ReleaseDate.trim()
			_tempAl = _tempAl.replace(/\./g,'/') # to elimate the format of ReleaseDate like 14.7/2010
		# console.log '***'+_tempAl+'***'
		# full dd/mm/yyyy
		if _tempAl.length > 8
			_releaseDate  = _tempAl.match(/\/[0-9]+$/g)[0].replace(/\//g,'') + "-" 
			_releaseDate += _tempAl.match(/[0-9]+\//g)[1].replace(/\//g,'') + "-"
			_releaseDate += _tempAl.match(/[0-9]+\//g)[0].replace(/\//g,'')
		else 	if _tempAl.length > 4 # only have mm/yyyy
					_releaseDate  = _tempAl.match(/\/[0-9]+$/g)[0].replace(/\//g,'') + "-" 
					_releaseDate += _tempAl.match(/[0-9]+\//g)[0].replace(/\//g,'') + "-01"
				else
					_releaseDate = _tempAl + "-01-01"#only have yyyy

	
		_album = 
			AlbumId: album.Id
			AlbumName : album.Name.trim()
			MasterArtistId : album.MasterArtistId
			MasterArtistName : album.MasterArtistName.trim()
			TopicId : album.TopicId
			TopicName : album.TopicName.trim()
			GenreId : album.GenreId
			GenreName : album.GenreName.trim()
			RegionId: album.RegionId
			RegionName : album.RegionName.trim()
			Duration : album.Duration
			ReleaseDate : _releaseDate #check again
			Tags : album.Tags
			Thumbnail : album.Thumbnail
			Description : album.Description
			SongCount : album.SongCount
			PlayCount : album.PlayCount
			CreateTime : _createTime
			UpdateTime : _updateTime

		@connection.query @query._insertIntoGMAlbums,_album,(err) =>
		 	if err 
		 		console.log err
		 	else
		 		@stats.passedItemCount+=1
		 		@_updateSongs_Albums _album.AlbumId
				@utils.printUpdateRunning _album.AlbumId, @stats, "Fetching..."

		_album
	_storeSongs_Album : (songs) ->
		for song in songs
			_song = 
				AlbumId : song.AlbumId
				SongId : song.SongId
				ArtistId : song.ArtistId
				Position : song.Position
				AlbumArtistId : song.AlbumArtistId
			@connection.query @query._insertIntoGMSongs_Albums,_song,(err) ->
				 if err then console.log err + "at albumid: " + id + " songid: " +_song.SongId + " is not available"			 	
	_updateSongs_Albums : (id)->
		link = "http://music.go.vn/Ajax/AlbumHandler.ashx?type=getsongbyalbum&album=" + id
		# console.log link + " " +id
		http.get link, (res) =>
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					songs = JSON.parse data							
					if songs isnt null
						@_storeSongs_Album songs						
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	_updateAlbum : (id) -> 
		link = "http://music.go.vn/Ajax/AlbumHandler.ashx?type=getinfo&album=" + id
		http.get link, (res) =>
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					album = JSON.parse data
					@stats.totalItemCount+=1		
					if album isnt null
						@stats.passedItemCount+=1
						@_storeAlbum album
						@log.lastAlbumId = id
						@_updateAlbum id+1
					else
						@temp.totalFail+=1
						@stats.failedItemCount+=1
						@utils.printUpdateRunning id, @stats, "Fetching..."
						if @temp.totalFail is 100
							@log.updated_at = Date.now()
							if @stats.passedItemCount isnt 0 
								@utils.printFinalResult @stats
							else 
								console.log ""
								console.log "Table: #{@table.GMAlbums} is up-to-date"
							@_writeLog @log						
						else
							@_updateAlbum id+1
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	_updateSong : (id) ->	
		link = "http://music.go.vn/Ajax/SongHandler.ashx?type=getsonginfo&sid=" + id
		@stats.currentTable = @table.GMSongs
		http.get link, (res) =>
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					song = JSON.parse data
					@stats.totalItemCount+=1
					if song isnt null
						@_storeSong song	
						@stats.passedItemCount+=1
						@utils.printUpdateRunning id, @stats, "Fetching..."
						@log.lastSongId = id
						@_updateSong(id+1)
					else 
						@temp.totalFail+=1
						@stats.failedItemCount+=1
						@utils.printUpdateRunning id, @stats, "Fetching..." 					
						if @temp.totalFail is 100 
							error = true
							if @stats.passedItemCount isnt 0
								@utils.printFinalResult @stats
							else 
								console.log ""
								console.log "Table: #{@table.GMSongs} is up-to-date"
							@log.totalPassedSongs = @stats.passedItemCount
							@resetStats()
							console.log " |"+"Updating Albums to table: #{@table.GMAlbums}".magenta 
							@temp.totalFail = 0
							@stats.currentTable = @table.GMAlbums
							@_updateAlbum @log.lastAlbumId+1
						else
							@_updateSong(id+1)
							
	
			.on 'error', (e) ->
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	update : ->
		@temp = {}
		@temp.totalFail = 0
		@connect()
		console.log " |"+"Updating Songs to table: #{@table.GMSongs}".magenta
		@_updateSong @log.lastSongId + 1
	showStats : ->
		@_printTableStats GM_CONFIG.table
	resetTables : ->
		@connect()
		@_readLog()
		_songid = 180500
		_albumid = 18000
		@log.lastSongId = _songid 
		@log.lastAlbumId = _albumid 
		@log.updated_at = Date.now()
		@_writeLog @log
		# fs.writeFileSync @logPath,JSON.stringify(@log),"utf8"	
		_query = "delete from " + @table.GMSongs  + " where SongId > #{_songid};"
		_query+= "delete from " + @table.GMAlbums + " where AlbumId > #{_albumid};"
		_query+= "delete from " + @table.GMSongs_Albums + " where AlbumId > #{_albumid};"
		@connection.query _query, (err,results) ->
		 	if err then console.log "Cannot reset the tables. ERROR: " + err
		 	else console.log results

module.exports = Gomusic
