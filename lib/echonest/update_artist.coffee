class UpdateNewArtist
	constructor : (@table,@connection,@getFileByHttp) ->
		keys = [{"id":"SQSOWEREIRXGF03CJ","rateLimit":240},{"id":"V3WFT6DHG0RJX4UD2","rateLimit":120},{"id":"EHY4JJEGIOFA1RCJP","rateLimit":500},{"id":"027ER5TKTSQ81BANR","rateLimit":500},{"id":"EGXKLPXBW3VLDDC6Y","rateLimit":120},{"id":"LCSBHWUZA2IHUVLCF","rateLimit":480},{"id":"DIRRTDZGPELXNOKKF","rateLimit":120}]
		APIKeys = require './api_key'
		@keys = new APIKeys()
		@keys.setApiKeys(keys)
		@templateLink = "http://developer.echonest.com/api/v4/artist/profile?id=<<ARTIST_ID_AREA>>&api_key=<<REPLACE_AREA_APIKEY>>&format=json"
		@artistsBucket = "bucket=audio&bucket=biographies&bucket=blogs&bucket=doc_counts&bucket=familiarity&bucket=genre&bucket=hotttnesss&bucket=images&bucket=artist_location&bucket=news&bucket=reviews&bucket=songs&bucket=terms&bucket=urls&bucket=video&bucket=years_active&bucket=id:7digital-US&bucket=id:7digital-AU&bucket=id:7digital-UK&bucket=id:facebook&bucket=id:fma&bucket=id:emi_open_collection&bucket=id:emi_bluenote&bucket=id:emi_artists&bucket=id:twitter&bucket=id:spotify-WW&bucket=id:seatwave&bucket=id:lyricfind-US&bucket=id:jambase&bucket=id:musixmatch-WW&bucket=id:rdio-US&bucket=id:rdio-AT&bucket=id:rdio-AU&bucket=id:rdio-BR&bucket=id:rdio-CA&bucket=id:rdio-CH&bucket=id:rdio-DE&bucket=id:rdio-DK&bucket=id:rdio-ES&bucket=id:rdio-FI&bucket=id:rdio-FR&bucket=id:rdio-IE&bucket=id:rdio-IT&bucket=id:rdio-NL&bucket=id:rdio-NO&bucket=id:rdio-NZ&bucket=id:rdio-PT&bucket=id:rdio-SE&bucket=id:emi_electrospective&bucket=id:rdio-WW&bucket=id:rdio-EE&bucket=id:rdio-LT&bucket=id:rdio-LV&bucket=id:rdio-IS&bucket=id:rdio-BE&bucket=id:rdio-MX&bucket=id:seatgeek&bucket=id:rdio-GB&bucket=id:rdio-CZ&bucket=id:rdio-CO&bucket=id:rdio-PL&bucket=id:rdio-MY&bucket=id:rdio-HK&bucket=id:rdio-CL"
		@songsBucket = "bucket=song_hotttnesss&bucket=artist_familiarity&bucket=artist_hotttnesss&bucket=audio_summary&bucket=artist_location&bucket=tracks&bucket=scores&bucket=song_type&bucket=song_discovery&bucket=song_currency&bucket=id:7digital-US&bucket=id:7digital-AU&bucket=id:7digital-UK&bucket=id:facebook&bucket=id:fma&bucket=id:emi_open_collection&bucket=id:emi_bluenote&bucket=id:emi_artists&bucket=id:twitter&bucket=id:spotify-WW&bucket=id:seatwave&bucket=id:lyricfind-US&bucket=id:jambase&bucket=id:musixmatch-WW&bucket=id:rdio-US&bucket=id:rdio-AT&bucket=id:rdio-AU&bucket=id:rdio-BR&bucket=id:rdio-CA&bucket=id:rdio-CH&bucket=id:rdio-DE&bucket=id:rdio-DK&bucket=id:rdio-ES&bucket=id:rdio-FI&bucket=id:rdio-FR&bucket=id:rdio-IE&bucket=id:rdio-IT&bucket=id:rdio-NL&bucket=id:rdio-NO&bucket=id:rdio-NZ&bucket=id:rdio-PT&bucket=id:rdio-SE&bucket=id:emi_electrospective&bucket=id:rdio-WW&bucket=id:rdio-EE&bucket=id:rdio-LT&bucket=id:rdio-LV&bucket=id:rdio-IS&bucket=id:rdio-BE&bucket=id:rdio-MX&bucket=id:seatgeek&bucket=id:rdio-GB&bucket=id:rdio-CZ&bucket=id:rdio-CO&bucket=id:rdio-PL&bucket=id:rdio-MY&bucket=id:rdio-HK&bucket=id:rdio-CL"
		Array::unique = -> @filter -> arguments[2].indexOf(arguments[0], arguments[1] + 1) < 0
		@stats = 
			totalItemCount :0
			passedItemCount :0
			failedItemCount : 0
			markedTimer : Date.now()
			totalDuration : 0
			totalItems : 0
			currentId : 0
			currentTable : ""
		@artistIDs = []
		Utils = require '../utils'
		@utils = new Utils()
		@statements = ""
		@ArtistsStats = []
		@songs = []
		ArtistTransformation = require './artist_transformation'
		@transformer = new ArtistTransformation @table, @connection
		table = 
			song : "ENSongs"
			foreign_ids :  "ENSongs_foreign_ids"
			tracks : "ENSongs_tracks"
		SongTransformation = require './song_transformation'
		@songTransformer = new SongTransformation table, @connection

	_getTime : (mms) ->
		totalsec = Math.floor mms/1000
		sec = totalsec%60
		min = Math.floor totalsec/60
		if min isnt 0 then result = min + "m" + sec + "s" else result = sec + "s"
	resetStats : ->
		@stats = 
			totalItemCount :0
			passedItemCount :0
			failedItemCount : 0
			markedTimer : Date.now()
			totalDuration : 0
			totalItems : 0
			currentId : 0
			currentTable : ""
	printUpdateInfo : (info) ->
		tempDuration = Date.now() - @stats.markedTimer
		message  = " |"+"#{info}"
		message += " | t:"  + @_getTime(tempDuration)
		message += "                                  "
		message += "\r"
		process.stdout.write message
	setArtistIDs : (artistids) ->
		@artistIDs = artistids
	getStatements : ->
		return @statements
	getNewSongs : ->
		return @songs
	getArtistsStats : ->
		return @ArtistsStats
	getArtistLink : (artistid,bucketsEnable=false)->
		_t = "#{@keys.getUrlByReplacingApiKey(@templateLink.replace("<<ARTIST_ID_AREA>>",artistid),"<<REPLACE_AREA_APIKEY>>")}"
		if bucketsEnable
			_t += "&#{@artistsBucket}"
		return _t

	# param(artist:Object, type="image","song","video")
	# OBject = 
	# { artist_id: 'ARXUILZ119B86685F1',
	#    nimages: 7,
	#    nvideos: 0,
	#    nsongs: 26 
	# }
	# return links:Array
	getArtistItemLinks : (artist, type)->
		getStartParams = (n) ->
			step = 100
			max = 1000
			result = []
			for i in [0...max] by step
				if n > i then result.push i
			return result
		links = []
		if type is "image"
			nitems = artist.nimages
			href = "http://developer.echonest.com/api/v4/artist/images?api_key=<<REPLACE_AREA_APIKEY>>&id=<<ARTIST_ID_AREA>>&format=json&results=100"
		if type is "video"
			nitems = artist.nvideos
			href = "http://developer.echonest.com/api/v4/artist/video?api_key=<<REPLACE_AREA_APIKEY>>&id=<<ARTIST_ID_AREA>>&format=json&results=100"
		if type is "song"
			nitems = artist.nsongs
			# href = "http://developer.echonest.com/api/v4/artist/songs?api_key=<<REPLACE_AREA_APIKEY>>&id=<<ARTIST_ID_AREA>>&format=json&results=100"
			href = "http://developer.echonest.com/api/v4/song/search?api_key=<<REPLACE_AREA_APIKEY>>&artist_id=<<ARTIST_ID_AREA>>&format=json&results=100"
			href += "&#{@songsBucket}"
		for start in getStartParams(nitems)
			links.push "#{@keys.getUrlByReplacingApiKey(href.replace("<<ARTIST_ID_AREA>>",artist.artist_id),"<<REPLACE_AREA_APIKEY>>")}&start=#{start}"

		return links

	updateStats : (isSuccessful)->
		@stats.totalItemCount += 1
		if isSuccessful
			@stats.passedItemCount +=1
		else 
			@stats.failedItemCount +=1

		@utils.printRunning @stats
		if @stats.totalItems is @stats.totalItemCount
			@utils.printFinalResult @stats
			return true
		else return false

	# callback(statements:String)
	requestArtistProfileLinks : (callback)->

		@stats.totalItems = @artistIDs.length
		onSucess = (data,options)=>
			artist = JSON.parse(data).response.artist
			if artist 
				_ta = @transformer.getTransformedArtist(artist)
				item =
					artist_id : options.id
					nimages : _ta.nimages
					nvideos : _ta.nvideos
					nsongs : _ta.nsongs
				@ArtistsStats.push item
				@statements +=  @transformer.getAllStatements(artist)
			# @connection.query @transformer.getAllStatements(artist), (err)->
			# 	if err then console.log "Cannot insert artist id: #{options.id}"
			if @updateStats(true)
				callback(@statements)
		onFail = (err,options)=>
			if @updateStats(false)
				callback(@statements)

		if @artistIDs.length is 0 then callback(@statements)

		for id in @artistIDs
			do (id)=>
				options = 
					id : id
				@getFileByHttp @getArtistLink(id,true),onSucess,onFail,options

	getArtistIdFromHref : (href)->
		_t = href.match(/&id=(.+)&format/)?[1]
		return _t

	# This function is called to get images, songs and videos of new artists
	requestItemLinks: (type,callback)->
		@resetStats()
		links = []
		for artist in @getArtistsStats()
			for link in @getArtistItemLinks(artist, type)
				links.push link
		@stats.totalItems  = links.length
		# console.log links
		# if type is "song" then console.log links
		onSucess = (data,options)=>
			item = JSON.parse(data).response
			if type is "image"
				images = item.images
				@statements += @transformer.getImagesStatements images, @getArtistIdFromHref(options.link)
			if type is "song"
				songs = item.songs
				# console.log songs
				if songs
					for song in songs
						# @songs.push song.id 
						@statements += @songTransformer.getAllStatements(song)
						# console.log @songTransformer.getAllStatements(song)
			if type is "video"
				videos = item.video
				@statements += @transformer.getVideosStatements videos, @getArtistIdFromHref(options.link)

			if @updateStats(true)
				callback()
		onFail = (err,options)=>
			if @updateStats(false)
				callback()

		if links.length is 0 then callback()

		for link in links
			do (link)=>
				options = 
					link : link
				@getFileByHttp link,onSucess,onFail,options
	
	getNewImagesFromNewArtists : (callback)->
		@requestItemLinks "image", ->
			callback()
	getNewVideosFromNewArtists : (callback)->
		@requestItemLinks "video", ->
			callback()
	getNewSongsFromNewArtists : (callback)->
		@requestItemLinks "song", ->
			callback()

	# callback(statements:String,newSongIds:Array)
	# statements is insert statements of artist profiles (bioraphies, terms,news.....), images and videos
	getArtistItems : (callback)->
		console.log "Getting new artist profiles..."
		@requestArtistProfileLinks (statements)=>
			console.log "New artist profiles have been added to statements".inverse.blue
			# console.log statements
			console.log "# of new artist profiles added: #{@getArtistsStats().length}"
			# console.log @getArtistsStats()
			console.log "Getting new artist images..."
			@getNewImagesFromNewArtists =>
				console.log "New artist images have been added to statements".inverse.blue
				console.log "Getting new artist videos..."
				@getNewVideosFromNewArtists =>
					console.log "New artist videos have been added to statements".inverse.blue
					# console.log  @getStatements()
					console.log "Getting new artist songs..."
					@getNewSongsFromNewArtists =>
						console.log "New artist songs have been added to statements".inverse.blue
						callback @getStatements()

			
module.exports = UpdateNewArtist


