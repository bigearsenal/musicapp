Site = require "./Site"

class Deezer extends Site
	constructor : ->
		super "ZZ"
		# @logPath = "./log/ZZLog.txt"
		# @log = {}
		# @_readLog()
		@table.Artists = "ZZArtists"
		@table.Clips = "ZZClips"
		@table.Lyrics  = "ZZLyrics"


	# callback(err:String,options:Object)
	requestItemLink: (link,callback)->
		onSucess = (data,options)=>
			callback(null,data,options)
		onFail = (err,options)=>
			callback(err,null,options)
		options = 
			link : link
		@getFileByHTTP link,onSucess,onFail,options
	updateStats : (isSuccessful)->
		@stats.totalItemCount += 1
		if isSuccessful
			@stats.passedItemCount +=1
		else 
			@stats.failedItemCount +=1

		@utils.printRunning @stats
		if @stats.totalItems is @stats.totalItemCount
			# @utils.printFinalResult @stats
			console.log ""
			return true
		else return false
	
	
	fetchAlbum : (id,callback)->
		link = "http://api.deezer.com/2.0/album/#{id}"
		enableTransaction = yes
		@requestItemLink link, (err,data,options)=>
			@stats.currentId = id
			if err 
				errMessage = "request error at album id: #{id}. ERROR: #{err}"
				console.log errMessage
				if @updateStats(false) then callback()
			else 
				try 
					album = JSON.parse(data)
					if not album.error
						if @updateStats(true) then callback()
						# console.log @at.getAllStatements(album,enableTransaction)
						@connection.query @at.getAllStatements(album,enableTransaction),(err)=>
							if err then console.log "cannot transaction Error: #{err}"
					else 
						if @updateStats(false) then callback() 

				catch e
					errMessage = "error occurs at album id #{id} while processing. Error: #{e}"
					if @updateStats(false) then callback()
	fetchAlbumInRange : (range) ->
		@roundCount += 1
		@resetStats()
		@stats.totalItems = range.length/@config.factor
		console.log "Round : #{@roundCount}. Album range: #{range[0]}..#{range[range.length-1]}".inverse.green
		# console.log range
		for id in range by @config.factor
			@fetchAlbum id, =>
				# console.log "callback triggered"
				min = range[range.length-1]+1
				max = min + @config.stepEachRound - 1
				if max <= @config.maxValue
					@fetchAlbumInRange [min..max]
				else 
					console.log "CONGRATS!!! PROCEDURE COMPLETED!".inverse.green
	getAlbums : ->
		@connect()
		AlbumTrans = require './deezer/album_transformation'
		table = 
			album : "DZAlbums"
			tracks : "DZTracks"
			tracks_albums : "DZTracks_Albums"
		@at = new AlbumTrans(table,@connection)
		# test = [6610100,6618984,6619211,6619301,6619513,6619594,6622867,6622912,6622976,6627962,6628946,6636727,6639586,6639664,6639764,6639830,6646166,6655738,6656052,6659793,6664895,6666630,6668083,6668574,6681673,6682567,6682697,6684285,6684478,6684539,6685363,6685368,6685439,6685750,6688675,6689043,6702562,6703049,6703093,6703169,6703058,6703196,6703255,6703258,6703310,6703495,6703564,6703996,6706129,6706155,6706156,6706172,6706243,6706310,6707919,6707944,6707935,6707937,6707950,6707955,6707968,6707979,6707989,6708009,6708052,6708097,6708130,6708137,6708158,6708185,6713105,6715041,6715299,6715476,6717576,6717622,6718444,6724531,6735338,6738626,6739228,6743960]
		@config = 
			initialRange : [6600001..6610000]
			maxValue : 6800000
			stepEachRound : 10000
			factor : 1
		# @config = 
		# 	initialRange : test
		# 	maxValue : 0
		# 	stepEachRound : 0
		# 	factor : 1
		@roundCount = 0
		# @fetchAlbumInRange @config.initialRange
		
	#Fetching artist
	# from 1..1711306 step 1
	# from 1711306..4015301 step 10
	# from 4015301..5000000 step 1

	fetchArtist : (id,callback)->
		link = "http://api.deezer.com/2.0/artist/#{id}"
		enableTransaction = yes
		@requestItemLink link, (err,data,options)=>
			@stats.currentId = id
			if err 
				errMessage = "Request error at artist id: #{id}. ERROR: #{err}"
				console.log errMessage
				if @updateStats(false) then callback()
			else 
				try 
					artist = JSON.parse(data)
					# console.log artist
					if not artist.error
						# console.log "asdasdas"
						if @updateStats(true) then callback()
						_artist = 
							id 			: artist.id
							name 		: artist.name
							link  		: artist.link
							picture 		: artist.picture
							nalbums 	: artist.nb_album,
							nfans 		: artist.nb_fan
							radio  		: artist.radio,
							type 		: artist.type
						@connection.query "INSERT IGNORE INTO #{@table.Artists} SET ?", _artist,(err)=>
							if err then console.log "cannot insert artist #{artist.id} to db Error: #{err}"
					else 
						if @updateStats(false) then callback() 

				catch e
					errMessage = "Error occurs at artist id #{id} while processing. Error: #{e}"
					console.log errMessage
					if @updateStats(false) then callback()
	fetchArtistInRange : (range) ->
		@roundCount += 1
		@resetStats()
		if 1720000 < range[0] and range[range.length-1] <= 3900000
			@config.stepEachRound = 100000
			@config.factor = 10
		else 
			@config.stepEachRound = 10000
			@config.factor = 1
		@stats.totalItems = range.length/@config.factor
		console.log "Round : #{@roundCount}. Artist range: #{range[0]}..#{range[range.length-1]} - Step each round: #{@config.stepEachRound} - Factor: #{@config.factor}".inverse.green
		# console.log range
		for id in range by @config.factor
			@fetchArtist id, =>
				# console.log "callback triggered"
				min = range[range.length-1]+1
				max = min + @config.stepEachRound - 1
				if max <= @config.maxValue
					@fetchArtistInRange [min..max]
				else 
					console.log "CONGRATS!!! PROCEDURE COMPLETED!".inverse.green
	getArtists : ->
		@connect()
		@table.Artists = "DZArtists"
		@config = 
			initialRange : [1..10000]
			maxValue : 5000000
			stepEachRound : 10000
			factor : 1
		@roundCount = 0
		@fetchArtistInRange @config.initialRange




		

			





module.exports = Deezer