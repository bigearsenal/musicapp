Site = require "./Site"


class Nhacso extends Site
	constructor: ->
		super "ns"
		@logPath = "./log/NSLog.txt"
		@log = {}
		@_readLog()
		Array::splitBySeperator = (seperator) ->
			result = []
			for val in @
				_a = val.split(seperator)
				for item in _a
					result.push item.trim()
			return result

	_decodeId  : (id) ->
		# console.log id + "......"
		a = ['bw bg bQ bA aw ag aQ aA Zw Zg'.split(' '),
		 	 'fedcbaZYXW'.split(''),
		 	 'NJFBdZVRtp'.split(''),
		 	 'U0 Uk UU UE V0 Vk VU VE W0 Wk'.split(' '),
		 	 'RQTSVUXWZY'.split(''),
		 	 'hlptx159BF'.split(''),
		 	 ' X1 XF XV Wl W1 WF WV Vl V1'.split(' ')]
		(id+'').split('').map((v,i)-> a[6-i][v]).join('')
	getValueXML : (data,tag,position)->
		v = data.match(new RegExp("<#{tag}>.+<\/#{tag}>","g"))?[position]
		if v then return @processStringorArray v.replace(/\]\].+$/g,'').replace(/^.+CDATA\[/g,'')
		else ''

	processSongLink : (data,options)=>
		song = 
			id : parseInt options.id,10		
			title : ""	
			artists : null
			artistid : 0
			authors : null
			authorid : 0
			duration : 0
			plays : 0
			topics : null
			bitrate : 0
			official : 0
			islyric : 0
			link : ""
			lyric : ""
			date_created : null
			date_updated : null
			same_artist : 0

		song.title = @getValueXML data,"name",1

		# convert artists and authors to ARRAY will be processed later on processSong()
		song.artists = @getValueXML data, "artist", 0
		song.artistid = parseInt @getValueXML(data,"artistlink",0).replace(/\.html/g,'').replace(/^.+-/g,''),10
		if song.artistid.toString() is "NaN" then song.artistid = 0
		song.authors = @getValueXML data, "author", 0
		if song.authors isnt ''
			song.authorid = parseInt @getValueXML(data, "authorlink",0).replace(/\.html/g,'').replace(/^.+-/g,''),10

		duration = data.match(/totalTime.+totalTime/)?[0]
		if duration then song.duration = parseInt duration.replace(/^.+>|<.+$/g,''),10
		
		song.link = @getValueXML data, "mp3link", 0

		song.artists = song.artists.split().splitBySeperator('||').splitBySeperator(' / ').splitBySeperator(' - ')
		if song.authors is '' then song.authors = null
		else song.authors = song.authors.split().splitBySeperator('||').splitBySeperator(' / ').splitBySeperator(' - ')

		if song.title isnt '' and song.link isnt '/'
			ts = song.link.match(/\/[0-9]+_/g)[0].replace(/\//, "").replace(/_/, "")
			ts = parseInt(ts)*Math.pow(10,13-ts.length)
			song.date_created = @formatDate new Date(ts)
			song.date_updated = @formatDate new Date()
			@updateSongLink(song.id + 1)
			@_updateSong song
		else 
			_options =
				id : song.id
			@onSongFail "The XML of song is empty", _options
		song
	updateSongLink : (id)->
		# id = 1283657
		
		link = "http://nhacso.net/flash/song/xnl/1/id/" + @_decodeId(id)
		options = 
				id : id
		@getFileByHTTP link, @processSongLink, @onSongFail, options
	processSong : (data,options)=>

		song = options.song
		if data.match(/official/) then song.official = 1
		bitrate = data.match(/\d+kb\/s/g)?[0]

		if bitrate then song.bitrate = parseInt bitrate.replace(/kb\/s/g,''),10

		plays = data.match(/total_listen_song_detail_\d+.+/g)?[0]
		if plays then song.plays = parseInt plays.replace(/<\/span>.+$/g,'').replace(/^.+>/g,'').replace(/\./g,''),10

		topics = data.match(/<li><a\shref\=\"http\:\/\/nhacso\.net\/the-loai.+/g)?[0]
		if topics  
			song.topics = @processStringorArray topics.replace(/^.+\">|<\/a><\/li>/g,'')
			if song.topics.match(/Nhạc Hoa/i)? and song.artists.match(" / ")?
				song.same_artist = 1

		lyric = data.match(/txtlyric.+[^]+.+Bạn chưa nhập nội bài hát/g)?[0]
		if lyric 
			song.islyric = 1
			song.lyric = lyric.replace(/<\/textarea>+[^]+.+$/g,'').replace(/^.+>/g,'')
			if song.lyric.match(/Hãy đóng góp lời bài hát chính xác cho Nhacso nhé/g)
				song.lyric = ""
				song.islyric = 0

		song.topics = song.topics.split().splitBySeperator(' - ').splitBySeperator('/')
		

		@eventEmitter.emit "result-song", song
		
		song
	onSongFail : (error, options)=>
		# console.log "Song #{options.id} has an error: #{error}"
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		@temp.totalFail += 1
		@utils.printUpdateRunning options.id, @stats, "Fetching..."
		if @temp.totalFail < @temp.nStop
			@updateSongLink options.id + 1
		else
			if @stats.totalItemCount is @temp.nStop 
				console.log ""
				console.log " |Songs are up-to-date"
			else 
				@utils.printFinalResult @stats
				@_writeLog @log
			@eventEmitter.emit "update-song-finish"
	# This special method will be triggered when XML file exists but the official page doesnt
	# On this case, the song will be considered as it is legitimate one and will be inserted into db
	onSpecialCase : (err, options)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@utils.printUpdateRunning options.song.id, @stats, "Fetching..."
			song = options.song
			if song.topics
				song.topics = song.topics.split().splitBySeperator(' - ').splitBySeperator('/')
			if song.artists is "" then song.artists = null
			else 
				if song.artists
					song.artists = song.artists.split().splitBySeperator('||').splitBySeperator(' / ').splitBySeperator(' - ')
			if song.authors is '' then song.authors = null
			else 
				if song.authors
					song.authors = song.authors.split().splitBySeperator('||').splitBySeperator(' / ').splitBySeperator(' - ')
			@log.lastSongId = options.song.id
			@connection.query @query._insertIntoSongs, song, (err)->
				if err then console.log "Cannot insert song: #{song.id} into database. ERROR: #{err}"
	_updateSong : (song)=>
		id = song.id
		link = "http://nhacso.net/nghe-nhac/link-joke.#{@_decodeId(id)}==.html"
		options = 
			id : id
			song : song	
		@getFileByHTTP link, @processSong, @onSpecialCase, options
	updateSongs : ->
		@connect()
		@showStartupMessage "Updating songs to table ", @table.Songs
		console.log " |The last song is " +  @log.lastSongId
		@stats.currentTable = @table.Songs
		@temp = 
			totalFail : 0
			nStop : 100
		console.log " |The program will stop after #{@temp.nStop} consecutive songs failed"
		@eventEmitter.on "result-song", (song)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@log.lastSongId = song.id
			@temp.totalFail = 0

			# console.log song
			# process.exit 0

			@connection.query @query._insertIntoSongs, song, (err)->
				if err then console.log "Cannt insert song: #{song.id} into database. ERROR: #{err}"
			@utils.printUpdateRunning song.id, @stats, "Fetching..."
			
		@updateSongLink @log.lastSongId+1
		# @updateSongLink 1283890

	# ALBUM PART
	getAlbumTotalPlays : (album)->
		link = "http://nhacso.net/statistic/albumtotallisten?listIds=#{album.id}"
		options = 
			album : album
		onSucess = (data,options)=>
			data = JSON.parse(data)
			options.album.plays = parseInt(data.result[options.album.id].totalListen,10)
			@eventEmitter.emit "result-album",options.album
		onFail = (err, options)->
			console.log "Cannt description and issued time of the album: #{options.album.id}. ERROR: #{err}"
		@getFileByHTTP link, onSucess, onFail, options
	getAlbumDescAndIssuedTime : (album)->
		link = "http://nhacso.net/album/getdescandissuetime?listIds=#{album.id}"
		options = 
			album : album
		onSucess = (data,options)=>
			data = JSON.parse(data).result[0]
			options.album.date_released = data.IssueTime
			options.album.description = @processStringorArray data.AlbumDesc
			if options.album.description.match(/thưởng thức nhạc chất lượng cao và chia sẻ cảm xúc với bạn bè tại Nhacso.net/)
				options.album.description = ""
			@getAlbumTotalPlays options.album
		onFail = (err, options)->
			console.log "Cannt description and issued time of the album: #{options.album.id}. ERROR: #{err}"
		@getFileByHTTP link, onSucess, onFail, options
	getTotalSongsInAlbum : (album)->
		link = "http://nhacso.net/album/gettotalsong?listIds=#{album.id}"
		options = 
			album : album
		onSucess = (data,options)=>
			data = JSON.parse data
			strId = "nsn:album:total:song:id:#{options.album.id}"
			options.album.nsongs = parseInt data.result[strId].TotalSong,10
			@getAlbumDescAndIssuedTime options.album
		onFail = (err, options)->
			console.log "Cannt get total songs of the album: #{options.album.id}. ERROR: #{err}"
		@getFileByHTTP link, onSucess, onFail, options
	processAlbum : (data, options)=>
		album = 
			id : options.id
			title : ""
			artists : null
			artistid : 0
			topics : null
			genres : null
			description : ""
			date_released : ""
			nsongs : 0
			plays : 0
			coverart : ""
			songids : []
					
		temp = data.match(/class=\"intro_album_detail.+[^]+.+id=\"divPlayer/g)?[0]
		if temp
			title = temp.match(/strong.+strong/)?[0]
			if title then album.title = @processStringorArray title.replace(/^.+>|<.+$/g,'')
			artists = temp.match(/strong.+/g,'')?[0]
			if artists
				album.artists = @processStringorArray artists.replace(/^.+>/g,'')
				artistid = artists.match(/\d+\.html/g)
				if artistid then album.artistid = parseInt artistid[0].replace(/\.html/g,''),10
			# description = temp.match(/class=\"desc.+[^]+.+xemthem/g)?[0]
			# if description then album.description = @processStringorArray description.replace(/<\/p>[^]+.+/g,'').replace(/^.+\">/g,'')
			coverart = temp.match(/<img width.+align/g)?[0]
			if coverart then album.coverart = coverart.replace(/^.+src=\"|\".+$/g,'')

		topics = data.match(/\<li\sclass\=\"bg\".+\<\/li\>/)?[0]
		if topics then  album.topics = @processStringorArray topics.replace(/\<li\sclass\=\"bg\"\>\<a\shref\s\=\"http\:\/\/nhacso\.net\/.+\"\>/,'')
										.replace(/\<\/a\>\<\/li\>/,'')

		# convert fields to ARRAY
		album.topics = album.topics.split().splitBySeperator(' - ').splitBySeperator('/')
		album.artists = album.artists.split().splitBySeperator('||').splitBySeperator(' / ').splitBySeperator(' - ')

		songids = data.match(/songid_\d+/g)
		if songids 
			songids.map (v)-> album.songids.push parseInt(v.replace(/songid_/g,''),10)
			@_updateAlbum options.id + 1
			@getTotalSongsInAlbum album
		else
			@onAlbumFail "The album: #{album.id} has no song", {id : album.id}
		album
	onAlbumFail : (error, options)=>
		# console.log "Album #{options.id} has an error: #{error}"
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		@temp.totalFail += 1
		@utils.printUpdateRunning options.id, @stats, "Fetching..."
		if @temp.totalFail < @temp.nStop
			@_updateAlbum options.id + 1
		else
			if @stats.totalItemCount is @temp.nStop
				console.log ""
				console.log " |Albums are up-to-date"
			else 
				@utils.printFinalResult @stats
				@_writeLog @log
			@eventEmitter.emit "update-album-finish"
	_updateAlbum : (id)=>
		link = "http://nhacso.net/nghe-album/ab.#{@_decodeId(id)}.html"
		options = 
			id : id
		@getFileByHTTP link, @processAlbum, @onAlbumFail, options
	updateAlbums : ->

		@connect()
		@showStartupMessage "Updating album to table ", @table.Albums
		@temp = 
			totalFail : 0
			nStop : 3000
		@stats.currentTable = @table.Albums

		console.log " |The last album is " +  @log.lastAlbumId
		console.log " |The program will stop after #{@temp.nStop} consecutive albums failed"

		@eventEmitter.on "result-album", (album)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@log.lastAlbumId = album.id
			@temp.totalFail = 0

			# console.log album
			# process.exit 0

			@connection.query @query._insertIntoAlbums, album, (err)=>
				if err then console.log "Cannt insert album: #{album.id} into database. ERROR: #{err}"
			@utils.printUpdateRunning album.id, @stats, "Fetching..."
			
		@_updateAlbum @log.lastAlbumId+1


	# VIDEO PART
	getVideoDurationAndSublink : (video)->
		link = "http://nhacso.net/flash/video/xnl/1/id/" + @_decodeId(video.id)
		options = 
			video : video
		onSucess = (data,options)=>
			options.video.duration = parseInt(@getValueXML(data, "duration", 0).replace(/<\/duration>|<duration>/g,''),10)
			options.video.sublink = @getValueXML data, "subUrl", 0
			@eventEmitter.emit "result-video",options.video
		onFail = (err, options)->
			console.log "Cannt get  duration and sublink of the video: #{options.video.id}. ERROR: #{err}"
		@getFileByHTTP link, onSucess, onFail, options
	processVideo : (data, options)=>
		@_updateVideo options.id + 1
		video = 
			id : options.id
			title : ""
			artists : ""
			topics : ""
			plays : 0
			duration : 0
			official : 0
			producerid : 0
			link : ""
			sublink : ""
			thumbnail : ""
			date_created : null

		temp = data.match(/<p class=\"title_video.+[^]+.+Đăng bởi/g)?[0]

		if temp
			title = temp.match(/title\">(.+)<\/h1>/)?[1]
			if title then video.title = @processStringorArray title

			official = temp.match(/official/)?[0]
			if official then video.official = 1

			artists = temp.match(/<h2>.+<\/h2>/g)
			if artists then video.artists = artists.map((v) => @processStringorArray  v.replace(/<h2>|<\/h2>/g,'')).unique()

		video.topics = @processStringorArray data.match(/<li><a href=\"http:\/\/nhacso.net\/the-loai-video.+html\">(.+)<\/a>.+/)?[1]
		video.topics = video.topics.split().splitBySeperator(' - ').splitBySeperator('/')

		plays = data.match(/<span>(.+)<\/span><ins>&nbsp;lượt xem<\/ins>/)?[1]
		video.plays = parseInt(plays.replace(/\./g,''),10)

		thumb_link  = data.match(/poster=\"(.+)\" src=\"(.+)\" data/)

		if thumb_link
			video.thumbnail = thumb_link[1]
			video.link = thumb_link[2]
			if video.link
				ts = video.link.match(/\/([0-9]+)_/)?[1]
				ts = parseInt(ts)*Math.pow(10,13-ts.length)
				video.date_created = @formatDate new Date(ts)

		producerid = data.match(/getProducerByListIds.+\'(\d+)\'.+/)?[1]
		if producerid then video.producerid = parseInt(producerid,10)

		# console.log video
		@getVideoDurationAndSublink video

		video
	onVideoFail : (error, options)=>
		# console.log "Video #{options.id} has an error: #{error}"
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		@temp.totalFail += 1
		@utils.printUpdateRunning options.id, @stats, "Fetching..."
		if @temp.totalFail < @temp.nStop
			@_updateVideo options.id + 1
		else
			if @stats.totalItemCount is @temp.nStop
				console.log ""
				console.log " |Videos are up-to-date"
			else 
				@utils.printFinalResult @stats
				@_writeLog @log
			@eventEmitter.emit "update-video-finish"
	_updateVideo: (id)=>
		link = "http://nhacso.net/xem-video/joke-link.#{@_decodeId(id)}=.html"
		options = 
			id : id
		@getFileByHTTP link, @processVideo, @onVideoFail, options
	updateVideos : ->

		@connect()
		@showStartupMessage "Updating video to table ", @table.Videos
		@temp = 
			totalFail : 0
			nStop : 100
		@stats.currentTable = @table.Videos

		console.log " |The last video is " +  @log.lastVideoId
		console.log " |The program will stop after #{@temp.nStop} consecutive videos failed"

		@eventEmitter.on "result-video", (video)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@log.lastVideoId = video.id
			@temp.totalFail = 0		

			# console.log video
			# process.exit 0	

			@connection.query @query._insertIntoVideos, video, (err)=>
				if err then console.log "Cannt insert video: #{video.id} into database. ERROR: #{err}"
			@utils.printUpdateRunning video.id, @stats, "Fetching..."
			
		@_updateVideo @log.lastVideoId+1
	 
	# UDPATE SONGS, ALBUMS & VIDEOS
	update : ->
		@eventEmitter.on "update-song-finish", =>
			@resetStats()
			@updateAlbums()
		@eventEmitter.on "update-album-finish", =>
			@resetStats()
			@updateVideos()
		@eventEmitter.on "update-video-finish", =>
			@resetStats()
			@updateSongsCategory()
		@eventEmitter.on "update-songs-category-done", =>
			@resetStats()
			@updateAlbumsCategory()
		@eventEmitter.on "update-albums-category-done", =>
			@updateGenreAndLabel()
		@updateSongs()

	# NEW part on August 7, 2013
	updateGenreAndLabel : ->
		@connect()
		dt = new Date()
		today = dt.getFullYear() + "-" + (dt.getMonth()+1) + "-" + dt.getDate()
		_query = "update nsalbums set genres = plc_ns_get_genre(description), label= plc_ns_get_label(description) where checktime > '#{today}'"
		@connection.query  _query, (err)->
			if err then console.log err
			else 
				console.log " ---------------------------- "
				console.log " |Update genres and labels of new albums added today COMPLETED!!!"
	# THIS UPDATE IS FOR CATEGORY ONLY
	# The format is ["Nhạc Việt Nam","Nhạc Trẻ","Pop","Ballad"]
	updateSongsCategory : ->
		Array::unique = ()->
			@.filter (element, index, array)->
				array.indexOf(element) is index
		@connect()
		@type = [null,"Nhạc Trẻ","Nhạc Trữ Tình","Nhạc Cách Mạng","Nhạc Trịnh ","Nhạc Tiền Chiến","Nhạc Dân Tộc","Nhạc Thiếu Nhi","Nhạc Không Lời","Rock Việt","Nhạc Hải Ngoại","Nhạc Quê Hương","Nhạc Việt Nam","Nhạc Quốc Tế","Rap Việt - Hiphop","Nhạc Hoa","Nhạc Hàn","Nhạc Pháp","Nhạc Các Nước Khác","Classical","Nhạc Phim","Nhạc Âu Mỹ","Pop","Rock","Hiphop/Rap","Country","Jazz","Hiphop","Latin",null,"Thể Loại","Dance/Electronic","Nhạc Nhật","Chưa phân loại",null,"Style","Acoustic/Audiophile","Soul","Reggae","Metal","New Age","R&B","Folk","Opera","TV Shows","VMVC 2011","Cặp Đôi Hoàn Hảo","Bài Hát Yêu Thích","Vietnam\'s Got Talent","Nhạc Chủ Đề","Nhạc 8/3","Nhạc chủ đề","Nhạc 8/3","Mừng QT phụ nữ 8/3","Nhạc Sàn","Nhạc Bà Bầu & Baby","Nhạc Spa | Thư Giãn","Nhạc Đám Cưới Hay","Sách Nói","Radio - Cảm Xúc","The Voice - Giọng Hát Việt","Vietnam Idol 2012","Nhạc Tuyển Tập","Shining Show","Gương Mặt Thân Quen","Ngâm Thơ","Fanmade / Radio"]
		@genres = [{"id":99,"name":"Nhạc Xuân","page":129},{"id":73,"name":"Nhạc Không Lời","page":2900},{"id":79,"name":"Pop/Ballad","page":12056},{"id":76,"name":"New Age","page":1326},{"id":90,"name":"House","page":187},{"id":62,"name":"R&B","page":1850},{"id":26,"name":"Rock","page":7595},{"id":64,"name":"Alternative","page":556},{"id":63,"name":"Hiphop/Rap","page":2513},{"id":65,"name":"Country","page":3053},{"id":74,"name":"Folk","page":762},{"id":68,"name":"Dance/Electronic","page":674},{"id":66,"name":"Latin","page":452},{"id":69,"name":"Jazz","page":2864},{"id":70,"name":"Acoustic/Audiophile","page":211},{"id":72,"name":"Soundtrack","page":1220},{"id":77,"name":"Classical","page":493},{"id":75,"name":"Blues","page":611},{"id":108,"name":"Nhạc Giáng Sinh","page":176},{"id":27,"name":"Metal","page":822},{"id":71,"name":"Soul","page":652}]
		
		# Set all pages in genres the value 10
		console.log "Fetching category for Songs".green
		console.log "The defaul page for each genre is set to 10"
		for index in [0..@genres.length-1]
			@genres[index].page = 10

		for g in @genres
			@stats.totalItems += g.page
		console.log "Total page: #{@stats.totalItems}"	
		@stats.currentTable = @table.Songs


		# THIS PART IS FOR RESULT EVENT
		@eventEmitter.on "result-type-done", (songs)=>
			# console.log songs
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@utils.printRunning @stats

			for song in songs
				do (song)=>
					# _u = "update #{@table.Songs} SET category = #{@connection.escape(JSON.stringify(song.cats))} where id=#{song.id}"
					# console.log _u
					# # 
					_u = "update #{@table.Songs} SET category = ARRAY[#{song.cats.map((v)=>if v.trim then @connection.escape(v.trim()) else @escape(v) ).join(',')}] where id=#{song.id}"
					# console.log _u
					# process.exit 0
					@connection.query _u, (err)->
						if err then console.log "Song:#{song.id} has an error: #{err}"

			if @stats.totalItems is @stats.totalItemCount
				@utils.printFinalResult @stats
				@eventEmitter.emit "update-songs-category-done"

		for genre in @genres
			for page in [1..genre.page]
				@_fetchType genre, page
	updateAlbumsCategory : ->
		Array::unique = ()->
			@.filter (element, index, array)->
				array.indexOf(element) is index
		@connect()
		@type = [null,"Nhạc Trẻ","Nhạc Trữ Tình","Nhạc Cách Mạng","Nhạc Trịnh ","Nhạc Tiền Chiến","Nhạc Dân Tộc","Nhạc Thiếu Nhi","Nhạc Không Lời","Rock Việt","Nhạc Hải Ngoại","Nhạc Quê Hương","Nhạc Việt Nam","Nhạc Quốc Tế","Rap Việt - Hiphop","Nhạc Hoa","Nhạc Hàn","Nhạc Pháp","Nhạc Các Nước Khác","Classical","Nhạc Phim","Nhạc Âu Mỹ","Pop","Rock","Hiphop/Rap","Country","Jazz","Hiphop","Latin",null,"Thể Loại","Dance/Electronic","Nhạc Nhật","Chưa phân loại",null,"Style","Acoustic/Audiophile","Soul","Reggae","Metal","New Age","R&B","Folk","Opera","TV Shows","VMVC 2011","Cặp Đôi Hoàn Hảo","Bài Hát Yêu Thích","Vietnam\'s Got Talent","Nhạc Chủ Đề","Nhạc 8/3","Nhạc chủ đề","Nhạc 8/3","Mừng QT phụ nữ 8/3","Nhạc Sàn","Nhạc Bà Bầu & Baby","Nhạc Spa | Thư Giãn","Nhạc Đám Cưới Hay","Sách Nói","Radio - Cảm Xúc","The Voice - Giọng Hát Việt","Vietnam Idol 2012","Nhạc Tuyển Tập","Shining Show","Gương Mặt Thân Quen","Ngâm Thơ","Fanmade / Radio"]

		@genres = [{"id":99,"name":"Nhạc Xuân","page":32},{"id":73,"name":"Nhạc Không Lời","page":517},{"id":79,"name":"Pop/Ballad","page":2831},{"id":76,"name":"New Age","page":281},{"id":90,"name":"House","page":31},{"id":62,"name":"R&B","page":428},{"id":26,"name":"Rock","page":1667},{"id":64,"name":"Alternative","page":95},{"id":63,"name":"Hiphop/Rap","page":442},{"id":65,"name":"Country","page":531},{"id":74,"name":"Folk","page":148},{"id":68,"name":"Dance/Electronic","page":142},{"id":66,"name":"Latin","page":80},{"id":69,"name":"Jazz","page":496},{"id":70,"name":"Acoustic/Audiophile","page":41},{"id":72,"name":"Soundtrack","page":223},{"id":77,"name":"Classical","page":67},{"id":75,"name":"Blues","page":105},{"id":108,"name":"Nhạc Giáng Sinh","page":53},{"id":27,"name":"Metal","page":184},{"id":71,"name":"Soul","page":128}]

		console.log "Fetching category for albums".green
		console.log "The defaul page for each genre is set to 10"
		for index in [0..@genres.length-1]
			@genres[index].page = 10

		for g in @genres
			@stats.totalItems += g.page
		console.log "Total page: #{@stats.totalItems}"	
		@stats.currentTable = @table.Albums

		# THIS PART IS FOR RESULT EVENT
		@eventEmitter.on "result-type-album-done", (albums)=>
			# console.log albums
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@utils.printRunning @stats
			# console.log albums
			for album in albums
				do (album)=>
					# _u = "update #{@table.Albums} SET category = #{@connection.escape(JSON.stringify(album.cats))} where id=#{album.id}"
					# console.log _u
					# 
					_u = "update #{@table.Albums} SET category = ARRAY[#{album.cats.map((v)=>if v.trim then @connection.escape(v.trim()) else @escape(v) ).join(',')}] where id=#{album.id}"
					# console.log _u
					# process.exit 0
					@connection.query _u, (err)->
						if err then console.log "Album:#{album.id} has an error: #{err}"
			if @stats.totalItems is @stats.totalItemCount
				@utils.printFinalResult @stats
				@eventEmitter.emit "update-albums-category-done"
		for genre in @genres
			for page in [1..genre.page]
				@_fetchTypeAlbum genre, page
	# for songs
	processFetchSongType : (data,options)=>
		# console.log options.genre
		# console.log "page is" + options.page
		songs = []
		try 
			temp = data.match(/getCategory.+\'(\{.+\})\'/)?[1]
			temp = JSON.parse temp

			mapping = []
			for prop, values of temp
				for value in values
					mapping[value] = parseInt(prop,10)


			topicsOfSongs = data.match(/Thể loại :.+/g)
			topicsOfSongs = topicsOfSongs.map (v)->
				if v.match(/cate_tag_song_\d+/g)
					v.match(/cate_tag_song_\d+/g).map (v1) -> parseInt(v1.replace(/cate_tag_song_/,''),10)
				else 
					# console.log "Genreid : #{options.genre.id}, name: #{options.genre.name}, page:#{options.page} has problems"
					null

			songids = data.match(/play\(\'blocksongtag_\d+/g)
			songids = songids.map (v)-> parseInt(v.replace(/play\(\'blocksongtag_/,''),10)

			# console.log temp
			# console.log JSON.stringify topicsOfSongs
			# console.log JSON.stringify songids

			# remove null value in topicsOfSongs
			topicsOfSongs = topicsOfSongs.filter (v) -> if v is null then false else true
			

			songs = []

			if songids.length is topicsOfSongs.length
				for songid, index in songids
					t = 
						id : songid
					t.cats = topicsOfSongs[index].map((v)=> mapping[v]).map (v)=> @type[v]
					t.cats.push options.genre.name
					t.cats = @filterType(t.cats.unique()).unique()
					songs.push t
			else console.log "songids and topicsOfSongs: type mismatched"

			@eventEmitter.emit "result-type-done", songs
			# console.log songs
			return songs
		catch e
			console.log ""
			console.log "Genreid : #{options.genre.id}, name: #{options.genre.name}, page:#{options.page} has problems"
			console.log "ERROR: #{e}".red
	onFetchTypeFail : (err,options) =>
		console.log ""
		console.log "Genreid : #{options.genre.id}, name: #{options.genre.name}, page:#{options.page} has failed"
		console.log "ERROR: #{err}".red
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		@utils.printRunning @stats
	_fetchType : (genre, page) ->
		link = "http://nhacso.net/bai-hat-theo-the-loai-#{genre.id}/joke-link-2-#{page}.html"
		# console.log link
		options = 
			genre : genre
			page : page
		@getFileByHTTP link, @processFetchSongType, @onFetchTypeFail, options				
	# for albums
	processFetchAlbumType : (data,options)=>
		# console.log options.genre
		# console.log "page is" + options.page
		try 

			albumList = data.match(/getTotalSongInAlbum\(\'(.+)\',.+album_new_totalsong_/)?[1]

			if albumList 
				albumList = albumList.split(',').map (v)-> parseInt(v,10)
				albums = []
				albumList.forEach (v)-> albums.push({"id": v})
				_q = "select id as id, topics as cats from #{@table.Albums} where "
				albumList.forEach (v,i,arr)-> 
					if i isnt arr.length-1
						_q += "id=#{v} or "
					else _q += "id=#{v}"
				@connection.query _q, (err, results)=>
					if err then console.log "EROOOOOOOOOOOOOOOOOR at QUERY: #{_q}".red
					else 
						albums = []
						for album in results
							if album.cats is null
									albums.push {id : album.id, cats : []}
							else albums.push {id : album.id, cats : album.cats}
						
						for album in albums
							album.cats.push options.genre.name
							album.cats = @filterType(album.cats.unique()).unique()

						@eventEmitter.emit "result-type-album-done", albums

		catch e
			console.log ""
			console.log "Genreid : #{options.genre.id}, name: #{options.genre.name}, page:#{options.page} has problems"
			console.log "ERROR: #{e}".red
	_fetchTypeAlbum : (genre, page) ->
		link = "http://nhacso.net/album-theo-the-loai-#{genre.id}/joke-link-2-#{page}.html"
		# console.log link
		options = 
			genre : genre
			page : page
		@getFileByHTTP link, @processFetchAlbumType, @onFetchTypeFail, options		
	# filter function
	filterType : (arr)->
		a = []
		vnSongs = ["Nhạc Trẻ","Nhạc Trữ Tình","Nhạc Cách Mạng","Nhạc Trịnh","Nhạc Tiền Chiến","Nhạc Dân Tộc","Nhạc Thiếu Nhi","Rock Việt","Nhạc Hải Ngoại","Nhạc Quê Hương","Rap Việt - Hiphop"]
		for item in arr
			if vnSongs.indexOf(item) > -1
				a.push "Nhạc Việt Nam"

			if item is "Pop/Ballad"
				a.push "Pop"
				a.push "Ballad"
			else if item is "Dance/Electronic"
				a.push "Dance"
				a.push "Electronic"
			else if item is "Nhạc Spa | Thư Giãn"
				a.push "Nhạc Spa"
				a.push "Thư Giãn"
			else if item is "Hiphop/Rap"
				a.push "Hiphop"
				a.push "Rap"
			else if item is "Nhạc Bà Bầu & Baby"
				a.push "Nhạc Bà Bầu"
				a.push "Nhạc Baby"
			else if item is "Rap Việt - Hiphop"
				a.push "Rap Việt"
				a.push "Hiphop"
			else if item is "Radio - Cảm Xúc"
				a.push "Radio"
				a.push "Cảm Xúc"
			else a.push item

		return a
	# this functions to find the maximum page in each genre. Only used once
	fetchMaxTypeSong : () -> 
		@genres = [{"id":99,"name":"Nhạc Xuân"},{"id":73,"name":"Nhạc Không Lời"},{"id":79,"name":"Pop/Ballad"},{"id":76,"name":"New Age"},{"id":90,"name":"House"},{"id":62,"name":"R&B"},{"id":26,"name":"Rock"},{"id":64,"name":"Alternative"},{"id":63,"name":"Hiphop/Rap"},{"id":65,"name":"Country"},{"id":74,"name":"Folk"},{"id":68,"name":"Dance/Electronic"},{"id":66,"name":"Latin"},{"id":69,"name":"Jazz"},{"id":70,"name":"Acoustic/Audiophile"},{"id":72,"name":"Soundtrack"},{"id":77,"name":"Classical"},{"id":75,"name":"Blues"},{"id":108,"name":"Nhạc Giáng Sinh"},{"id":27,"name":"Metal"},{"id":71,"name":"Soul"}]
		@count = 0
		@type = "song"
		for genre in @genres
			@getMax genre, 1, 1000
	fetchMaxTypeAlbum : () -> 
		@genres = [{"id":99,"name":"Nhạc Xuân"},{"id":73,"name":"Nhạc Không Lời"},{"id":79,"name":"Pop/Ballad"},{"id":76,"name":"New Age"},{"id":90,"name":"House"},{"id":62,"name":"R&B"},{"id":26,"name":"Rock"},{"id":64,"name":"Alternative"},{"id":63,"name":"Hiphop/Rap"},{"id":65,"name":"Country"},{"id":74,"name":"Folk"},{"id":68,"name":"Dance/Electronic"},{"id":66,"name":"Latin"},{"id":69,"name":"Jazz"},{"id":70,"name":"Acoustic/Audiophile"},{"id":72,"name":"Soundtrack"},{"id":77,"name":"Classical"},{"id":75,"name":"Blues"},{"id":108,"name":"Nhạc Giáng Sinh"},{"id":27,"name":"Metal"},{"id":71,"name":"Soul"}]
		@count = 0
		@type = "album"
		for genre in @genres
			@getMax genre, 1, 1000
	getMax : (genre, page, inc) ->
		if @type is "song"
			link = "http://nhacso.net/bai-hat-theo-the-loai-#{genre.id}/joke-link-2-#{page}.html"
		else if @type is "album"
			link = "http://nhacso.net/album-theo-the-loai-#{genre.id}/joke-link-2-#{page}.html"
		options = 
			genre : genre
			page : page
			inc : inc
		onSucess = (data,options)=>
			# console.log "Genreid : #{options.genre.id} , name : #{options.genre.name} has page #{options.page} with inc:#{options.inc}"
			@utils.printMessage("Running #{new Date()}")
			if options.inc is 0
				@count += 1
				console.log "DONE: #{@count}---------------------------------------------------------------------------"
				for genre, index in @genres
					if genre.id is options.genre.id
						@genres[index].page = options.page
				console.log JSON.stringify @genres
			else 
				@getMax(options.genre,options.page+options.inc,inc)
		onFail = (data,options)=>
			page = options.page - options.inc
			inc = options.inc/2 | 0
			page = page + inc
			# console.log "increment now is #{options.inc}"
			# console.log options
			# console.log "The page:#{options.page} has failed, inc: -#{inc}. Calling page:#{page}"
			@utils.printMessage("Running #{new Date()}")
			@getMax(options.genre,page, inc)


		@getFileByHTTP link, onSucess, onFail, options		


	# NEW PART : Update songs with range
	updateSongWithRange : (range0, range1)=>
		@connect()
		range0 = parseInt range0,10
		range1 = parseInt range1,10
		@showStartupMessage "Updating songs to table ", @table.Songs
		console.log " |The last song is " +  @log.lastSongId
		@stats.currentTable = @table.Songs
		@stats.totalItems = range1 - range0 + 1
		console.log " |The program will update from #{range0} to #{range1}"
		@onSongFail = (error, options)=>
			@stats.totalItemCount +=1
			@stats.failedItemCount +=1
			@utils.printRunning  @stats
			if @stats.totalItemCount is @stats.totalItems 
				@utils.printFinalResult @stats
				@eventEmitter.emit "update-song-finish"
		@onSpecialCase = (err, options)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@utils.printRunning @stats
			@connection.query @query._insertIntoSongs, options.song, (err)->
				if err then console.log "Cannot insert song: #{options.song.id} into database. ERROR: #{err}"
		@updateSongLinkv2 = (id)=>
			link = "http://nhacso.net/flash/song/xnl/1/id/" + @_decodeId(id)
			@utils.printRunning  @stats
			options = 
					id : id
			@getFileByHTTP link, @processSongLink, @onSongFail, options
		@updateSongLink = (id)->
			# none
		@eventEmitter.on "result-song", (song)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@log.lastSongId = song.id
			@connection.query @query._insertIntoSongs, song, (err)->
				if err then console.log "Cannt insert song: #{song.id} into database. ERROR: #{err}"
			@utils.printRunning  @stats
			if @stats.totalItemCount is @stats.totalItems 
				@utils.printFinalResult @stats
				@eventEmitter.emit "update-song-finish"
		
		for id in [range0..range1]
			@updateSongLinkv2 id

	showStats : ->
		@_printTableStats NS_CONFIG.table


module.exports = Nhacso
