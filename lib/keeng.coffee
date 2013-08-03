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
		Videos : "kevideos"
http.globalAgent.maxSockets = 5
class Keeng extends Module
	constructor : (@mysqlConfig, @config = KE_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoKESongs : "INSERT IGNORE INTO " + @table.Songs + " SET ?"
			_insertIntoKEVideos : "INSERT IGNORE INTO " + @table.Videos + " SET ?"
		@utils = new Utils()
		@parser = new xml2js.Parser();
		super @mysqlConfig
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


	createTables : ->
		@connect()
		songsQuery = "CREATE TABLE IF NOT EXISTS " + @table.Songs + " (
					id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
					albumid varchar(20),
					album_name varchar(255),
					songid varchar(20),
					song_name varchar(255),
					artist_name varchar(255),
					album_plays int,
					album_link varchar(255),
					song_link varchar(255)
					);"
		@connection.query songsQuery, (err, result)=>
			if err then console.log "Cannot create table" else console.log "Tables: #{@table.Songs} have been created!"
			@end()
	resetTables : ->
		@connect()
		songsQuery = "truncate table #{@table.Songs} ;"
		@connection.query songsQuery, (err, result)=>
			if err then console.log "Cannot truncate tables" else console.log "Tables: #{@table.Songs} have been truncated!"
			@end()

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
								album_title : encoder.htmlDecode album.title
								key: ids[i+1].replace(/\<info\>/,'').replace(/<\/info\>/,'').trim()
								title : encoder.htmlDecode titles[i+1].replace(/\<title\>/,'').replace(/<\/title\>/,'').trim()
								link : locations[i].replace(/\<location\>/,'').replace(/<\/location\>/,'').trim()
								artists : encoder.htmlDecode(album.artist_name).split().splitBySeperator(' - ').replaceElement('Nhiều Ca Sỹ','Various Artists')
							if song.link.match(/\d{4}\/\d{2}\/\d{2}/) isnt null then song.date_created = song.link.match(/\d{4}\/\d{2}\/\d{2}/)[0].replace(/\//g,'-')
							
							# console.log song
							# console.log album
							# process.exit 0

							@connection.query @query._insertIntoKESongs, song, (err)->
								if err then console.log "CANNOT insert songid #{song.songid}. ERROR: #{err}".red
						@utils.printUpdateRunning album.id, @stats, "Fetching"
					else
						@stats.failedItemCount+=1
					if @stats.totalItemCount is @temp.albumList.length
						@utils.printFinalResult @stats

			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	
	_fetchAlbum : (pageId) ->
		link = "http://www.keeng.vn/album/album-moi.html?page=" + pageId
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					items = data.match(/class\=\"link\sname-song\sunder\".+/g)
					data  = ""
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
						@_fetchSongs album	
			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	_fetchSongs : (album) ->
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
								albumid : album.id
								album_name : album.title
								songid : ids[i+1].replace(/\<info\>/,'').replace(/<\/info\>/,'').trim()
								song_name : titles[i+1].replace(/\<title\>/,'').replace(/<\/title\>/,'').trim()
								song_link : locations[i].replace(/\<location\>/,'').replace(/<\/location\>/,'').trim()
								artist_name : album.artist_name
							if song.song_link.match(/\d{4}\/\d{2}\/\d{2}/) isnt null then song.created = song.song_link.match(/\d{4}\/\d{2}\/\d{2}/)[0].replace(/\//g,'-')
							@connection.query @query._insertIntoKESongs, song, (err)->
								if err then console.log "CANNOT insert songid #{song.songid}".red
						@utils.printRunning @stats
							
					else
						@stats.failedItemCount+=1
					if @stats.totalItemCount is @stats.totalItems
							@utils.printFinalResult @stats
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	
	fetchAlbums : (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching songid: #{range0}..#{range1} to table: #{@table.Songs}".magenta
		@stats.totalItems = (range1 - range0 + 1)*25
		[@stats.range0, @stats.range1] = [range0, range1]
		@stats.currentTable = @table.Albums
		@_fetchAlbum id for id in [range0..range1]
		null

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
		@_updateAlbum(1)



	proccessAlbumPage : (albumid,data)->
		album = 
			id : albumid
			plays : 0
			description : ""
			artist_description : null
			album_description : null
			songs : []
		

		plays = data.match(/([0-9])+.+Lượt nghe/)?[1]
		if plays 
			album.plays = parseInt plays,10

		albumProfile = data.match(/_profileContent[^]+box\-search/)?[0]
		if albumProfile
			albumProfile = albumProfile.replace(/<div class="clear"[^]+$/,'').replace(/_profileContent _content _info-content">/,'').trim()
			album.album_description = albumProfile

		artistProfile = data.match(/THÔNG TIN CA SĨ[^]+_profileContent[^]+box\-search/)?[0]
		if artistProfile
			artistProfile = artistProfile.replace(/<div class="clear"[^]+$/,'').replace(/THÔNG TIN CA SĨ[^]+_profileContent _content _info-content">/,'').trim()
			album.artist_description =  artistProfile

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
				album.songs[index].lyrics = lyric

		return album
	updateSongsStatsFromAlbumPage : (albumid) ->
		link = "http://www.keeng.vn/album/joke-link/#{albumid}.html"
		@_getFileByHTTP link, (err,data)=>
			if err 
				console.log "#{link} has error. ERROR: #{err}"
				@updateStatsInfo(false)
			else 
				@updateStatsInfo(true,albumid)
				album = @proccessAlbumPage albumid,data
				# console.log album
				try 
					for song in album.songs
						_u = "UPDATE #{@table.Songs} SET"
						_u += " plays=#{album.plays}"
						_u += " , album_description=#{@connection.escape album.album_description}"
						_u += " , artist_description=#{@connection.escape album.artist_description}"
						_u += " , artists='#{@updateArrayQuery song.artists}'"
						_u += " , lyrics='#{@updateArrayQuery song.lyrics}'"
						_u += " WHERE key=#{@connection.escape song.key}"
						@connection.query _u, (err0)->
							if err0 then console.log err0
				catch e
					console.log e
					console.log JSON.stringify album
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

		select = "
select album_key from kesongs where album_key in 
 ('0RIZGVMJ','3CCC5D3','63824BF3','7B99685F','7FD3753D')
 GROUP BY album_key
		"
		@connection.query select, (err,results)=>
			if err then console.log err
			else 
				albumids = []
				for result,index in results
					albumids.push result.album_key
				# albumids = []
				# albumids.push "46CC6843"
				# albumids.push "PLGGW8C0"
				
				@stats.totalItems = albumids.length
				for id in albumids
					@updateSongsStatsFromAlbumPage id


	showStats : ->
		@_printTableStats KE_CONFIG.table


module.exports = Keeng
