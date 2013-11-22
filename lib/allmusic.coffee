Site = require "./Site"
require("./helpers/string")
http = require 'http'
url = require 'url'
zlib = require 'zlib'

http.globalAgent.maxSockets = 150

class AllMusic extends Site
	constructor : ->
		super "am"
		@table.Artists = "amartists"

		# convert "04:12" to seconds
		String::toSeconds = ()->
			if @.toString() isnt ""
				intervals = @.split(":").map (v)-> parseInt(v,10)
				if intervals.length is 3
					return intervals[0]*3600 + intervals[1]*60 + intervals[2]
				else if intervals.length is 2
					return intervals[0]*60 + intervals[1]
				else if intervals.length is 1
					return intervals[0]
				else return 0	
			else return 0

	# callback(err:String,data:String,options:Object)
	HTTPGet : (link, callback) ->
		headers =
			'Accept-Encoding': 'gzip,deflate'
			'Accept-Language' : 'en-US,en'
			'Cache-Control' : 'max-age=0'
			'Connection' :  'keep-alive'
			'Host' : 'www.allmusic.com'
			'User-Agent' : 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'
			'Cookie' : ''
		params = 
			'host' : url.parse(link).host
			'path' : url.parse(link).path
			'method' : "GET"
			'headers': headers
		req = http.get params, (res) ->
			chunks = []
			if res.statusCode isnt 302 and res.statusCode isnt 403 and res.statusCode isnt 404
				res.on "data", (chunk)->
					chunks.push chunk
				res.on "end", ->
					buffer = Buffer.concat(chunks)
					encoding = res.headers['content-encoding']
					if encoding is "gzip" then zlib.gunzip(buffer, (err, result)-> if err then console.log err  else callback(null, result.toString()))
					else 
						if encoding is "deflate" then zlib.inflate(buffer, (err, result)-> if err then console.log err  else  callback(null, result.toString()))
						else callback(null,buffer.toString())  # no encoding
			else callback("Status code is 302 or 403 or 404",null)
		req.on "error", (err) ->
			callback(err,null)
	

	# getting themes, styles, genres, moods from albums
	getTSGM : (data,type)->
		switch type
			when "genres"
				items = data.match(/<h4>Genre<\/h4>([^]+?<\/div>)/)?[1]
			when "styles"
				items = data.match(/<h4>Styles<\/h4>([^]+?<\/div>)/)?[1]
			when "moods"
				items = data.match(/<h4>Album Moods<\/h4>([^]+?<\/div>)/)?[1]
			when "themes"
				items = data.match(/<h4>Themes<\/h4>([^]+?<\/div>)/)?[1]
		if items
			items = items.split("<\/a>").map((v)-> 
				item =
					id : ""
					name : v.stripHtmlTags().trim()
				if item.name isnt "" 
					if type is "moods"
						item.id = parseInt(v.match(/xa([0-9]+)\"/)?[1],10)
					else item.id = parseInt(v.match(/ma([0-9]+)\"/)?[1],10)
					return item
				else return null
				).filter (v)-> v isnt null
			return items
		else return []
		
	# convert multiple integer id into their key
	# for example: albumid : 2579055 converted to mw0002579055
	toKey : (id,prefix)->
		id = id.toString()
		zeros = ""
		zeros += "0" for i in [0..10-id.length-1]
		return prefix + zeros + id

	# COVERART!!!!!!!!!!!!
	getAlbum : (key,callback)->
		link = "http://www.allmusic.com/album/joke-#{key}"
		album = 
			id : parseInt(key.match(/([0-9]+)/)?[1],10)
			title : ""
			artistids : []
			artists : []
			discographies : []
			review : ""
			duration : 0 #in seconds
			date_released : null
			genres : []
			styles : []
			moods : []
			themes : []
			songs : []
		@HTTPGet link, (err,data)=>
			if err 
				callback(err,null)
			else 
				error = null
				try
					# ignore multiple artists.... CHEKCING LATER!!!!!!!!!!!!
					artists = data.match(/<h3 class="album-artist"[^]+?<\/h3>/g)?[0]
					if artists 
						if artists.match(/(mn[0-9]+)"/)?[1]
							album.artistids = artists.match(/mn([0-9]+)"/g).map (v)-> parseInt(v.match(/[0-9]+/)?[0],10)
						album.artists = artists.stripHtmlTags().trim().split(' / ')
						

					title = data.match(/<h2 class="album-title"[^]+?<\/h2>/g)?[0]
					if title 
						album.title = title.stripHtmlTags().trim()

					review = data.match(/<div class="text" itemprop="reviewBody">[^]+?<\/div>/)?[0]
					if review
						album.review = review.trim()

					duration = data.match(/<h4>Duration<\/h4>([^]+?)<\/span>/)?[1]
					if duration
						album.duration = duration.stripHtmlTags().trim().toSeconds()						

					dateReleased = data.match(/<h4>Release Date<\/h4>([^]+?)<\/span>/)?[1]
					if dateReleased
						dateReleased = dateReleased.stripHtmlTags().trim()
						album.date_released = @formatDate(new Date(dateReleased.replace(/'s/,"")))

					discographies = data.match(/<li class="album">[^]+?<\/li>/g)
					if discographies
						discographies = discographies.map (discography)->
							return discog = 
								id : parseInt(discography.match(/mw([0-9]+)"/)?[1],10)
								title : discography.match(/title="(.+?)"/)?[1]
								coverart : discography.match(/<img src="(.+?)"/)?[1].replace("?partner=allrovi.com","")
						album.discographies =  discographies



					album.genres = @getTSGM(data,"genres")
					album.moods = @getTSGM(data,"moods")
					album.styles = @getTSGM(data,"styles")
					album.themes = @getTSGM(data,"themes")

					# trackNums = data.match(/<td class="tracknum">[^]+?<\/td>/g)
					# if trackNums then trackNums = trackNums.map (v)-> parseInt(v.stripHtmlTags().trim(),10)
					# console.log trackNums

					songTitles = data.match(/<div class="title" itemprop="name">[^]+?<\/div>/g)
					if songTitles 
						songIds = songTitles.map (v)->  parseInt(v.match(/mt([0-9]+)"/)?[1],10)
						songTitles = songTitles.map (v)-> v.stripHtmlTags().trim()

					# console.log songTitles

					songComposers = data.match(/<div class="composer">[^]+?<\/div>/g)
					if songComposers  
						songComposers = songComposers.map (composers)-> 
							cposers = composers.split(" \/ ")
							cposers = cposers.map (v)->
								composer = 
									id : ""
									name : v.stripHtmlTags().trim()
								if composer.name isnt ""   
									composer.id = parseInt(v.match(/mn([0-9]+)"/)?[1],10)
									return composer
								else return null 
							cposers.filter (v)-> v isnt null
					else songComposers = []
					# console.log songComposers

					songPerformers =  data.match(/<td class="performer"[^]+?<\/td>/g)
					if songPerformers
						songPerformers = songPerformers.map (artists)-> 
							ars = artists.split(" / ")
							ars = ars.map (v)-> 
									artist = 
										id : ""
										name : v.stripHtmlTags().trim()
									if artist.name isnt "" 
										artist.id = parseInt(v.match(/mn([0-9]+)"/)?[1],10)
										return artist
									else return null
							ars = ars.filter (v)-> v isnt null
							return ars
					else songPerformers = []
					# console.log songPerformers

					songTimes =  data.match(/<td class="time">[^]+?<\/td>/g)
					if songTimes
						songTimes = songTimes.map (v)-> v.stripHtmlTags().trim().toSeconds()
					else songTimes = []
					# console.log songTimes
					
					for _xx, index in songTimes
						song = 
							# num : trackNuqms[index]
							id : songIds[index]
							title : songTitles[index]
							artists : songPerformers[index]
							composers : songComposers[index]
							duration : songTimes[index]
						album.songs.push song

				catch e
					console.log eq
					error = e
				if error is null
					callback(null,album)
				else callback(error,null)
	getAlbumsInRange : ->
		@resetStats()
		@stats.totalItems = @config.to - @config.from + 1
		@stats.currentTable = @table.Albums
		@config.count +=1
		console.log  "LOOP: #{@config.count}".inverse.blue + " - getting albums from : #{@config.from} - #{@config.to}".blue
		for idx in [@config.from..@config.to] by @config.step
			id = @arr[idx]
			do (id)=>
				@getAlbum @toKey(id,"mw"),(err,album)=>
					@stats.totalItemCount +=1
					@stats.currentId = id
					if err 
						@stats.failedItemCount +=1
						@fs.appendFile @config.errorFilePath,"#{id}\n",(err)->
							if err then console.log "Cannot append new file"
					else 
						@stats.passedItemCount +=1
						album.discographies = JSON.stringify album.discographies
						album.genres = JSON.stringify album.genres
						album.styles = JSON.stringify album.styles
						album.moods = JSON.stringify album.moods
						album.themes = JSON.stringify album.themes
						album.songs = JSON.stringify album.songs
						@connection.query @query._insertIntoAlbums, album, (errInfo)=>
							if errInfo
								# console.log errInfo
								# console.log album
								@fs.appendFile @config.sqlErrorFilePath,"#{id}\n",(err)->
									if err then console.log "Cannot append new file. SQL"
					
					@utils.printRunning @stats

					if @stats.totalItems is @stats.totalItemCount
						@utils.printFinalResult @stats
						if @config.leap > 0 and @config.count < @config.maxLeap
							@config.from  = @config.to + 1
							@config.to = @config.to + @config.leap
							@getAlbumsInRange()

	# print album to console. For debug purpose
	printAlbumFormat : (album)->
		console.log album
		for key, value of album
			if value instanceof Array
				console.log "\t#{key}:"
				for v in value
					console.log v
			else console.log "\t#{key} : #{value}"	
	getAlbums : ->
		id = "mw0002080092"
		id = "mw0002579055"
		id = 1675534
		id = 2579057
		@config =
			from : 20001
			to : 40000
			step : 1
			leap : 20000 # the number of items each loop
			maxLeap : 22
			count : 0
			errorFilePath : "./almusic.err"
			sqlErrorFilePath : "./almusic_sql.err"
		@connect()
		@fs  = require("fs")
		@fs.readFile "./amalbums.err", (err,content)=>
			if err then console.log err
			else 
				@arr = content.toString().split("\n")
				console.log "array length is : #{@arr.length}"

		
			console.log "MAX SOCKET: #{http.globalAgent.maxSockets}"
			@getAlbumsInRange()

	getRating : (key,callback)->
		link = "http://www.allmusic.com/tooltip/Album/#{key}?thumbnail=true"
		album = 
			id : parseInt(key.match(/([0-9]+)/)?[1],10)
			ratings : [0,0,0]
			coverart : ""
		@HTTPGet link, (err,data)=>
			if err 
				callback(err,null)
			else 
				error = null
				try
					coverart = data.match(/<img src="(.+?)"/)?[1]
					if coverart
						album.coverart = coverart.replace("?partner=allrovi.com","").replace("JPG_170","JPG_400")
					allmusicRating = data.match(/rating-allmusic-([0-9]+)/)?[1]
					if allmusicRating
						if parseInt(allmusicRating,10) is 0
							album.ratings[0] =  0
						else album.ratings[0] = parseInt(allmusicRating,10) + 1
					userRating = data.match(/average-user-rating[^]+?data-score="([0-9]+)"/)?[1]
					if userRating
						album.ratings[1] = parseInt(userRating,10)
					userRatingCount = data.match(/average-user-rating-count.+?([0-9]+)<\/span>/)?[1]
					if userRatingCount
						album.ratings[2] = parseInt(userRatingCount,10)

					
				catch e
					error = e
				if error
					callback(error,null)
				else callback(null,album)
	getRatingsInRange : ->
		@resetStats()
		@stats.totalItems = @config.to - @config.from + 1
		@stats.currentTable = @table.Albums
		@config.count +=1
		console.log  "LOOP: #{@config.count}".inverse.blue + " - getting albums from : #{@config.from} - #{@config.to}".blue
		for id in [@config.from..@config.to] by @config.step
			do (id)=>
				@getRating @toKey(id,"mw"),(err,album)=>
					@stats.totalItemCount +=1
					@stats.currentId = id
					if err 
						@stats.failedItemCount +=1
						@fs.appendFile @config.errorFilePath,"#{id}\n",(err)->
							if err then console.log "Cannot append new file"
					else 
						@stats.passedItemCount +=1
						upd = "UPDATE #{@table.Albums} SET ratings='#{JSON.stringify(album.ratings).replace(/^\[/,'{').replace(/\]$/,'}')}', coverart=#{@connection.escape album.coverart} where id=#{album.id}"
						@connection.query upd, (errInfo)=>
							if errInfo
								# console.log errInfo
								# console.log album
								@fs.appendFile @config.sqlErrorFilePath,"#{id}\n",(err)->
									if err then console.log "Cannot append new file. SQL"
					
					@utils.printRunning @stats

					if @stats.totalItems is @stats.totalItemCount
						@utils.printFinalResult @stats
						if @config.leap > 0 and @config.count < @config.maxLeap
							@config.from  = @config.to + 1
							@config.to = @config.to + @config.leap
							@getRatingsInRange()
	getRatings : ->
		@config =
			from : 2000001
			to : 2030000
			step : 1
			leap : 30000 # the number of items each loop
			maxLeap : 20
			count : 0
			errorFilePath : "./almusic.err"
			sqlErrorFilePath : "./almusic_sql.err"
		@connect()
		@fs  = require("fs")
		console.log "MAX SOCKET: #{http.globalAgent.maxSockets}"
		@getRatingsInRange()
				

	getSimilar : (key,callback)->
		link = "http://www.allmusic.com/album/ajax/google-bot-#{key}/similar/listview"
		album =
			id : parseInt(key.match(/([0-9]+)/)?[1],10)
			similar : []
		@HTTPGet link, (err,data)=>
			if err 
				callback(err,null)
			else 
				error = null
				song = 
					id : 0
					coverart : ""
					allmusicRating : 0
				try
					ids = data.match(/data-id="(.+?)"/g)
					if ids 
						ids = ids.map (v)-> parseInt(v.match(/data-id="(.+?)"/)?[1].match(/([0-9]+)/)?[1],10)
					else ids = []

					coverarts  = data.match(/data-original="(.+?)"/g)
					if coverarts
						coverarts = coverarts.map (v)-> v.match(/data-original="(.+?)"/)?[1].replace("?partner=allrovi.com","").replace("JPG_75","JPG_400")
					else coverarts = []
					
					allmusicRatings = data.match(/rating-allmusic-([0-9]+)/g)
					if allmusicRatings
						allmusicRatings = allmusicRatings.map (v)->
							ret = v.match(/rating-allmusic-([0-9]+)/)?[1]
							if parseInt(ret,10) is 0
								return 0
							else return (parseInt(ret,10) + 1)
					else allmusicRatings = []

					songs = []

					for id,idx in ids
						song = 
							id : id
							coverart : coverarts[idx]
							allmusicRating : allmusicRatings[idx]
						songs.push song
					album.similar = songs
				catch e
					error = e
				if error
					callback(error,null)
				else callback(null,album)
	getSimilarsInRange : ->
		@resetStats()
		@stats.totalItems = @config.to - @config.from + 1
		@stats.currentTable = @table.Albums
		@config.count +=1
		console.log  "LOOP: #{@config.count}".inverse.blue + " - getting albums from : #{@config.from} - #{@config.to}".blue
		for id in [@config.from..@config.to] by @config.step
			do (id)=>
				@getSimilar @toKey(id,"mw"),(err,album)=>
					@stats.totalItemCount +=1
					@stats.currentId = id
					if err 
						@stats.failedItemCount +=1
						@fs.appendFile @config.errorFilePath,"#{id}\n",(err)->
							if err then console.log "Cannot append new file"
					else 
						@stats.passedItemCount +=1
						similarids = album.similar.map (song)-> song.id
						upd = ""
						upd += "UPDATE #{@table.Albums} SET similars = '#{JSON.stringify(similarids).replace(/^\[/,'{').replace(/\]$/,'}')}' where id=#{album.id};"
						upd += "INSERT INTO amcovertart VALUES "
						for song, index in album.similar
							upd += " (#{song.id}, '#{song.coverart}', #{song.allmusicRating})"
							if index is album.similar.length-1
								upd += ";"
							else upd += ","
						# upd += "COMMIT;"
						# console.log upd
						# process.exit 0
						@connection.query upd, (errInfo)=>
							if errInfo
								# console.log errInfo
								# console.log album
								@fs.appendFile @config.sqlErrorFilePath,"#{id}\n",(err)->
									if err then console.log "Cannot append new file. SQL"
							# else console.log "DONE.................."
					
					@utils.printRunning @stats

					if @stats.totalItems is @stats.totalItemCount
						@utils.printFinalResult @stats
						if @config.leap > 0 and @config.count < @config.maxLeap
							@config.from  = @config.to + 1
							@config.to = @config.to + @config.leap
							@getSimilarsInRange()
	getSimilars : ->
		@config =
			from : 770001
			to : 800000
			step : 1
			leap : 30000 # the number of items each loop
			maxLeap : 100
			count : 0
			errorFilePath : "./almusic.err"
			sqlErrorFilePath : "./almusic_sql.err"
		@connect()
		@fs  = require("fs")
		console.log "MAX SOCKET: #{http.globalAgent.maxSockets}"
		@getSimilarsInRange()


	getCredit : (key,callback)->
		link = "http://www.allmusic.com/album/album/google-v2.5.4.2-#{key}/credits/mobile"
		album =
			id : parseInt(key.match(/([0-9]+)/)?[1],10)
			credits : []
		@HTTPGet link, (err,data)=>
			if err 
				callback(err,null)
			else 
				error = null
				try
					artistids = data.match(/mn[0-9]+/g)
					if artistids
						artistids = artistids.map (v)-> parseInt(v.match(/[0-9]+/)?[0],10)

					artists = data.match(/<a href=.+?<\/a>/g)
					if artists
						artists = artists.map (v)-> v.stripHtmlTags().trim()

					jobs = data.match(/<div class="credit">[^]+?<\/div>/g)
					if jobs
						jobs = jobs.map (v)-> v.stripHtmlTags().trim()

					for artistid, index in artistids
						credit = 
							id : artistid
							artist : artists[index]
							job : jobs[index]
						album.credits.push credit
				catch e
					error = e
				if error
					callback(error,null)
				else callback(null,album)

	getCreditsInRange : ->
		@resetStats()
		@stats.totalItems = @config.to - @config.from + 1
		@stats.currentTable = @table.Albums
		@config.count +=1
		console.log  "LOOP: #{@config.count}".inverse.blue + " - getting albums from : #{@config.from} - #{@config.to}".blue
		for id in [@config.from..@config.to] by @config.step
			do (id)=>
				@getCredit @toKey(id,"mw"),(err,album)=>
					@stats.totalItemCount +=1
					@stats.currentId = id
					if err 
						@stats.failedItemCount +=1
						@fs.appendFile @config.errorFilePath,"#{id}\n",(err)->
							if err then console.log "Cannot append new file"
					else 
						@stats.passedItemCount +=1
						upd = "UPDATE #{@table.Albums} SET credits=#{@connection.escape JSON.stringify(album.credits)}"
						upd += " WHERE id=#{album.id}"
						@connection.query upd, (errInfo)=>
							if errInfo
								# console.log errInfo
								# console.log album
								@fs.appendFile @config.sqlErrorFilePath,"#{id}\n",(err)->
									if err then console.log "Cannot append new file. SQL"
							# else console.log "DONE.................."
					
					@utils.printRunning @stats

					if @stats.totalItems is @stats.totalItemCount
						@utils.printFinalResult @stats
						if @config.leap > 0 and @config.count < @config.maxLeap
							@config.from  = @config.to + 1
							@config.to = @config.to + @config.leap
							@getCreditsInRange()
	getCredits : ->
		@config =
			from : 2360001
			to : 2390000
			step : 1
			leap : 30000 # the number of items each loop
			maxLeap : 5
			count : 0
			errorFilePath : "./almusic.err"
			sqlErrorFilePath : "./almusic_sql.err"
		@connect()
		@fs  = require("fs")
		console.log "MAX SOCKET: #{http.globalAgent.maxSockets}"
		@getCreditsInRange()

module.exports = AllMusic