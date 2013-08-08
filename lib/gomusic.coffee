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


	refineArtist : (str)->
		return str.trim().splitBySeperator(' ft ').splitBySeperator(' ft. ')
				.splitBySeperator(', ').splitBySeperator(' feat ').splitBySeperator(' feat. ')
				.splitBySeperator(' duet with ').splitBySeperator(' & ').splitBySeperator(' Ft ')
				.splitBySeperator(' Ft. ').splitBySeperator(' Ft, ').splitBySeperator(' _ ')
				.splitBySeperator(' - ').replaceElement('Various Artists (VN)','')
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
			id : song.Id
			title : song.Name.trim()
			artistid :  song.ArtistId
			artist_display : @refineArtist song.ArtistName
			artists : @refineArtist song.ArtistDisplayName
			topicid : song.TopicId
			topics : song.TopicName.trim().split().splitBySeperator(' / ')
			genreid : song.GenreId
			genres  : song.GenreName.trim().split().splitBySeperator(' / ')
			regionid : song.RegionId
			regions : song.RegionName.trim().split().splitBySeperator(' / ')
			coverart :song.Thumbnail
			tags : song.Tags.trim().split().splitBySeperator(', ').splitBySeperator(',').unique()
			lyric : encoder.htmlDecode song.Lyric
			link : song.FilePath
			bitrate : song.Bitrate
			duration : song.Duration
			size : song.FileSize
			plays : song.PlayCount + song.CommentCount*3 + song.LikeCount*3 + song.DownloadCount*2
			date_created : _createTime
			date_updated : _updateTime

		# console.log _item
		# process.exit 0

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

		if album.ReleaseDate is "" then _releaseDate = null
	
		_album = 
			id: album.Id
			title : album.Name.trim()
			artistid : album.MasterArtistId
			artists : @refineArtist album.MasterArtistName
			topicid : album.TopicId
			topics : album.TopicName.trim().split().splitBySeperator(' / ')
			genreid : album.GenreId
			genres : album.GenreName.trim().split().splitBySeperator(' / ')
			regionid: album.RegionId
			regions : album.RegionName.trim().split().splitBySeperator(' / ')
			duration : album.Duration
			date_released : _releaseDate #check again
			tags : album.Tags.split().splitBySeperator(', ').splitBySeperator(',').unique()
			coverart : album.Thumbnail
			description : encoder.htmlDecode album.Description
			nsongs : album.SongCount
			plays : album.PlayCount
			date_created : _createTime
			date_uploaded : _updateTime

		@_updateSongs_Albums _album.id,_album
		@utils.printUpdateRunning _album.id, @stats, "Fetching..."

		_album
	_storeSongs_Album : (songs,album) ->
		songids = []
		song_positions = []
		for song in songs
			songids.push song.SongId
			song_positions.push song.Position
		album.songids = songids
		album.song_positions = song_positions
		# console.log album
		# process.exit 0
		@connection.query @query._insertIntoGMAlbums,album,(err) ->
			 if err then console.log err + "at id: " + album.id		 	
	_updateSongs_Albums : (id,album)->
		link = "http://music.go.vn/Ajax/AlbumHandler.ashx?type=getsongbyalbum&album=" + id
		# console.log link
		http.get link, (res) =>
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					songs = JSON.parse data	
					if songs isnt null
						@_storeSongs_Album songs,album						
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
							
	
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	update : ->
		@temp = {}
		@temp.totalFail = 0
		@connect()
		console.log " |"+"Updating Songs to table: #{@table.GMSongs}".magenta
		@_updateSong @log.lastSongId + 1
	
	updateAlbums : ->
		@connect()
		@temp = {}
		@temp.totalFail = 0
		console.log " |"+"Updating Albums to table: #{@table.GMAlbums}".magenta
		@stats.currentTable = @table.GMAlbums
		@_updateAlbum @log.lastAlbumId+1

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
