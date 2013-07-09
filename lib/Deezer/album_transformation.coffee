ObjectTransformation = require '../echonest/object_transformation'

class AlbumTransformation extends ObjectTransformation
	constructor : (@table,@connection)->
		super @table,@connection
	getAlbum : (album)->
		_album =
			id				: album.id,
			title			: album.title,
			link				: album.link,
			cover			: album.cover,
			genre_id		: album.genre_id,
			label			: album.label,
			duration		: album.duration,
			fans			: album.fans,
			rating			: album.rating,
			release_date	: album.release_date,
			available		: album.available,
			type			: album.type
			nsongs 	 	: 0

		if album.artist
			_album.artist_id = album.artist.id
			_album.artist_name = album.artist.name

		if album.tracks
			if album.tracks.data 
				_album.nsongs = album.tracks.data.length

		return _album

	getTracks : (album,tracks)->
		_tracks = []
		for track in tracks
			_track = 
				id			: track.id,
				readable	: track.readable,
				title		: track.title,
				link			: track.link,
				duration	: track.duration,
				rank		: track.rank,
				preview		: track.preview,
				type		: track.type
				album_id 	: album.id
				album_title : album.title
			if track.artist
				_track.artist_id = track.artist.id
				_track.artist_name = track.artist.name
			_tracks.push _track
		return _tracks

	getTracks_Albums : (albumid,tracks)->
		_trals = []
		for track in tracks
			_tral = 
				aid : albumid
				tid : track.id
			_trals.push _tral
		return _trals



	getAllStatements : (album,enableTransaction)->
		_album = @getAlbum(album)
		_tracks = []
		_trals = []
		if album.tracks
			_tracks =  @getTracks(album,album.tracks.data)
			_trals =  @getTracks_Albums(album.id,album.tracks.data)

		if enableTransaction
			_statement = "start transaction;\n" 
		else _statement = ""
		_statement +=  @getInsertStatement _album,		 @table.album
		_statement += "\n"
		_statement +=  @getInsertStatement _tracks,		 @table.tracks
		_statement += "\n"
		_statement +=  @getInsertStatement _trals,		 @table.tracks_albums
		if enableTransaction
			_statement += "\ncommit;\n"
		else _statement += "\n"
		
		return _statement
	resetAllTables :  ->
		_statement = ""
		_specialStatment  = ""
		for key,value of @table
			if value.match /Artists/
				_specialStatment = "delete from #{value};"
			else _statement += "truncate table #{value};"
		_statement += _specialStatment
		@connection.query _statement, (err,result)->
			if err then console.log "Cannt reset all of the tables!!!. #{err}".red
			else console.log  "RESET TABLES DONE!".inverse.blueq
	


	appendArtistToFile : (artist, callbackOnDone) ->
		_select = "Select id from #{@table.artist} where id=#{@connection.escape artist.id}"
		# console.log _select
		@connection.query _select, (err,result)=>
			if err then callbackOnDone "We have an error in statement. ERROR: #{err}"
			else 
				if result.length is 0
					# console.log "THERE is no artist in TABLE. We will append new one to file,insert  it in table and callback when its done"
					@fs.appendFileSync @filePath, @getAllStatements(artist)+"\n"
					_statement = @getInsertStatement @getTransformedArtist(artist), @table.artist
					@connection.query _statement, (err, result)=>
						if err then callbackOnDone "Cannot insert new artist into table! ERROR:#{err}"
						else 
							# console.log result
							callbackOnDone null
				else 
					# console.log "Artist #{artist.id} exists. WE will discard"
					callbackOnDone "Artist #{artist.id} exists. Artist will be discard"

		# @fs.appendFileSync @filePath, @getAllStatements()
		# console.log "File: #{@fileName} saved succeed to #{@filePath}"
module.exports = AlbumTransformation