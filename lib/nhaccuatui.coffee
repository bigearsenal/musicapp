http = require 'http'
# xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require '../node_modules/colors'
fs = require 'fs'

Encoder = require('../node_modules/node-html-encoder').Encoder
encoder = new Encoder('entity');

events = require('events')

NCT_CONFIG =
	table :
		Songs : "nctsongs"
		Albums : "nctalbums"
		Videos : "nctvideos"
		MVs : "nctmvs"
		MVPlaylists : "nctmvplaylists"
		MVs_MVPlaylists : "nctmvs_mvplaylists"
		Songs_Albums  : "nctsongs_albums"
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
		# @parser = new xml2js.Parser();
		@eventEmitter = new events.EventEmitter()
		super @mysqlConfig
		@logPath = @config.logPath
		@log = {}
		@_readLog()
		String::stripHtmlTags = (tag)->
			if not tag then tag = ""
			@.replace(RegExp("</?" + tag + "[^<>]*>", "gi"), "")

		Array::uniqueObjectByKey = (property)->
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
				# console.log res.statusCode
				if res.statusCode isnt 302 and res.statusCode isnt 301
					res.on 'data', (chunk) =>
						data += chunk;
					res.on 'end', () =>
						onSucess data, options
				else 
					if res.statusCode is 301
						@getFileByHTTP res.headers.location,onSucess,onFail,options
					else 
						onFail("The link: #{link} is temporary moved",options)
			.on 'error', (e) =>
				onFail  "Cannot get file: #{link} from server. ERROR: " + e.message, options
				@stats.totalItemCount +=1
				@stats.failedItemCount +=1
	# getFileByHTTP : (link, onSucess, onFail, options) ->
	# 	http.get link, (res) =>
	# 			res.setEncoding 'utf8'
	# 			data = ''
	# 			# onSucess res.headers.location
	# 			if res.statusCode isnt 302
	# 				res.on 'data', (chunk) =>
	# 					data += chunk;
	# 				res.on 'end', () =>

	# 					onSucess data, options
	# 			else onFail("The link: #{link} is temporary moved",options)
	# 		.on 'error', (e) =>
	# 			onFail  "Cannot get file: #{link} from server. ERROR: " + e.message, options
	# 			@stats.totalItemCount +=1
	# 			@stats.failedItemCount +=1
	_onFail : (err)=>
		console.log "#{err}".red
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		@utils.printRunning @stats

		if @stats.totalItems is @stats.totalItemCount
			@utils.printFinalResult @stats
			@updateVideosPlays()

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

				

				album.songids = []
				if album.songs
					for song in album.songs
						album.songids.push song.id
					delete album.songs
				
				# console.log album
				# process.exit 0

				@connection.query @query._insertIntoNCTAlbums, album, (err)=>
					@stats.totalItemCount +=1
					@stats.currentId = album.id
					if err 
						console.log err
						@stats.failedItemCount +=1
					else 
						@stats.passedItemCount +=1

					@utils.printRunning @stats
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats
						@updateSongsPlays()
	processSong : (data,options)=>
		song =
			id : options.id
			key : options.key
			title : ""
			artists : null
			topics : null
			plays : 0
			bitrate : 0
			type : ""
			link_key : ""
			lyric : ""

		# console.log data

		if options.official then if options.official is 1
			song.official = 1

		id = data.match(/hidden.+\"(\d+)\".+inpHiddenId/)?[1]

		if id
			id = parseInt(id,10)
			if id isnt song.id
				song.id = id

		topics =  data.match(/inpHiddenGenre.+/g)?[0]
		if topics then song.topics = topics.replace(/inpHiddenGenre.+value\=|\"|\s\/\>/g,'').split()


		temp = data.match(/<div class="songname">[^]+?<\/div>/)?[0]
		if temp
			temp = temp.stripHtmlTags()
			temp =  encoder.htmlDecode(temp.trim()).split(' - ')
			temp = temp.map (v) -> v.trim()
			# console.log temp
			if temp.length >= 2
				song.artists = temp[temp.length-1].split(", ").map((v)-> v.trim())
				temp.pop()
				song.title =  temp.join(" - ")
			else 
				# console.log "------------"
				# console.log temp
				# console.log song.key
				# console.log "----------"
				throw Error("Cannot process song while finding artists and title of the song")
		else
			throw Error("Cannot process song: unknow artists & title")
		# artists = data.match(/songname.+[\r\t\n]+.+/g)?[0]
		# if artists then song.artists = artists.match(/title.+"/)[0].replace(/>.+$/,'').replace(/title=|"/g,'').split(', ').map((v)->encoder.htmlDecode(v).trim()).uniqueObjectByKey()

		# title = data.match(/songname.+[\r\t\n]+.+/g)?[0]
		# if title then song.title = encoder.htmlDecode title.replace(/\- <a href.+/g,'').replace(/^.+\s+.+>/,'').trim()

		link_key = data.match(/flashPlayer\"\,\s\".+/g)?[0]
		if link_key then song.link_key = link_key.match(/"([0-9a-f]+)"/)?[1]

		type =  data.match(/.+inpHiddenType/g)?[0]
		if type then song.type = type.replace(/\"\sid.+$/g,'').replace(/^.+\"/g,'')


		lyric = data.match(/divLyric[^]+inpLyricId/g)?[0]
		
		if lyric 
			lyric = lyric.replace(/<input.+$/g,'').replace(/[^]+hidden;\">\n/g,'').trim().replace(/<\/div>$/g,'').trim()
			lyric = lyric.replace(/^divLyricHtml[^]+overflow\:hidden\;\"\>/g,'').trim()
			song.lyric = encoder.htmlDecode lyric

		bitrate = data.match(/<title>.+\s(\d+)( Kb|kbps)/)?[1]
		if bitrate
			song.bitrate = bitrate
		# THIS PART IS OPTIONAL. Only use for getting new songs
		# @processSimilarSongs data, options
		# END OF OPTIONAL PART

		if song.type is "mv"
			title = data.match(/songname.+/g)?[0]
			if title then song.title = encoder.htmlDecode title.replace(/<\/h1>.+/g,'').replace(/^.+>/,'')
			coverart = data.match(/image_src.+\"(http.+)\"/)?[1]
			if coverart
				song.coverart = coverart
				if song.coverart
					if song.coverart.match(/\d{4}\/\d{2}\/\d{2}/g)
						song.date_created = song.coverart.match(/\d{4}\/\d{2}\/\d{2}/g)[0].replace(/\//g,'-')
					else if song.coverart.match(/\d{4}_\d{2}\//g)
						song.date_created = song.coverart.match(/\d{4}_\d{2}\//g)[0].replace(/_/g,':').replace(/\//g,'')
						song.date_created += ":01"
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
		# console.log "we have error at album. #{JSON.stringify albums}"
		songs = []
		for album in albums
			if album.songs
				for song in album.songs
					song.id = parseInt song.id,10
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
		@stats.currentTable = @table.Songs

		# for testing
		# songs = [{ id: 2442282,key: 'GbV3lZa2Yifq'}]
		_options =
			field : "id"
			table : @table.Songs
		@filterNonExistedRecordInDB songs, _options, (results)=>
			console.log " |The # of items AFTER being filtered :" + results.length
			@stats.totalItems = results.length
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
				artists : null
				topics : null
				plays : options.plays
				nsongs : 0
				coverart : ""
				link_key : ""
				description : ""
				date_created : null

			if album.plays is undefined
				album.plays = 0

			if data.match(/<div\sclass\=\"category\"\>[\s]+.+Thể\sloại\:.+/g)

				_info = data.match(/<div\sclass\=\"category\"\>[\s]+.+Thể\sloại\:.+/g)[0].split('|')

				album.nsongs = parseInt _info[2].replace(/Số\sbài\:\s|<\/p\>/g,'').trim(), 10

				if album.id > 1000000000
					id = data.match(/hidden.+\"(\d+)\".+inpHiddenId/)?[1]
					# console.log "#{id}".red
					if id then album.id = parseInt(id,10)

				link_key = data.match(/flashPlayer\"\,\s\"playlist.+/g)?[0]
				if link_key then album.link_key = link_key.match(/"([0-9a-f]+)"/)?[1]

				topics =  data.match(/inpHiddenGenre.+/g)?[0]
				if topics then album.topics = topics.replace(/inpHiddenGenre.+value\=|\"|\s\/\>/g,'').split()

				temp = data.match(/<div class="songname">[^]+?<\/div>/)?[0]
				if temp
					temp = temp.stripHtmlTags()
					temp =  encoder.htmlDecode(temp.trim()).split(' - ')
					temp = temp.map (v) -> v.trim()
					# console.log temp[1]
					if temp.length >= 2
						album.artists = temp[temp.length-1].split(", ").map((v)-> v.trim())
						temp.pop()
						album.title =  temp.join(" - ")

					else 
						throw Error("Cannot process album while finding artists and title of the album")
				else
					throw Error("Cannot process album: unknow artists & title")
				# artists = data.match(/songname.+\s+.+/g)?[0]
				# if artists then album.artists = artists.match(/title.+"/)[0].replace(/>.+$/,'').replace(/title=|"/g,'').split(',').map((v)->encoder.htmlDecode(v).trim())

				# title = data.match(/songname.+\s+.+/g)?[0]
				# if title then album.title = encoder.htmlDecode title.replace(/\- <a href.+/g,'').replace(/^.+\s+.+>/,'').trim()

				coverart = data.match(/.+img152/g)?[0]
				if coverart then album.coverart = coverart.match(/src=\"http.+\"\swidth/g)?[0].replace(/src=\"|\"\swidth/g,'')

				if album.coverart.match(/\d{4}\/\d{2}\/\d{2}/g)
					album.date_created = album.coverart.match(/\d{4}\/\d{2}\/\d{2}/g)[0].replace(/\//g,'-')
				if album.coverart.match(/\/\d+\.jpg$/g)
					_t = new Date(parseInt(album.coverart.match(/\/\d+\.jpg/g)[0].replace(/\/|\.jpg/g,'')))
					album.date_created += " " + _t.getHours() + ":" + _t.getMinutes() + ":" + _t.getSeconds()


				songs = data.match(/btnDownload.+rel.+key.+relTitle.+/g)
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
			console.log "Catching error while trying to process album [key : #{options.key}, id : #{options.id}] content: #{JSON.stringify album}: Error message: #{e}"

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
	filterNonExistedRecordInDB : (items,options,callback)->
		temp = []
		count = 0
		tempItems = []
		chunkLength = 150
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
				count +=1
				@printUpdateInfo "Count : #{count}.Filtering......"
				if err then console.log err
				# console.log results
				for result in results
					if result[options.field].match and result[options.field].match(/^[0-9]+$/)
						_tempArray.push parseInt(result[options.field],10)
					else
						_tempArray.push result[options.field]
				# console.log JSON.stringify _tempArray
				temp = temp.concat(items.filter((v)-> if _tempArray.indexOf(v[options.field]) > -1 then return false else return true))

				# console.log JSON.stringify _tempArray
				# console.log items.filter((v)-> if _tempArray.indexOf(v[options.field]) > -1 then return false else return true)
				# console.log temp

				# process.exit 0

				if count is nChunks
					# console.log temp
					callback(temp)	
		items.map (item, index)=>
			if (index/chunkLength|0) isnt currentChunk
				currentChunk +=1
				processTempItems tempItems
				tempItems = []
			tempItems.push item
			if index is items.length-1
				processTempItems tempItems
			@printUpdateInfo "Count : #{count}.Filtering......"
	getAlbumKeysAndIds : (topicLink,page = 1) ->
		link = topicLink.replace(".html","." + page + ".html")
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
				@albums = @albums.uniqueObjectByKey("id")
				console.log ""
				console.log " |The # of albums UNIQUEObjectByKey BEFORE being filtered :" + @albums.length
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

		topics = "bai-hat-moi-nhat nhac-tre-moi-nhat tru-tinh-moi-nhat cach-mang-moi-nhat tien-chien-moi-nhat nhac-trinh-moi-nhat thieu-nhi-moi-nhat rap-viet-moi-nhat rock-viet-moi-nhat khong-loi-moi-nhat au-my-moi-nhat han-quoc-moi-nhat nhac-hoa-moi-nhat nhac-nhat-moi-nhat nhac-phim-moi-nhat the-loai-khac-moi-nhat"
		# topics = "nhac-tre"
		topics = topics.split(' ')
		url = "http://www.nhaccuatui.com/playlist/"
		#update max album id
		if @log.tempMaxAlbumId > @log.maxAlbumId
			 @log.maxAlbumId = @log.tempMaxAlbumId
		@stats.currentTable = @table.Albums

		# init conditions to stop
		nPages = 34 # default 34
		@stats.totalPageCount = 0
		@stats.totalPages = nPages * topics.length
		# init the album array
		@albums = []

		for topic in topics
			# link =  url + topic + ".html" + "?sort=1&page="
			link =  url + topic + ".html"
			for page in [1..nPages]
				@getAlbumKeysAndIds link, page
		null


	processVideo : (data,options)=>
		video =
			id : options.id
			key : options.key
			title : ""
			artists : null
			topics : null
			plays : 0
			thumbnail : ""
			type : ""
			link_key : ""
			lyric : ""

		#new version in June 2013 does not support lyric of videos
		id = data.match(/hidden.+\"(\d+)\".+inpHiddenId/)?[1]
		if id
			id = parseInt(id,10)
			if id isnt video.id
				video.id = id

		type =  data.match(/.+inpHiddenType/g)?[0]
		if type then video.type = type.replace(/\"\sid.+$/g,'').replace(/^.+\"/g,'')

		info = data.match(/<div class="songname">[^]+?<\/h2>/g)?[0]
		if info
			info = info.stripHtmlTags().trim()
			info =  encoder.htmlDecode(info.trim()).split(' - ')
			info = info.map (v) -> v.stripHtmlTags().trim()
			if info.length >= 2
				video.artists = info[info.length-1].split(', ').map((v)->encoder.htmlDecode(v).trim())
				info.pop()
				video.title = encoder.htmlDecode info.join(" - ").trim()
			else
				throw Error("error while getting artists and title of video")

		topics = data.match(/<p class="category">.+/g)?[0]
		if topics

			topics = topics.stripHtmlTags().replace(/Thể loại:/,'').replace(/Âm Nhạc,/,'').replace(/&nbsp;/g,' ').trim()
			# console.log topics
			video.topics = topics.split(", ").map (v)-> encoder.htmlDecode v
			# console.log video.topics		
		thumbnail = data.match(/image_src.+\"(http.+)\"/)?[1]
		if thumbnail
			video.thumbnail = thumbnail
			if video.thumbnail
					if video.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)
						video.date_created = video.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)[0].replace(/\//g,'-')
					else if video.thumbnail.match(/\d{4}_\d{2}\//g)
						video.date_created = video.thumbnail.match(/\d{4}_\d{2}\//g)[0].replace(/_/g,':').replace(/\//g,'')
						video.date_created += ":01"
			
		link_key = data.match(/flashPlayer\"\,\s\".+/g)?[0]
		if link_key then video.link_key = link_key.match(/"([0-9a-f]+)"/)?[1]

		@eventEmitter.emit "video-result", video
		return video

	# 2. THIS PART IS FOR UPDATING SONGS & VIDEOS ONLY
	processItemsAfterFilter : (items, options)->

		if options.config.type is "song"
			@eventEmitter.on "song-result", (song)=>
				# console.log song
				@stats.totalItemCount +=1
				@stats.passedItemCount +=1
				
				# @utils.printRunning @stats
				# console.log "call song result"
				# console.log song
				if song isnt null
					@stats.currentId = song.id
					
					@connection.query @query._insertIntoNCTSongs, song, (err)->
						if err then console.log "Cannt insert song: #{song.key}. ERROR #{err} "

				else
					@stats.passedItemCount -=1
					@stats.failedItemCount +=1
				@utils.printRunning @stats

				if @stats.totalItems is @stats.totalItemCount
					@utils.printFinalResult @stats
					console.log "SONGS HAVE ALREADY BEEN UPDATED".inverse.red
					# @updateSongsPlays()
					@eventEmitter.emit "update-song-finish"
		else if options.config.type is "video"
			@eventEmitter.on "video-result", (video)=>
				# console.log video
				@stats.totalItemCount +=1
				@stats.passedItemCount +=1
				@stats.currentId = video.id
				# @utils.printRunning @stats

				# console.log video
				# process.exit 0
				if video isnt null
					@connection.query @query._insertIntoNCTVideos, video, (err)->
						if err then console.log "Cannt insert video: #{video.key}. ERROR #{err} "
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
					@getFileByHTTP link, @processSong, @_onFail, _options
				else if options.config.type is "video"
					link = "http://www.nhaccuatui.com/video/joke-link.#{item.key}.html"
					_options =
						key : item.key
						duration : item.duration
					@getFileByHTTP link, @processVideo, @_onFail, _options
				# console.log link
				
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
		ids = data.match(/.+img150/g)
		if ids
			if  ids.length?
					ids = ids.map (v)-> v.replace(/\.html.+$/g,'').replace(/^.+\./g,'')
					for v,index in ids
						video =
							key :  ids[index]
						videos.push video
			else
				console.log "ERROR: videos duration and ids do not have length property"
				console.log JSON.stringify options
		# else
		# 	console.log "ERROR: Videos duration and times do not exist at the same time"
		# 	console.log JSON.stringify options
		return videos
	getItemsKeysAndIds : (topicLink,page = 1,config)->
		link = topicLink.replace(".html","." + page + ".html")
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
					@items = @items.uniqueObjectByKey("id")
				else if  options.config.type is "video"
					@items = @items.uniqueObjectByKey("key")
				console.log ""
				console.log " |The # of items UNIQUEObjectByKey BEFORE being filtered :" + @items.length
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
			topics = "bai-hat-moi-nhat nhac-tre-moi-nhat tru-tinh-moi-nhat cach-mang-moi-nhat tien-chien-moi-nhat nhac-trinh-moi-nhat thieu-nhi-moi-nhat rap-viet-moi-nhat rock-viet-moi-nhat khong-loi-moi-nhat au-my-moi-nhat han-quoc-moi-nhat nhac-hoa-moi-nhat nhac-nhat-moi-nhat nhac-phim-moi-nhat the-loai-khac-moi-nhat"
			# topics = "nhac-tre"
			topics = topics.split(' ')
			url = "http://www.nhaccuatui.com/bai-hat/"
			nPages = 50
		else if config.type is "video"
			topics = "video-moi video-am-nhac-viet-nam-nhac-tre video-am-nhac-viet-nam-tru-tinh video-am-nhac-viet-nam-que-huong video-am-nhac-viet-nam-cach-mang video-am-nhac-viet-nam-thieu-nhi video-am-nhac-viet-nam-nhac-rap video-am-nhac-viet-nam-nhac-rock video-am-nhac-au-my-pop video-am-nhac-au-my-rock video-am-nhac-au-my-dance video-am-nhac-au-my-r-b-hip-hop-rap video-am-nhac-au-my-blue-jazz video-am-nhac-au-my-country video-am-nhac-au-my-latin video-am-nhac-au-my-indie video-am-nhac-han-quoc video-am-nhac-nhac-hoa video-am-nhac-nhac-nhat video-am-nhac-the-loai-khac video-giai-tri-hai-kich video-giai-tri-phim video-giai-tri-khac"
			# topics = "video-moi"
			topics = topics.split(' ')
			url = "http://www.nhaccuatui.com/"
			nPages = 42

		@stats.currentTable = config.table
		@stats.totalPageCount = 0
		@stats.totalPages = nPages * topics.length
		# init the items array
		@items = []

		for topic in topics
			# link =  url + topic + ".html" + "?sort=1&page="
			link =  url + topic + ".html"
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
			_u += " coverart=#{@connection.escape video.coverart},"
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



	# nEW PART on August 17, 2013, ONCE!!!!
	getFileByHTTPXXX : (link, onSucess, onFail, options) ->
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
				@stats.totalItemCount +=1
				@stats.failedItemCount +=1
	fetchSongWhereTitleIsNull : ->
		@connect()

		# @eventEmitter.on "video-result", (video,options)=>
		# 	@stats.totalItemCount +=1
		# 	@stats.passedItemCount +=1

		# 	@utils.printRunning @stats
		# 	if @stats.totalItems is @stats.totalItemCount
		# 		@utils.printFinalResult @stats
		# 	upd = "update nctvideos set title=#{@connection.escape video.title},"
		# 	upd += " artists = '#{@connection.escape(JSON.stringify video.artists).replace(/^'\[/g,"{").replace(/\]'$/g,"}")}'"
		# 	upd +=  " where key = #{@connection.escape video.key}"
		# 	# console.log upd
		# 	# process.exit 0
		# 	@connection.query upd, (err)->
		# 			if err 
		# 				console.log err
		# 				console.log 
			# process.exit 0
		# link = "http://www.nhaccuatui.com/bai-hat/beautiful-day-jamie-grace.FWnas8E9l6Pl.html"
		# options = 
		# 	key : "FWnas8E9l6Pl"
		# @getFileByHTTP link, @processSong, @_onFail, options
		
		
		processVideo = (data,options)=>
			try 
				@stats.totalItemCount +=1
				@stats.passedItemCount +=1

				@utils.printRunning @stats
				if @stats.totalItems is @stats.totalItemCount
					@utils.printFinalResult @stats
				video = 
					key : options.key
				data = data.replace(/<recommend>[^]+<\/recommend>/,'')
				title = data.match(/<title>[^]+\[CDATA\[(.+)\]\]>[^]+<\/title>/)?[1]
				artists = data.match(/<creator>[^]+\[CDATA\[(.+)\]\]>[^]+<\/creator>/)?[1]
				video.title = encoder.htmlDecode title
				video.artists = artists.split(", ").map (v)-> encoder.htmlDecode v.trim()

				upd = "update nctvideos set title=#{@connection.escape video.title},"
				upd += " artists = '#{@connection.escape(JSON.stringify video.artists).replace(/^'\[/g,"{").replace(/\]'$/g,"}")}'"
				upd +=  " where key = #{@connection.escape video.key}"

				# console.log upd
				@connection.query upd, (err)->
					if err 
						console.log err
						console.log ""
			catch e

				@stats.passedItemCount -=1
				@stats.failedItemCount +=1
				# console.log "err at adfasdfsd".red
				# console.log options
				# console.log data
				# console.log ""
				# console.log ""
				# console.log ""

		onFail = (err,options)=>
			console.log err + " at key #{options.key}"
			console.log ""
			@stats.totalItemCount +=1
			@stats.failedItemCount +=1

			@utils.printRunning @stats
			if @stats.totalItems is @stats.totalItemCount
				@utils.printFinalResult @stats

			# process.exit 0
		@connection.query "select key, link_key from nctvideos", (err, videos)=>
			if err then console.log err
			else 
				@stats.totalItems = videos.length
				for video in videos
					link = "http://www.nhaccuatui.com/video/-nam.#{video.key}.html"
					link  = "http://www.nhaccuatui.com/flash/xml?key3=#{video.link_key}"
					# link  = "http://www.nhaccuatui.com/flash/xml?key3=61c1d84bb4882988e865c0a6af169363"
					
					options = 
						key : video.key
					@getFileByHTTPXXX link, processVideo, onFail, options

	showStats : -> @_printTableStats NCT_CONFIG.table


module.exports = Nhaccuatui
