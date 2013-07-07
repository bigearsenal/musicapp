class DownloadEchoNest 
	constructor : (indices = [])->
		@indices = indices
		@maxConcurrentJobs = 8
		@currentCursor = -1
		@templateLink = "http://developer.echonest.com/api/v4/song/search?artist_id=<<REPLACE_AREA_SECOND>>&start=<<REPLACE_AREA_FIRST>>&api_key=<<REPLACE_AREA_APIKEY>>&format=json&results=100&bucket=song_hotttnesss&bucket=artist_familiarity&bucket=artist_hotttnesss&bucket=audio_summary&bucket=artist_location&bucket=tracks&bucket=scores&bucket=song_type&bucket=song_discovery&bucket=song_currency&bucket=id:7digital-US&bucket=id:7digital-AU&bucket=id:7digital-UK&bucket=id:facebook&bucket=id:fma&bucket=id:emi_open_collection&bucket=id:emi_bluenote&bucket=id:emi_artists&bucket=id:twitter&bucket=id:spotify-WW&bucket=id:seatwave&bucket=id:lyricfind-US&bucket=id:jambase&bucket=id:musixmatch-WW&bucket=id:rdio-US&bucket=id:rdio-AT&bucket=id:rdio-AU&bucket=id:rdio-BR&bucket=id:rdio-CA&bucket=id:rdio-CH&bucket=id:rdio-DE&bucket=id:rdio-DK&bucket=id:rdio-ES&bucket=id:rdio-FI&bucket=id:rdio-FR&bucket=id:rdio-IE&bucket=id:rdio-IT&bucket=id:rdio-NL&bucket=id:rdio-NO&bucket=id:rdio-NZ&bucket=id:rdio-PT&bucket=id:rdio-SE&bucket=id:emi_electrospective&bucket=id:rdio-WW&bucket=id:rdio-EE&bucket=id:rdio-LT&bucket=id:rdio-LV&bucket=id:rdio-IS&bucket=id:rdio-BE&bucket=id:rdio-MX&bucket=id:seatgeek&bucket=id:rdio-GB&bucket=id:rdio-CZ&bucket=id:rdio-CO&bucket=id:rdio-PL&bucket=id:rdio-MY&bucket=id:rdio-HK&bucket=id:rdio-CL"
		@filePath = "/Volumes/Data/website/database/echonest/"
		@count = 0
		@nAritsts = 10000
		@nArtistsSkipped = 0
		@_checkCursorCount = 0
		@exec = require('child_process').exec
		ENApiKeys = require './api_key'
		@apikey = new ENApiKeys()
		
	
	setMaxConcurrentJobs : (max)->
		@maxConcurrentJobs = max
	setFilePath : (path)->
		@filePath = path
	setTemplateLink : (link)->
		@templateLink = link
	getTotalItems : ->
		return @count
	getFilePath : ->
		return @filePath
	getIndexces : ->
		return @indices
	saveIndices : (path = @filePath)->
		fs = require 'fs'
		fileName = "list_#{@nArtistsSkipped}_#{@nAritsts+@nArtistsSkipped}.txt"
		fs.writeFileSync path+fileName, @indices
		return "#{fileName} has already been saved!"
	saveLog : (log,path = @filePath)->
		fs = require 'fs'
		fileName = "log.txt"
		fs.writeFileSync path+fileName, log
		return "#{fileName} has already been saved!"
	setnArtists : (number)->
		@nAritsts = number
	setnArtistsSkipped : (number)->
		@nArtistsSkipped =number
	getnArtists : ->
		return @nAritsts
	getnArtistsSkipped : ->
		return @nArtistsSkipped
	getMaxConccurentJobs : ->
		return @maxConcurrentJobs

	appendNewIndicesFromArtist : (artist)->
		nsongs = artist.nsongs
		id = artist.artist_id
		if nsongs%100 is 0
			nlinks = nsongs/100
		else nlinks = nsongs/100+1

		if nsongs is 0 then console.log "EROOR nsongs of artists is ZERO"

		nsteps = nlinks - 1
		if nsteps > 9  then nsteps = 9
		for i in [0..nsteps]
			# link = templateLink.replace("<<REPLACE_AREA_FIRST>>",i*100).replace("<<REPLACE_AREA_SECOND>>",id)
			Index = "#{id}_#{(i*100)}"
			@count +=1
			@indices.push Index
	downloadFileByWGET : (index,callback)->
		_t = index.split('_')
		id = _t[0]
		start = _t[1]
		fileName = "#{id}_#{start}.json"
		path = @filePath + fileName
		url = @templateLink.replace("<<REPLACE_AREA_FIRST>>",start).replace("<<REPLACE_AREA_SECOND>>",id)
		
		url = @apikey.getUrlByReplacingApiKey url, "<<REPLACE_AREA_APIKEY>>"
		# mode: quiet -q, continue -c
		cmd = "wget -q -c '#{url}' -O #{path} "
		# console.log index
		@exec cmd, (err, stdout, stderr)=>
			if err 
				if callback then callback(err,null)
			else 
				if callback  
					callback(null,fileName)
					@runNext(callback)
				else @runNext()
	downloadAll : ->
		for i in [0..@maxConcurrentJobs-1]
			@getNextIndex()

	runNext : (callback) ->
		if @currentCursor < @indices.length-1
			@currentCursor +=1
			@downloadFileByWGET @indices[@currentCursor],callback
			return true
		else
			@_checkCursorCount +=1
			if @_checkCursorCount is @maxConcurrentJobs
				callback null, null, true
			return false 

	runJob : (callback) ->
		for i in [0..@maxConcurrentJobs-1]
			@runNext(callback)

module.exports = DownloadEchoNest