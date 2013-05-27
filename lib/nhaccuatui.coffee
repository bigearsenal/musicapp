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
			_insertIntoNCTAlbums : "INSERT  INTO " + @table.Albums + " SET ?"
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

	printUpdateInfo : (info) ->
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

	# 1. THIS IS PART 1- UPDATE ALBUMS, INCLUDING SONGS-ALBUMS
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
	_fetchItemsPlays : (ids,table)->
		link = "http://www.nhaccuatui.com/wg/get-counter?listSongIds=#{ids}"
		onSucess = (data)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			data = JSON.parse data
			songs = data.data.songs
			# console.log songs
			for  id, plays of songs
				do (id, plays)=>
					_u = "update #{table} SET plays=#{plays} where id=#{id}"
					# console.log _u
					@stats.currentId = id
					@connection.query _u, (err)->
						if err then console.log "Cannt update the total plays of the song #{id} into database. ERROR: #{err}"
			@utils.printRunning @stats
			if @stats.totalItemCount is @stats.totalItems
				@utils.printFinalResult @stats
				if table is @table.Videos
					console.log "VIDEOS HAVE ALREADY BEEN UPDATED".inverse.red
					@eventEmitter.emit "update-video-finish"

		@getFileByHTTP link, onSucess, @_onFail
	updateItemsPlays  : (table = @table.Songs)->
		@connect()
		@resetStats()
		console.log " |LAST STEP: Update plays of #{table} in DB".magenta
		@stats.currentTable = table
		_q = "select id from #{table} where plays = 0 or plays is null "
		# console.log  _q
		@connection.query _q, (err,results)=>
			if err then console.log "Cannt query song where plays is 0. ERROR: #{err}"
			else
				n = results.length
				lengthOfGroup = 200

				if n%lengthOfGroup is 0
					nChunks = n/lengthOfGroup | 0
				else
					nChunks = (n/lengthOfGroup|0) + 1
				a = []
				@stats.totalItems = nChunks
				@stats.currentTable = table

				for song in results
					if a.length < lengthOfGroup
						a.push song.id
					else
						@_fetchItemsPlays a.join(','), table
						a = []
						a.push song.id
				@_fetchItemsPlays a.join(','), table
	updateSongsPlays : -> @updateItemsPlays(@table.Songs)
	updateVideosPlays : -> @updateItemsPlays(@table.Videos)
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

		if options.official then if options.official is 1
			song.official = 1

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
		# @processSimilarSongs data, options
		# END OF OPTIONAL PART

		if song.type is "mv"
			title = data.match(/songname.+/g)?[0]
			if title then song.title = encoder.htmlDecode title.replace(/<\/h1>.+/g,'').replace(/^.+>/,'')
			thumbnail = data.match(/image_src.+\"(http.+)\"/)?[1]
			if thumbnail
				song.thumbnail = thumbnail
				if song.thumbnail
					if song.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)
						song.created = song.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)[0].replace(/\//g,'-')
					else if song.thumbnail.match(/\d{4}_\d{2}\//g)
						song.created = song.thumbnail.match(/\d{4}_\d{2}\//g)[0].replace(/_/g,':').replace(/\//g,'')
						song.created += ":01"
			delete song.bitrate
			if options.duration
				song.duration = options.duration
			@processSimilarVideos data, options
			# console.log "emit video"
			@eventEmitter.emit "video-result", song
		else if song.type is "song"
			@eventEmitter.emit "song-result", song
		else if song.type is ""
			song = null
			@eventEmitter.emit "song-result", song
		# console.log song
		return song
	fetchSongs : (albums)->
		# albums has full stats and array of songs
		songs = []
		for album in albums
			for song in album.songs
				songs.push song

		callback = (song)=>
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
		@eventEmitter.on "song-result", callback
		@eventEmitter.on "video-result", callback
		console.log " |The number of songs found in new albums: #{songs.length}"
		console.log " |STEP 4: Fetching & inserting new songs".magenta
		@resetStats()
		@stats.totalItems = songs.length
		@stats.currentTable = @table.Songs

		# for testing
		# songs = [{ id: '2442282',key: 'GbV3lZa2Yifq'}]
		_options =
			field : "id"
			table : @table.Songs
		@filterNonExistedRecordInDB songs, _options, (results)=>
			console.log " |The # of items AFTER being filtered :" + results.length
			if results.length > 0
				for song in results
					do (song)=>
						link = "http://www.nhaccuatui.com/bai-hat/joke-link.#{song.key}.html"
						options =
							id : song.id
							key : song.key
						@getFileByHTTP link, @processSong, @_onFail, options
			else 
				console.log "All the Songs are available in database"
				@insertAlbumsIntoDB @albums
		
	processAlbum : (data,options)=>
		try
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
				description : ""
				created : "0000-00-00"

			if data.match(/<p\sclass\=\"category\"\>Thể\sloại\:.+/g)

				_info = data.match(/<p\sclass\=\"category\"\>Thể\sloại\:.+/g)[0].split('|')

				album.nsongs = parseInt _info[2].replace(/Số\sbài\:\s|<\/p\>/g,'').trim(), 10


				if album.id > 1000000000
					id = data.match(/hidden.+\"(\d+)\".+inpHiddenId/)?[1]
					# console.log "#{id}".red
					if id then album.id = parseInt(id,10)

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

				description = data.match(/<div class=\"about\">\s(.+)/)
				if description
					album.description = encoder.htmlDecode description[1].trim().replace(/<a href=\"javascript.+<\/strong><\/a>/,'')

			@eventEmitter.emit "album-result",album
			return album
		catch e
			console.log "NBINH: eROOR: #{e}"

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
	# options parameter in filterNonExistedRecordInDB() is an object
	# containing field and table needed to be filtered
	# filterNonExistedRecordInDB_BK : (items,options,callback)->
	# 	temp = []
	# 	count = 0
	# 	for item in items
	# 		do (item)=>
	# 			_select = "select #{options.field} from #{options.table} where #{options.field} =#{item[options.field]}"
	# 			if options.table is @table.Videos
	# 				_select = "select #{options.table}.#{options.field} from #{options.table} where #{options.table}.#{options.field} =#{@connection.escape item[options.field]}"
	# 			@printUpdateInfo "Filtering......"
	# 			@connection.query _select, (err, result)=>
	# 				@printUpdateInfo "Filtering......"
	# 				count +=1
	# 				if result.length is  0
	# 					temp.push item
	# 				if count is items.length
	# 					callback(temp)
	filterNonExistedRecordInDB : (items,options,callback)->
		temp = []
		count = 0
		tempItems = []
		chunkLength = 100
		currentChunk = 0
		if items.length%chunkLength is 0 then nChunks = items.length/chunkLength
		else nChunks = (items.length/chunkLength|0) + 1
		# console.log  "n chunks is #{nChunks}"
		processTempItems = (items)=>
			if options.table is @table.Videos
				condition = items.map((v)-> "#{options.table}.#{options.field}='#{v[options.field]}'").join(' or ')
				_select = "select #{options.table}.#{options.field} from #{options.table} where #{condition}"
			else 
				condition = items.map((v)-> "#{options.field}=#{v[options.field]}").join(' or ')
				_select = "select #{options.field} from #{options.table} where #{condition}"
			# console.log _select
			_tempArray = []
			@connection.query _select, (err, results)=>
				@printUpdateInfo "Filtering......"
				count +=1
				for result in results
					_tempArray.push result[options.field]
				# console.log JSON.stringify _tempArray
				temp = temp.concat(items.filter((v)-> if _tempArray.indexOf(v[options.field]) > -1 then return false else return true))
				if count is nChunks
					callback(temp)	
		items.map (item, index)=>
			if (index/chunkLength|0) isnt currentChunk
				currentChunk +=1
				processTempItems tempItems
				tempItems = []
			tempItems.push item
			if index%chunkLength isnt 0 and index is items.length-1
				processTempItems tempItems
			@printUpdateInfo "Filtering......"
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
					@printUpdateInfo "Topic:#{options.link} | Page=#{options.page} | nAlbums = #{@albums.length}"

					# filter new albums if available
					# if _album.id > 11986716
					# 	@albums.push _album

					# disable filter
					@albums.push _album
			# fetchAlbums func will be invoked when done
			if @stats.totalPageCount is @stats.totalPages
				@albums = @albums.unique("id")
				console.log ""
				console.log " |The # of albums UNIQUE BEFORE being filtered :" + @albums.length
				# console.log " |Filtering.............."
				options =
					field : "id"
					table : @table.Albums
				# console.log @albums
				@filterNonExistedRecordInDB @albums, options, (results)=>
					console.log " |The # of albums AFTER being filtered :" + results.length
					@albums = results
					# console.log @albums
					if @albums.length is 0
						console.log " |ALBUMS TABLE  UP-TO-DATE".green
					else @fetchAlbums @albums
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
			# link =  url + topic + ".html" + "?page="
			for page in [1..nPages]
				@getAlbumKeysAndIds link, page
		null

	# 2. THIS PART IS FOR UPDATING SONGS & VIDEOS ONLY
	processItemsAfterFilter : (items, options)->

		if options.config.type is "song"
			@eventEmitter.on "song-result", (song)=>
				# console.log song
				@stats.totalItemCount +=1
				@stats.passedItemCount +=1
				@stats.currentId = song.id
				# @utils.printRunning @stats
				# console.log "call song result"
				# console.log song
				if song isnt null
					@connection.query @query._insertIntoNCTSongs, song, (err)->
						if err then console.log "Cannt insert song: #{song.key}. ERROR #{err} "
				else
					@stats.passedItemCount -=1
					@stats.failedItemCount +=1
				@utils.printRunning @stats

				if @stats.totalItems is @stats.totalItemCount
					@utils.printFinalResult @stats
					console.log "SONGS HAVE ALREADY BEEN UPDATED".inverse.red
					@eventEmitter.emit "update-song-finish"
		else if options.config.type is "video"
			@eventEmitter.on "video-result", (video)=>
				# console.log video
				@stats.totalItemCount +=1
				@stats.passedItemCount +=1
				@stats.currentId = video.id
				# @utils.printRunning @stats

				# console.log video
				if video isnt null
					@connection.query @query._insertIntoNCTVideos, video, (err)->
						if err then console.log "Cannt insert video: #{song.key}. ERROR #{err} "
				else
					@stats.passedItemCount -=1
					@stats.failedItemCount +=1
				@utils.printRunning @stats

				if @stats.totalItems is @stats.totalItemCount
					@utils.printFinalResult @stats
					@updateVideosPlays()

		console.log " |The number of #{options.config.type}s found: #{items.length}"
		console.log " |STEP 2: Fetching & inserting new #{options.config.type}s".magenta
		@resetStats()
		@stats.totalItems = items.length
		@stats.currentTable = options.config.table

		# for testing
		# songs = [{ id: '2442282',key: 'GbV3lZa2Yifq'}]
		# item may be song or video
		# console.log items
		for item in items
			do (item)=>
				if options.config.type is "song"
					link = "http://www.nhaccuatui.com/bai-hat/joke-link.#{item.key}.html"
					_options =
						id : item.id
						key : item.key
						official : item.official
				else if options.config.type is "video"
					link = "http://www.nhaccuatui.com/mv/joke-link.#{item.key}.html"
					_options =
						key : item.key
						duration : item.duration
				# console.log link
				@getFileByHTTP link, @processSong, @_onFail, _options
	getSongsFromData : (data,options)->
		ids = data.match(/btnAddPlaylist_(\d+)/g)
		songs = []
		if ids
			ids = ids.map (v)-> parseInt(v.replace(/btnAddPlaylist_/,''),10)
		keys = data.match(/song-name.+\s+.+\s+.+\s+.+\s+.+\s+/g)
		if keys
			if keys.length is ids.length
				keys.forEach (v,index)=>
					song =
						id : ids[index]
					song.key = v.match(/<a.+\.(.+)\.html/)?[1]
					if v.match(/class=\"mof\"/g)
						song.official = 1
					else song.official = 0
					if v.match(/class=\"m320\"/g)
						song.bitrate = 320
					else song.bitrate = 0
					# console.log song
					songs.push song
		return songs
	getVideosFromData : (data,options)->
		videos = []
		times  = data.match(/times\">.+/g)
		ids = data.match(/<h3><a href=\".+/g)
		if times and ids
			if times.length? and ids.length?
				if times.length is ids.length
					ids = ids.map (v)-> v.replace(/\.html.+$/g,'').replace(/^.+\./g,'')
					times =  times.map (v)->
						t = v.match(/>(.+)</)?[1].split(':')
						if t.length
							if t.length is 2
								return parseInt(t[0],10)*60 + parseInt(t[1],10)
							else return 0
						else return 0
					for v,index in times
						video =
							key :  ids[index]
							duration : times[index]
						videos.push video
				else
					console.log "ERROR: lengths of videos durations and ids do not match"
					console.log JSON.stringify options
			else
				console.log "ERROR: videos duration and ids do not have length property"
				console.log JSON.stringify options
		# else
		# 	console.log "ERROR: Videos duration and times do not exist at the same time"
		# 	console.log JSON.stringify options
		return videos
	getItemsKeysAndIds : (topicLink,page = 1,config)->
		link = topicLink + page
		if config.type is "song"
			options =
				link : link.replace(/^.+bai-hat\//g,'').replace(/\.html.+/g,'')
				page : page
				config : config
		else if config.type is "video"
			options =
				link : link.replace(/^.+mv\//g,'').replace(/\.html.+/g,'')
				page : page
				config : config
		onSucess = (data,options)=>
			@stats.totalPageCount +=1
			if options.config.type is "song"
				songs = @getSongsFromData(data,options)
				for song in songs
					@items.push song
			else if  options.config.type is "video"
				videos = @getVideosFromData(data,options)
				# console.log videos
				for video in videos
					@items.push video
				# console.log "ASFKSJAHF"


			@printUpdateInfo "Topic:#{options.link} | Page=#{options.page} | nItems = #{@items.length}"

			# fetchsongs func will be invoked when done
			if @stats.totalPageCount is @stats.totalPages
				if options.config.type is "song"
					@items = @items.unique("id")
				else if  options.config.type is "video"
					@items = @items.unique("key")
				console.log ""
				console.log " |The # of items UNIQUE BEFORE being filtered :" + @items.length
				# console.log @items
				# console.log " |Filtering.............."
				if options.config.type is "song"
					_options =
						field : "id"
						table : options.config.table
				else
					if options.config.type is "video"
						_options =
							field : "key"
							table : options.config.table
				# console.log @items
				@filterNonExistedRecordInDB @items, _options, (results)=>
					console.log " |The # of items AFTER being filtered :" + results.length
					@items = results
					# console.log @items
					if @items.length is 0
						console.log " |items TABLE  UP-TO-DATE".green
						if _options.table is @table.Songs
							@eventEmitter.emit "update-song-finish"
						else if _options.table is @table.Videos
							@eventEmitter.emit "update-video-finish"
					else @processItemsAfterFilter @items, options

		@getFileByHTTP link, onSucess, @_onFail, options
	setup: (config) ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating #{config.type}s to table: #{config.table}".magenta
		console.log " |STEP 1: Fetching ids and keys of new #{config.type}s from existing topics".magenta

		if config.type is 'song'
			topics = "bai-hat-moi nhac-tre tru-tinh cach-mang tien-chien nhac-trinh thieu-nhi rap-viet rock-viet khong-loi au-my han-quoc nhac-hoa nhac-nhat nhac-phim the-loai-khac"
			# topics = "nhac-tre"
			topics = topics.split(' ')
			url = "http://www.nhaccuatui.com/bai-hat/"
			nPages = 50
		else if config.type is "video"
			topics = "video-moi viet-nam au-my han-quoc nhac-nhat nhac-hoa shining-show sea-show house-of-dreams the-loai-khac"
			# topics = "video-moi"
			topics = topics.split(' ')
			url = "http://www.nhaccuatui.com/mv/"
			nPages = 42

		@stats.currentTable = config.table
		@stats.totalPageCount = 0
		@stats.totalPages = nPages * topics.length
		# init the items array
		@items = []

		for topic in topics
			link =  url + topic + ".html" + "?sort=1&page="
			# link =  url + topic + ".html" + "?page="
			for page in [1..nPages]
				@getItemsKeysAndIds link, page, config
		null
	# ------------------------------------
	# END OF PART 2
	updateSongsByCategory : ->
		config =
			type : 'song'
			table : @table.Songs
		@setup(config)
	updateVideosByCategory : ->
		config =
			type : 'video'
			table : @table.Videos
		@setup(config)

	# THIS PART IS FOR UPDATE
	update : ->
		# @updateAlbumsAndSongs()
		@eventEmitter.on "update-song-finish", =>
			@updateVideosByCategory()
		@eventEmitter.on "update-video-finish", =>
			# to avoid conflict between event callbacks
			@eventEmitter.removeAllListeners()
			@resetStats()
			@updateAlbumsAndSongs()
		@updateSongsByCategory()
	# THIS PART FOR PROCESSING SONG, EXPANDING DB TO MILLIONS RECORDS May-05
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
			# if nSongs >= 1000 # used for albums only, scan all
			if nSongs%10 isnt 0
				maxPage = (nSongs/10|0)+1
			else maxPage = nSongs/10|0
			# console.log "max page is" + maxPage + " .Current page is:" +options.page
			# if options.page < maxPage and options.page isnt 1
			if options.page < maxPage
				@_fetchArtist options.artistName, options.page+1, options.type
			# if options.page is 1
			# 	@_fetchArtist options.artistName, 100, "mobile"
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
		options =
			artistName : artistName
			page : page
			type : type
		if type is "desktop"
			link = "http://www.nhaccuatui.com/tim-kiem/bai-hat?q=#{artistName}&b=title&page=#{page}"
			@getFileByHTTP link, @processArtistSongs, @onProcessArtistSongsFail, options
		else if type is "mobile"
			link = "http://m.nhaccuatui.com/tim-kiem/bai-hat?q=#{artistName}&b=&page=#{page}"
			@getFileByHTTP link, @processArtistSongsMobileVersion, @onProcessArtistSongsFail, options
		else if type is "playlist-mobile"
			link = "http://m.nhaccuatui.com/tim-kiem/playlist?q=#{artistName}&b=&page=#{page}"
			@getFileByHTTP link, @processArtistSongsMobileVersion, @onProcessArtistSongsFail, options
		else if type is "video-mobile"
			link = "http://m.nhaccuatui.com/tim-kiem/mv?q=#{artistName}&b=&page=#{page}"
			@getFileByHTTP link, @processArtistSongsMobileVersion, @onProcessArtistSongsFail, options

		# console.log link

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

		@eventEmitter.on "fetch-song-artist-done-mobile-version", (items, options)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@utils.printUpdateRunning options.artistName + "-" + options.page, @stats, "Fetching..."
			# console.log options
			# console.log items
			for item in items
				do (item)=>
					@connection.query @query._insertIntoNCTVideos, item, (err)->
						if err then console.log "Cannot insert item key #{item.key} into DB. ERROR: #{err}"

			# for item in items
			# 	do (item)=>
			# 		@connection.query @query._insertIntoNCTSongs, item, (err)->
			# 			if err then console.log "Cannot insert item key #{item.key} into DB. ERROR: #{err}"
	fetchArtist : () =>
		@connect()
		artists = fs.readFileSync "./log/test/artist.txt" , "utf8"
		artists = '["CS Trang Nhung","No One","My Name","House of Heroes","The Pony","Super Mario Bros. 1","For All I Am","Jung Ki Song","Nguyễn Kiên Giang","The Toxic Avenger","Kim Jun Su","Tâm Vịnh Hà","The Blockhead","Hoàng Lan (Hải Ngoại)","Jin By Jin&","Kang Joon Ha","The Irish Rovers","Nguyễn Đồng Nai","Biển Sáng","Vũ Cát Tường","Mai Trang SMĐH","The Astronauts","Thùy Như","The Peculiar Pretzelmen","Don Gere","Dark Mean","Hoàng Kim Long ft Thanh Ngọc","Soundscape of Silence","Lê Hoa","U Day","The Choirgirl Isabel"]'
		artists = JSON.parse artists
		console.log " |"+"Fetching artists, albums to table: #{@table.Albums}".magenta

		@onFetchSongAritstDone()

		@stats.totalItems = artists.length
		@stats.currentTable = @table.Songs
		console.log "get from xxx"
		for name, index in artists
			# if 15000<=index
				@_fetchArtist name, 1, "video-mobile"
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
	processSimilarVideos : (data, options) =>
		times  = data.match(/times.+/g)
		ids = data.match(/<h3><a href=\".+/g)
		if times and ids
			if times.length? and ids.length?
				if times.length is ids.length
					ids = ids.map (v)-> v.replace(/\.html.+$/g,'').replace(/^.+\./g,'')
					times =  times.map (v)->
						t = v.match(/>(.+)</)?[1].split(':')
						if t.length
							if t.length is 2
								return parseInt(t[0],10)*60 + parseInt(t[1],10)
							else return 0
						else return 0
					videos = []
					for v,index in times
						video =
							key :  ids[index]
							duration : times[index]
						videos.push video

					for video in videos
						do (video)=>
							@connection.query @query._insertIntoNCTVideos, video,(err)=>
								if err then console.log "cannt insert video into table. #{err}"
							_u = "UPDATE #{@table.Videos} SET duration=#{video.duration} WHERE #{@table.Videos}.key=#{@connection.escape video.key}"
							@connection.query _u,(err1)=>
								if err1 then console.log "Cannt update video #{err1}"


	_getFieldsFromTable : (param, callback)->
		fields = "id"
		if param.fields
			_t = param.fields.map (v)-> return "#{param.table}.#{v}"
			fields = _t.join(',')
		_q = "Select #{fields} from #{param.table}"
		_q += " #{param.onCondition}" if param.onCondition
		_q += " LIMIT #{param.limit}" if param.limit
		# console.log _q
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
				@getField()
				# @getFieldBitrate()

		if @stats.totalItemCount is @stats.totalItems
				@utils.printFinalResult @stats
	getField : =>
		@_getFieldsFromTable @params, (songs)=>
			console.log "THE NUMBERE OF #{songs.length}"

			# songs = [{"id": 1000030186 , "key" : "TD4AyHBgpDSu"}]
			for song in songs
				do (song)=>
					link = "http://www.nhaccuatui.com/bai-hat/joke-link.#{song.key}.html"
					# link = "http://www.nhaccuatui.com/playlist/joke-link.#{song.key}.html"
					options =
						id : song.id
						key : song.key
					@getFileByHTTP link, @processSong, @_onFailSong_UPDATE, options
					# @getFileByHTTP link, @processAlbum, @_onFailSong_UPDATE, options
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
		# @eventEmitter.on "album-result", (song)=>
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
			# _u += " bitrate=#{song.bitrate},"
			_u += " lyric=#{@connection.escape song.lyric}"
			_u += " WHERE #{@table.Songs}.key=#{@connection.escape song.key}"

			@connection.query _u, (err)=>
				if err then console.log "Cannt insert song: #{song.key} into table. ERROR: #{err}"

			if @stats.totalItemCount%@params.limit is 0 and @stats.totalItemCount < @stats.totalItems
				console.log ""
				console.log "GO TO NEXT STEP: #{@stats.totalItemCount/@params.limit+1}".inverse.yellow
				@getField()

			if @stats.totalItemCount is @stats.totalItems
				@utils.printFinalResult @stats

		@eventEmitter.on "video-result", (video)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@stats.currentId = video.id
			@utils.printRunning @stats
			# insert video into table
			#
			_u = "update #{@table.Videos} SET "
			_u += " id=#{video.id}," # this option is enable when video.id > 1.000.000.000
			_u += " title=#{@connection.escape video.title},"
			_u += " artists=#{@connection.escape video.artists},"
			_u += " topic=#{@connection.escape video.topic},"
			_u += " type=#{@connection.escape video.type},"
			_u += " link_key=#{@connection.escape video.link_key},"
			_u += " thumbnail=#{@connection.escape video.thumbnail},"
			_u += " created=#{@connection.escape video.created}," if video.created
			_u += " lyric=#{@connection.escape video.lyric}"
			_u += " WHERE #{@table.Videos}.key=#{@connection.escape video.key}"

			# console.log _u
			@connection.query _u, (err)=>
				if err then console.log "Cannt insert video: #{video.key} into table. ERROR: #{err}"

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
		console.log " |"+" UPDATE VIDEOS lyric is null from #{@table.Videos}".magenta
		@params =
			fields : ['id','key']
			table : @table.Videos
			limit : 5000
			onCondition : "  where id > 1000000000 "
		@stats.totalItems = 100000
		@stats.currentTable = @table.Videos
		@onSongResultDone()
		@getField()
		# @getFieldBitrate()


	# this is for testing
	# testing : ->
	# 	@connect()
	# 	a = [ { id: 112551772, key: 'UQlpB3L0PuI8', official: 0, bitrate: 320 },{ id: 112551267, key: '7sG9EYq5PXxS', official: 1, bitrate: 0 },{ id: 2550305, key: 'LJ9PRAXNRr73', official: 0, bitrate: 320 },{ id: 2550792, key: 'ZTpaNKY6Z0lt', official: 0, bitrate: 0 },{ id: 2550182, key: 'OC3NZx1Gi8Cg', official: 0, bitrate: 0 },{ id: 2550050, key: 'g1flJ7SzKeAp', official: 0, bitrate: 320 },{ id: 2551576, key: 'OUnlflpbHBaH', official: 1, bitrate: 0 },{ id: 2549950, key: 'fBXuSJ9s4ADN', official: 1, bitrate: 0 },{ id: 2547244, key: 'qAfgFblkf5AL', official: 0, bitrate: 0 },{ id: 2547231, key: 'll3VME4g23p1', official: 0, bitrate: 0 },{ id: 2547223, key: '6FGQ0UWQkn3p', official: 0, bitrate: 0 },{ id: 2547222, key: 'cJSayZOfenUi', official: 0, bitrate: 0 },{ id: 2547214, key: 'LZRkGqPN08h9', official: 0, bitrate: 0 },{ id: 2547065, key: '3meQJ96UDwym', official: 0, bitrate: 320 },{ id: 2547061, key: '9JbSjwfoDktE', official: 0, bitrate: 320 },{ id: 2545401, key: 'EfPcdZdahlBs', official: 0, bitrate: 0 },{ id: 2543210, key: '4vwub4IeSre3', official: 0, bitrate: 320 },{ id: 2545054, key: 'Ujnhct1AYMXa', official: 1, bitrate: 0 },{ id: 2544648, key: 'J5DZwW9sdlzR', official: 1, bitrate: 0 },{ id: 2546229, key: 'BnxCXbzx9uEA', official: 1, bitrate: 0 },{ id: 2553510, key: 'PkGFgNrWAAsJ', official: 0, bitrate: 320 },{ id: 2546231, key: 'DYvBulFzrCTb', official: 1, bitrate: 0 },{ id: 2546224, key: '68G5ZKbowAYB', official: 1, bitrate: 0 },{ id: 2546227, key: '2XaiUnapc6PM', official: 1, bitrate: 0 },{ id: 2546226, key: 'QGN42gmVYQRL', official: 1, bitrate: 0 },{ id: 2546237, key: '102g4ssNvFMI', official: 1, bitrate: 0 },{ id: 2546236, key: '3PS93B7OsJy5', official: 1, bitrate: 0 },{ id: 2553517, key: '5EIJlVa4Ubdl', official: 1, bitrate: 0 },{ id: 2546238, key: '9wuOhI67n202', official: 1, bitrate: 0 },{ id: 112546232, key: 'KeFCjS4YQEMc', official: 1, bitrate: 0 }]
	# 	console.log a.length
	# 	_options =
	# 		field : "id"
	# 		table : @table.Songs
	# 	@filterNonExistedRecordInDB a, _options, (results)=>
	# 		console.log "------- LENGTH: #{results.length}"
	# 		console.log JSON.stringify results


	showStats : -> @_printTableStats NCT_CONFIG.table


module.exports = Nhaccuatui
