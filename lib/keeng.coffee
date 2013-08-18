http = require 'http'
xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require '../node_modules/colors'
atob = require '../node_modules/atob' 
fs = require 'fs'

Encoder = require('../node_modules/node-html-encoder').Encoder
encoder = new Encoder('entity');

KE_CONFIG = 
	table : 
		Songs : "kesongs"
		Albums : "kealbums"
		Videos : "kevideos"
http.globalAgent.maxSockets = 5
class Keeng extends Module
	constructor : (@mysqlConfig, @config = KE_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoKESongs : "INSERT IGNORE INTO " + @table.Songs + " SET ?"
			_insertIntoKEAlbums : "INSERT IGNORE INTO " + @table.Albums + " SET ?"
			_insertIntoKEVideos : "INSERT IGNORE INTO " + @table.Videos + " SET ?"
		@utils = new Utils()
		@parser = new xml2js.Parser();
		super @mysqlConfig
		require('./helpers/string')
		Array::splitBySeperator = (seperator) ->
			result = []
			for val in @
				_a = val.split(seperator)
				for item in _a
					result.push item.trim()
			return result
		Array::replaceElement = (source,value)->
			for val,index in @
				if val is source
					@[index] = value
			return @
	
	_getFileByHTTP : (link, callback) ->
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				# callback res.headers.location
				# if res.statusCode isnt 302
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					
					callback null, data
				# else callback("statusCode is 302",null)
			.on 'error', (e) =>
				callback  "Cannot get file. ERROR: " + e.message,null

	formatDate : (dt)->
		dt.getFullYear() + "-" + (dt.getMonth()+1) + "-" + dt.getDate() + " " + dt.getHours() + ":" + dt.getMinutes() + ":" + dt.getSeconds()

	_updateAlbum : (pageId) ->
		link = "http://www.keeng.vn/album/album-moi.html?page=" + pageId
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					items = data.match(/class\=\"link\sname-song\sunder\".+/g)
					data  = ""
					totalAlbums = items.length
					
					newAlbumCount = 0
					count = 0
					for item, i in items
						album = 
							title : item.match(/^class.+name-single/g)[0]
									.match(/^class.+\<\/a\>/g)[0]
									.replace(/^class.+\"\>/,'')
									.replace(/\<\/a\>/,'').trim()
							artist_name : item.replace(/^class.+\"\>/g,'').replace(/\<\/a\>\<\/p\>/,'').trim()
							id :  item.match(/^.+name-single/g)[0]
									.match(/^.+ title/)[0]
									.replace(/^.+\/.+\/.+\//,'')
									.replace(/\.html.+/,'')
						if @temp.isNewPage
							do (album, i) =>
								_query = "select * from #{@table.Songs} where album_key=#{@connection.escape(album.id)}"
								@connection.query _query, (err, result)=>
									count += 1
									if err then console.log "We have error: #{err}"
									else
										if result.toString() is ''
											@temp.albumList.push album
											newAlbumCount += 1
											# console.log "#{album} is new"
											# @_updateSongs album #fetch new album
											# if i is items.length-1 then @_updateAlbum pageId+1
										# else
										# 	if pageId is 1 and i is 0 then console.log "Table: #{@table.Songs} is up-to-date"
											
									if count is totalAlbums
										if newAlbumCount is 0
											if pageId is 1
												console.log "Table: #{@table.Songs} is up-to-date"
											else 
												@_updateSongs album for album in @temp.albumList
										else 
											if newAlbumCount is totalAlbums
												@_updateAlbum pageId+1
											else 
												if newAlbumCount < totalAlbums
													@temp.isNewPage = false
													if @temp.check is false 
														@temp.check = true
														@stats.totalItems = @temp.albumList.length
														@_updateSongs album for album in @temp.albumList
												else console.log "invalid vars : new albums found greater than total albums"
												
									# if count is totalAlbums
									# 	if pageId <= 100
									# 		@_updateAlbum pageId+1
									# 	else 
									# 		@_updateSongs album for album in @temp.albumList


			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	_updateSongs : (album) ->
		link = "http://www.keeng.vn/album/get-album-xml?album_identify=#{album.id}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					data = data.replace(/\r/g,'')
					titles = data.match(/\<title\>.+\<\/title\>/g)
					locations = data.match(/\<location\>.+\<\/location\>/g)
					ids = data.match(/\<info\>.+\<\/info\>/g)
					@stats.totalItemCount+=1
					if locations isnt null
						@stats.passedItemCount +=1
						for i in [0..locations.length-1]
							song = 
								album_key : album.id
								# album_title : encoder.htmlDecode album.title
								key: ids[i+1].replace(/\<info\>/,'').replace(/<\/info\>/,'').trim()
								title : encoder.htmlDecode titles[i+1].replace(/\<title\>/,'').replace(/<\/title\>/,'').trim()
								link : locations[i].replace(/\<location\>/,'').replace(/<\/location\>/,'').trim()
								# album_artists : encoder.htmlDecode(album.artist_name).split().splitBySeperator(' - ').replaceElement('Nhiều Ca Sỹ','Various Artists')
							if song.link.match(/\d{4}\/\d{2}\/\d{2}/) isnt null then song.date_created = song.link.match(/\d{4}\/\d{2}\/\d{2}/)[0].replace(/\//g,'-')
							
							# console.log song
							# console.log album
							# process.exit 0

							@connection.query @query._insertIntoKESongs, song, (err)->
								if err then console.log "CANNOT insert songid #{song.songid}. ERROR: #{err}".red
						@stats.currentId = album.id
						@utils.printRunning @stats
					else
						@stats.failedItemCount+=1
					if @stats.totalItemCount is @temp.albumList.length
						@utils.printFinalResult @stats
						@updateAlbumStats()

			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.totalItemCount+=1
				@stats.failedItemCount+=1
				if @stats.totalItemCount is @temp.albumList.length
					@utils.printFinalResult @stats
					@updateAlbumStats()
	
	_fetchVideos : (pageId) ->		
		link = "http://www.keeng.vn/video/video-moi.html?page=" + pageId
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					items = data.match(/class\=\"link\sname-song\sunder\".+/g)
					data  = ""
					for item, i in items
						@stats.totalItemCount +=1
						@stats.passedItemCount +=1
						video = 
							vid :  item.match(/^.+name-single/g)[0]
									.match(/^.+ title/)[0]
									.replace(/^.+\/.+\/.+\//,'')
									.replace(/\.html.+/,'')
						@connection.query @query._insertIntoKEVideos, video, (err)->
							if err then console.log "cannt insert video id: #{video.vid}"
						@utils.printRunning @stats
					
					if @stats.totalItems is @stats.totalItemCount 
						@utils.printFinalResult @stats
			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	

	fetchVideos : (range0 = 0, range1 = 0)=>
		@connect()
		console.log " |"+"Fetching videoid: #{range0}..#{range1} to table: #{@table.Videos}".magenta
		@stats.totalItems = (range1 - range0 + 1)*28
		[@stats.range0, @stats.range1] = [range0, range1]
		@stats.currentTable = @table.Videos
		@_fetchVideos id for id in [range0..range1]

	_updateVideos : ->
		_q  = "select vid from KEVideos_test LIMIT 7"
		# _getFileByHTTP FUNC CHANGE
		# @connection.query _q, (err,results)=>
		# 	if err then console.log "cannt fetch videos from table"
		# 	else
		# 		@stats.totalItems = results.length
		# 		for video, index in results
		# 			do (video, index)=>
		# 				# link = "http://www.keeng.vn/video/joke-link/DBKXN8EQ.html"
		# 				link = "http://www.keeng.vn/video/joke-link/#{video.vid}.html"
		# 				@_getFileByHTTP link, (data)=>
		# 					_video = 
		# 						vid : video.vid
		# 					@stats.totalItemCount++
		# 					if data isnt null
		# 						if data.match(/name-song\".+/g)
		# 							_temp = data.match(/name-song\".+/g)[0]
		# 							_video.name = encoder.htmlDecode _temp.replace(/<\/span>.+$/g,'')
		# 											.replace(/^.+>/g,'')
		# 							_t = _temp.replace(/^.+<\/span>/g,'').split(" ft ")
		# 							_video.artists = JSON.stringify _t.map (v)-> encoder.htmlDecode v.replace(/<\/a>.+$/g,'').replace(/^.+>/g,'')
		# 							_video.playingid = _temp.match(/playingid=\d+/g)?[0].match(/\d+/g)?[0]
		# 						if data.match(/Lượt\snghe:.+/g)
		# 							_video.plays = data.match(/Lượt\snghe:.+/g)[0].match(/\d+/g)?[0]
		# 						if data.match(/videoPlayerLink.+/g)
		# 							_video.link = data.match(/videoPlayerLink.+/g)?[0].match(/http.+/)?[0].replace(/\';/g,'')
		# 						if data.match(/videoImageLink.+/g)
		# 							_video.thumbnail = atob data.match(/videoImageLink.+/g)?[0]
		# 													.replace(/\";/g,'').replace(/^.+\"/g,'').trim()
		# 							_video.created = _video.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)?[0]
		# 						if data.match(/link\stl\sunder.+/g)
		# 							_video.topic = encoder.htmlDecode data.match(/link\stl\sunder.+/g)[0].replace(/<\/a>.+$/g,'').replace(/^.+>/g,'')

		# 						data = JSON.stringify(data)
		# 						if data.match(/statis.+link\stl\sunder/g)
		# 							_video.author = data.match(/statis.+link\stl\sunder/g)[0].replace(/<\/a>.+$/g,'').replace(/^.+>/g,'')
		# 							if _video.author.search(/Đang\scập\snhật/) > -1
		# 								_video.author = ""

		# 						@stats.passedItemCount++
		# 						@connection.query @query._insertIntoKEVideos, _video, (err)=>
		# 							if err
		# 								console.log "cannt insert new videoid #{_video.vid} into table. ERROR: #{err}"
		# 							else @connection.query "delete from KEVideos_test where vid=#{@connection.escape(_video.vid)}"



		# 					else @stats.failedItemCount++

		# 					@utils.printRunning @stats

		# 					if index is 6 then @_updateVideos()

		# 					if @stats.totalItems is @stats.totalItemCount
		# 						@utils.printFinalResult @stats

	updateVideos : ->
		@connect()
		console.log " |"+"Update videos to table: #{@table.Videos}".magenta
		_q  = "select vid from KEVideos_test LIMIT 7"

		@_updateVideos()

	update : ->
		#update songs and albums
		@connect()
		@stats.currentTable = @table.Songs
		@temp = 
			albumList : []
			check : false #used to check the last new album
			isNewPage : true #to check if a page contains old albums. If not, fetch new page
		console.log " |"+"Updating Albums + Songs to table: #{@table.Songs}".magenta
		@lastMaxSongId = 0
		@connection.query "select max(id) as id from #{@table.Songs}",(err,result)=>
			if err then console.log err
			else 
				@lastMaxSongId = result[0].id
				# console.log @lastMaxSongId
				@_updateAlbum(1)

	proccessAlbumPage : (al,data)->
		album = 
			key : al.key
			title : ""
			artists : null
			plays : 0
			description : ""
			# artist_description : null
			description : null
			coverart : null
			songids : al.songids
			nsongs : parseInt(al.nsongs,10)
			date_created : null
			songs : []
		
		if al.date_created then album.date_created = @formatDate al.date_created 

		plays = data.match(/([0-9]+) Lượt nghe/i)?[1]
		if plays 
			album.plays = parseInt plays,10

		title = data.match(/<h2 itemprop="name"[^]+?<\/h2>/g)?[0]
		if title
			title = encoder.htmlDecode title.stripHtmlTags().trim()
			title = title.replace(/\[Nghe Thử\]/gi,'').trim()
			album.title = title

		artists = data.match(/<p class="name-single">[^]+?<\/p>/)?[0]
		if artists
			artists = artists.split('</a>').map((v) ->encoder.htmlDecode v.stripHtmlTags().trim())
			artists = artists.filter (v)-> v isnt ""
			artists = artists.map (v)-> v.replace(/\sf(ea)?t\.?\s/i,'').replace(/\s[-_]\s/,'').trim()
			album.artists = artists

		albumProfile = data.match(/_profileContent[^]+box\-search/)?[0]
		if albumProfile
			albumProfile = albumProfile.replace(/<div class="clear"[^]+$/,'').replace(/_profileContent _content _info-content">/,'').trim()
			albumProfile = albumProfile.replace(/^<p>/,'').replace(/<\/p>$/,'').trim()
			album.description = encoder.htmlDecode albumProfile

		# artistProfile = data.match(/THÔNG TIN CA SĨ[^]+_profileContent[^]+box\-search/)?[0]
		# if artistProfile
		# 	artistProfile = artistProfile.replace(/<div class="clear"[^]+$/,'').replace(/THÔNG TIN CA SĨ[^]+_profileContent _content _info-content">/,'').trim()
		# 	artistProfile = artistProfile.replace(/^<p>/,'').replace(/<\/p>$/,'').trim()
		# 	album.artist_description =  encoder.htmlDecode artistProfile

		thumbnail = data.match(/<span class="wrap highslide-gallery">[^]+?<\/span>/)?[0]
		if thumbnail
			thumbnail = thumbnail.match(/(http.+?)">/)?[1]
			album.coverart = thumbnail

		songKeys = data.match(/javascript:playSong.+/g)
		if songKeys
			songKeys = songKeys.map (key)-> key.match(/playSong\('(.+)'\)/)?[1]
			songKeys.map (key)->
				reg = new RegExp("#{key}\.html.+\\s+.+")
				artist = data.match(reg)?[0]
				if artist
					artist = artist.split('<\/a>').map((v)-> v.match(/title="(.+)"/)?[1]).filter (v)-> v
				song = 
					key : key 
					artists : artist
					lyrics : []
				album.songs.push song

			lyrics = data.match(/id="change_content0"[^]+\<\!--Comment--\>/g)?[0]
			# console.log lyrics
			lyrics = lyrics.split("lyricId")
			for lyric,index in lyrics
				lyricArray = []
				lyric =  encoder.htmlDecode lyric.replace(/^[^]+hide_detail">/g,'').replace(/<a id="input_id[^]+$/,'').trim()
								 .replace(/<\/div>$/,'').replace(/<\/p>/,'').replace(/<p>/,'').trim()
				if lyric.search("Bài hát chưa được cập nhật lời") > -1
					lyric = ""
				if lyric.match(/<div style=\"float\:right/) and lyric.match(/<div style=\"float\:left/)
					lyric = lyric.split(' <div style="float:right;width: 300px;">').map (item)-> item.replace('<div style="float:left;width: 309px;">','')
								.trim().replace(/<\/div>$/,'').trim().replace(/<\/p>/,'').replace(/<p>/,'').trim()
				else 
					lyric = lyric.split()
				# lyric = [ 'Mong Manh</td></tr></tbody></table><p>Mùa thu làm rơi chiếc lá Sáng nay lá rụng quanh nhà Người yêu giờ xa xôi quá Có hay mơ về với ta Mong manh như chiếc lá Lá rơi khắp sân nhà Mong manh ôi nỗi nhớ Tháng năm có phai mờ Tình yêu nào như cơn gió Thoáng qua cho đời bất ngờ Giờ đây mình ta nhung nhớ Mắt em ôi lệ hoen mờ Mong manh như nắng sớm Nắng không thích đêm về Mong manh như khói thuốc Có đôi lúc ê chề ĐK: Này em cùng ta vui sống Này em cùng ta đắm say Nhớ mãi phút giây này Dù cho đời thêm gian dối Đừng cho tình thêm đắng cay Cho nhau niềm vui mới Giọt sương nào mong manh quá Sáng nay đóa hồng nõn nà Tìm em tìm đâu cho thấy Nắng lên thôi tàn kiếp hoa Mong manh như kiếp sống Chớ gian dối trong lòng Mong manh như tiếng hát Hát cho kiếp phiêu bồng Tình yêu nào như giông tố Sóng nhô cao dạt đôi bờ Giờ đây mình ta trông ngóng Vắng tanh cõi lòng trống không Mong manh như lớp sóng Sóng tan lúc xô bờ Mong manh như thế đấy Cớ sao cứ hững hờ (trở lại ĐK)' ] 
				lyric = lyric.map (v)->
					v.replace(/^<table border="0" cellpadding="0" cellspacing="0"[^]+?<strong>/g,'')
					.replace(/<\/strong>[^]+?<\/table>/,'')
					.replace(/\r/g,'').replace(/\n/g,'').replace(/\t/g,'').replace(/<\/td><\/tr><\/tbody><\/table>/g,'').trim()
					.replace(/<p style="margin-left:.25in;">/,'')
					.replace(/<strong>(.+)<\/strong>/,"$1").stripHtmlTags('div').replace(/^<p>/,'').replace(/<\/p>$/,'').trim()
					# .replace(/<br\/>/g,"\\n").replace(/<br \/>/g,"\\n").stripHtmlTags().trim()
				# console.log lyric
				# process.exit 0
				album.songs[index].lyrics = lyric

		return album
	updateSongsStatsFromAlbumPage : (album) ->
		key = album.key
		link = "http://www.keeng.vn/album/joke-link/#{key}.html"
		@_getFileByHTTP link, (err,data)=>
			if err 
				console.log "#{link} has error. ERROR: #{err}"
				@updateStatsInfo(false)
			else 
				@updateStatsInfo(true,key)
				newAlbum = @proccessAlbumPage album,data

				try 
					songs = newAlbum.songs
					delete newAlbum.songs
					# console.log newAlbum
					# console.log songs
					# process.exit 0
					for song in songs
						_u = "UPDATE #{@table.Songs} SET"
						_u += " plays=#{newAlbum.plays}"
						_u += " , artists='#{@updateArrayQuery song.artists}'"
						_u += " , lyrics='#{@updateArrayQuery song.lyrics}'"
						_u += " WHERE key=#{@connection.escape song.key}"
						# console.log _u
						@connection.query _u, (err0)->
							if err0 then console.log err0
					@connection.query @query._insertIntoKEAlbums, newAlbum, (err1)->
						if err1 then console.log err1
					# console.log newAlbum
				catch e
					console.log e
					console.log JSON.stringify newAlbum
					console.log "-------------------------------"

			
	updateArrayQuery : (arr)->
		return @connection.escape(JSON.stringify arr).replace(/^'\[/g,"{").replace(/\]'$/g,"}")
	updateAlbumStats : ->
		@connect()
		@updateStatsInfo = (isSuccess,currentId) ->
			if currentId
				@stats.currentId = currentId
			@stats.totalItemCount +=1
			if isSuccess
				@stats.passedItemCount +=1
			else 
				@stats.failedItemCount +=1
			@utils.printRunning @stats
			if @stats.totalItems is @stats.totalItemCount
				@utils.printFinalResult @stats
		console.log "Getting album stats where songid > #{@lastMaxSongId} "
		_s = "select album_key as key,array_agg(id) as songids,count(album_key) as nsongs,max(date_created) as date_created from kesongs where id > #{@lastMaxSongId} group by album_key"
		# _s = "select album_key as key,array_agg(id) as songids,count(album_key) as nsongs,max(date_created) as date_created from kesongs group by album_key "
		@connection.query _s,(err,albums)=>
			if err then console.log err
			else 
				# albums = []
				
				# test =  
				# 	key: 'F6LCGMEU',
				# 	songids: [ 284465, 284464 ],
				# 	nsongs: '2',
				# 	date_created: new Date('Thu Jun 06 2013 07:00:00 GMT+0700 (ICT)')
				# albums.push test

				# albums.push "PLGGW8C0"		
				@resetStats()		
				@stats.totalItems = albums.length
				@stats.currentTable = @table.Albums
				for album in albums
					@updateSongsStatsFromAlbumPage album


	showStats : ->
		@_printTableStats KE_CONFIG.table


module.exports = Keeng
