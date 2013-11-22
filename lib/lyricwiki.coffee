Site = require "./Site"
http = require 'http'
url = require('url')
zlib = require('zlib')

class LyricWiki extends Site
	constructor: ->
		super "lw"
		@logPath = "./log/LWLog.txt"
		@table.Artists = "lwartists"
		@log = {}
		@_readLog()
		http.globalAgent.maxSockets = 5
		Array::unique = -> @filter -> arguments[2].indexOf(arguments[0], arguments[1] + 1) < 0
		Array::uniqueObject = (property)->
			indexOfObjectInArray  = (arr, searchTerm, property)->
				for i in [0..arr.length-1]
					if arr[i][property] is searchTerm
						return i
				return -1
			@.filter (element, index, array)->
   			indexOfObjectInArray(array, element[property], property) is index
	_getFieldFromTable : (params, callback)->
		_q = "Select #{params.sourceField} from #{params.table}"
		_q += " WHERE #{params.condition} LIMIT #{params.limit} OFFSET #{params.skip}" if params.limit
		console.log _q
		@connection.query _q, (err, results)=>
			# console.log err
			# console.log "ansdasd"
			callback results    
	 # this version removes all the status code 301 and 404. Applied only for lyricwiki
	getFileByHTTPv2 : (link, onSucess, onFail, options) ->
		# console.log "ansdas"
		# console.log link
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				# onSucess res.headers.location
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					
					onSucess data, options
				
			.on 'error', (e) =>
			 	onFail  "Cannot get file from server. ERROR: " + e.message, options
	getGzipped : (link, onSucess, onFail, options) ->
		headers =
			'Accept-Encoding': 'gzip'
		params = 
			'host' : url.parse(link).host
			'path' : url.parse(link).path
			'method' : "GET"
			'headers': headers
		# console.log params
		buffer = []
		http.get(params, (res) ->
			gunzip = zlib.createGunzip()
			res.pipe gunzip
			gunzip.on("data", (data) ->
			  buffer.push data.toString()
			).on("end", ->
				# console.log buffer.join("")
				onSucess buffer.join(""),options
			).on "error", (e) ->
			  onFail e,options
		).on "error", (e) ->
		 onFail e,options  
	processSong: (data,options)=>
		try 

			song = JSON.parse data
			if song.albums.length is 0
				# console.log "--#{options.name}-- has no album".red
				@onSongFail "no album", options
			else 
				@eventEmitter.emit "result-song", song, options

			return song
		catch error
			console.log "ERROR : at link #{options.name}. ---> #{error}"
	insertStatement : (query, options)->
		@connection.query query, (err)->
			if err then console.log "Cannot insert song #{options.id} [called in insertStatement() ] . ERROR: #{err}"

	onSongFail : (error, options)=>
		console.log "onSongFail() called: Err --#{options.link}-- has an error: #{error}"
		# console.log options
		_u = "UPDATE #{@table.Songs} SET "
		_u += "  download_done = -1 "
		_u += " where id=#{options.id}"
		# console.log "HWWE"
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		@stats.currentId  = options.id
		@utils.printRunning @stats
		# console.log _u
		# @insertStatement _u, options
		if @stats.totalItems is @stats.totalItemCount
			@utils.printFinalResult @stats
			@count +=1
			console.log " |GET NEXT STEP :#{@count}".inverse.red
			@resetStats()
			@_getSongsLyrics()
	_getSong : (artist)=>
		options = 
			id : artist.id
			name : artist.name
		link = "http://lyrics.wikia.com/api.php?artist=#{encodeURIComponent artist.name}&fmt=json"
		# console.log "#{link}".inverse.red
		@getFileByHTTP link, @processSong, @onSongFail, options	
	fetchSongs : ->
		@connect()
		@showStartupMessage "Fetching songs to table", @table.Songs
		@albumId = 0

		@eventEmitter.on "result-song", (song, options)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@stats.currentId  = options.id
			# @log.lastSongId = song.songid
			# @temp.totalFail = 0
			if song isnt null
				artist = song.artist
				count = 0
				for album in song.albums
					do (album)=>
						@albumId += 1
						for recording in album.songs
							_song = 
								title : recording
								artist_id : options.id
								artist : artist
								album : album.album
								album_id : @albumId
							_song.year = album.year if album.year
							count +=1
							@connection.query @query._insertIntoSongs, _song, (err)->
								if err  then console.log "Cannt insert song: #{song.id}. SITE: #{options.site} into database. ERROR: #{err}"
				
			else 
				@stats.passedItemCount -=1
				@stats.failedItemCount +=1
			@utils.printRunning @stats

			if @stats.totalItems is @stats.totalItemCount
				@utils.printFinalResult @stats
		

		params =
			sourceField : "#{@table.Artists}.name"
			table : @table.Artists
			limit : 70000
			condition : " id > 0 "

		params =
			sourceField : "anbinh.name"
			table : "anbinh"
			limit : 70000
			condition : " id > 0 "
		
		@_getFieldFromTable params, (artists)=>
			@stats.totalItems = artists.length
			console.log " |# of items : #{@stats.totalItems}"
			for artist in artists
				# console.log artist
				@_getSong artist

	# THIS PART FOR UPDATING LYRIC 
	processSongLyric: (data,options)=>
		try 

			song = 
				id : options.id
				title : options.title
				artist : options.artist
				lyric : ""
				download_done : 1

			if data.match(/class='lyricbox'.+Instrumental.+TrebleClef/)
				song.lyric = "Instrumental"
			
			lyric = data.match(/class='lyricbox'.+<\/span><\/div>(.+)<\!--/)?[1]

			if lyric 
				song.lyric = @processStringorArray lyric

			musicbrainzLink = data.match(/http:\/\/musicbrainz.+html/)?[0]
			if musicbrainzLink then song.musicbrainz_link  = musicbrainzLink

			allmusicLink  = data.match(/http:\/\/www\.allmusic\.com.+/)?[0]
			if allmusicLink then song.allmusic_link = allmusicLink.replace(/".+$/,'')

			youtubeLink = data.match(/http:\/\/youtube\.com.+/)?[0]
			if youtubeLink then song.youtube_link = youtubeLink.replace(/".+$/,'')

			is_gracenote = data.match(/View the Gracenote/)?[0]
			if is_gracenote then song.is_gracenote = 1

			language = data.match(/category normal" data-name="Language\/(.+)" data-namespace/)?[1]
			if language then song.language = language

			album = data.match(/appears on the album.+">(.+)<\/a><\/i>/)?[1]
			if album then song.album = album

			if options.date_created then song.date_created = options.date_created

			if song.lyric is "" then song.download_done = -1


			@eventEmitter.emit "result-song", song, options

			return song
		catch error
		    console.log "ERROR : at link #{options.name}. ---> #{error}"
	_getSongsLyrics : (source = "lyricwiki")=>
		params =
			sourceField : "id, #{@table.Songs}.title,#{@table.Songs}.artists"
			table : @table.Songs
			limit : @temp.nItems
			skip : @temp.nItemsSkipped
			condition : @temp.condition
		# console.log params
		@_getFieldFromTable params, (songs)=>

			# FOR TESTING
			# songs = [{id : 640472, artist : "David Coverdale", title : "Coverdale/Page:Don't Leave Me This Way"}]
			# test = {id : 123, artist : "Justin bieber", title : "never say never"}
			# songs.push test
			
			if songs and songs.length > 0
				@stats.totalItems = songs.length
				@stats.currentTable = @table.Songs
				console.log " |# of items : #{@stats.totalItems}"
				console.log " |Getting from range: #{songs[0].id} ---> #{songs[songs.length-1].id}"
				
				# console.log songs
				for song in songs
					options = 
					     id : parseInt(song.id,10)
					     title : song.title
					     artist : song.artists
					     source : source

					if song.title.search(':') > -1 then uri = song.title.replace(/\s+/g,'_')
					else  uri = song.artists.replace(/\s+/g,'_') + ':' + song.title.replace(/\s+/g,'_')

					if source is "lyricwiki" 
						# console.log uri
						link = "http://lyrics.wikia.com/#{encodeURIComponent uri}"
						# console.log "#{link}".inverse.red
						# link = "http://google.com"
						@getFileByHTTPv2 link, @processSongLyric, @onSongFail, options 
					else if source is "gracenote"
						# uri = uri.replace(/®/,'').replace(/Hank_Williams_Jr/,"Hank_Williams_Jr")
						link = "http://lyrics.wikia.com/Gracenote:#{encodeURIComponent uri}"
						# console.log link
						# link = link.replace("\%3A",':')
						# link = "http://lyrics.wikia.com/Gracenote:Lester_Flatt_%26_Earl_Scruggs:Give_Mother_My_Crown"
						# console.log "#{link}".inverse.red
						@getFileByHTTPv2 link, @processGraceNoteSongLyric, @onGraceNoteSongFail, options 
			else
				console.log "Nothing left!!"
		    
	updateSongsLyrics : ->
		@connect()
		@showStartupMessage "Fetching songs lyric to table", @table.Songs
		@count = 0
		
		@temp = 
			nItems : 1500
			nItemsSkipped : 10
			# condition : " download_done is null"
			condition : " download_done=0 "
		console.log " |The number of items to skip: #{@temp.nItemsSkipped}"

		@eventEmitter.on "result-song", (song, options)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@stats.currentId  = options.id
			# @log.lastSongId = song.songid
			# @temp.totalFail = 0
			if song isnt null
				_u = "UPDATE #{@table.Songs} SET "
				# _u += "  musicbrainz_link = #{@connection.escape song.musicbrainz_link}, " if song.musicbrainz_link
				# _u += "  allmusic_link = #{@connection.escape song.allmusic_link}, " if song.allmusic_link
				# _u += "  youtube_link = #{@connection.escape song.youtube_link}, " if song.youtube_link
				_u += "  is_gracenote=#{@connection.escape song.is_gracenote}, " if song.is_gracenote
				_u += "  download_done=#{song.download_done}, "
				_u += "  lyric=#{@connection.escape song.lyric} "
				_u += " where id=#{song.id}"
				# console.log song
				# console.log _u
				@insertStatement _u, options
			else 
				@stats.passedItemCount -=1
				@stats.failedItemCount +=1
			@utils.printRunning @stats

			if @stats.totalItems is @stats.totalItemCount
				@utils.printFinalResult @stats
				@count +=1
				console.log " |GET NEXT STEP :#{@count}".inverse.red
				@resetStats()
				@_getSongsLyrics()


		@_getSongsLyrics()


	# THIS PART FOR GRACENOTE LYRIC
	# ------------------------------------------------------------------------------------------
	processGraceNoteSongLyric: (data,options)=>
		try 

			song = 
				id : options.id
				title : options.title
				artist : options.artist
				gracenote_songwriters  : ""
				gracenote_publishers : ""
				gracenote_lyric : ""
				download_gracenote_done : 1

			gracenote_songwriters = data.match(/Songwriters.+/)?[0]
			if gracenote_songwriters then song.gracenote_songwriters = @processStringorArray gracenote_songwriters
																						.replace(/<\/em>|<\/em>.+$/,'')
																						.replace(/^.+<em>/,'')

			gracenote_publishers = data.match(/Publishers.+/)?[0]
			if gracenote_publishers then song.gracenote_publishers = @processStringorArray gracenote_publishers
																						.replace(/<\/em>|<\/em>.+$/,'')
																						.replace(/^.+<em>/,'')																		   
			lyric = data.match(/class='lyricbox'.+<\/a><\/div>\s+(.+)<\!--/)?[1]
			if not lyric then lyric = data.match(/class='lyricbox'.+<\/a><\/div>(.+)<\!--/)?[1]

			if lyric 
				song.gracenote_lyric = @processStringorArray lyric.replace(/^<p>/,'')

			if song.gracenote_lyric is "" then song.download_gracenote_done = 0

			# console.log data.match(/class='lyricbox'.+/)?[0]

			@eventEmitter.emit "result-song", song, options

			return song
		catch error
		    console.log "ERROR : at link #{options.name}. ---> #{error}"
	onGraceNoteSongFail : (error, options)=>
		# console.log "err --#{options.id}-- has an error: #{error}"
		# console.log options.link
		_u = "UPDATE #{@table.Songs} SET "
		_u += "  download_gracenote_done = -1 "
		_u += " where id=#{options.id}"
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		@stats.currentId  = options.id
		@utils.printRunning @stats
		# console.log _u
		@insertStatement _u, options
		if @stats.totalItems is @stats.totalItemCount
			@utils.printFinalResult @stats
			@count +=1
			console.log " |GET NEXT STEP :#{@count}".inverse.red
			@resetStats()
			@_getSongsLyrics("gracenote")
	updateGraceNoteSongsLyrics : (datetime)->
		# for testing 
		# datetime = "2013-06-10 03:35:21"
		@connect()
		@showStartupMessage "Fetching GRACENOTE songs lyric to table", @table.Songs
		@count = 0
		@resetStats()
		
		@temp = 
			nItems : 1000
			nItemsSkipped : 0
			condition : "  download_gracenote_done is null and is_gracenote=1 "
			# condition : " download_done=1 and download_gracenote_done=0 "
		if datetime 
			@temp.condition = "  checktime > '#{datetime}' and download_gracenote_done is null and is_gracenote=1 "
		console.log " |The number of items to skip: #{@temp.nItemsSkipped}"
		@eventEmitter.on "result-song", (song, options)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@stats.currentId  = options.id
			# @log.lastSongId = song.songid
			# @temp.totalFail = 0
			if song isnt null
				_u = "UPDATE #{@table.Songs} SET "
				_u += "  gracenote_songwriters = #{@connection.escape song.gracenote_songwriters}, "
				_u += "  gracenote_publishers = #{@connection.escape song.gracenote_publishers}, "
				_u += "  gracenote_lyric = #{@connection.escape song.gracenote_lyric}, " 
				_u += "  download_gracenote_done = #{song.download_gracenote_done} "
				_u += " where id=#{song.id}"
				# console.log song
				# console.log _u
				@insertStatement _u, options
			else 
				@stats.passedItemCount -=1
				@stats.failedItemCount +=1
			@utils.printRunning @stats

			if @stats.totalItems is @stats.totalItemCount
				@utils.printFinalResult @stats
				@count +=1
				console.log " |GET NEXT STEP :#{@count}".inverse.red
				@resetStats()
				@_getSongsLyrics("gracenote")

		@_getSongsLyrics("gracenote")
	# THIS PART FOR UPDATING METRO LYRIC
	# --------------------------------------------------------------------------------
	onAlbumFail : (error, options)=>
		console.log "err  has an errorq: #{error}, #{options.id}"
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		_u = "UPDATE #{@table.Albums} SET "
		_u += "  download_done = -1 "
		_u += " where id=#{options.id}"
		# console.log album
		# console.log _u
		@connection.query _u, (err)->
			if err then console.log "Cannot insert album #{options.id} . ERROR: #{err}"
		@utils.printRunning @stats
		if @stats.totalItems is @stats.totalItemCount
			@utils.printFinalResult @stats
			@count +=1
			console.log " |GET NEXT STEP :#{@count}".inverse.red
			@resetStats()
			@_getAlbum()
	 processAlbum: (data,options)=>
		try 

			album = 
				id : options.id
				title : options.title
				artist : options.artist
				year : options.year
				genre : ""
				duration : 0
				coverart : ""
				allmusic_link : ""
				discogs_link : ""
				musicbrainz_link : ""
				download_done : 1

			# DO SOMETHING
			duration = data.match(/Length:.+<\/td><\/tr>.+/)?[0]
			if duration 
				duration = duration.replace(/<\/td><\/tr>.+/,'').replace(/^.+>/,'').split(":").map (v)-> parseInt v,10
				if duration.length is 2
					album.duration = duration[0]*60 + duration[1]
				else if duration.length is 3
					album.duration = duration[0]*3600 + duration[1]*60 + duration[2]
				else console.log "ERROR ar duration. #{options.id} ---"

			genre = data.match(/Genre:.+<\/a><\/td><\/tr>.+/)?[0]
			if genre then album.genre = @processStringorArray genre.replace(/<\/a><\/td><\/tr>.+/,'').replace(/^.+>/,'')

			coverart = data.match(/<\/div><\/div><\/div><td>.+/)?[0]
			if coverart then album.coverart = coverart.replace(/" class.+/,'').replace(/^.+"/,'')

			musicbrainz_link = data.match(/MusicBrainz:.+/)?[0]
			if musicbrainz_link then album.musicbrainz_link = musicbrainz_link.replace(/">.+/,'').replace(/^.+"/,'')

			discogs_link = data.match(/Discogs:.+/)?[0]
			if discogs_link then album.discogs_link = discogs_link.replace(/">.+/,'').replace(/^.+"/,'')

			allmusic_link = data.match(/allmusic:.+/)?[0]
			if allmusic_link then album.allmusic_link = allmusic_link.replace(/">.+/,'').replace(/^.+"/,'')

			if  album.coverart is "" and album.musicbrainz_link is "" and album.discogs_link is "" and album.allmusic_link is "" and album.genre is "" and album.duration is 0
				album.download_done = 0

			@eventEmitter.emit "result-album", album, options

			return album
		catch error
		    console.log "ERROR : at link #{options.link}. ---> #{error}"
	_getAlbum : (artist)=>
		params =
		    sourceField : "id, #{@table.Albums}.title,#{@table.Albums}.artist,#{@table.Albums}.year"
		    table : @table.Albums
		    limit : @temp.nItems
		    skip : @temp.nItemsSkipped
		    condition : " year is not null and download_done is null"
		    # condition : " id=160884 "
		
		@_getFieldFromTable params, (albums)=>
			@stats.totalItems = albums.length
			console.log " |# of items : #{@stats.totalItems}"
			console.log " |Getting from range: #{albums[0].id} ---> #{albums[albums.length-1].id}"
			for album in albums
				  # console.log album
				options = 
					id : album.id
					title : album.title
					artist : album.artist
					year : album.year
	
				uri = "#{album.artist}:#{album.title}_(#{album.year})".replace(/\s/g,'_')
	
				link = "http://lyrics.wikia.com/#{encodeURIComponent(uri)}"
				options.link = link
				# console.log "#{options.id} \t- #{link}".inverse.red
				@getFileByHTTPv2 link, @processAlbum, @onAlbumFail, options 
	updateAlbums :->
		@connect()
		@showStartupMessage "Fetching METROLYRIC of albums to table", @table.Albums
		@count = 0
		@stats.currentTable = @table.Albums
		@temp = 
		    nItems : 1000
		    nItemsSkipped : 0
		console.log " |The number of items to skip: #{@temp.nItemsSkipped}"

		@eventEmitter.on "result-album", (album, options)=>
		    @stats.totalItemCount +=1
		    @stats.passedItemCount +=1
		    @stats.currentId  = options.id
		    if album isnt null
			    _u = "UPDATE #{@table.Albums} SET "
			    _u += "  genre = #{@connection.escape album.genre}, " 
			    _u += "  duration = #{album.duration}, "
			    _u += "  coverart = #{@connection.escape album.coverart}, "
			    _u += "  allmusic_link = #{@connection.escape album.allmusic_link}, "
			    _u += "  discogs_link = #{@connection.escape album.discogs_link}, "
			    _u += "  musicbrainz_link = #{@connection.escape album.musicbrainz_link}, "
			    _u += "  download_done = #{album.download_done} "
			    _u += " where id=#{album.id}"
			    # console.log album
			    # console.log _u
			    @connection.query _u, (err)->
				    if err then console.log "Cannot insert album #{album.id} . ERROR: #{err}"
		    else 
			    @stats.passedItemCount -=1
			    @stats.failedItemCount +=1
		    @utils.printRunning @stats

		    if @stats.totalItems is @stats.totalItemCount
			    @utils.printFinalResult @stats
			    @count +=1
			    console.log " |GET NEXT STEP :#{@count}".inverse.red
			    @resetStats()
			    @_getAlbum()


		@_getAlbum()


	# THIS PART FOR fetching GENRE
	# --------------------------------------------------------------------------------
	onItemFail : (err, options)=>
		console.log "Link: {options.link} has an error. ERROR:#{err}"
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		@utils.printUpdateRunning @stats.totalItemCount*200, @stats, "Fetching...."
	processItem : (data,options)=>
		nextlink = data.match(/previous 200.+href=\"(.+)\" title.+next 200/)?[1]
		@eventEmitter.emit "item-processing", data, options
		if nextlink then @_getItem "http://lyrics.wikia.com#{nextlink}"
	_getItem : (link)->
		options = 
			link : link
			genre : link.replace(/http\:\/\/lyrics\.wikia\.com\//,'')
		# console.log "#{link}".inverse.red
		@getFileByHTTP link, @processItem, @onItemFail, options  
	fetchItems: (uri) ->
		@connect()
		

		link = "http://lyrics.wikia.com/#{uri}"
		@_getItem link
	updateStats : (options)->
		@stats.totalItemCount +=1
		@stats.passedItemCount +=1
		@utils.printUpdateRunning @stats.totalItemCount*200, @stats, "Fetching...."

	insertItemIntoDB : (item,insertStatement)->
		# console.log item
		# console.log insertStatement
		# item = { artist: 'Adamski', genre: 'Acid House' }
		# item =  
		#	 artist: 'Alabama 3',
		#	 album: 'Outlaw',
		#	 year: '2005',
		#	 genre: 'Acid House' 

		@connection.query insertStatement, item, (err)->
			if err then console.log "We have an  error at item: #{item} --> #{err}".red
	_getAlbumsArtistsGenres  : (langs)->
		@showStartupMessage "Fetching items to table", @table.Songs
		for lang in langs
			@fetchItems lang
			# console.log lang
		@eventEmitter.on "item-result", (items, options)=>
			@updateStats(options)
			# console.log "ANSDNSAD"
			for item in items
				if item isnt undefined
					@insertItemIntoDB item, "INSERT IGNORE INTO lwalbums_artists_genres SET ?"
				else 
					@stats.totalItemCount +=1
					@stats.failedItemCount +=1
		@eventEmitter.on "item-processing", (data,options)=>

			items = []
			temps = data.match(/<li><a href=\".+/g)
			if temps
				temps.map (v)=>
					_temp = v.replace(/<\/a>.+/,'').replace(/^.+>/,'').split(":")
					if _temp.length is 2
						_t = 
							artist : @processStringorArray _temp[0]
							album : @processStringorArray _temp[1].replace(/(\([0-9]+\))/,'')
							year : _temp[1].match(/\(([0-9]+)\)/)?[1]
							genre : @processStringorArray decodeURIComponent options.link.replace(/http\:\/\/lyrics\.wikia\.com\/Category\:Genre\//,'').replace(/\?pagefrom.+/,'').replace(/_/g,' ')
					else if _temp.length is 1
						_t = 
							artist : @processStringorArray _temp[0]
							genre : @processStringorArray decodeURIComponent options.link.replace(/http\:\/\/lyrics\.wikia\.com\/Category\:Genre\//,'').replace(/\?pagefrom.+/,'').replace(/_/g,' ')
					else if _temp.length is 3
						_t = 
							artist : @processStringorArray _temp[0]+":"+_temp[1]
							album : @processStringorArray _temp[2].replace(/(\([0-9]+\))/,'')
							year : _temp[1].match(/\(([0-9]+)\)/)?[2]
							genre : @processStringorArray decodeURIComponent options.link.replace(/http\:\/\/lyrics\.wikia\.com\/Category\:Genre\//,'').replace(/\?pagefrom.+/,'').replace(/_/g,' ')

					else console.log "#{options.link} ..... #{_temp}"
					items.push _t
			# console.log items
			@eventEmitter.emit "item-result", items, options
	fetchAlbumsArtistsGenres : ->
		@connect()
		@connection.query "select link from lwgenres", (err,results)=>
			if err then console.log "#{err}"
			else 
				console.log "#n results #{results.length}"
				genres = []
				# results = [{link : "/Category:Genre/Acoustic"}]
				for genre in results
					genres.push genre.link.replace(/\/Category\:/,'Category:')
				@_getAlbumsArtistsGenres genres
		# lang = "Category:Language/Japanese"


	# this is new part on July 02
	# 
	_fetchLyric : (song,source = "lyricwiki")->
		if source is "lyricwiki" 
			# console.log song
			link = "http://lyrics.wikia.com/#{encodeURIComponent(song.artist.replace(/\s/g,'_')+":"+song.title.replace(/\s/g,'_'))}"
			# console.log link
			options = 
				title : song.title
				artist : song.artist
				date_created : song.date_created
				link : link
			# console.log link
			@getFileByHTTPv2 link, @processSongLyric, @onSongFail, options 
		else if source is "gracenote"
			link = "http://lyrics.wikia.com/Gracenote:#{encodeURIComponent page.name}"
			@getFileByHTTPv2 link, @processGraceNoteSongLyric, @onGraceNoteSongFail, options
	_updateLyric : (path)->
		link  = "http://lyrics.wikia.com" + path
		options = 
			link : link
		@getFileByHTTPv2 link,@onSucess,@onFail,options
	updateLyrics : ->
		@connect()
		console.log "MAX SOCKET IS : #{http.globalAgent.maxSockets}"
		@showStartupMessage "Fetching new lyric to table", @table.Songs
		
		@newPages = []

		@helpers = {}
		@helpers.getTimestamp = (str)->
			if str.match(/,/)
				t = str.split(',')
				temp = t[0]
				t[0] = t[2]
				t[2] = temp
				t = t.join(',')
			else t = str
			return new Date(t).getTime()
		@helpers.getInsertStatement = (objects,table,connection)->	
			getStatementFromObject = (object,table)=>
				columns = []
				values = []
				for key,value of object
					columns.push "#{table}.#{key}"
					values.push  connection.escape value
				return "INSERT IGNORE INTO #{table} (#{columns.join(',')}) VALUES (#{values.join(",")})"

			if objects instanceof Array 
				statements = []
				for object in objects
					statements.push getStatementFromObject object, table
				if statements.length > 0
					return statements.join(";")+";"
				else return ""
			else  
				statement = getStatementFromObject objects, table
				statement += ";"
				return statement
		@helpers.printUpdateInfo = (info) =>
			tempDuration = Date.now() - @stats.markedTimer
			message  = " |"+"#{info}"
			message += " | t:"  + @utils._getTime(tempDuration)
			message += "                                  "
			message += "\r"
			process.stdout.write message
		@helpers.getMaxId = (field,table,connection,callback)->
			select = "Select max(#{field}) as max from #{table}"
			connection.query select, (err, result)->
				if err then	callback "Cannot find max #{field} of #{table}", null
				else 
					for item in result
						callback null, item.max

		ObjectFinding = require './lyricwiki/object_finding'

		itemSearching = new ObjectFinding(@table,@connection)
				
		@processNewItems = =>
			artists = []
			albums = []
			songs = []
			temporarySongs = @newPages.filter (v) ->  if v.type is "song" then return true else return false
			temporaryAlbums = @newPages.filter (v) ->  if v.type is "album" then return true else return false
			console.log "# of new songs: #{temporarySongs.length}, new albums:#{temporaryAlbums.length}".magenta
			for album in temporaryAlbums
				temp = album.name.split(':')
				_album = 
					title : @processStringorArray temp[1]
					artist : @processStringorArray temp[0]
					date_created : @formatDate(new Date(album.date_created))
				artists.push _album.artist
				if _album.title
					if _album.title.match(/\([0-9]+\)/)
						year = _album.title.match(/\(([0-9]+)\)/)?[1]
						if year 
							_album.year = year
						else
							_album.year = '1000'
						_album.title = _album.title.replace(/\([0-9]+\)/,'').trim()
					if _album.year is undefined then _album.year = '1000'
					albums.push _album
			for song in temporarySongs
				temp = song.name.split(':')
				_song = 
					title : @processStringorArray temp[1]
					artist : @processStringorArray temp[0]
					date_created : @formatDate(new Date(song.date_created))
				artists.push _song.artist
				songs.push _song

			# console.log songs
			# console.log albums

			# Filter unique albums
			albums = albums.map (v)-> 
				v.hash = v.title+":"+v.artist
				return v
			albums = albums.uniqueObject "hash"
			albums = albums.map (v)-> 
				delete v.hash 
				return v

			# Filter unique artists	
			artists = artists.unique()

			#FIlter legitimate songs
			songs = songs.filter (v)-> if v.artist and v.title then return yes else return false
			console.log "# of legitimate songs #{songs.length}".inverse.green

			# console.log songs
			# console.log albums
			itemSearching.insertNewArtistsAnNewAlbumsToDB artists,albums,(err)=>
				if err then console.log "CANNT BE DONE #{err}"
				else 
					console.log "New artists and new albums have been inserted!"
					@stats.totalItems = songs.length
					# console.log songs
					for song in songs
						@_fetchLyric song
		@eventEmitter.on "result-song", (song, options)=>

			@stats.totalItemCount +=1
			@stats.passedItemCount +=1

			# console.log "--------"
			# console.log song	
			# 
			try 
				itemSearching.addArtistidAndAlbumidToANewSong song, (newSong)=>
					# console.log newSong
					# process.exit 0
					# change the name of property
					if newSong.album
						newSong.album_title= newSong.album
						delete newSong.album
					if newSong.artist
						newSong.artists= newSong.artist
						delete newSong.artist

					itemSearching.addNewSong newSong, (err)->
						if err
							console.log "------------- at #{newSong}"  
							console.log err
			catch e
				console.log "Error occurs in updateLyrics(). #{e}"
				console.log song
			
			@utils.printRunning @stats

			if @stats.totalItems is @stats.totalItemCount
				@utils.printFinalResult @stats
				@updateGraceNoteSongsLyrics(@config.datetime)
		@onFail = (data, options)=>
			console.log "failed"
		@onSucess = (data,options)=>
			items = data.match(/<li><a href=.+/g)
			# console.log "# of items : #{items.length}"
			pages = []
			items.map (item,index)=>
				_page = {}
				_page.date_created = @helpers.getTimestamp item.match(/mw-newpages-time.+/)?[0].replace(/<.+$/,'').replace(/^.+>/,'')
				_page.name = @processStringorArray item.match(/mw-newpages-pagename.+/)?[0].replace(/<.+$/,'').replace(/^.+>/,'')
				if item.match(/Created page with/)
					_page.type = "song"
				else if item.match(/Album created/)
					_page.type = "album"
				if _page.name.match(/\([0-9]+\)/)
					_page.type = "album"
				pages.push _page
			
			# Filter song only, delete property type of a song
			# pages = pages.filter (v) -> if v.type is "song" then return true else return false
			# pages = pages.map (v)-> 
			# 	delete v.type
			# 	return v

			# console.log "# of new songs : #{pages.length}, total songs: #{@newPages.length}"
			# console.log pages
			isNextpage = true
			pages.forEach (v)=> if v.date_created <  @config.lastUpdatedTimestamp then isNextpage = false

			pages = pages.filter (v)=> if v.date_created >  @config.lastUpdatedTimestamp then return yes else return no

			pages.forEach (v)=> @newPages.push v

			# console.log "Get next page: #{isNextpage}"
			if isNextpage
				nextLink = data.match(/\|  <a.+nextlink/g)?[0]
				if nextLink
					nextLink = nextLink.match(/href="(.+)" title/)?[1]
					path = @processStringorArray nextLink
					# console.log "Refer to new URL: #{path}"
					@helpers.printUpdateInfo "# new songs + albums added: #{@newPages.length} "
					@_updateLyric path
				else
					console.log "Cannt get next link"
			else
				console.log ""
				console.log "Total new pages (songs+albums) found: #{@newPages.length}"
				# console.log @newPages
				@processNewItems()
		
		@config = 
			lastUpdatedTimestamp : 0
			datetime : ""

		itemSearching.findLastCreatedDate (err,lastDate)=>
			if err then console.log err
			else 
				@config.lastUpdatedTimestamp = lastDate.getTime()
				@config.datetime = @formatDate lastDate
				# console.log @config.datetime
				console.log "Last posted date: #{new Date(@config.lastUpdatedTimestamp)}"
				@_updateLyric("/Special:NewPages?limit=500")
	

	showStats : ->
	  @_printTableStats @table


module.exports = LyricWiki








