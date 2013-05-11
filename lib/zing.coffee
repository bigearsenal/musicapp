http = require 'http'
xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require 'colors'
fs = require 'fs'

Encoder = require('node-html-encoder').Encoder
encoder = new Encoder('entity');

events = require('events')

ZI_CONFIG = 
	table : 
		Songs : "ZISongs"
		Albums : "ZIAlbums"
		Songs_Albums : "ZISongs_Albums"
		Artists : "ZIArtists"
		Videos : "ZIVideos"
	logPath : "./log/ZILog.txt"

class Zing extends Module
	constructor : (@mysqlConfig, @config = ZI_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoZISongs : "INSERT IGNORE INTO " + @table.Songs + " SET ?"
			_insertIntoZIAlbums : "INSERT INTO " + @table.Albums + " SET ?"
			_insertIntoZISongs_Albums : "INSERT IGNORE INTO " + @table.Songs_Albums + " SET ?"
			_insertIntoZIArtists : "INSERT IGNORE INTO " + @table.Artists + " SET ?"
			_insertIntoZIVideos : "INSERT IGNORE INTO " + @table.Videos + " SET ?"
		@utils = new Utils()
		@parser = new xml2js.Parser();
		@eventEmitter = new events.EventEmitter()
		super @mysqlConfig
		@logPath = @config.logPath
		@log = {}
		@_readLog()
	encryptId : (id) ->
		a = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty".split("|") 
		[1,0,8,0,10].concat((id-307843200+'').split(''),[10,1,2,8,10,2,0,1,0]).map((i)-> 
			a[i][Math.random()*a[i].length|0]).join('')
	_convertToInt : (id)->
		a = "0IWOUZ6789ABCDEF".split('')
		b = "0123456789ABCDEF"
		parseInt id.split('').map((v)-> b[a.indexOf(v)]).join(''), 16
	_convertToId : (i)->
		a = "0IWOUZ6789ABCDEF".split('')
		b = "0123456789abcdef"
		i.toString(16).split('').map((v)-> a[b.indexOf(v)]).join('')
	_decodeString : (str)->
		s=["IJKLMNOPQRSTUVWXYZabcdef",
		"CDEFGHSTUVWXijklmnyz0123"]
		base24 = "0123456789abcdefghijklmn"
		s1 = "AEIMQUYcgkosw048".split('')
		category = ""

		charCode = (x)->x.charCodeAt(0)

		x1x2 = str.substr(0,2).split('').map((v, i)-> base24[s[i].indexOf(v)] ).join('')
		n = parseInt(x1x2,24)

		x3 = str[2]
		x4 = str[3]
		c_x3 = charCode(x3)
		c_x4 = charCode(x4)  

		for i in [0..s1.length-2]
			if 56<=c_x3<=57
				if c_x3 is 56 then category = "typeA"
				else category = "typeB"
				additionalFactor =  s1.indexOf "8"
				break
			else if charCode(s1[i])<=c_x3<charCode(s1[i+1])
					# console.log "#{s1[i]}"
					additionalFactor = s1.indexOf s1[i]
					if c_x3 is charCode(s1[i])
						category = "typeA"
					else 
						if c_x3 is charCode(s1[i])+1
							category = "typeB"
						else category = "typeC"

		# console.log "the input is #{str}"
		# console.log "Additional Factor is #{additionalFactor}"
		# console.log "Value of x3 is #{x3}: Category: #{category}"

		#additionalFactor is the remainder in hex value from (0..15)
		c_y2 = (n%6 + 2)*16 + additionalFactor
		c_y1 = Math.floor(n/6)+32

		c_y3 = ""
		if category is "typeA"
		
			if 103<=c_x4<=122
				c_y3 = c_x4 - 103 + 32
			if 48<=c_x4<=57
				c_y3 = c_x4 + 4
		else 
			if category is "typeB"
				
				if 65<=c_x4<=90
					c_y3 = c_x4 - 1
				else if 97<=c_x4<=122
					c_y3 = c_x4 - 7
				else if 48<=c_x4<=57
					c_y3 = c_x4 + 68
			else 
				# doing thing with C D
				c_y3 = 63
		[String.fromCharCode(c_y1), String.fromCharCode(c_y2), String.fromCharCode(c_y3)].join('')
		# [result,remainder]

	###*
	 * update a field in table
	 * params = 
	 * 		sourceField
	 * 		table
	 * 		limit (optional)
	###
	_getFieldFromTable : (@params, callback)->

		_q = "Select #{@params.sourceField} from #{@params.table}"
		_q += " LIMIT #{@params.limit}" if @params.limit
		@connection.query _q, (err, results)=>
			for result in results
				do (result)=>
					callback result[@params.sourceField]

	_getFileByHTTP : (link, callback) ->
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				# callback res.headers.location
				if res.statusCode isnt 302
					res.on 'data', (chunk) =>
						data += chunk;
					res.on 'end', () =>
						
						callback data
				else callback(null)
			.on 'error', (e) =>
				console.log  "Cannot get file. ERROR: " + e.message

	# VIDEO SECTION
	updatevid : ->
		@connect()
		_q = "select videoid from ZIVideos"
		@connection.query _q, (err,results)=>
			if err then console.log "cannt fetch videos"
			else 
				for video in results
					_temp = @_convertToInt video.videoid
					_u = "update ZIVideos set vid=#{_temp} where videoid=#{@connection.escape(video.videoid)}"
					@connection.query _u, (err)->
						if err then console.log "cannt update video"
	updateCreatedTime : ->
		@connect()
		
		for i in [0..30000] by 1000
			_q = "select videoid, link from ZIVideos LIMIT #{i},1000 "
			@connection.query _q, (err,results)=>
				if err then console.log "cannt fetch videos"
				else 
					console.log "anbinh"
					for video in results
						link = video.link
						if link.match /\d{4}\/\d{1}/g
							created = link.match(/\d{4}\/\d{1}/g)[0]
						if link.match /\d{4}\/\d{2}/g
							created = link.match(/\d{4}\/\d{2}/g)[0]
						if link.match /\d{4}\/\d{1}\/\d{1}/g
							created = link.match(/\d{4}\/\d{1}\/\d{1}/g)[0]
						if link.match /\d{4}\/\d{1}\/\d{2}/g
							created = link.match(/\d{4}\/\d{1}\/\d{2}/g)[0]
						if link.match /\d{4}\/\d{2}\/\d{2}/g
							created = link.match(/\d{4}\/\d{2}\/\d{2}/g)[0]
						if created?
							_u = "update ZIVideos set created=#{@connection.escape(created)} where videoid=#{@connection.escape(video.videoid)}"
							@connection.query _u, (err)->
								if err then console.log "cannt update video"
	_updateLyricForVideo : (vid) ->
		
		link = "http://mp3.zing.vn/ajax/lyric-v2/lyrics?id=#{@_convertToId vid}&from=0"
		# console.log link
		@_getFileByHTTP link, (data)=>
			try 
				if data isnt null
					arr = JSON.parse(data).result
					bbb = arr.map (v)-> 
						v = v.match(/score\">\d+<\/span>/g)?[0].match(/\d+/g)?[0]
						if v isnt undefined then parseInt v,10 else 0
					zeroCount = 0
					bbb.map (v)->
						if v is 0 then zeroCount+=1
					index = bbb.indexOf Math.max bbb...
					if zeroCount is bbb.length then index = bbb.length-1
					t =  JSON.stringify(arr[index]).replace(/^.+<\/span><\/span>/g,'')
													.replace(/<\/div>.+$/g,'')
													.replace(/<\/p>\\n/g,'')
													.replace(/\\r/g,'').replace(/\\t/g,'').replace(/\\n/g,'')
					if t.search("Hiện chưa có lời bài hát") > -1
						t = ""
					t = encoder.htmlDecode t
					_u = "UPDATE #{@table.Videos} SET lyric=#{@connection.escape(t)} where vid=#{vid}"
					@connection.query _u, (err)->
						if err then console.log "Cannt update lyric #{video.vid}"
	
	_processVideo : (vid, data)->
		_video = null
		if data.match(/xmlURL.+\&amp\;/g) is null then return _video
		else
			# _video = 
			# 	video_encodedId : data.match(/xmlURL.+\&amp\;/g)[0].replace(/xmlURL\=http\:\/\/mp3\.zing\.vn\/xml\/video\-xml\//g,'').replace(/\&amp\;/,'')
			_video = 
				vid : vid
				title : ""
				artists : ""
				topic : ""
				plays : 0
				thumbnail : ""
				link : ""
				lyric : ""
				created : "0000-00-00"

			if data.match(/Thể\sloại\:/g)
					_temp= data.match(/Thể\sloại\:.+/g)[0]				
					_topics = _temp.split('|')[0].replace(/Thể\sloại\:.|\/span\>|\<\/p\>/g,'').split(',')
					_video.plays = _temp.split('|')[1].replace(/Lượt\sxem\:|\s|\<\/p\>|\./g,'')
					arr = []
					arr.push _topic.replace(/\<a.+\"\>|\<\/a\>/g,'').trim() for _topic in _topics
					_video.topic = JSON.stringify arr
			else _video.topic = ''

			if data.match(/detail-title.+/g)
				_temp = data.match(/detail-title.+/g)[0]
									.replace(/detail-title"/g,'')
				_temp = _temp.split(/<span>-<\/span>/g)

				_video.title = _temp[0].replace(/<\/h1>|>/g,'')
				# console.log _temp[1]
				_video.artists = JSON.stringify _temp[1].match(/Tìm\sbài\shát\scủa.+"/g)[0].replace(/"$/g,'')
															.replace(/Tìm\sbài\shát\scủa\s/g,'').split(' ft. ')
				
			if data.match(/og:image/g)
				_video.thumbnail = data.match(/og:image.+/g)[0].match(/http.+"/g)[0].replace('"','')

			link = _video.thumbnail
			if link.match /\d{10}\.jpg/g
				_timestamp = link.match(/\d{10}\.jpg/g)[0].replace(/\.jpg/g,'')
				_date = new Date(parseInt(_timestamp,10)*1000)
				_video.created = _date.getFullYear() + "-" + (_date.getMonth()+1) + "-"+ _date.getDate()
			if link.match /\d{4}\/\d{1}/g
				_video.created = link.match(/\d{4}\/\d{1}/g)[0]
			if link.match /\d{4}\/\d{2}/g
				_video.created = link.match(/\d{4}\/\d{2}/g)[0]
			if link.match /\d{4}\/\d{1}\/\d{1}/g
				_video.created = link.match(/\d{4}\/\d{1}\/\d{1}/g)[0]
			if link.match /\d{4}\/\d{1}\/\d{2}/g
				_video.created = link.match(/\d{4}\/\d{1}\/\d{2}/g)[0]
			if link.match /\d{4}\/\d{2}\/\d{2}/g
				_video.created = link.match(/\d{4}\/\d{2}\/\d{2}/g)[0]
			if link.match /\d{4}\/\d{2}_\d{2}/g
				_video.created = link.match(/\d{4}\/\d{2}\_\d{2}/g)[0].replace(/\//,'-').replace(/_/,'-')

			_video.link = "http://mp3.zing.vn/html5/video/" + @encryptId(vid)

			lyric = data.match(/Lời\sbài\shát+[^]+class=\"seo\"/g)?[0]
			if lyric
				lyric = lyric.replace(/<p\sclass=\"seo+[^]+<p\sclass=\"seo/g,'').replace(/Lời\sbài\shát+[^]+<\/span><\/span>/g,'').trim()
				_video.lyric = lyric.replace(/<\/p>\r\n\t<\/div>\r\n\t\t<\/div>\r\n\t\t/g,'')

				# 

			return _video
			
	_updateVideo : (id)->
		link = "http://mp3.zing.vn/video-clip/joke-link/#{@_convertToId id}.html"
		@_getFileByHTTP link, (data)=>
			@stats.totalItemCount +=1
			@stats.currentId = id		
			if data isnt null
				video = @_processVideo id, data	
				if video is null
					@stats.failedItemCount += 1
					@temp.totalFail += 1
				else 
					# console.log video
					@stats.passedItemCount += 1
					@log.lastVideoId = id
					@temp.totalFail = 0
					@connection.query @query._insertIntoZIVideos, video, (err)=>
						if err then console.log "Cannot insert video #{video.videoid} into table. Error: #{err}"					
			else 
				@stats.failedItemCount += 1
				@temp.totalFail += 1
			
			@utils.printUpdateRunning id, @stats, "Fetching..."
			
			if @temp.totalFail < @temp.nStop
				@_updateVideo id+1
			else
				@utils.printFinalResult @stats
				@_writeLog @log
	updateVideos : ->
		@connect()
		@stats.currentTable = @table.Videos
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Update video to table  : #{@table.Videos}".magenta
		@temp =
			totalFail : 0
			nStop : 3000 # the number of consecutive items fail
		console.log "The program will stop after #{@temp.nStop} consecutive videos failed"
		@_updateVideo @log.lastVideoId+1

	# ---------------------------------------
	# Updating songs, albums and songs_albums
	_processAlbum : (albumid, data) ->
		album = 
			aid : albumid
			albumid : @_convertToId albumid
		album.album_encodedId = data.match(/xmlURL.+\&amp\;/g)[0].replace(/xmlURL\=http\:\/\/mp3\.zing\.vn\/xml\/album\-xml\//g,'').replace(/\&amp\;/,'') 
		
		if data.match(/Lượt\snghe\:\<\/span\>.+/g)
			album.plays = data.match(/Lượt\snghe\:\<\/span\>.+/g)[0]
							.replace(/Lượt\snghe\:\<\/span\>\s|\<\/p\>|\./g,'').trim()
		else album.plays = 0
		
		if data.match(/Năm\sphát\shành\:.+/g)
			album.released_year = data.match(/Năm\sphát\shành\:.+/g)[0]
									.replace(/Năm\sphát\shành\:/g,'')
									.replace(/\<\/p\>|\<\/span\>/g,'').trim()
		else album.released_year = ''

		if data.match(/Số\sbài\shát\:/g)
			album.nsongs = data.match(/Số\sbài\shát\:.+/g)[0]
								.replace(/Số\sbài\shát\:|\<\/span\>\s|\<\/p\>/g,'')
		else album.nsongs = ''

		if data.match(/Thể\sloại\:/g)
			_topics = data.match(/Thể\sloại\:.+/g)[0]
								.replace(/Thể\sloại\:.|\/span\>|\<\/p\>/g,'').split(',')
			arr = []
			arr.push _topic.replace(/\<a.+\"\>|\<\/a\>/g,'').trim() for _topic in _topics
			album.topic = JSON.stringify arr
		else album.topic = ''

		if data.match(/_albumIntro\"\sclass\=\"rows2.+/g)
			album.description = encoder.htmlDecode data.match(/_albumIntro\"\sclass\=\"rows2.+/g)[0]
									.replace(/_albumIntro.+\"\>|\<br\s\/\>|\<\/p\>/g,'')

		if data.match /detail-title.+/g
			item = data.match(/detail-title.+/g)[0].replace(/detail-title\">|<\/h1>/g,'')
			_tempArr = item.split(' - ')
			_temp_artist = encoder.htmlDecode _tempArr[_tempArr.length-1]

			if _temp_artist.search(" ft. ") > -1
				album.album_artist = JSON.stringify _temp_artist.trim().split(' ft. ')
			else album.album_artist = JSON.stringify _temp_artist.trim().split(',')

			_tempArr.splice(-1)
			album.album_name = encoder.htmlDecode _tempArr.join(' - ')
		
		if data.match /album-detail-img/g
			_temp =  data.match(/album-detail-img.+/g)[0].replace(/album-detail-img|/)
			album.album_thumbnail = _temp.match(/src\=\".+/g)[0].replace(/album-detail-img.+src\=/g,'')
											.replace(/alt.+|\"|src\=/g,'').trim()
			if album.album_thumbnail.match(/_\d+\..+$/)
				_t = album.album_thumbnail.match(/_\d+\..+$/)[0].replace(/_|\..+$/,'')
				_t = new Date(parseInt(_t,10)*1000)
				_created = _t.getFullYear() + "-" + (_t.getMonth()+1) + "-" + _t.getDate() + " " + _t.getHours() + ":" + _t.getMinutes() + ":" + _t.getSeconds()
				album.created = _created

		if data.match(/_divPlsLite.+\"\sclass/g)
			arr = []
			_songids = data.match(/_divPlsLite.+\"\sclass/g)
			arr.push _songid.replace(/_divPlsLite|\"\sclass/g,'') for _songid in _songids
			songids = arr.map (v)=> @_convertToInt v
		else album.description = ""
		data = ""
		
		# console.log album
		# console.log songs_albums
		# Starting to insert new album
		
		@connection.query @query._insertIntoZIAlbums, album, (err)=>
			if !err 
				for sid in songids
					do (sid, albumid)=>
						_item = 
							aid : albumid
							sid : sid
						@connection.query @query._insertIntoZISongs_Albums, _item, (err)->
							if err then console.log "Cannot insert new record: #{JSON.stringify(_item)} into Songs_Albums. ERROR: #{err}"
		album
	_updateAlbums : (albumid)->
		link = "http://mp3.zing.vn/album/joke-link/#{@_convertToId albumid}.html"
		@_getFileByHTTP link, (data)=>
			try 
				@stats.totalItemCount +=1
				@stats.currentId = albumid
				if data isnt null
					if data.match(/xmlURL.+\&amp\;/g) is null 
						@stats.failedItemCount += 1
						@temp.totalFail+=1
						# console.log "ERROR : album #{albumid}: does not exist".red
					else
						@temp.totalFail = 0
						@log.lastAlbumId = albumid
						@stats.passedItemCount +=1	
						@_processAlbum albumid, data	
				else 
					@temp.totalFail+=1
					@stats.failedItemCount +=1

				@utils.printUpdateRunning albumid, @stats, "Fetching..."

				if @temp.totalFail >= @temp.nStop
					@utils.printFinalResult @stats
					@_writeLog @log
					@eventEmitter.emit "update-album-finish"
				else @_updateAlbums albumid+1

			catch e
				console.log "CANNOT fetch albumid : #{albumid}. ERROR: #{e}"
				@stats.failedItemCount +=1
				@temp.totalFail+=1
	updateAlbums : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Update Albums and Songs_Albums to tables: #{@table.Albums} & #{@table.Songs_Albums}".magenta
		@temp = {}
		@temp.totalFail = 0
		@temp.nStop = 1000
		console.log "The program will stop after #{@temp.nStop} consecutive albums failed"
		@stats.currentTable = @table.Albums + " & " + @table.Songs_Albums
		@_updateAlbums @log.lastAlbumId+1

	_updateLyric : (song) ->
		link = "http://mp3.zing.vn/ajax/lyrics/lyrics?from=0&id=#{@_convertToId song.sid}&callback="
		# console.log link
		@_getFileByHTTP link, (data)=>
			try 
				if data isnt null
					
					str = JSON.parse(data).html

					arr = str.split(/oLyric/g)

					bbb = arr.map (v)-> 
						v = v.match(/score\">\d+<\/span>/g)?[0].match(/\d+/g)?[0]
						if v isnt undefined then parseInt v,10 else 0

					zeroCount = 0
					bbb.map (v)->
						if v is 0 then zeroCount+=1

					index = bbb.indexOf Math.max bbb...

					if zeroCount is bbb.length then index = bbb.length-1

					# console.log bbb[index]
					t =  JSON.stringify(arr[index]).replace(/^.+<\/span><\/span>/g,'')
														.replace(/<\/div>.+$/g,'')
														.replace(/<\/p>\\r\\n\\t/g,'')
														.replace(/^\\r\\n\\t\\t\\t/g,'')
														.replace(/\\r/g,'').replace(/\\t/g,'').replace(/\\n/g,'').replace(/\\"/g,'"')
					if t.search("Hiện chưa có lời bài hát") > -1
						t = ""
					t = encoder.htmlDecode t
					_u = "UPDATE #{@table.Songs} SET lyric=#{@connection.escape(t)} where sid=#{song.sid}"
					# console.log _u
					@connection.query _u, (err)->
						if err then console.log "Cannt update lyric #{song.sid}"
					
				else 
					console.log "FAILED WHILE UPDATING LYRICS"
			catch e
				console.log "FAILED WHILE UPDATING LYRICS 2"
	_processSong : (songid, data)->
		_song = 
			sid : songid
			songid : @_convertToId songid

		if data.match(/Lượt\snghe\:.+<\/p>/g)
			_song.plays = data.match(/Lượt\snghe\:.+<\/p>/g)[0]
						.replace(/Lượt\snghe\:|<\/p>|\./g,'').trim()
		else _song.plays = 0

		if data.match(/Sáng\stác\:.+<\/a><\/a>/g)
			_song.author = encoder.htmlDecode data.match(/Sáng\stác\:.+<\/a><\/a>/g)[0]
						.replace(/^.+\">|<.+$/g,'').trim()
		else _song.author = ''

		if data.match(/Thể\sloại\:.+\|\sLượt\snghe/g)
			_topics = data.match(/Thể\sloại\:.+\|\sLượt\snghe/g)[0]
								.replace(/Thể\sloại\:|\s\|\sLượt\snghe/g,'').split(',')
			arr = []
			arr.push _topic.replace(/\<a.+\"\>|\<\/a\>/g,'').trim() for _topic in _topics
			_song.topic = JSON.stringify arr
		else _song.topic = ''

		if data.match(/xmlURL.+/)

			_link = data.match(/xmlURL.+/)[0]
						.match(/http:\/\/mp3\.zing\.vn\/xml\/song-xml\/[a-zA-Z]+/)[0]

			_link = _link.replace(/song-xml/,'song')
						.replace(/mp3/,'m.mp3')
		data = ""
		do (_song) =>
			@_getFileByHTTP _link, (data)=>
				try
					data = JSON.parse data
					_song.song_name	= encoder.htmlDecode data.data[0].title.trim()
					_song.song_artist = JSON.stringify encoder.htmlDecode(data.data[0].performer.trim()).split(',')
					_song.song_link = data.data[0].source

					_str =  _song.song_link.replace(/^.+load-song\//g,'').replace(/^.+song-load\//g,'')
					testArr = []
					testArr.push @_decodeString _str.slice(i, i+4) for i in [0.._str.length-1] by 4
					path =  decodeURIComponent testArr.join('').match(/.+mp3/g)

					created = path.match(/^\d{4}\/\d{2}\/\d{2}/)?[0].replace(/\//g,"-")

					_song.path = path
					_song.created = created

					_tempSong = 
						sid : _song.sid

					# console.log _song
					@connection.query @query._insertIntoZISongs, _song, (err)=>
						if err then console.log "Cannot insert song: #{_song.songid} into table"
						else @_updateLyric _tempSong
		_song
	_updateSongs : (songid) ->
		link = "http://mp3.zing.vn/bai-hat/joke-link/#{@_convertToId songid}.html"
		@_getFileByHTTP link, (data)=>
			try 	
				@stats.totalItemCount +=1
				@stats.currentId = songid
				if data isnt null
					@_processSong songid, data
					data = ""
					@stats.passedItemCount +=1
					@log.lastSongId = songid
					@temp.totalFail = 0
					@_updateSongs(songid + 1)
					
				else 
					@stats.failedItemCount+=1
					@temp.totalFail += 1
					if @temp.totalFail < @temp.nStop
						@_updateSongs(songid + 1)

				@utils.printUpdateRunning songid, @stats, "Fetching....."

				if @temp.totalFail is @temp.nStop
					@utils.printFinalResult @stats
					@_writeLog @log
					@eventEmitter.emit "update-song-finish"
	updateSongs : =>
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Update Songs to table: #{@table.Songs}".magenta
		@temp = {}
		@temp.totalFail = 0
		@temp.nStop = 2000
		console.log "The program will stop after #{@temp.nStop} consecutive songs failed"
		@stats.currentTable = @table.Songs

		@_updateSongs @log.lastSongId+1

	update : ->
		@eventEmitter.on "fetch-new-songs-done", =>
			@resetStats()
			@updateSongs()
		@eventEmitter.on "update-song-finish", =>
			@resetStats()
			@updateAlbums()
		@eventEmitter.on "update-album-finish",=>
			@resetStats()
			@updateVideos()

		# update the songs which is not available when downloaded then
		@updateSongsWithRange 1,1

	# ---------------------------------------
	# Update songs and albums with RANGE
	fetchRows : (range0, range1, type, onSuccess)->
		# type 1 is song, 2 is album, 3 is video
		if type is 1
			typeId = "sid"
			table = @table.Songs
		else if type is 2
			typeId = "aid"
			table = @table.Albums
		else if type is 3
			typeId = "vid"
			table = @table.Videos
			
		nSteps = (range1 - range0 + 1)/1000 | 0 + 1
		resultArray = []

		console.log "nsteps is " + nSteps
		
		for i in [1..nSteps]
			do (i) =>
				if (range1 - range0) >= 1000
					firstId = range0 + 1000*(i-1)
					lastId = range0 + 1000*i
					if i is nSteps
						lastId = range1
				else 
					firstId = range0
					lastId = range1
				_q = "select #{typeId} from #{table} where #{typeId} < #{lastId} and #{typeId} >= #{firstId}"
				# console.log _q
				@connection.query _q, (err, results)->
					if err then console.log "cannot fetch the results"
					else 
						b = []
						for item in results
							b.push item[typeId]
						for value in [firstId..lastId]
							if b.indexOf(value) is -1 then resultArray.push value
						# console.log "lastid is #{lastId} and range1 is #{range1}"
						if lastId is range1
							onSuccess resultArray
	_updateSongsOrAlbumsWithRange : (range0, range1, type)->
		console.log "Running on: #{new Date(Date.now())}"
		if type is 1 
			console.log " |"+"Update Songs to table: #{@table.Songs}".magenta
			@stats.currentTable = @table.Songs
		else if type is 2
			console.log " |"+"Update Albums to table: #{@table.Albums}".magenta
			@stats.currentTable = @table.Albums

		@fetchRows range0, range1, type, (arr)=>
			console.log "The # of items is: #{arr.length}"
			@stats.totalItems = arr.length
			for id in arr
				do (id)=>
					# console.log id
					if type is 1 then link = "http://mp3.zing.vn/bai-hat/joke-link/#{@_convertToId id}.html"
					else if type is 2 then link = "http://mp3.zing.vn/album/joke-link/#{@_convertToId id}.html"
					# console.log link
					@_getFileByHTTP link, (data)=>
						try
							# console.log data
							@stats.totalItemCount +=1
							@stats.currentId = id
							if data isnt null
								if type is 1 then @_processSong id, data
								else if type is 2 then @_processAlbum id, data
								@stats.passedItemCount +=1
								data = ""
							else 
								@stats.failedItemCount+=1
							@utils.printRunning @stats
							if @stats.totalItems is @stats.totalItemCount
								@utils.printFinalResult @stats
								@eventEmitter.emit "fetch-new-songs-done"
	updateSongsWithRange : (range0, range1) =>
		@connect()
		# if both range0 and range1 equal 1. Then we trigger the special case. 
		# Fetching the max and min id in the last 100 pages 
		if range0 is 1 and range1 is 1
			console.log "Fetching items in last 100 pages. Each page contains 500 records"
			_q = "select max(sid) as max from #{@table.Songs}"
			max = ""
			@connection.query _q, (err, results)=>
				if err then console.log "cannt getting max item from table. ERROR: #{err}"
				else 
					for result in results
						max = result.max
						_q = "select sid as min from #{@table.Songs} order by sid DESC LIMIT 50000,1"
						@connection.query _q, (err, results)=>
							if err then console.log "cannt getting max item from table. ERROR: #{err}"
							else 
								for result in results
									min = result.min
									console.log "Fetching items in range: #{min} - #{max}"
									@_updateSongsOrAlbumsWithRange min, max, 1

		else @_updateSongsOrAlbumsWithRange range0, range1, 1
	updateAlbumsWithRange : (range0, range1) =>
		@connect()
		# if both range0 and range1 equal 1. Then we trigger the special case. 
		# Fetching the max and min id in the last 100 pages 
		if range0 is 1 and range1 is 1
			console.log "Fetching items in last 100 pages. Each page contains 500 records"
			_q = "select max(aid) as max from #{@table.Albums}"
			max = ""
			@connection.query _q, (err, results)=>
				if err then console.log "cannt getting max item from table. ERROR: #{err}"
				else 
					for result in results
						max = result.max
						_q = "select aid as min from #{@table.Albums} order by aid DESC LIMIT 50000,1"
						@connection.query _q, (err, results)=>
							if err then console.log "cannt getting max item from table. ERROR: #{err}"
							else 
								for result in results
									min = result.min
									console.log "Fetching items in range: #{min} - #{max}"
									@_updateSongsOrAlbumsWithRange min, max, 2
		else @_updateSongsOrAlbumsWithRange range0, range1, 2

	# fetching ffrom data base
	# ------------------------------------------
	showStats : ->
		@_printTableStats ZI_CONFIG.table


module.exports = Zing
