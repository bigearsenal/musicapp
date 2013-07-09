ObjectTransformation = require './object_transformation'

class ArtistTransformation extends ObjectTransformation
	constructor : (@table,@connection)->
		super @table,@connection
	getArtist  : (artist)->
		_artist = 
			id 				:	artist.id
			name 			: 	artist.name
			familiarity 		:	artist.familiarity 						
			hotttnesss 		:	artist.hotttnesss 					
					

		location = artist.artist_location 
		if location
			_artist.country = location.country or ""
			_artist.city = location.city or ""
			_artist.location = location.location or ""
			_artist.region = location.region or ""
		else
			_artist.country = ""
			_artist.city = ""
			_artist.location =  ""
			_artist.region = ""

		
		docCounts = artist.doc_counts
		if docCounts
			_artist.nbiographies 	= docCounts.biographies
			_artist.nblogs			= docCounts.blogs
			_artist.nnews			= docCounts.news
			_artist.nreviews		= docCounts.reviews
			_artist.nimages			= docCounts.images
			_artist.naudios			= docCounts.audio
			_artist.nsongs			= docCounts.songs
			_artist.nvideos			= docCounts.video
		else 
			_artist.nbiographies 	= 0
			_artist.nblogs			= 0
			_artist.nnews			= 0
			_artist.nreviews		= 0
			_artist.nimages			= 0
			_artist.naudios			= 0
			_artist.nsongs			= 0
			_artist.nvideos			= 0

		genres = artist.genres
		_artist.genres = ""
		if genres
			_genres = []
			for genre in genres
				_genres.push genre.name
			if _genres.length > 0
				_artist.genres = JSON.stringify _genres

		yearsActive = artist.years_active 
		_artist.years_active = ""
		if yearsActive
			if yearsActive.length > 0
				_artist.years_active = JSON.stringify yearsActive
		return _artist
	
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
module.exports = ArtistTransformation