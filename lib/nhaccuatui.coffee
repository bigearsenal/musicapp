http = require 'http'
xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require 'colors'
fs = require 'fs'

Encoder = require('node-html-encoder').Encoder
encoder = new Encoder('entity');

events = require('events')

NCT_CONFIG = 
	table : 
		Songs : "NCTSongs"
		Albums : "NCTAlbums"
		Videos : "NCTVideos"
		MVs : "NCTMVs"
		MVPlaylists : "NCTMVPlaylists"
		MVs_MVPlaylists : "NCTMVs_MVPlaylists"
		Songs_Albums  : "NCTSongs_Albums"
	logPath : "./log/NCTLog.txt"

class Nhaccuatui extends Module
	constructor : (@mysqlConfig, @config = NCT_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoNCTSongs : "INSERT IGNORE INTO " + @table.Songs + " SET ?"
			_insertIntoNCTAlbums : "INSERT INTO " + @table.Albums + " SET ?"
			_insertIntoNCTVideos : "INSERT IGNORE INTO " + @table.Videos + " SET ?"
			_insertIntoNCTSongs_Albums : "INSERT INTO " + @table.Songs_Albums + " SET ?"
			_insertIntoNCTMVs : "INSERT INTO " + @table.MVs + " SET ?"
			_insertIntoNCTMVPlaylists : "INSERT INTO " + @table.MVPlaylists + " SET ?"
			_insertIntoNCTMVs_MVPlaylists : "INSERT INTO " + @table.MVs_MVPlaylists + " SET ?"
		@utils = new Utils()
		@parser = new xml2js.Parser();
		@eventEmitter = new events.EventEmitter()
		super @mysqlConfig
		@logPath = @config.logPath
		@log = {}
		@_readLog()
		Array::unique = (property)->
			indexOfObjectInArray  = (arr, searchTerm, property)->
				for i in [0..arr.length-1]
					if arr[i][property] is searchTerm
						return i
				return -1
			@.filter (element, index, array)->
   			indexOfObjectInArray(array, element[property], property) is index

	printUpdateAlbum : (info) ->
			tempDuration = Date.now() - @stats.markedTimer
			message  = " |"+"#{info}"
			message += " | t:"  + @utils._getTime(tempDuration)
			message += "                                  "
			message += "\r"
			process.stdout.write message
	getFileByHTTP : (link, onSucess, onFail, options) ->
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				# onSucess res.headers.location
				if res.statusCode isnt 302
					res.on 'data', (chunk) =>
						data += chunk;
					res.on 'end', () =>
						
						onSucess data, options
				else onFail("The link: #{link} is temporary moved",options)
			.on 'error', (e) =>
				onFail  "Cannot get file: #{link} from server. ERROR: " + e.message, options
				@stats.failedItemCount +=1
	
	_onFail : (err)->
		console.log "#{err}".red


	_fetchAlbumsPlays : (ids)->
		
		link = "http://www.nhaccuatui.com/wg/get-counter?listPlaylistIds=#{ids}"
		@getFileByHTTP(link, (data)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			data = JSON.parse data
			_albums = data.data.playlists
			for al in @albums
				if _albums[al.id]?
					al.plays = _albums[al.id]

			@utils.printRunning @stats
			if @stats.totalItemCount is @stats.totalItems
				@utils.printFinalResult @stats
				@eventEmitter.emit "album-plays-result", @albums
		, @_onFail)
	updateAlbumsPlays : (albums, onDone)->

		n = albums.length
		lengthOfGroup = 200

		if n%lengthOfGroup is 0
			nChunks = n/lengthOfGroup | 0
		else 
			nChunks = (n/lengthOfGroup|0) + 1

		@resetStats()
		@stats.totalItems = nChunks
		@stats.currentTable = "STORE IN MEMORY ONLY (NOT DB)"
		a = []
		for album in albums
			if a.length < lengthOfGroup
				a.push album.id
			else 
				@_fetchAlbumsPlays a.join(',')
				a = []
				a.push album.id
		@_fetchAlbumsPlays a.join(',')
		
		@eventEmitter.on "album-plays-result", (albums)->
			onDone albums
	_fetchSongsPlays : (ids)->
		link = "http://www.nhaccuatui.com/wg/get-counter?listSongIds=#{ids}"
		onSucess = (data)=> 
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			data = JSON.parse data
			songs = data.data.songs
			# console.log songs
			for  id, plays of songs
				do (id, plays)=>
					_u = "update #{@table.Songs} SET plays=#{plays} where id=#{id}"
					@connection.query _u, (err)->
								if err then console.log "Cannt update the total plays of the song #{id} into database. ERROR: #{err}"
			@utils.printRunning @stats
			if @stats.totalItemCount is @stats.totalItems
				@utils.printFinalResult @stats

		@getFileByHTTP link, onSucess, @_onFail
	updateSongsPlays : ->
		@connect()
		@resetStats()
		console.log " |STEP 6: Update plays of songs in DB".magenta
		@stats.currentTable = @table.Songs
		_q = "select id, #{@table.Songs}.key from #{@table.Songs} where plays = 0"
		# console.log  _q
		@connection.query _q, (err,results)=>
			if err then console.log "Cannt query song where plays is 0"
			else 
				n = results.length
				lengthOfGroup = 200

				if n%lengthOfGroup is 0
					nChunks = n/lengthOfGroup | 0
				else 
					nChunks = (n/lengthOfGroup|0) + 1
				a = []
				@stats.totalItems = nChunks
				@stats.currentTable = @table.Songs

				for song in results
					if a.length < lengthOfGroup
						a.push song.id
					else 
						@_fetchSongsPlays a.join(',')
						a = []
						a.push song.id
				@_fetchSongsPlays a.join(',')
	insertAlbumsIntoDB : (albums)->
		console.log " |STEP 5: Inserting new albums into table".magenta
		@resetStats()
		@stats.totalItems = albums.length
		@stats.currentTable = @table.Albums
		for album in albums
			do (album)=>
				songs = album.songs
				delete album.songs
				@connection.query @query._insertIntoNCTAlbums, album, (err)=>
					@stats.totalItemCount +=1
					@stats.currentId = album.id
					if err then @stats.failedItemCount +=1
					else
						@stats.passedItemCount +=1
						for song in songs
							do (song,album) =>
								@connection.query @query._insertIntoNCTSongs_Albums, {songid: song.id, albumid : album.id}, (err1)=>
									if err1 then console.log "cannt insert song: #{song.key} of album: #{album.key}. ERROR: #{err1}"
						
					@utils.printRunning @stats
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats
						@updateSongsPlays()
	processSong : (data,options)=>
		song = 
			id : options.id
			key : options.key
			title : ""
			artists : ""
			topic : ""
			plays : 0
			bitrate : 0
			type : ""
			link_key : ""
			lyric : ""

		id = data.match(/hidden.+\"(\d+)\".+inpHiddenId/)?[1]

		if id
			id = parseInt(id,10)
			if id isnt song.id
				song.id = id

		topic =  data.match(/inpHiddenGenre.+/g)?[0]
		if topic then song.topic = topic.replace(/inpHiddenGenre.+value\=|\"|\s\/\>/g,'')

		artists = data.match(/inpHiddenSingerIds.+/g)?[0]
		if artists then song.artists = JSON.stringify artists.replace(/inpHiddenSingerIds.+value\=|\"|\s\/\>/g,'').split(',').map((v)->encoder.htmlDecode(v).trim())

		title = data.match(/songname.+[\r\t\n]+.+/g)?[0]
		if title then song.title = encoder.htmlDecode title.replace(/<\/h1>.+/g,'').replace(/^.+[\r\t\n]+.+>/,'')

		link_key = data.match(/flashPlayer\"\,\s\".+/g)?[0]
		if link_key then song.link_key = link_key.replace(/0\..+/g,'').replace(/\s\"/g,'').replace(/\"\,$/g,'').replace(/flashPlayer.+\,/g,'')

		type =  data.match(/.+inpHiddenType/g)?[0]
		if type then song.type = type.replace(/\"\sid.+$/g,'').replace(/^.+\"/g,'')

		lyric = data.match(/divLyric[^]+inpLyricId/g)?[0]
		if lyric then song.lyric = encoder.htmlDecode lyric.replace(/<input.+$/g,'').replace(/[^]+hidden;\">\n/g,'').trim().replace(/<\/div>$/g,'').trim()
	
		bitrate = data.match(/<meta content=.+\s(\d+)kb/)?[1] 
		if bitrate 
			song.bitrate = bitrate
		# THIS PART IS OPTIONAL. Only use for getting new songs
		@processSimilarSongs data, options
		# END OF OPTIONAL PART

		@eventEmitter.emit "song-result", song

		song
	fetchSongs : (albums)->
		# albums has full stats and array of songs
		songs = []
		for album in albums
			for song in album.songs
				songs.push song

		@eventEmitter.on "song-result", (song)=>
			# console.log song
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@stats.currentId = song.id
			@utils.printRunning @stats

			@connection.query @query._insertIntoNCTSongs, song, (err)->
				if err then console.log "Cannt insert song: #{song.key}. ERROR #{err} "

			if @stats.totalItems is @stats.totalItemCount
				@utils.printFinalResult @stats
				@insertAlbumsIntoDB @albums
				
		console.log " |The number of songs found in new albums: #{songs.length}"
		console.log " |STEP 4: Fetching & inserting new songs".magenta
		@resetStats()
		@stats.totalItems = songs.length
		@stats.currentTable = @table.Songs

		# for testing
		# songs = [{ id: '2442282',key: 'GbV3lZa2Yifq'}]
		
		for song in songs
				do (song)=>
					link = "http://www.nhaccuatui.com/bai-hat/joke-link.#{song.key}.html"
					options = 
						id : song.id
						key : song.key
					@getFileByHTTP link, @processSong, @_onFail, options
	processAlbum : (data,options)=>
		album = 
			id : options.id
			key : options.key
			title : ""
			artists : ""
			topic : ""
			plays : options.plays
			nsongs : 0
			thumbnail : ""
			link_key : ""
			created : "0000-00-00"

		if data.match(/<p\sclass\=\"category\"\>Thể\sloại\:.+/g)
				_info = data.match(/<p\sclass\=\"category\"\>Thể\sloại\:.+/g)[0].split('|')
				album.nsongs = parseInt _info[2].replace(/Số\sbài\:\s|<\/p\>/g,'').trim(), 10

			link_key = data.match(/flashPlayer\"\,\s\"playlist.+/g)?[0]
			if link_key then album.link_key = link_key.replace(/flashPlayer.+playlist|0\..+|\s|\"|\,/g,'')

			topic =  data.match(/inpHiddenGenre.+/g)?[0]
			if topic then album.topic = topic.replace(/inpHiddenGenre.+value\=|\"|\s\/\>/g,'')

			artists = data.match(/inpHiddenSingerIds.+/g)?[0]
			if artists then album.artists = JSON.stringify artists.replace(/inpHiddenSingerIds.+value\=|\"|\s\/\>/g,'').split(',').map((v)->encoder.htmlDecode(v).trim())

			title = data.match(/songname.+/g)?[0]
			if title then album.title = encoder.htmlDecode title.replace(/<\/h1>.+/g,'').replace(/^.+>/,'')

			thumbnail = data.match(/.+img152/g)?[0]
			if thumbnail then album.thumbnail = thumbnail.match(/src=\"http.+\"\swidth/g)?[0].replace(/src=\"|\"\swidth/g,'')

			if album.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)
				album.created = album.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)[0].replace(/\//g,'-')
			if album.thumbnail.match(/\/\d+\.jpg$/g)
				_t = new Date(parseInt(album.thumbnail.match(/\/\d+\.jpg/g)[0].replace(/\/|\.jpg/g,'')))
				album.created += " " + _t.getHours() + ":" + _t.getMinutes() + ":" + _t.getSeconds()

			songs = data.match(/btnDownload.+/g)
			if songs
				album.songs = songs.map (v)-> 
					_song = 
						id :  v.match(/rel=\"\d+\"/g)?[0]?.replace(/rel=|\"/g,'')
						key : v.match(/key=\".+\"\srelTitle/g)?[0]?.replace(/key=|\"|\srelTitle/g,'')

		@eventEmitter.emit "album-result",album

		album
	fetchAlbums : (albums)->
		# album Object has only id and key properties
		# 
		console.log " |The number of new albums in STEP 1: #{albums.length}"
		console.log " |STEP 2: Fetching plays of new albums from results".magenta

		# event called back when processing album complete
		@eventEmitter.on "album-result", (album)=>
			@albums.push album
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@stats.currentId = album.id
			@utils.printRunning @stats
			if @stats.totalItems is @stats.totalItemCount
				@utils.printFinalResult @stats
				@fetchSongs @albums

		# update plays of the current albums containing only keys and ids 
		@updateAlbumsPlays albums, (albums)=>
			@resetStats()
			@stats.totalItems = albums.length
			@stats.currentTable = "STORE IN MEMORY ONLY (NOT DB)"
			console.log " |The number of plays has already been added to new albums: #{albums.length}"
			console.log " |STEP 3: Fetching new albums".magenta
			@albums = []
			# console.log albums
			for album in albums
				do (album)=>
					link = "http://www.nhaccuatui.com/playlist/joke-link.#{album.key}.html"
					options = 
						id : album.id
						key : album.key
						plays : album.plays
					@getFileByHTTP link, @processAlbum, @_onFail, options
	getAlbumKeysAndIds : (topicLink,page = 1) ->
		link = topicLink + page
		options = 
			link : link.replace(/^.+playlist\//g,'').replace(/\.html.+/g,'')
			page : page
		onSucess = (data,options)=>
			@stats.totalPageCount +=1

			albums = data.match(/<h3\><a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/playlist.+/g)
			if albums isnt null
				if data.match /NCTCounter_pl_\d+/g
					albumids = data.match /NCTCounter_pl_\d+/g
				else albumids[i] = '0' for album, i in albumids

				for album, index in albums
					_album = 
						id : parseInt albumids[index].replace(/NCTCounter_pl_/g, ''), 10
					if album.match(/<a.+\.html/)
						_album.key = album.match(/<a.+\.html/)[0].replace(/\.html/g,'').replace(/<a.+\./,'')
					else _album.key = ''
					@printUpdateAlbum "Topic:#{options.link} | Page=#{options.page} | nAlbums = #{@albums.length}" 
					# filter new albums if available
					if _album.id > 11986716
						@albums.push _album

					# disable filter
					# @albums.push _album

			
			# fetchAlbums func will be invoked when done
			if @stats.totalPageCount is @stats.totalPages
				@albums = @albums.unique("id")
				@fetchAlbums @albums
		@getFileByHTTP link, onSucess, @_onFail, options
	updateAlbumsAndSongs:  ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating albums and songs to table: #{@table.Albums}".magenta
		console.log " |STEP 1: Fetching ids and keys of new albums from existing topics".magenta

		topics = "playlist-moi nhac-tre tru-tinh cach-mang tien-chien nhac-trinh thieu-nhi rap-viet rock-viet khong-loi au-my han-quoc nhac-hoa nhac-nhat nhac-phim the-loai-khac"
		# topics = "nhac-tre"
		topics = topics.split(' ')
		url = "http://www.nhaccuatui.com/playlist/"
		#update max album id
		if @log.tempMaxAlbumId > @log.maxAlbumId
			 @log.maxAlbumId = @log.tempMaxAlbumId
		@stats.currentTable = @table.Albums

		# init conditions to stop
		nPages = 34
		@stats.totalPageCount = 0
		@stats.totalPages = nPages * topics.length
		# init the album array
		@albums = []

		for topic in topics
			link =  url + topic + ".html" + "?sort=1&page="
			for page in [1..nPages]
				@getAlbumKeysAndIds link, page
		null



	# THIS PART FOR PROCESSING SONG, EXPANDING DB TO MILLIONS RECORDS May-05
	# 
	processArtistSongs : (data, options)=>
		nSongs = data.match(/Tìm được (.+) kết quả cho/)?[1]
		if nSongs
			nSongs = parseInt(nSongs.replace(",",""),10)
			if nSongs >= 50*20
				maxPage = 50
			else maxPage = (nSongs/20|0)+1
			if options.page < maxPage
				@_fetchArtist options.artistName, options.page+1
			ids = data.match(/btnAddPlaylist_(\d+)/g)
			if ids 
				ids = ids.map (v)-> parseInt(v.replace(/btnAddPlaylist_/,''),10)
			keys = data.match(/song-name.+\s+.+\s+.+\s+.+\s+.+\s+/g)
			songs = []
			if keys 
				if keys.length is ids.length
					keys.forEach (v,index)-> 
						song = 
							id : ids[index]
						song.key = v.match(/<a.+\.(.+)\.html/)?[1]
						if v.match(/class=\"mof\"/g)
							song.official = 1
						else song.official = 0
						if v.match(/class=\"m320\"/g)
							song.bitrate = 320
						else song.bitrate = 0	
						songs.push song
					@eventEmitter.emit "fetch-song-artist-done", songs, options
					# THIS EVENT CALLBACK IS OPTIONAL. USE ONLY FOR getSongs()
					# @eventEmitter.emit "fetch-song-artist-done-the-FULL", songs, options
					# END OF OPTIONAL PART
				else 
					console.log "Artist: #{options.artistName} page: #{options.page} has keys and ids mismatched                                       "
			else console.log "Artist: #{options.artistName} page: #{options.page} has keys and ids which do not exit                                       "
		else console.log "Artist: #{options.artistName} page: #{options.page} has keys and ids which do not exit --- BBBB                                       "
	processArtistSongsMobileVersion : (data,options)=>

		songs = data.match(/<h3><a href=.+/g)

		temp = data.match(/Hiển thị\s(\d+)\/(\d+).+/)

		if temp
			currentSongs = parseInt(temp[1],10)
			nSongs = parseInt(temp[2],10)
			# console.log currentSongs
			# console.log nSongs
			
			if nSongs >= 1000
				if nSongs%10 isnt 0
					maxPage = (nSongs/10|0)+1
				else maxPage = nSongs/10|0

				# console.log "max page is" + maxPage
				if options.page < maxPage and options.page isnt 1
					@_fetchArtist options.artistName, options.page+1, "mobile"
				if options.page is 1
					@_fetchArtist options.artistName, 100, "mobile"
				if songs 
					songs = songs.map (v)-> 
						t = 
							key : v.match(/http.+\.(.+)\.html/)?[1]
					@eventEmitter.emit "fetch-song-artist-done-mobile-version", songs, options
	onProcessArtistSongsFail : (err,options)=>
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		console.log "ERROR while fetching http file. ERROR:#{err}".red
	_fetchArtist : (artistName,page = 1, type = "desktop") ->
		# link = "http://www.nhaccuatui.com/tim-kiem/bai-hat?q=#{artistName}&b=&page=#{page}"
		
		if type is "desktop"
			link = "http://www.nhaccuatui.com/tim-kiem/bai-hat?q=#{artistName}&b=title&page=#{page}"
		else if type is "mobile"
			link = "http://m.nhaccuatui.com/tim-kiem/bai-hat?q=#{artistName}&b=&page=#{page}"
		options = 
			artistName : artistName
			page : page
		if link.match(/www\.nhaccuatui\.com/)
			@getFileByHTTP link, @processArtistSongs, @onProcessArtistSongsFail, options

		else if link.match(/m\.nhaccuatui\.com/)
			@getFileByHTTP link, @processArtistSongsMobileVersion, @onProcessArtistSongsFail, options
	onFetchSongAritstDone : ->
		@eventEmitter.on "fetch-song-artist-done", (songs, options)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@utils.printUpdateRunning options.artistName + "-" + options.page, @stats, "Fetching..."

			console.log songs

			# for song in songs
			# 	do (song)=>
			# 		@connection.query @query._insertIntoNCTSongs, song, (err)->
			# 			if err then console.log "Cannot insert song: #{song.id}, key #{song.key} into DB. ERROR: #{err}"
			# 		_u = "update #{@table.Songs} SET official=#{song.official}, bitrate=#{song.bitrate} where id=#{song.id}"
			# 		@connection.query _u, (err,results)=>
			# 			if err then console.log "Cannot update song: #{song.id}, key #{song.key}. ERROR: #{err} "

		@eventEmitter.on "fetch-song-artist-done-mobile-version", (songs, options)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@utils.printUpdateRunning options.artistName + "-" + options.page, @stats, "Fetching..."
			# console.log options
			# console.log songs

			for song in songs
				do (song)=>
					@connection.query @query._insertIntoNCTSongs, song, (err)->
						if err then console.log "Cannot insert song key #{song.key} into DB. ERROR: #{err}"
	fetchArtist : () =>
		@connect()
		artists = fs.readFileSync "./log/test/artist.txt" , "utf8"
		# artists = "[\"dam vinh hung\"]"
		artists = JSON.parse artists
		console.log " |"+"Fetching artists, albums  to table: #{@table.Albums}".magenta

		@onFetchSongAritstDone()
			
		@stats.totalItems = artists.length
		@stats.currentTable = @table.Songs
		console.log "get from 20000 to the rest"
		for name, index in artists
			if 20000<=index
				@_fetchArtist name, 1, "mobile"
		null
	#This part is used to update the song info: title, artist, plays..... after scan through the site nhaccuatui
	processSimilarSongs : (data, options)=>
		ids = data.match(/btnAddPlaylist_(\d+)\" class=\"add\"/g)
		if ids 
			ids = ids.map (v)-> parseInt(v.replace(/btnAddPlaylist_/,'').replace(/\" class=\"add\"/g,''),10)
		keys = data.match(/class=\"song-name\".+\s+.+\s+.+\s+.+\s+.+\s+/g)
		songs = []
		if keys 
			if ids
				if keys.length is ids.length
					keys.forEach (v,index)-> 
						song = 
							id : ids[index]
						song.key = v.match(/<a.+\.(.+)\.html/)?[1]
						if v.match(/class=\"mof\"/g)
							song.official = 1
						else song.official = 0
						if v.match(/class=\"m320\"/g)
							song.bitrate = 320
						else song.bitrate = 0	
						songs.push song
					@eventEmitter.emit "fetch-song-artist-done", songs, options
					# THIS EVENT CALLBACK IS OPTIONAL. USE ONLY FOR getSongs()
					# @eventEmitter.emit "fetch-song-artist-done-the-FULL", songs, options
					# END OF OPTIONAL PART
				else 
					# console.log "Song: #{options.id} key: #{options.key} has similar songs mismatched                                                "
					@_onFailSong_UPDATE "Song: #{options.id} key: #{options.key} has similar songs mismatched                                                "
			else 
				# console.log "Song: #{options.id} key: #{options.key} is not available  !!!!"
				@_onFailSong_UPDATE  "Song: #{options.id} key: #{options.key} is not available  !!!!"
		else 
			# console.log "Song: #{options.id} key: #{options.key} is not available                                                          "
			@_onFailSong_UPDATE "Song: #{options.id} key: #{options.key} is not available                                                          "

		# this part is for song-like
		keys = data.match(/class=\"can-like\".+\s+.+\s+.+\s+.+\s+.+\s+/g)
		ids = data.match(/NCTCounter_sg.+\s.+class=\"clr\"/g)
		songs = []
		if keys and ids
			if keys.length is ids.length
				ids = ids.map (v)-> v.match(/NCTCounter_sg_(\d+)/)?[1]
				keys.forEach (v,index)-> 
					song = 
						id : ids[index]
					song.key = v.match(/<a.+\.(.+)\.html/)?[1]
					if v.match(/class=\"mof\"/g)
						song.official = 1
					else song.official = 0
					if v.match(/class=\"m320\"/g)
						song.bitrate = 320
					else song.bitrate = 0	
					songs.push song
			@eventEmitter.emit "fetch-song-artist-done", songs, options
		else 
			# console.log "Song: #{options.id} key: #{options.key} is not available 2222      "
			@_onFailSong_UPDATE "Song: #{options.id} key: #{options.key} is not available 2222      "	
	_getFieldsFromTable : (param, callback)->
		fields = "id"
		if param.fields
			_t = param.fields.map (v)-> return "#{param.table}.#{v}"
			fields = _t.join(',')
		_q = "Select #{fields} from #{param.table}"
		_q += " #{param.onCondition}" if param.onCondition
		_q += " LIMIT #{param.limit}" if param.limit
		@connection.query _q, (err, results)=>
			if err then console.log "cannt fetch fields from table. ERROR: #{err}"
			else  callback results
	_onFailSong_UPDATE : (err)=>
		# if err isnt "The link: http://www.nhaccuatui.com/bai-hat/joke-link.null.html is temporary moved"
		# 	console.log "#{err}".red
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		@utils.printRunning @stats
		if @stats.totalItemCount%@params.limit is 0 and @stats.totalItemCount < @stats.totalItems
				console.log ""
				console.log "GO TO NEXT STEP: #{@stats.totalItemCount/@params.limit+1}".inverse.yellow
				# @getField()
				@getFieldBitrate()
		
		if @stats.totalItemCount is @stats.totalItems
				@utils.printFinalResult @stats
	getField : =>
		@_getFieldsFromTable @params, (songs)=>
			for song in songs
				do (song)=>
					link = "http://www.nhaccuatui.com/bai-hat/joke-link.#{song.key}.html"
					options = 
						id : song.id
						key : song.key
					@getFileByHTTP link, @processSong, @_onFailSong_UPDATE, options
	onSongResultDone : ->
		@eventEmitter.on "fetch-song-artist-done", (songs, options)=>
			for song in songs
				do (song)=>
					@connection.query @query._insertIntoNCTSongs, song, (err)->
						if err then console.log "Cannot insert song: #{song.id}, key #{song.key} into DB. ERROR: #{err}"
					if song.bitrate isnt 0 or song.official isnt 0
						_u = "update #{@table.Songs} SET "
						_u += "official=#{song.official} " if song.official isnt 0
						_u += "bitrate=#{song.bitrate} " if song.bitrate isnt 0
						_u += " where id=#{song.id}"
						@connection.query _u, (err,results)=>
							if err then console.log "Cannot update song: #{song.id}, key #{song.key}. ERROR: #{err} "
		@eventEmitter.on "song-result", (song)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@stats.currentId = song.id
			@utils.printRunning @stats
			# insert song into table
			# 
			_u = "update #{@table.Songs} SET "
			# _u += " id=#{song.id}," # this option is enable when song.id > 1.000.000.000
			_u += " title=#{@connection.escape song.title},"
			_u += " artists=#{@connection.escape song.artists},"
			_u += " topic=#{@connection.escape song.topic},"
			_u += " type=#{@connection.escape song.type},"
			_u += " link_key=#{@connection.escape song.link_key},"
			_u += " bitrate=#{song.bitrate},"
			_u += " lyric=#{@connection.escape song.lyric}"
			_u += " WHERE #{@table.Songs}.key=#{@connection.escape song.key}"

			# console.log _u
			@connection.query _u, (err)=>
				if err then console.log "Cannt insert song: #{song.key} into table. ERROR: #{err}"

			if @stats.totalItemCount%@params.limit is 0 and @stats.totalItemCount < @stats.totalItems
				console.log ""
				console.log "GO TO NEXT STEP: #{@stats.totalItemCount/@params.limit+1}".inverse.yellow
				@getField()
			
			if @stats.totalItemCount is @stats.totalItems
				@utils.printFinalResult @stats
		@eventEmitter.on "update-song-bitrate-mobile-version", (song)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@stats.currentId = song.id
			@utils.printRunning @stats
			# insert song into table
			# console.log song
			_u = "update #{@table.Songs} SET "
			# _u += " id=#{song.id}," # this option is enable when song.id > 1.000.000.000
			_u += " bitrate=#{song.bitrate}"
			_u += " WHERE #{@table.Songs}.key=#{@connection.escape song.key}"
			# console.log  _u
			@connection.query _u, (err)=>
				if err then console.log "Cannt insert song: #{song.key} into table. ERROR: #{err}"

			if @stats.totalItemCount%@params.limit is 0 and @stats.totalItemCount < @stats.totalItems
				console.log ""
				console.log "GO TO NEXT STEP : #{@stats.totalItemCount/@params.limit+1} - MOBILE-VERSION".inverse.yellow
				# @getField()
				@getFieldBitrate()
			
			if @stats.totalItemCount is @stats.totalItems
				@utils.printFinalResult @stats
	
		@eventEmitter.on "fetch-song-artist-done-mobile-version", (songs, options)=>
			for song in songs
				do (song)=>
					# console.log song
					@connection.query @query._insertIntoNCTSongs, song, (err)->
						if err then console.log "Cannot insert song: #{song.id}, key #{song.key} into DB. ERROR: #{err}"
	getSongs : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+" UPDATE SONGS WHERE BITRATE = 0 OR BITRATE IS NULL from #{@table.Songs}".magenta	
		@params = 
			fields : ['id','key']
			table : @table.Songs
			limit : 10000
			onCondition : " where artists = '[\"\"]'"
		songs = []
		@stats.totalItems = 10000
		@stats.currentTable = @table.Songs
		@onSongResultDone()
		@getField()
		# @getFieldBitrate()

	#THIS PART USED FOR FILLED UP BITRATE IN TABLE
	getFieldBitrate : =>
		@_getFieldsFromTable @params, (songs)=>
			for song in songs
				do (song)=>
					link = "http://m.nhaccuatui.com/bai-hat/joke-link.#{song.key}.html"
					# console.log link
					options = 
						id : song.id
						key : song.key
					@getFileByHTTP link, @processSongBitrate, @_onFailSong_UPDATE, options
	processSongBitrate : (data,options)=>
		song =
			id : options.id
			key : options.key
			bitrate : 0
		bitrate = data.match(/<span><img.+\s(\d+)kbps/)?[1]
		if bitrate 
			song.bitrate = bitrate
		@eventEmitter.emit "update-song-bitrate-mobile-version", song
		songs = data.match(/<h3><a href.+html/g)
		if songs 
			songs = songs.map (v)->
				ob = 
					key : v.match(/.+\.([a-zA-Z0-9-_]+)\.html/)?[1]
			@eventEmitter.emit "fetch-song-artist-done-mobile-version", songs	

	#This part is not supposed to replace the func updateSongsPlays()
	#It is used to fetch a large amount of songs which ends up to a million ones
	#It will be removed later
	onSongsPlaysFail : (err,options)=>
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		@utils.printRunning @stats

		if @stats.totalItemCount<@stats.totalItems
			@_getSongsPlays()

		if @stats.totalItemCount is @stats.totalItems
			@utils.printFinalResult @stats
	processSongsPlays : (data, options)=>
		data = JSON.parse data
		songs = data.data.songs
		# console.log songs
		for  id, plays of songs
			do (id, plays)=>
				@stats.totalItemCount +=1
				@stats.passedItemCount +=1
				_u = "update #{@table.Songs} SET plays=#{plays} where id=#{id}"
				@stats.currentId = id
				# console.log _u
				@connection.query _u, (err)->
							if err then console.log "Cannt update the total plays of the song #{id} into database. ERROR: #{err}"
				@utils.printRunning @stats

		if @stats.totalItemCount<@stats.totalItems
			@_getSongsPlays()

		if @stats.totalItemCount is @stats.totalItems
			@utils.printFinalResult @stats
	_getSongsPlays : =>
		@_getFieldsFromTable @params, (songs)=>
			ids = []
			for song in songs
				ids.push song.id
			ids = ids.join(',')
			link = "http://www.nhaccuatui.com/wg/get-counter?listSongIds=#{ids}"
			# console.log link
			options = 
				id : song.id
			@getFileByHTTP link, @processSongsPlays, @onSongsPlaysFail, options
	getSongsPlays : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+" UPDATE PLAYS OF SONGS WHERE PLAYS = 0 from #{@table.Songs}".magenta	
		@params = 
			fields : ['id']
			table : @table.Songs
			limit : 500
			onCondition : " WHERE plays=0 order by id DESC"
		songs = []
		@stats.totalItems = 17340
		@stats.currentTable = @table.Songs
		# @getField()
		@_getSongsPlays()
	
	showStats : -> @_printTableStats NCT_CONFIG.table


module.exports = Nhaccuatui
