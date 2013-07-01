ObjectTransformation = require './object_transformation'

class SongTransformation extends	 ObjectTransformation
	constructor : (@table,@connection)->
		super @table,@connection
	getSong : (song)->
		_item = 
			id 					: song.id
			title 				: song.title
			artist_id 			: song.artist_id
			# artist_name 		: song.artist_name
			# artist_location 		: JSON.stringify song.artist_location
			# artist_familiarity  	: song.artist_familiarity
			# artist_hotttnesss 	: song.artist_hotttnesss
			acousticness 		: song.audio_summary.acousticness
			# analysis_url 		: JSON.stringify song.audio_summary.analysis_url
			danceability 		: song.audio_summary.danceability
			duration 			: song.audio_summary.duration
			energy 				: song.audio_summary.energy
			key 				: song.audio_summary.key
			liveness 			: song.audio_summary.liveness
			loudness 			: song.audio_summary.loudness
			mode 				: song.audio_summary.mode
			speechiness 		: song.audio_summary.speechiness
			tempo 				: song.audio_summary.tempo
			time_signature 	: song.audio_summary.time_signature
			valence 			: song.audio_summary.valence
			song_currency 		: song.song_currency
			song_discovery 	: song.song_discovery
			song_hotttnesss 	: song.song_hotttnesss
			song_type 			: JSON.stringify song.song_type

		return _item
	getForeignIds : (song)->
		foreignIds = song.foreign_ids
		_foreignIds = []
		if foreignIds
			_foreignIds = @groupBy foreignIds, (value) -> value.foreign_id.replace(/^.+song:/,'')
			_result = []
			for key, values of _foreignIds
				_id = 
					foreign_id : key
					song_id : song.id
				countries = @groupBy values, (value) -> value.catalog.replace(/^.+-/,'')
				catalog = @groupBy values, (value) -> value.catalog.replace(/-.+$/,'')
				_id.countries = [] 
				_id.catalog = []
				for k1, v1 of countries
					_id.countries.push k1
				_id.countries = _id.countries.join()
				# if _id.countries is "facebook" or _id.countries is "WW" or _id.countries is "seatgeek" or _id.countries is "twitter" or _id.countries is "jambase" or _id.countries is "seatwave"
				if _id.countries in ["facebook","WW","seatgeek","twitter","jambase","seatwave"]
					_id.countries = "World Wide"
				for k2,v2 of catalog
					_id.catalog.push k2
				_id.catalog = _id.catalog.join()
				if _id.catalog is "rdio"
					if _id.foreign_id.match(/r[0-9]+/)
						_id.foreign_id = _id.foreign_id.replace("r","")
				_result.push _id
			return  _result

		else return []

	getTracks : (song)->
		tracks = song.tracks
		_tracks = []
		if tracks
			
			_tracks = @groupBy tracks, (value) -> value.id 
			_result = []
			# console.log _tracks
			for key, values of _tracks
				_id = {}
				_id.track_id = key
				_id.song_id = song.id
				foreign_release_ids = @groupBy values, (v)-> if v.foreign_release_id then v.foreign_release_id.replace(/^.+release:/,'') else null
				countries = @groupBy values, (value) -> value.catalog.replace(/^.+-/,'')
				catalog = @groupBy values, (value) -> value.catalog.replace(/-.+$/,'')
				foreign_ids =  @groupBy values, (value) -> value.foreign_id.replace(/^.+track:/,'')

				_id.countries = [] 
				_id.catalog = []
				for k1, v1 of countries
					_id.countries.push k1
				_id.countries = _id.countries.join()
				# if _id.countries is "facebook" or _id.countries is "WW" or _id.countries is "seatgeek" or _id.countries is "twitter" or _id.countries is "jambase" or _id.countries is "seatwave"
				if _id.countries in ["facebook","WW","seatgeek","twitter","jambase","seatwave"]
					_id.countries = "World Wide"
				for k2,v2 of catalog
					_id.catalog.push k2
				_id.catalog = _id.catalog.join()
				

				_id.foreign_release_ids = [] 
				for k3,v3 of foreign_release_ids
					_id.foreign_release_ids.push k3
				_id.foreign_release_ids = _id.foreign_release_ids.join()
				if _id.catalog is "rdio"
					if _id.foreign_release_ids.match(/a[0-9]+/g)
						_id.foreign_release_ids = _id.foreign_release_ids.replace(/a/g,"")
				if _id.foreign_release_ids in [null, "", "null"]
					_id.foreign_release_ids = ""

				_id.foreign_ids = []
				for k4,v4 of foreign_ids
					_id.foreign_ids.push k4
				_id.foreign_ids = _id.foreign_ids.join('')

				if _id.catalog is "rdio"
					if _id.foreign_ids.match(/r[0-9]+/)
						_id.foreign_ids = _id.foreign_ids.replace("r","")
				
				
				_result.push _id



			return  _result

		else return []
	getAllStatements : (song)->
		_statement = ""
		_statement += @getInsertStatement @getSong(song), @table.song
		_statement += "\n"
		_statement += @getInsertStatement @getForeignIds(song), @table.foreign_ids
		_statement += "\n"
		_statement += @getInsertStatement @getTracks(song),@table.tracks
		_statement += "\n"
		return _statement
	appendSongToFile : (song, callbackOnDone) ->
		_select = "Select id from #{@table.song} where id=#{@connection.escape song.id}"
		# console.log _select
		@connection.query _select, (err,result)=>
			if err then callbackOnDone "We have an error in statement. ERROR: #{err}"
			else 
				if result.length is 0
					# console.log "THERE is no song in TABLE. We will append new one to file,insert  it in table and callback when its done"
					@fs.appendFileSync @filePath, @getAllStatements(song)+"\n"
					_statement = @getInsertStatement @getSong(song), @table.song
					@connection.query _statement, (err, result)=>
						if err then callbackOnDone "Cannot insert new song #{song.id} into table! ERROR:#{err}"
						else 
							# console.log result
							callbackOnDone null
				else 
					# console.log "song #{song.id} exists. WE will discard"
					callbackOnDone "Song #{song.id} exists. Song will be discard"
module.exports = SongTransformation