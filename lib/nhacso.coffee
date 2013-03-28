http = require 'http'
xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require 'colors'

Encoder = require('node-html-encoder').Encoder
encoder = new Encoder('entity');

NS_CONFIG = 
	table : 
		NSSongs : "NSSongs"
		NSAlbums : "NSAlbums"
		NSSongs_Albums : "NSSongs_Albums"
		NSVideos : "NSVideos"
	logPath : "./log/NSLog.txt"

class Nhacso extends Module
	constructor : (@mysqlConfig, @config = NS_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoNSSongs : "INSERT INTO " + @table.NSSongs + " SET ?"
			_insertIntoNSAlbums : "INSERT INTO " + @table.NSAlbums + " SET ?"
			_insertIntoNSSongs_Albums : "INSERT INTO " + @table.NSSongs_Albums + " SET ?"
			_insertIntoNSVideo : "INSERT INTO " + @table.NSVideos + " SET ?"
		@utils = new Utils()
		@parser = new xml2js.Parser();
		super @mysqlConfig
		@logPath = @config.logPath
		@log = {}
		@_readLog()
	
	_decodeId : (songId) ->
		arr = Array::slice.call songId.toString()
		arr = arr.map((value) -> parseInt(value) )
		a = []
		songid = ""
		a[1] = ['bw','bg','bQ','bA','aw','ag','aQ','aA','Zw','Zg']
		a[2] = ['f','e','d','c','b','a','Z','Y','X','W']
		a[3] = ['N','J','F','B','d','Z','V','R','t','p']
		a[4] = ['U0','Uk','UU','UE','V0','Vk','VU','VE','W0','Wk']
		a[5] = ['R','Q','T','S','V','U','X','W','Z','Y']
		a[6] = ['h','l','p','t','x','1','5','9','B','F']
		a[7] = ['','X1','XF','XV','Wl','W1','WF','WV','Vl','V1']		
		for i in [1..arr.length]
			songid += a[7-i+1][arr[i-1]]
		songid

	_storeSong : (song) ->
		_item = 
			songid : parseInt song.id[0]
			totaltime : parseInt song.totalTime[0]
			name : song.name[0].trim()
			mp3link : song.mp3link[0]
		# convert timestamp from link to to  created datetime
		ts = _item.mp3link.match(/\/[0-9]+_/g)[0].replace(/\//, "").replace(/_/, "")
		ts = parseInt(ts)*Math.pow(10,13-ts.length)
		date = new Date(ts)
		_formatedDate = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds()
		_item.created = _formatedDate

		if typeof song.artist[0] isnt "object"
			_item.artist = song.artist[0].trim()
			_item.artistid = parseInt song.artistlink[0].match(/-\d+\.html/)[0].replace("-","").replace(".html","")
		else
			_item.artist = 0
			_item.artistid = 0

		if typeof song.author[0] isnt "object"
			_item.author = song.author[0].trim()
			_item.authorid = parseInt song.authorlink[0].match(/-\d+\.html/)[0].replace("-","").replace(".html","")
		else
			_item.author = 0
			_item.authorid = 0

		@connection.query @query._insertIntoNSSongs, _item, (err) =>
			if err then console.log "Cannot insert the song into table. ERROR: " + err
			else 
				@_updateSongStats _item.songid
				@_updateSongBitrate _item.songid
	_storeSongStats : (songs, isFinalStep = false) ->
		_query = ""
		for song, index in songs 
			# console.log song
			_item = 
				id : parseInt(song.SongID)
				plays : parseInt(song.TotalFeel)*3 + parseInt(song.TotalLike)*3 + parseInt(song.TotalListen) + parseInt(song.TotalDownload)*2
				islyric : parseInt song.TotalLyric
			_query+= "UPDATE " + @table.NSSongs + " SET "
			_query+= "plays=" + _item.plays + ", "
			_query+= "islyric=" + _item.islyric + ", "
			_query+= "updated=now()"
			_query+= " WHERE songid=" + _item.id + "; "
			if _item.islyric > 0  then @_updateSongLyric _item.id
			if index is (songs.length - 1)
				#console.log _query
				@connection.query _query, (err, results) =>
			 		if err
			 			console.log "Cannot insert the song's stats into table. ERROR: " + err
			 			console.log _item.id
	_storeAlbum : (id,album) ->
		_album = 
			albumid : id
			album_name : album.name[0].trim()
			thumbnail : album.img[0]
		if typeof album.username[0] isnt "object"
			_album.artist = album.username[0].trim()
			_album.artistid = parseInt album.userlink[0].match(/-\d+\.html/)[0].replace("-","").replace(".html","")
		else
			_album.artist = ""
			_album.artistid = ""
		@connection.query @query._insertIntoNSAlbums,_album,(err) =>
			if err then console.log err 
			else 
				@_updateAlbumTopic id
				@_updateAlbumTotalSongs id
				@_updateAlbumDescAndIssuedTime id
	_storeSongs_Album : (id,songs) ->
		_songlist = []									
		songs.forEach (element, index)=> 
			_songid = parseInt element.id[0]
			if !isNaN(_songid)
				_songlist[index] = {}
				_songlist[index].songid = _songid
				_songlist[index].albumid = id
				@connection.query @query._insertIntoNSSongs_Albums,_songlist[index],(err) ->
				 	if err then console.log err + "at albumid: " + id + " songid: " +_songlist[index].songid + " is not available"
	_storeVideo : (video) ->
		ts = video.link.match(/\/[0-9]+_/g)[0].replace(/\//, "").replace(/_/, "")
		ts = parseInt(ts)*Math.pow(10,13-ts.length)
		date = new Date(ts)
		_formatedDate = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds()
		
		_item =
			videoid : video.id
			video_name : video.name.trim()
			link : video.link
			sublink : video.sublink
			thumbnail : video.thumbnail
			plays :  video.plays
			artist_list : video.artist_list
			created : _formatedDate
		@connection.query @query._insertIntoNSVideo,_item,(err) =>
			if err then console.log err + " Videoid: " + video.id + " is not ready"
	
	_updateAlbum : (id) ->
		link = "http://nhacso.net/flash/album/xnl/1/uid/X1lWW0NabwIBAw==," + @_decodeId(id)
		# console.log link + " " +id		
		album_id = id
		http.get link, (res) =>
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					# length is 39 means data only contains <?xml version="1.0" encoding="utf-8" ?>
					# therefore it has to stop
					@stats.currentTable = @table.NSAlbums + " and " + @table.NSSongs_Albums
					if data.length isnt 39
						@parser.parseString data, (err, result) =>
							album = result.music.playlist[0]
							@stats.totalItemCount+=1
							if album.name[0] isnt "Playlist Nhạc Số" and album.img[0].search(/_120x90.(jpg|png)$/g) is -1  and album.song?
								@_storeAlbum album_id, album
								@_storeSongs_Album album_id, album.song
								@stats.passedItemCount+=1
							else 
								@stats.failedItemCount+=1
							@log.lastAlbumId +=1
							@utils.printUpdateRunning id, @stats, "Fetching..."	
							@_updateAlbum(id+1) 
					else 
						@log.updated_at = Date.now()
						# fs.writeFileSync @logPath,JSON.stringify(@log),"utf8"
						if @stats.totalItemCount is 0 then console.log "Table #{@table.NSAlbums} is up-to-date on: #{new Date(Date.now())}"
						else
							@_writeLog @log
							@utils.printFinalResult @stats
						@resetStats()
						# if @log.totalPassedSongs is 0 then console.log "The stats of table: #{@table.NSSongs} is up-to-date on: #{new Date(Date.now())}" 
						# else @fetchSongsStats @log.lastSongId-@log.totalPassedSongs+1, @log.lastSongId
			.on 'error', (e) ->
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	_updateSong : (id) ->
		link = "http://nhacso.net/flash/song/xnl/1/id/" + @_decodeId(id)
		http.get link, (res) =>
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@parser.parseString data, (err, result) =>
						song = result.music.playlist[0].song[0]
						@stats.totalItemCount+=1
						@stats.currentTable = @table.NSSongs
						if typeof song.id[0] isnt "object"
							@_storeSong(song)	
							@stats.passedItemCount+=1
							@utils.printUpdateRunning id, @stats, "Fetching..."
							@log.lastSongId = id
							@_updateSong id+1
						else 
							@stats.totalItemCount -=1
							error = true
							if @stats.totalItemCount is 0 then console.log "Table #{@table.NSSongs} is up-to-date on: #{new Date(Date.now())}"
							else @utils.printFinalResult @stats
							@log.totalPassedSongs = @stats.passedItemCount
							@_writeLog @log
							
							
	
			.on 'error', (e) ->
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	_updateVideo : (id) ->
		link = "http://nhacso.net/flash/video/xnl/1/id/" + @_decodeId(id)
		link2 = "http://nhacso.net/video/parse?listIds=" + id
		link3 = "http://nhacso.net/statistic/videostatistic?listIds=" +id
		videoData = ""

		http.get link, (res) =>
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@stats.currentId = id
					@utils.printUpdateRunning id, @stats, "Fetching..."
					@parser.parseString data, (err, result) =>
						result = result.data.track[0]
						if typeof result.id[0] isnt "object"
							videoData =
								id : result.id[0]
								name : result.name[0].trim()
								link : result.sourceUrl[0]
								thumbnail : result.thumbnailUrl[0]
							if typeof result.subUrl[0] isnt "object"
								videoData.sublink = result.subUrl[0]
							else videoData.sublink = ""
							@stats.currentId = id
							@utils.printUpdateRunning id, @stats, "Fetching..."
							http.get link2, (res2) =>
									data2 = ''
									res2.on 'data', (chunk) =>
										data2 += chunk;
									res2.on 'end', () =>
										data2 = JSON.parse data2
										arr = data2[0].ListArtist.split(',')
										arr[i] = arr[i].replace(/\<a.+\"\>/,'').replace(/\<\/a\>/,'').trim() for i in [0..arr.length-1]
										videoData.artist_list = arr.reduce (x,y)-> x+","+y								
										@stats.currentId = id
										@utils.printUpdateRunning id, @stats, "Fetching..."
										http.get link3, (res3) =>
												data3 = ''
												res3.on 'data', (chunk) =>
													data3 += chunk;
												res3.on 'end', () =>
													data3 = JSON.parse data3
													@stats.totalItemCount+=1
													videoData.plays  = parseInt data3.result[id.toString()].TotalView
													videoData.plays += parseInt(data3.result[id.toString()].TotalLike)*3
													videoData.plays += parseInt(data3.result[id.toString()].TotalComment)*3
													videoData.plays += parseInt(data3.result[id.toString()].TotalDownload)*3											
													@stats.passedItemCount+=1
													@stats.currentId = id
													@utils.printUpdateRunning id, @stats, "Fetching..."
													@_storeVideo videoData
													@log.lastVideoId = id
													@_updateVideo(id+1)
													
											.on 'error', (e) =>
												console.log  "Got error: " + e.message
												@stats.failedItemCount+=1
								.on 'error', (e) =>
									console.log  "Got error: " + e.message
									@stats.failedItemCount+=1
						else 
							if @stats.totalItemCount is 0
								console.log ""
								console.log "Video is up-to-date".magenta
							else
								@stats.failedItemCount+=1
								@_writeLog @log 
								@utils.printFinalResult @stats
							@connection.end()
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1

	_fetchItem : (id,type) ->
		if type is "song" then link = "http://nhacso.net/flash/song/xnl/1/id/" + @_decodeId(id)
		else if type is "album" then link = "http://nhacso.net/flash/album/xnl/1/uid/X1lWW0NabwIBAw==," + @_decodeId(id)
		http.get link, (res) =>
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@parser.parseString data, (err, result) =>
						if type is "song"
							@stats.currentTable = @table.NSSongs
							song = result.music.playlist[0].song[0]
							@stats.totalItemCount+=1
							if typeof song.id[0] isnt "object"
								# insert song into table"
								@_storeSong(song)	
								@stats.passedItemCount+=1
								
							else 
								# console.log "do nothing....."
								@stats.failedItemCount+=1
						
						else if type is "album"
							@stats.currentTable = @table.NSAlbums + " and " + @table.NSSongs_Albums
							_album = result.music.playlist[0]
							@stats.totalItemCount+=1
							if _album.name[0] isnt "Playlist Nhạc Số" and _album.song?
								@_storeAlbum id, _album
								@_storeSongs_Album id, _album.song
								@stats.passedItemCount+=1	
							else 
								@stats.failedItemCount+=1

						# print when completed in each percent
						
						if @stats.totalItemCount%Math.ceil(0.0001*@stats.totalItems) is 0
							@stats.currentId = id
							@utils.printRunning @stats 
	
						if @stats.totalItemCount is @stats.totalItems
							@utils.printFinalResult @stats
							@connection.end()
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	_fetchVideo : (videoid) ->
		id = videoid
		link = "http://nhacso.net/flash/video/xnl/1/id/" + id
		link2 = "http://nhacso.net/video/parse?listIds=" + id
		link3 = "http://nhacso.net/statistic/videostatistic?listIds=" + id
		videoData = ""
		
		http.get link, (res) =>
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@stats.currentId = videoid
					@utils.printRunning @stats
					@parser.parseString data, (err, result) =>
						result = result.data.track[0]
						if typeof result.id[0] isnt "object"
							videoData =
								id : result.id[0]
								name : result.name[0].trim()
								link : result.sourceUrl[0]
								thumbnail : result.thumbnailUrl[0]
							if typeof result.subUrl[0] isnt "object"
								videoData.sublink = result.subUrl[0]
							else videoData.sublink = ""
							@stats.currentId = videoid
							@utils.printRunning @stats
							http.get link2, (res2) =>
									data2 = ''
									res2.on 'data', (chunk) =>
										data2 += chunk;
									res2.on 'end', () =>
										data2 = JSON.parse data2
										arr = data2[0].ListArtist.split(',')
										arr[i] = arr[i].replace(/\<a.+\"\>/,'').replace(/\<\/a\>/,'').trim() for i in [0..arr.length-1]
										videoData.artist_list = arr.reduce (x,y)-> x+","+y								
										@stats.currentId = videoid
										@utils.printRunning @stats
										http.get link3, (res3) =>
												data3 = ''
												res3.on 'data', (chunk) =>
													data3 += chunk;
												res3.on 'end', () =>
													data3 = JSON.parse data3
													@stats.totalItemCount+=1
													videoData.plays  = parseInt data3.result[id.toString()].TotalView
													videoData.plays += parseInt(data3.result[id.toString()].TotalLike)*3
													videoData.plays += parseInt(data3.result[id.toString()].TotalComment)*3
													videoData.plays += parseInt(data3.result[id.toString()].TotalDownload)*3											
													@stats.passedItemCount+=1
													@stats.currentId = videoid
													@utils.printRunning @stats
													@_storeVideo videoData

													if @stats.totalItemCount is @stats.totalItems 
														@utils.printFinalResult @stats
													
											.on 'error', (e) =>
												console.log  "Got error: " + e.message
												@stats.failedItemCount+=1
								.on 'error', (e) =>
									console.log  "Got error: " + e.message
									@stats.failedItemCount+=1
						else @stats.failedItemCount+=1
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	_fetchSongStats : (id) -> 
		ids = ""
		finalStep = false
		isFinalStep = false
		@currentStep+=1
		if @currentStep isnt @totalSteps
			ids = [id..id+@step-1].join(',')
			step = @step
		else
			finalStep = @stats.totalItems-((@totalSteps-1)*@step)
			step = finalStep
			isFinalStep = true
			ids = [id..id+finalStep-1].join(',')
		link = "http://nhacso.net/statistic/songstatistic?listIds=" + ids
		# console.log link
		http.get link, (res) =>
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					# console.log data
					songStats = JSON.parse(data)
					@stats.currentTable = @table.NSSongs
					@stats.totalItemCount+=step
					if songStats.error is 0

						@stats.currentId = id
						@stats.passedItemCount+=step		
						@utils.printRunning @stats
						@_storeSongStats songStats.result						
					else 
						# console.log "do nothing....."
						@stats.failedItemCount+=step
						@utils.printRunning @stats 
					
					if isFinalStep then @utils.printFinalResult @stats	
			.on 'error', (e) ->
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	_fetchLyrics : (offset,rows) ->
		_query  = "select songid from #{@table.NSSongs} where islyric > 0 and lyric is null ORDER BY songid DESC LIMIT #{offset},#{rows}"	
		# _query = "select songid,lyric from #{@table.NSSongs} where songid=779401"
		# _query = "select songid from NSSongs where islyric > 0 and lyric like '%�%' order by songid DESC"
		@connection.query _query, (err,results) =>
			if err
				console.log "Error at offset: #{offset} and rows: #{rows}"
			else
				if results.length is 0 then console.log " |"+"The lyrics are up-to-date".magenta
				for song in results
					if results.length < rows then @stats.totalItems = results.length
					do (song) =>
						link = "http://nhacso.net/song/lyric?song_id=#{song.songid}"
						song.lyric = 
						http.get link, (res) =>
								res.setEncoding 'utf8'
								data = ''
								res.on 'data', (chunk) =>
									data += chunk
								res.on 'end', () =>
									# data = data.match(/\<p\sclass=\"desc\"\>.+\<p\sclass=\"xemthem\"/)[0].replace(/\<p\sclass=\"desc\"\>/,'').replace(/\<p\sclass=\"xemthem\"/,'').replace(/\<\/p\>/,'')
									@stats.totalItemCount+=1
									id = song.songid
									# console.log id
									@temp.count+=1
									# console.log JSON.stringify data
									data = data.replace(/\r/g,'')
									data = data.match(/\<p\sclass=\"desc\"\>.+/)[0].replace(/\sclass="desc"/,'')
									_insertLyric = "UPDATE #{@table.NSSongs} SET lyric = #{@connection.escape(data)} where songid = #{id};"
									@stats.passedItemCount+=1
									# console.log _insertLyric
									@connection.query _insertLyric, (err) =>
										if err then console.log "Cannot update lyric of songid: #{song.songid}. ERROR: #{err}"
										else
											@stats.currentId = song.songid
											@utils.printRunning @stats 	
																			
										if @temp.count is @stats.totalItems
											@utils.printFinalResult @stats
											@connection.end()

							.on 'error', (e) =>
								console.log  "Got error: " + e.message
								@stats.failedItemCount+=1	
	
	_updateAlbumTopic : (id) ->
		link = "http://nhacso.net/nghe-album/ab.#{@_decodeId(id)}.html"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk
				res.on 'end', () =>
					if res.headers.location isnt "http://nhacso.net/404"
						data = data.replace(/\r/g,'')
						_item = 
							id : id
						_item.topic = data.match(/\<li\sclass\=\"bg\".+\<\/li\>/)[0]
										.replace(/\<li\sclass\=\"bg\"\>\<a\shref\s\=\"http\:\/\/nhacso\.net\/.+\"\>/,'')
										.replace(/\<\/a\>\<\/li\>/,'').trim()
						data = ""
						_insertTopic = "UPDATE #{@table.NSAlbums} SET topic = #{@connection.escape(_item.topic)} where albumid = #{_item.id};"
						@connection.query _insertTopic, (err)->
							if err then console.log "Albumid:#{_item.id} has errors. Error:#{err}".red	

			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	_updateAlbumDescAndIssuedTime : (id) ->
		link = "http://nhacso.net/album/getdescandissuetime?listIds=#{id}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk
				res.on 'end', () =>
					data = JSON.parse data
					data = data.result[0]
					try
						_item = 
							id : data.AlbumID
							issuedAt : data.IssueTime
							desc : data.AlbumDesc
						_item.desc = encoder.htmlDecode _item.desc
						if _item.desc.search("thưởng thức nhạc chất lượng cao và chia sẻ cảm xúc với bạn bè tại Nhacso.net") > -1
							_item.desc = ""
					catch e
						console.log "Cannot update album description. ERROR: albumid: #{_item.id} "
					_updateDesc = "UPDATE #{@table.NSAlbums} SET description = #{@connection.escape(_item.desc)},"+
						" released_date=#{@connection.escape(_item.issuedAt)} where albumid = #{_item.id};"
					@connection.query _updateDesc, (err)->
						if err then console.log "Albumid:#{_item.id} has errors. Error:#{err}".red	

			.on 'error', (e) =>
				console.log  "Got error: " + e.message	
	_updateAlbumTotalSongs : (id) ->
		link = "http://nhacso.net/album/gettotalsong?listIds=#{id}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk
				res.on 'end', () =>
					data = JSON.parse data
					data = data.result
					_query = ""
					try
						strId = "nsn:album:total:song:id:#{id}"
						# console.log strId
						_item =
							id : data[strId].AlbumID
							totalSongs : data[strId].TotalSong
						_query = "UPDATE #{@table.NSAlbums} SET total_songs = #{_item.totalSongs} where albumid = #{_item.id};"
						@connection.query _query, (err)->
							if err then console.log "Albumid:#{_item.id} has errors. Error:#{err}".red
					catch e
						console.log "Cannot update total_songs of the album: #{id}.ERROR: " + strId

			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1		
	_updateSongStats : (id) -> 
		link = "http://nhacso.net/statistic/songstatistic?listIds=" + id
		http.get link, (res) =>
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					songStats = JSON.parse(data)
					if songStats.error is 0
						@_storeSongStats songStats.result						
			.on 'error', (e) ->
				console.log  "Got error: " + e.message
	_updateSongBitrate : (songid) ->
		link = "http://nhacso.net/nghe-nhac/link-joke.#{@_decodeId(songid)}==.html"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					if data.match(/\d+kb\/s/g)
						bitrate = data.match(/\d+kb\/s/g)[0].replace(/kb\/s/g,'')
						if data.match(/official/g) then official = true 
						else official = false
						if data.match(/<li><a\shref\=\"http\:\/\/nhacso\.net\/the-loai.+/g)
							topic = data.match(/<li><a\shref\=\"http\:\/\/nhacso\.net\/the-loai.+/g)[0]
								.replace(/^.+\">|<\/a><\/li>/g,'').trim()
						else topic = ''
						data  = ''
						_q = "update NSSongs set bitrate=#{bitrate}, official=#{official}, topic=#{@connection.escape(topic)}  where songid=#{songid}"
						@connection.query _q, (err)=>
							if err then console.log "cannt update birate. ERROR: #{err}"

			.on 'error', (e) =>
				console.log  "Got error while updating bitrate: " + e.message		
	_updateSongLyric : (id) ->
		link = "http://nhacso.net/song/lyric?song_id=#{id}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk
				res.on 'end', () =>
					data = data.replace(/\r/g,'')
					data = data.match(/\<p\sclass=\"desc\"\>.+/)[0].replace(/\sclass="desc"/,'')
					_insertLyric = "UPDATE #{@table.NSSongs} SET lyric = #{@connection.escape(data)} where songid = #{id};"
					@connection.query _insertLyric, (err) =>
						if err then console.log "Cannot update lyric of songid: #{song.songid}. ERROR: #{err}"
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	
	fetchSongsStats: (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching statistics of songid: #{range0}..#{range1} to table: #{@table.NSSongs}".magenta
		@stats.totalItems = range1 - range0 + 1
		[@stats.range0, @stats.range1] = [range0, range1]
		@step = 50
		@currentStep = 0
		if @stats.totalItems%@step is 0 then @totalSteps = @stats.totalItems/@step 
		else @totalSteps = Math.floor(@stats.totalItems/@step) + 1
		@_fetchSongStats id for id in [range0..range1] by @step
		null
	fetchSongs : (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching songid: #{range0}..#{range1} to table: #{ @table.NSSongs}".magenta
		@stats.totalItems = range1 - range0 + 1
		[@stats.range0, @stats.range1] = [range0, range1]
		@_fetchItem id, "song" for id in [range0..range1]
		null
	fetchAlbums : (range0 = 0, range1 = 0) =>
		@connect()
		@stats.totalItems = range1 - range0 + 1
		[@stats.range0, @stats.range1] = [range0, range1]
		console.log " |"+"Fetching albumid: #{range0}..#{range1} to table: #{@table.NSAlbums}".magenta
		@_fetchItem id, "album" for id in [range0..range1]
		null
	fetchVideos : (range0 = 0, range1 = 0) =>
		@connect()
		@stats.totalItems = range1 - range0 + 1
		@stats.currentTable = @table.NSVideos
		[@stats.range0, @stats.range1] = [range0, range1]
		console.log " |"+"Fetching videoid: #{range0}..#{range1} to table: #{@table.NSVideos}".magenta
		# @_fetchVideo id for id in [range0..range1]
		for id in [range0..range1]
			do () =>
				@_fetchVideo id

		null	
	fetchLyrics : ( amount = 0, repetition = 0)=>
		@connect()
		_rows = amount #fetch 100 rows in database
		_initialOffset = 0 #offset each time
		@temp = 
			step : repetition 
			count : 0
		@stats.totalItems = @temp.step * _rows
		@stats.currentTable = @table.NSSongs
		console.log " |"+"Fetching songs which have lyrics. Rows: #{_initialOffset+1}..#{_initialOffset+@stats.totalItems} to table: #{@table.NSSongs}".magenta		
		for i in [1..@temp.step]
			do (i) =>
				_offset = _initialOffset + (i-1)*_rows
				@_fetchLyrics(_offset,_rows)
	
	
	updateSongs : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating Songs to table: #{@table.NSSongs}".magenta 
		@_updateSong @log.lastSongId+1
	updateAlbums : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating Albums to table: #{@table.NSAlbums}".magenta 
		@_updateAlbum @log.lastAlbumId+1

	updateVideos : ->
		@connect()
		@_readLog()
		@_updateVideo(@log.lastVideoId+1)
	updateLyrics : ->
		# get last 100 songs which have lyrics but arent updated
		@fetchLyrics 100, 1

	showStats : ->
		@_printTableStats NS_CONFIG.table

	
	_updateVideoErrors : ->
					videoData = ""			
					http.get link, (res) =>
							data = ''
							res.on 'data', (chunk) =>
								data += chunk;
							res.on 'end', () =>
								@parser.parseString data, (err, result) =>
									result = result.data.track[0]
									if typeof result.id[0] isnt "object"
										videoData =
											id : result.id[0]
											name : result.name[0].trim()
											link : result.sourceUrl[0]
											thumbnail : result.thumbnailUrl[0]
									
									console.log videoData
						.on 'error', (e) =>
							console.log  "Got error: " + e.message
	_insertCreatedDatesofVideo : ()->
		@connect()
		_query = "select videoid,link from NSVideos where videoid=334 or videoid=6228 or videoid=6229"
		@connection.query _query, (err,results) =>
			for key, video of results
				do (video) =>
					try
						if video.link isnt "http://st01.freesocialmusic.com/" and video.link isnt "http://st02.freesocialmusic.com/"
							ts = video.link.match(/\/[0-9]+_/g)[0].replace(/\//, "").replace(/_/, "")
							ts = parseInt(ts)*Math.pow(10,13-ts.length)
							date = new Date(ts)
							console.log ts
							console.log date
							_formatedDate = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds()
							_qUpdate = "update NSVideos set created='#{_formatedDate}' where videoid=#{video.videoid}"
							@connection.query _qUpdate, (err,resutls) =>
								if err then console.log "we have an error at #{video.videoid}"
					catch e
						console.log "error at videoid: #{video.videoid}"


	resetVideosTable : ->
		@connect()
		@_readLog()
		_videoid = 0
		@log.lastVideoId = _videoid 
		@log.updated_at = Date.now()
		@_writeLog @log
		# fs.writeFileSync @logPath,JSON.stringify(@log),"utf8"	
		_query = "delete from " + @table.NSVideos  + " where videoid > #{_videoid};"
		@connection.query _query, (err,results) ->
		 	if err then console.log "Cannot reset the table Video. ERROR: " + err
		 	else console.log results
	resetSongsAndAlbumsTable : ->
		@connect()
		@_readLog()
		_songid = 1263474
		_albumid = 557356
		@log.lastSongId = _songid 
		@log.lastAlbumId = _albumid 
		@log.updated_at = Date.now()
		@_writeLog @log
		# fs.writeFileSync @logPath,JSON.stringify(@log),"utf8"	
		_query = "delete from " + @table.NSSongs  + " where songid > #{_songid};"
		_query+= "delete from " + @table.NSAlbums + " where albumid > #{_albumid};"
		_query+= "delete from " + @table.NSSongs_Albums + " where albumid > #{_albumid};"
		@connection.query _query, (err,results) ->
		 	if err then console.log "Cannot reset the tables. ERROR: " + err
		 	else console.log results
module.exports = Nhacso
