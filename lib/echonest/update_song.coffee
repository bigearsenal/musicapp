class UpdateNewSongsAndArtists
	constructor : (@table,@connection,@getFileByHttp) ->
		# keys = [ {"id":"SQSOWEREIRXGF03CJ","rateLimit":240},{"id":"V3WFT6DHG0RJX4UD2","rateLimit":120},{"id":"EHY4JJEGIOFA1RCJP","rateLimit":500},{"id":"027ER5TKTSQ81BANR","rateLimit":500},{"id":"EGXKLPXBW3VLDDC6Y","rateLimit":120},{"id":"LCSBHWUZA2IHUVLCF","rateLimit":480},{"id":"DIRRTDZGPELXNOKKF","rateLimit":120}]
		keys = [ {"id":"EHY4JJEGIOFA1RCJP","rateLimit":500}]
		
		APIKeys = require './api_key'
		@keys = new APIKeys()
		@keys.setApiKeys(keys)
		@templateLink = "http://developer.echonest.com/api/v4/song/search?<<ATTRIBUTES_AREA>>&api_key=<<REPLACE_AREA_APIKEY>>&format=json&results=100"
		@attributes = []
		@songsBucket = "bucket=song_hotttnesss&bucket=artist_familiarity&bucket=artist_hotttnesss&bucket=audio_summary&bucket=artist_location&bucket=tracks&bucket=scores&bucket=song_type&bucket=song_discovery&bucket=song_currency&bucket=id:7digital-US&bucket=id:7digital-AU&bucket=id:7digital-UK&bucket=id:facebook&bucket=id:fma&bucket=id:emi_open_collection&bucket=id:emi_bluenote&bucket=id:emi_artists&bucket=id:twitter&bucket=id:spotify-WW&bucket=id:seatwave&bucket=id:lyricfind-US&bucket=id:jambase&bucket=id:musixmatch-WW&bucket=id:rdio-US&bucket=id:rdio-AT&bucket=id:rdio-AU&bucket=id:rdio-BR&bucket=id:rdio-CA&bucket=id:rdio-CH&bucket=id:rdio-DE&bucket=id:rdio-DK&bucket=id:rdio-ES&bucket=id:rdio-FI&bucket=id:rdio-FR&bucket=id:rdio-IE&bucket=id:rdio-IT&bucket=id:rdio-NL&bucket=id:rdio-NO&bucket=id:rdio-NZ&bucket=id:rdio-PT&bucket=id:rdio-SE&bucket=id:emi_electrospective&bucket=id:rdio-WW&bucket=id:rdio-EE&bucket=id:rdio-LT&bucket=id:rdio-LV&bucket=id:rdio-IS&bucket=id:rdio-BE&bucket=id:rdio-MX&bucket=id:seatgeek&bucket=id:rdio-GB&bucket=id:rdio-CZ&bucket=id:rdio-CO&bucket=id:rdio-PL&bucket=id:rdio-MY&bucket=id:rdio-HK&bucket=id:rdio-CL"
		@defaultTotalItems = 100
		@itemsPerRequest = 100
		Array::unique = -> @filter -> arguments[2].indexOf(arguments[0], arguments[1] + 1) < 0
		@songStatements = ""
		@stats = 
			totalItemCount :0
			passedItemCount :0
			failedItemCount : 0
			markedTimer : Date.now()
			totalDuration : 0
			totalItems : 0
			currentId : 0
			currentTable : ""
		Utils = require '../utils'
		@utils = new Utils()
		table = 
			song : "ensongs"
			foreign_ids :  "ensongs_foreign_ids"
			tracks : "ensongs_tracks"
		SongTransformation = require './song_transformation'
		@transformer = new SongTransformation table, @connection
	_getTime : (mms) ->
		totalsec = Math.floor mms/1000
		sec = totalsec%60
		min = Math.floor totalsec/60
		if min isnt 0 then result = min + "m" + sec + "s" else result = sec + "s"
	printUpdateInfo : (info) ->
		tempDuration = Date.now() - @stats.markedTimer
		message  = " |"+"#{info}"
		message += " | t:"  + @_getTime(tempDuration)
		message += "                                  "
		message += "\r"
		process.stdout.write message
	addAttribute : (name,value)->
		attribute = {}
		attribute[name] = value
		@attributes.push attribute
	setDefaultTotalItems : (total)->
		@defaultTotalItems = total
	setAttributes : (attributes)->
		@attributes = attributes
	getAttributes : ->
		return @attributes
	getQuery : (bucketEnable=false)->
		query = ""
		# console.log @attributes
		@attributes.forEach (v)-> 
			for key, value of v
				query += "&#{key}=#{value}"
		if bucketEnable 
			query += "&#{@songsBucket}"
		return query.replace(/^&/,'')
	getLink : (start=0)->
		return "#{@keys.getUrlByReplacingApiKey(@templateLink.replace("<<ATTRIBUTES_AREA>>",@getQuery()),"<<REPLACE_AREA_APIKEY>>")}&start=#{start}"
	
	getUniqueArray : (arr)->
		return arr.unique()
	#callback(err:String,songs:Array,artists:Array,options:Object)
	requestSongsLinks : (attributeName, attributeValue,callback)->
		# att = {}
		# att[attributeName] = attributeValue
		# a = []
		# a.push att
		@addAttribute(attributeName,attributeValue)
		totalCount = @defaultTotalItems/@itemsPerRequest
		count = 0
		onSucess = (data,options)->
			try 
				count +=1
				if count is totalCount
					options.isDone = true
				songs = JSON.parse(data).response.songs
				_songIds = []
				_artistIds = []
				for song in songs
					_songIds.push song.id
					_artistIds.push song.artist_id
				callback null, _songIds.unique(), _artistIds.unique() ,options
			catch e
				console.log "requestSongsLinks() called! #{e}"
				console.log data
		onFail = (err,options)->
			count +=1
			if count is totalCount
				options.isDone = true
			errMessage = "#{err} at link: #{options.link}"
			callback errMessage, null,null
		for start in [0...@defaultTotalItems] by @itemsPerRequest
			link =  @getLink(start)
			# console.log link
			do (link,start)=>
				options = 
					link : link
					start : start
				@getFileByHttp link,onSucess,onFail,options

	#callback(songids:Array,artistid:Array)
	getSongAndArtistIds : (attributeName, attributeValue,callback)->
		sids = []
		aids = []
		count = 0
		@requestSongsLinks attributeName,attributeValue, (err,songIds,artistIds,options)=>
			if err then console.log err
			else 
				songIds.forEach (v)-> sids.push v
				artistIds.forEach (v)-> aids.push v
			@printUpdateInfo "Getting:#{attributeName} with value (#{attributeValue}) Start: #{options.start} : nLinks requested : #{++count}"
			if options.isDone 
				sids = sids.unique()
				aids = aids.unique()
				callback sids,aids

	#callback(newItemIds:Array)
	filterNewItemIds : (itemIds,table,callback) ->
		_select = "Select id from #{table} where id in (#{itemIds.map((v)->return "'#{v}'").join(',')})"
		resultItems = []
		iids = itemIds
		# console.log iids
		@connection.query _select, (err, items)=>
			if err then callback "Cannot run filter new items. #{err}", null
			else 
				for item in items
					iids[itemIds.indexOf(item.id)] = null
				# console.log iids
				callback null, iids.filter (v)-> if v is  null then return no else return yes

	filterNewSongIds : (songids,callback)->
		 @filterNewItemIds songids, @table.Songs, (err, newIIDS)->
		 	if err then callback err, null
		 	else 
		 		callback null, newIIDS
		 		# console.log newIIDS

	filterNewArtistIds : (artistids,callback)->
		 @filterNewItemIds artistids, @table.Artists, (err, newArtistIds)->
		 	if err then callback err, null
		 	else 
		 		callback null, newArtistIds

	# callback(statments:String)
	# statements is insert statments of artist profiles (bioraphies, terms,news.....), images and videos
	updateNewArtists : (artistids,callback) ->
		UNA = require './update_artist'
		# console.log UNA
		artistTable ={artist : "enartists",blogs : "enblogs",news : "ennews",reviews : "enreviews",audios : "enaudios",biographies : "enbiographies",terms : "enterms",urls : "enurls",foreign_ids : "enforeign_ids",images : "enimages",videos : "envideos",songs : "ensongs"}
		una = new UNA(artistTable,@connection,@getFileByHttp)
		una.setArtistIDs(artistids)
		una.getArtistItems (statements)->
			callback statements

	#callback(statements:String,songids:Array)
	#statements: all statments of new artists
	getNewSongAndArtistIds : (attributeName, attributeValue,callback)->
		@getSongAndArtistIds attributeName,attributeValue, (songids,artistids)=>
			console.log ""
			console.log "# of songIds: #{songids.length}"	
			console.log "# of artistIds: #{artistids.length}"	
			@filterNewSongIds songids, (err,sids)=>
				if err then console.log err
				else 
					console.log "# of new unique songs (after being filtered) found: #{sids.length}"
				@filterNewArtistIds artistids, (err,aids)=>
					if err then console.log err
					else 
						console.log "# of new unique artists (after being filtered) found #{aids.length}"
						@updateNewArtists aids,(statements)->
							callback(statements,sids)

	# This function used to get songs with its tracks, its foreign_ids 
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
	
	#callback(songStatements:String)
	#songStatements is new song statement relating to tracks, foreign_ids....
	requestNewSongsWithItsProperties : (songids,callback)->
		templateHref = "http://developer.echonest.com/api/v4/song/profile?api_key=<<REPLACE_AREA_APIKEY>>&format=json&id=<<REPLACE_SONG_ID>>"
		# console.log songids
		@stats.totalItems = songids.length
		onSucess = (data,options)=>
			songs = JSON.parse(data).response.songs
			if songs
				for song in songs
					@songStatements +=  @transformer.getAllStatements(song)
			if @updateStats(true)
				callback(@songStatements)
		onFail = (err,options)=>
			if @updateStats(false)
				callback(@songStatements)
		for id in songids
			do (id)=>
				link = "#{@keys.getUrlByReplacingApiKey(templateHref.replace("<<REPLACE_SONG_ID>>",id),"<<REPLACE_AREA_APIKEY>>")}&#{@songsBucket}"
				options = 
					link : link
				@getFileByHttp link,onSucess,onFail,options








module.exports = UpdateNewSongsAndArtists