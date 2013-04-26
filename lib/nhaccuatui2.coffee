http = require 'http'
xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require 'colors'
fs = require 'fs'

Encoder = require('node-html-encoder').Encoder
encoder = new Encoder('entity');

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
			_insertIntoNCTAlbums : "INSERT IGNORE INTO " + @table.Albums + " SET ?"
			_insertIntoNCTVideos : "INSERT IGNORE INTO " + @table.Videos + " SET ?"
			_insertIntoNCTSongs_Albums : "INSERT INTO " + @table.Songs_Albums + " SET ?"
			_insertIntoNCTMVs : "INSERT INTO " + @table.MVs + " SET ?"
			_insertIntoNCTMVPlaylists : "INSERT INTO " + @table.MVPlaylists + " SET ?"
			_insertIntoNCTMVs_MVPlaylists : "INSERT INTO " + @table.MVs_MVPlaylists + " SET ?"
		@utils = new Utils()
		@parser = new xml2js.Parser();
		super @mysqlConfig
		@logPath = @config.logPath
		@log = {}
		@_readLog()
		


	_printUpdateAlbum : (info) ->
			tempDuration = Date.now() - @stats.markedTimer
			message  = " |"+"#{info}".inverse.magenta
			message += " | t:"  + @utils._getTime(tempDuration)
			message += "\r"
			process.stdout.write message

	_storeSong : (songs) ->
		try
			for song in songs
				do (song) =>
					@connection.query @query._insertIntoNCTSongs, song, (err)=>
						if err then console.log "Cannot insert song #{song.song_key}"
						else 
							@_updateSongPlays song.songid
							# @_updateSongLinkKey song.song_key
		catch e 
			console.log "Cannt insert new song in album: #{songs[0].album_key}. ERROR: #{e} "
	_updateSongPlays : (songid)->
		link = "http://www.nhaccuatui.com/wg/get-counter?listSongIds=#{songid}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try 
						data = JSON.parse data
						_q = "update #{@table.Songs} SET plays=#{data.data.songs[songid]} where songid=#{songid}"
						data  = ""
						@connection.query _q, (err)->
							if err then console.log "Cannt update the total plays of the song #{songid} into database. ERROR: #{err}"
					catch e 
						console.log "Cannot udpate plays of the song: #{songid} has an error: #{e}"
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	_updateAlbumPlays : (albumid)->
		link = "http://www.nhaccuatui.com/wg/get-counter?listPlaylistIds=#{albumid}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try 
						data = JSON.parse data
						_q = "update #{@table.Albums} SET plays=#{data.data.playlists[albumid]} where albumid=#{albumid}"
						data  = ""
						@connection.query _q, (err)->
							if err then console.log "Cannt update the total plays of the Album #{albumid} into database. ERROR: #{err}"
					catch e 
						console.log "Album #{albumid} has an error: #{e}"
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	_updateAlbumTopic : (album) ->
		try 
			_q = "update #{@table.Albums} SET albumid=#{album.albumid}, " +
									 " nsongs=#{album.nsongs}, " +
									 " topic=#{@connection.escape(album.topic)}, " +
									 " genre=#{@connection.escape(album.genre)}, " +
									 " artist_list=#{@connection.escape(album.artist_list)}," + 
									 " link_key=#{@connection.escape(album.link_key)}" + 
									 " WHERE album_key=#{@connection.escape(album.album_key)}"
			@connection.query _q ,(err)=>
				if err then console.log "Cannot update album topic #{album.album_key}. ERROR: #{err}"
				else @_updateAlbumPlays album.albumid
		catch e 
			console.log "Cannt update album topic: #{album.album_key}. ERROR: #{e} "

	#--------------------------------
	#Using with fetchVideosByArtist |
	#--------------------------------
	_fetchVideosByArtist : (artistName,page = 1) ->
		link = "http://www.nhaccuatui.com/tim-kiem/mv?q=#{artistName}&b=singer&page=#{page}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@stats.totalItemCount +=1
					if not data.match(/Tìm\sđược\s0\skết\squả/) and data isnt ''
						# console.log "#{artistName}: current Page: #{page}".red
						# try 
							if data.match(/<a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/mv.+/g)
								arr = data.match(/<a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/mv.+/g)
								videos = []
								thumbs = []
								durations = []

								for item, index in arr
									videos.push item if index%2 is 0
								
								if  data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
									thumbs = data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
									thumbs[i] = thumb.replace(/src\=\"|\"\swidth/g,'') for thumb, i in thumbs
								else 
									thumbs[i] = '' for video, i in videos
									console.log "#{artistName}: current Page: #{page} has no thummbinial"

								if data.match(/<a\s.+www\.nhaccuatui\.com\/tim\-kiem.+/g)
									video_artists = data.match(/<a\s.+www\.nhaccuatui\.com\/tim\-kiem.+/g)
									for _artist, index in video_artists
										video_artists[index] = _artist.split(/\>\,\s</g).map (v)->
											v.replace(/a\shref.+_blank\"\>|\/a|<\/p\>|<|\>/g,'')
								else 
									video_artists[i] = '' for video, i in albums
									console.log "#{XXXXXXXX}: current Page: #{page} has no artists names"

								if data.match(/<\!\-\-<div\sclass\=\"times\"\>.+/g)
									durations = data.match(/<\!\-\-<div\sclass\=\"times\"\>.+/g)
													.map (v)->
														v = v.replace(/<\!\-\-<div\sclass\=\"times\"\>|<\/div\>\-\-\>/g,'').split(':')
														time = parseInt(v[0],10)*60 + parseInt(v[1],10)

								else 
									durations[i] = '' for video, i in videos

								# console.log JSON.stringify durations
								
								@stats.passedItemCount +=1
								for video, index in videos
									_video = 
										artist : encoder.htmlDecode artistName
									if video.match(/<a.+\.html/)
										_video.video_key = video.match(/<a.+\.html/)[0].replace(/\.html/g,'').replace(/<a.+\./,'')
									else _video.video_key = ''

									if video.match(/title\=.+\"\>/)
										_video.video_name = encoder.htmlDecode video.match(/title\=.+\"\>/)[0].replace(/title\=\"|\"\>/g,'')
									else _video.video_name = ''
									_video.thumbnail = thumbs[index]
									_video.video_artists = JSON.stringify video_artists[index]
									_video.duration = durations[index]
									if _video.thumbnail
										if _video.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)
											_video.created = _video.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)[0].replace(/\//g,'-')
										else if _video.thumbnail.match(/\d{4}_\d{2}\//g)
											_video.created = _video.thumbnail.match(/\d{4}_\d{2}\//g)[0].replace(/_/g,':').replace(/\//g,'')
											_video.created += ":01"
									@connection.query @query._insertIntoNCTVideos, _video, (err)->
										if err then console.log "Cannot insert video:#{_video.videoid} to table. ERROR: #{err}".red
							else console.log "#{artistName}: has no video at current Page: #{page} ".red

								# @_fetchAlbum _video
								# console.log _video
							# console.log "#{artistName}: current Page: #{page} has #{videos.length} --------------------".red

							# callback if page is greater than 1
							if page is 1
								if data.match(/Tìm\sđược\s.+\skết\squả/g)
									foundItems = data.match(/Tìm\sđược\s.+\skết\squả/g)[0].replace(/Tìm\sđược\s|\skết\squả|\,/g,'')
									foundItems = parseInt foundItems, 10
									if foundItems%20 is 0
										totalPage = foundItems/20
									else totalPage = Math.floor(foundItems/20)+1
									if totalPage > 50 then totalPage = 50
								else totalPage = 1
								
								# console.log "#{artistName} has #{totalPage} page(s) ".red
								@_fetchVideosByArtist artistName, p for p in [2..totalPage] if totalPage > 1
							data = ""
						# catch e
						# 	console.log "ERROR at artist: #{artistName}. Error: #{e}".red
						

					else
						@stats.failedItemCount+=1
						# console.log "ARTIST: #{artistName} does not exit". magenta
					
					@utils.printRunning @stats
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats

			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	#--------------------------------
	_fetchAlbumByTopic : (topicLink,page = 1) ->
		link = topicLink + page

		XXXXXXXX = "FAKE VAR"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					
					# console.log "#{XXXXXXXX}: current Page: #{page}".red
					# try 
					if data.match(/<h3\><a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/playlist.+/g)
						albums = data.match(/<h3\><a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/playlist.+/g)
						thumbs = []
						artists = []
						if  data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
							thumbs = data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
							thumbs[i] = thumb.replace(/src\=\"|\"\swidth/g,'') for thumb, i in thumbs
						else 
							thumbs[i] = '' for album, i in albums
							console.log "#{XXXXXXXX}: current Page: #{page} has no thumbnail"
						if data.match(/<a\s.+www\.nhaccuatui\.com\/tim\-kiem.+/g)
							artists = data.match(/<a\s.+www\.nhaccuatui\.com\/tim\-kiem.+/g)
							for _artist, index in artists
								artists[index] = _artist.split(/\>\,\s</g).map (v)->
									v.replace(/a\shref.+_blank\"\>|\/a|<\/p\>|<|\>/g,'')
						else 
							artists[i] = '' for album, i in albums
							console.log "#{XXXXXXXX}: current Page: #{page} has no artists names"


						
						for album, index in albums
							@stats.totalItemCount +=1
							@stats.passedItemCount +=1
							_album = 
								artist : encoder.htmlDecode JSON.stringify artists[index]
							if album.match(/<a.+\.html/)
								_album.album_key = album.match(/<a.+\.html/)[0].replace(/\.html/g,'').replace(/<a.+\./,'')
							else _album.album_key = ''

							if album.match(/title\=.+\"\>/)
								_album.title = encoder.htmlDecode album.match(/title\=.+\"\>/)[0].replace(/title\=\"|\"\>/g,'')
							else _album.title = ''
							_album.thumbnail = thumbs[index]

							if _album.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)
								_album.created = _album.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)[0].replace(/\//g,'-')
							if _album.thumbnail.match(/\/\d+\.jpg$/g)
								_t = new Date(parseInt(_album.thumbnail.match(/\/\d+\.jpg/g)[0].replace(/\/|\.jpg/g,'')))
								_album.created += " " + _t.getHours() + ":" + _t.getMinutes() + ":" + _t.getSeconds()
							@connection.query @query._insertIntoNCTAlbums, _album, (err)->
							 	if err then console.log "Cannot insert album:#{_album.album_key} to table. ERROR: #{err}".red
							
							@utils.printRunning @stats
							# console.log _album
						
						
					else console.log "#{XXXXXXXX}: has no album at current Page: #{page} ".red

						
					data = ""
					# catch e
					# 	console.log "ERROR at artist: #{XXXXXXXX}. Error: #{e}".red
					
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats

			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	fetchAlbumByTopic : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching albums'data  to table: #{@table.Albums}".magenta

		# topics = "playlist-moi nhac-tre tru-tinh cach-mang tien-chien nhac-trinh thieu-nhi rap-viet rock-viet khong-loi au-my han-quoc nhac-hoa nhac-nhat nhac-phim the-loai-khac".split(' ')
		# link = "http://www.nhaccuatui.com/playlist/nhac-tre.html?page="
		# link2 = "http://www.nhaccuatui.com/playlist/nhac-tre.html?sort=1&page"
		topics = "ana".split(',')
		url = "http://www.nhaccuatui.com/playlist/"
		
		@stats.totalItems = 123617263187
		@stats.currentTable = @table.Albums
		for topic in topics
			# link1 =  url + topic + ".html" + "?page="
			# link2 =  url + topic + ".html" + "?sort=1&page="
			link1 = "http://www.nhaccuatui.com/tim-nang-cao?title=&singer=&user=lee_00&kbit=&type=3&sort=&direction=&page="
			link2 = "http://www.nhaccuatui.com/tim-nang-cao?title=&singer=&user=thienhasaxoi&kbit=&type=2&sort=&direction=&page="
			link3 = "http://www.nhaccuatui.com/tim-nang-cao?title=&singer=&user=anime-club&kbit=&type=2&sort=&direction=&page="
			link4 = "http://www.nhaccuatui.com/tim-nang-cao?title=&singer=&user=belinh909&kbit=&type=2&sort=&direction=&page="
			for page in [1..34]
				@_fetchAlbumByTopic link1, page
				@_fetchAlbumByTopic link2, page
				@_fetchAlbumByTopic link3, page
				@_fetchAlbumByTopic link4, page

		null
	####------------------------------------
	#get album by author
	_fetchAlbumByAuthor : (topicLink,page = 1) ->
		link = topicLink + page
		# console.log link
		XXXXXXXX = "FAKE VAR"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					
					# console.log "#{XXXXXXXX}: current Page: #{page}".red
					# try 
					if data.match(/<h3\><a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/playlist.+/g)
						albums = data.match(/<h3\><a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/playlist.+/g)
						thumbs = []
						artists = []
						if  data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
							thumbs = data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
							thumbs[i] = thumb.replace(/src\=\"|\"\swidth/g,'') for thumb, i in thumbs
						else 
							thumbs[i] = '' for album, i in albums
							console.log "#{XXXXXXXX}: current Page: #{page} has no thumbnail"
						if data.match(/<p\><a\s.+www\.nhaccuatui\.com\/tim\-kiem.+/g)
							artists = data.match(/<p\><a\s.+www\.nhaccuatui\.com\/tim\-kiem.+/g)
							for _artist, index in artists
								artists[index] = _artist.split(/\>\,\s</g).map (v)->
									v.replace(/a\shref.+_blank\"\>|\/a|<\/p\>|<p\>|<|\>/g,'')
						else 
							artists[i] = '' for album, i in albums
							# console.log "#{XXXXXXXX}: current Page: #{page} has no artists names"


						
						for album, index in albums
							@stats.totalItemCount +=1
							@stats.passedItemCount +=1
							_album = 
								artist : encoder.htmlDecode JSON.stringify artists[index]
							if album.match(/<a.+\.html/)
								_album.album_key = album.match(/<a.+\.html/)[0].replace(/\.html/g,'').replace(/<a.+\./,'')
							else _album.album_key = ''

							if album.match(/title\=.+\"\>/)
								_album.title = encoder.htmlDecode album.match(/title\=.+\"\>/)[0].replace(/title\=\"|\"\>/g,'')
							else _album.title = ''
							_album.thumbnail = thumbs[index]

							if _album.thumbnail 
								if _album.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)
									_album.created = _album.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)[0].replace(/\//g,'-')
								if _album.thumbnail.match(/\/\d+\.jpg$/g)
									_t = new Date(parseInt(_album.thumbnail.match(/\/\d+\.jpg/g)[0].replace(/\/|\.jpg/g,'')))
									_album.created += " " + _t.getHours() + ":" + _t.getMinutes() + ":" + _t.getSeconds()
							# console.log _album
							@connection.query @query._insertIntoNCTAlbums, _album, (err)->
							 	if err then console.log "Cannot insert album:#{_album.album_key} to table. ERROR: #{err}".red
							
							@utils.printRunning @stats
							# console.log _album
						
						
					# else console.log "#{XXXXXXXX}: has no album at current Page: #{page} ".red

						
					data = ""
					# catch e
					# 	console.log "ERROR at artist: #{XXXXXXXX}. Error: #{e}".red
					
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats

			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	fetchAlbumByAuthor : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching albums'data  to table: #{@table.Albums}".magenta

		# topics = "playlist-moi nhac-tre tru-tinh cach-mang tien-chien nhac-trinh thieu-nhi rap-viet rock-viet khong-loi au-my han-quoc nhac-hoa nhac-nhat nhac-phim the-loai-khac".split(' ')
		# link = "http://www.nhaccuatui.com/playlist/nhac-tre.html?page="
		# link2 = "http://www.nhaccuatui.com/playlist/nhac-tre.html?sort=1&page"
		
		authors = "lee_00 thienhasaxoi anime-club belinh909 anime47 bluemoon_xx thangtin00 hestiasama witaolaonct iamjustguysbaka xuka_333 tinhlagi03357 ancotls m0nk3yt diaphilong3 quocbao88513 thansam962 loveforever010609012012 hongmiu1137 dacvu121 nguyenpro221992 nhutno.one annabelle_nguyen gared99 saovayhuy suzeria iambota91".split(' ')
		url = "http://www.nhaccuatui.com/playlist/"
		console.log authors.length
		@stats.totalItems = 123617263187
		@stats.currentTable = @table.Albums
		for author in authors
			# link1 =  url + topic + ".html" + "?page="
			# link2 =  url + topic + ".html" + "?sort=1&page="			
			for page in [1..34]
				link = "http://www.nhaccuatui.com/tim-nang-cao?title=&singer=&user=" + author + "&kbit=&type=2&sort=&direction=&page="
				@_fetchAlbumByAuthor link, page
		null	
	#---------------------------------------
	_fetchArtist : (artistName,page = 1) ->
		link = "http://www.nhaccuatui.com/tim-kiem/playlist?q=#{artistName}&b=singer&page=#{page}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@stats.totalItemCount +=1
					if not data.match(/Tìm\sđược\s0\skết\squả/) and data isnt ''
						# console.log "#{artistName}: current Page: #{page}".red
						# try 
							if data.match(/<a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/playlist.+/g)
								arr = data.match(/<a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/playlist.+/g)
								albums = []
								thumbs = []

								for item, index in arr
									albums.push item if index%2 is 0
								
								if  data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
									thumbs = data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
									thumbs[i] = thumb.replace(/src\=\"|\"\swidth/g,'') for thumb, i in thumbs
								else 
									thumbs[i] = '' for album, i in albums
									console.log "#{artistName}: current Page: #{page} has no thummbinial"
								
								@stats.passedItemCount +=1
								for album, index in albums
									_album = 
										artist : encoder.htmlDecode artistName
									if album.match(/<a.+\.html/)
										_album.albumid = album.match(/<a.+\.html/)[0].replace(/\.html/g,'').replace(/<a.+\./,'')
									else _album.albumid = ''

									if album.match(/title\=.+\"\>/)
										_album.title = encoder.htmlDecode album.match(/title\=.+\"\>/)[0].replace(/title\=\"|\"\>/g,'')
									else _album.title = ''
									_album.thumbnail = thumbs[index]
									@connection.query @query._insertIntoNCTAlbums, _album, (err)->
										if err then console.log "Cannot insert album:#{_album.albumid} to table. ERROR: #{err}".red
							else console.log "#{artistName}: has no album at current Page: #{page} ".red

								# @_fetchAlbum _album
								# console.log _album
							# console.log "#{artistName}: current Page: #{page} has #{albums.length} --------------------".red

							# callback if page is greater than 1
							if page is 1
								if data.match(/Tìm\sđược\s.+\skết\squả/g)
									foundItems = data.match(/Tìm\sđược\s.+\skết\squả/g)[0].replace(/Tìm\sđược\s|\skết\squả|\,/g,'')
									foundItems = parseInt foundItems, 10
									if foundItems%20 is 0
										totalPage = foundItems/20
									else totalPage = Math.floor(foundItems/20)+1
									if totalPage > 50 then totalPage = 50
								else totalPage = 1
								
								# console.log "#{artistName} has #{totalPage} page(s) ".red
								@_fetchArtist artistName, p for p in [2..totalPage] if totalPage > 1
							data = ""
						# catch e
						# 	console.log "ERROR at artist: #{artistName}. Error: #{e}".red
						

					else
						@stats.failedItemCount+=1
						# console.log "ARTIST: #{artistName} does not exit". magenta
					
					@utils.printRunning @stats
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats

			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	fetchArtist : () =>
		@connect()
		artists = fs.readFileSync "./log/test/artist.txt" , "utf8"
		artists = JSON.parse artists
		console.log " |"+"Fetching artists, albums  to table: #{@table.Albums}".magenta
		@stats.totalItems = artists.length
		@stats.currentTable = @table.Songs
		@_fetchArtist name for name in artists
		null
	#---------------------------------------
	_updateAlbumStatsAndInsertSongs : (album) ->
		link = "http://www.nhaccuatui.com/playlist/joke-link.#{album.album_key}.html"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try
						if data.match(/<p\sclass\=\"category\"\>Thể\sloại\:.+/g)
							_info = data.match(/<p\sclass\=\"category\"\>Thể\sloại\:.+/g)[0].split('|')
							album.topic = _info[0].replace(/<p.+\"\>|<\/a\>/g,'').trim()
							album.nsongs = parseInt _info[2].replace(/Số\sbài\:\s|<\/p\>/g,'').trim(), 10
						else 
							album.topic = ''
							album.nsongs = 0

						if data.match(/flashPlayer\"\,\s\"playlist.+/g)
							album.link_key = data.match(/flashPlayer\"\,\s\"playlist.+/g)[0].replace(/flashPlayer.+playlist|0\..+|\s|\"|\,/g,'')
						else album.link_key = ""

						if data.match(/inpHiddenGenre/g)
							album.genre = data.match(/inpHiddenGenre.+/g)[0].replace(/inpHiddenGenre.+value\=|\"|\s\/\>/g,'')
						else album.genre = ''

						if data.match(/inpHiddenSingerIds/g)
							album.artist_list = JSON.stringify data.match(/inpHiddenSingerIds.+/g)[0].replace(/inpHiddenSingerIds.+value\=|\"|\s\/\>/g,'').split(',').map((v)->encoder.htmlDecode v)
						else album.artist_list = ''

						# if data.match(/value.+inpHiddenId/g)
						# 	album.albumid = data.match(/value.+inpHiddenId/g)[0].replace(/\"\s.+$/g,'').replace(/value\=\"/,'')
						# else album.albumid = 0

						if data.match(/rel\=\"\d+\"\skey=.+/g)
							_songs = data.match(/rel\=\"\d+\"\skey=.+/g)
							songs = []
							for _song, index in _songs
								_temp = _song.replace(/class.+/g,'')
								_d =
									albumid : album.albumid
									album_key : album.album_key
									genre : album.genre
									topic : album.topic
									artists : album.artist_list
									song_artists : JSON.stringify _temp.match(/singer.+/)[0].replace(/singer\=\"|\"/g,'').split(',').map (v)-> 
													v = v.trim()
													encoder.htmlDecode v
									song_name : encoder.htmlDecode _temp.match(/relTitle.+singer/g)[0].replace(/relTitle\=\"|\"\ssinger/g,'')
									song_key : _temp.match(/key.+relTitle/g)[0].replace(/key\=\"|\"\srelTitle/g,'')
									songid : _temp.match(/rel.+key/g)[0].replace(/rel\=\"|\"\skey/g,'')
								songs.push _d
						else _songs= ''
						data = ''
						# @_updateAlbumTopic album
						album.totalMvs = 0
						songs_albums =  []
						for song, index in songs
							_songs_albums =
								songid : song.songid
								albumid : song.albumid
							delete song.albumid
							delete song.album_key
							songs_albums.push(_songs_albums)
							if index is songs.length-1
								@_updateSongLinkKey song, songs, album, songs_albums,  true
							else 
								# console.log index
								@_updateSongLinkKey song, songs, album, songs_albums
						
						
					catch e
						console.log ""
						console.log "ERROR while updating Album Stats And Inserting Songs. Album key: #{album.album_key}. ERROR: #{e}"
					
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	updateAlbumStatsAndInsertSongs : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching albums'data  to table: #{@table.Albums}".magenta
		@connection.query "select album_key from NCTAlbums where plays is null",(err, albums)=>
			if err then console.log "CANNT get albums from database"
			else
				@stats.totalItems = albums.length
				console.log albums.length + "----------"
				@stats.currentTable = @table.Albums
				for album, index in albums
					@_updateAlbumStatsAndInsertSongs album.album_key
		null		
	#---------------------------------------
	_fetchArtistProfile : (artistName) ->
		link = "http://mp3.Nhaccuatui.vn/nghe-si/#{artistName}/tieu-su"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@stats.totalItemCount +=1
					if res.statusCode isnt 302 and res.statusCode isnt 400
						# console.log "#{artistName}: current Page: #{page}".red
						
						try 
							@stats.passedItemCount +=1
							artist = 
								name : artistName
							if data.match(/\<li\>\<span\>Tên\sthật\:.+/g)
								artist.real_name = data.match(/\<li\>\<span\>Tên\sthật\:.+/g)[0]
														.replace(/\<li\>\<span\>Tên\sthật\:|\<\/span\>|\<\/li\>/g,'').trim()
							else artist.real_name = ""
							if data.match(/\<li\>\<span\>Ngày\ssinh\:.+/g)
								artist.dateofbirth = data.match(/\<li\>\<span\>Ngày\ssinh\:.+/g)[0]
														.replace(/\<li\>\<span\>Ngày\ssinh\:|\<\/span\>|\<\/li\>/g,'').trim()
														.split('/').reverse().join('-')
							else artist.dateofbirth = ""
							if data.match(/Công\sty\sđại\sdiện\:.+/)
								artist.publisher = data.match(/Công\sty\sđại\sdiện\:.+/)[0]
														.replace(/Công\sty\sđại\sdiện\:|\<\/span\>|\<\/p\>/g,'').trim()
							else artist.publisher = ''
							if data.match(/\<li\>\<span\>Quốc\sGia\:.+/g)
								artist.country = data.match(/\<li\>\<span\>Quốc\sGia\:.+/g)[0]
														.replace(/\<li\>\<span\>Quốc\sGia\:|\<\/li\>|\<\/span\>/g,'').trim()
							else artist.country = ''

							if data.match(/Thể\sloại\:\<\/span\>.+/g)
								_topics = data.match(/Thể\sloại\:\<\/span\>.+/g)[0]
													.replace(/Thể\sloại\:.|\/span\>|\<\/li\>/g,'').split(',')
								arr = []
								arr.push _topic.replace(/\<a.+\"\>|\<\/a\>/g,'').trim() for _topic in _topics
								artist.topic = JSON.stringify arr
							else artist.topic = ''

							
							data = data.replace(/\r|\t|\n/g,'')

							if data.match(/Thông\stin\schi\stiết.+\<div\sclass\=\"new\-sidebar\"\>/)
								_chunks = data.match(/Thông\stin\schi\stiết.+\<div\sclass\=\"new\-sidebar\"\>/g)[0]
														.replace(/Thông\stin\schi\stiết\<\/span\>\<\/p\>\<div\sclass\=\"clear\-fix\"\>\<\/div\>|\<div\sclass\=\"new\-sidebar\"\>/g,'')
														.replace(/\<\/div\>\<\/div\>\<\/div\>/,'')
														.split(/\<a\shref/)
								arr = []
								arr.push _chunk.replace(/\=\"\/tim\-kiem.+\"\>|\<\/a\>|\<strong\>|\<\/strong\>/g,'').trim() for _chunk in _chunks
								artist.description = arr.join(' ')
							
							@connection.query @query._insertIntoZIArtists, artist , (err)->
								if err then console.log "Cannot insert artist #{artistName} into table. Error: #{err}"

						catch e
							"ERROR: Cannot fetch a profile of artist: #{artistName}".red
						

					else
						@stats.failedItemCount+=1
						# console.log "ARTIST: #{artistName} does not exit". magenta
					
					@utils.printRunning @stats
					if @stats.totalItemCount is @stats.totalItems
					 	@utils.printFinalResult @stats

			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	fetchArtistProfile : () ->
		@connect()
		artists = fs.readFileSync "./log/test/artist.txt" , "utf8"
		artists = JSON.parse artists
		console.log " |"+"Fetching artists profile table: #{@table.Artists}".magenta
		@stats.totalItems = artists.length
		@stats.currentTable = @table.Artists
		@_fetchArtistProfile name for name in artists
		null
	#---------------------------------------
	_fetchSongsPlays : (ids)->
		idList = ids.join(',')
		link = "http://www.nhaccuatui.com/wg/get-counter?listSongIds=#{idList}"
		# console.log link
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try 
						data = JSON.parse data

						for id in ids
							# console.log id
							_q = "update #{@table.Songs} SET plays=#{data.data.songs[id]} where songid=#{id};"
							# console.log _q
							@stats.passedItemCount +=1
							@stats.totalItemCount +=1
							@stats.currentId = id
							@utils.printRunning @stats
							@connection.query _q, (err)=>
								if err  
									# console.log "Cannot update the total plays of the Album #{id} into database. ERROR: #{err}"
									@stats.failedItemCount +=1
							
						data = ""
						if @stats.totalItems is @stats.totalItemCount
								@utils.printFinalResult @stats
					catch e 
						console.log "Album has an error: #{e}"
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	fetchSongsPlays : ()->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching albums'data  to table: #{@table.Songs}".magenta
		_q = "Select songid from NCTSongs where plays is null"
		@connection.query _q, (err, songs)=>
			if err then console.log "CANNT get songs from database"
			else
				@stats.totalItems = songs.length
				console.log songs.length + "----------"
				@stats.currentTable = @table.songs
				a = []
				for song, index in songs
					a.push song.songid
					if index%200 is 0
							@_fetchSongsPlays a 
							a = []
	##-------------------------------------------
	_updateSongIds :(item)->
		try
			_query = "select id from #{@table.Songs} where albumid=#{@connection.escape(item.albumid)} order by id asc"
			@connection.query _query, (err,songs)=>
				if err then console.log "Cannt update songids, ERROR: #{err}"
				else 
					for i in [0..songs.length-1]
						_q = "update #{@table.Songs} set songid=#{@connection.escape(item.songids[i])} where id=#{songs[i].id}"
						@connection.query  _q, (err)=>
							if err then console.log "CANNT UPDATE songid. ERROR: #{err}"
		catch e
			console.log "CAN NOT update songids in album: #{item.albumid}. ERROR: #{e}".red
	_updateAlbumLinkKey : (album_key)->
		link = "http://www.nhaccuatui.com/playlist/joke-link.#{album_key}.html"
		# console.log link
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try 
						if data.match(/flashPlayer\"\,\s\"playlist.+/g)
							link_key = data.match(/flashPlayer\"\,\s\"playlist.+/g)[0].replace(/flashPlayer.+playlist|0\..+|\s|\"|\,/g,'')
						else link_key = ""
						data = ""
						_q = "update #{@table.Albums} SET link_key=#{@connection.escape(link_key)} where album_key=#{@connection.escape(album_key)};"
						# console.log _q
						@connection.query _q, (err)=>
							if err  
								consolqe.log "Cannot update the link key of the Album #{album_key} into database. ERROR: #{err}"
								# @stats.failedItemCount +=1
						data = ""
					catch e 
						console.log "Album has an error: #{e}"
			.on 'error', (e) =>
				console.log  "Got error: " + e.message	
	updateAlbumLinkKey : ()->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching albums'data  to table: #{@table.Albums}".magenta
		_q = "Select album_key from #{@table.Albums}"
		@connection.query _q, (err, albums)=>
			if err then console.log "CANNT get albums from database"
			else
				@stats.totalItems = albums.length
				console.log albums.length + "----------"
				@stats.currentTable = @table.Albums
				for album, index in albums
					# if index < 10
						@_updateAlbumLinkKey album.album_key 
	
	#-----------------------------------------------
	#update type and link_key of song
	#if song.type is song then check if song exists, update song plays and insert into table Songs_Albums 
	#if song.type is music video then put into table video
	#
	_updateSongLinkKey : (song, songs, album, songs_albums, isLastItem)->
		link = "http://www.nhaccuatui.com/bai-hat/joke-link.#{song.song_key}.html"
		# console.log link
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try 

						if data.match(/value.+inpHiddenType/g)
							song.type = data.match(/value.+inpHiddenType/g)[0].replace(/value\=\"|\"\sid\=\"inpHiddenType/g,'')
						else song.type = ""

						if data.match(/flashPlayer\"\,\s\".+/g)
							song.link_key = data.match(/flashPlayer\"\,\s\".+/g)[0].replace(/0\..+/g,'').replace(/\s\"/g,'').replace(/\"\,$/g,'').replace(/flashPlayer.+\,/g,'')
						else song.link_key = ""

						data = ""
						
						if song.type is 'mv' then album.totalMvs += 1
						if isLastItem is true then @_writeLog @log
						
						if isLastItem is true and album.totalMvs is 0
							delete album.totalMvs
							@connection.query @query._insertIntoNCTAlbums, album, (err)=>
								if err then console.log "Cannt insert album into table. ERROR: #{err}"
								else 
									@_updateAlbumPlays album.albumid
									for song, index in songs
								 		do (song, index) =>
									 		@connection.query @query._insertIntoNCTSongs, song, (err)=>
												if err then console.log "Cannot insert song #{song.song_key}. Error: #{err}"
												else 
													@_updateSongPlays song.songid
													@connection.query @query._insertIntoNCTSongs_Albums, songs_albums[index], (err)=>
														if err then console.log "cannt insert into songs_albums. #{JSON.stringify songs_albums[index]} Error: #{err}"

						else 
							if isLastItem is true and album.totalMvs isnt 0
								if album.totalMvs is album.nsongs
									delete album.totalMvs
									@connection.query @query._insertIntoNCTMVPlaylists, album, (err)=>
										if err then console.log "Cannt insert album into table. ERROR: #{err}"
										else 
											# @_updateAlbumPlays album.albumid
											for song, index in songs
										 		do (song, index) =>
										 			video =
										 				videoid : song.songid
										 				video_key : song.song_key
										 				video_name : song.song_name
										 				video_artists : song.song_artists
										 				plays : song.plays
										 				artists : song.artists
										 				topic : song.topic
										 				genre : song.genre
										 				type : song.type
										 				link_key : song.link_key

											 		@connection.query @query._insertIntoNCTMVs, video, (err)=>
														if err then console.log "Cannot insert video #{video.video_key}. Error: #{err}"
														else 
															@_updateVideosPlays video.videoid
															video_album = 
																videoid : songs_albums[index].songid
																albumid : songs_albums[index].albumid
															@connection.query @query._insertIntoNCTMVs_MVPlaylists, video_album, (err)=>
																if err then console.log "cannt insert into video_album. #{JSON.stringify songs_albums[index]} Error: #{err}"
								else 
									# this is used for special case when an album has songs and videos. We prefer songs
									# therefore we will insert into table album
									delete album.totalMvs
									@connection.query @query._insertIntoNCTAlbums, album, (err)=>
										if err then console.log "Cannt insert album into table. ERROR: #{err}"
										else 
											@_updateAlbumPlays album.albumid
											for song, index in songs
										 		do (song, index) =>
										 			# only insert song, if type is music video then we dont have to do it
										 			# 'cause we are gonna update video later
											 		if song.type isnt 'mv'
												 		@connection.query @query._insertIntoNCTSongs, song, (err)=>
															if err then console.log "Cannot insert song #{song.song_key}. Error: #{err}"
															else 
																@_updateSongPlays song.songid
																@connection.query @query._insertIntoNCTSongs_Albums, songs_albums[index], (err)=>
																	if err then console.log "cannt insert into songs_albums. #{JSON.stringify songs_albums[index]} Error: #{err}"
					catch e 
						console.log "Album has an error: #{e}"
						console.log "#{JSON.stringify album}".red
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	updateSongLinkKey : ()->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching albums'data  to table: #{@table.Songs}".magenta
		_q = "Select song_key from #{@table.Songs}"
		@connection.query _q, (err, songs)=>
			if err then console.log "CANNT get songs from database"
			else
				@stats.totalItems = songs.length
				console.log songs.length + "----------"
				@stats.currentTable = @table.Songs
				for song, index in songs
					@_updateSongLinkKey song.song_key 
	#-----------------------------------------------
	_updateVideoLinkKey : (video)->
		link = "http://www.nhaccuatui.com/mv/joke-link.#{video.video_key}.html"
		# console.log link
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try 

						if data.match(/value.+inpHiddenType/g)
							type = data.match(/value.+inpHiddenType/g)[0].replace(/value\=\"|\"\sid\=\"inpHiddenType/g,'')
						else type = ""

						if data.match(/value.+inpHiddenId/g)
							videoid = data.match(/value.+inpHiddenId/g)[0].replace(/value\=\"|\"\sid\=\"inpHiddenId/g,'')
						else videoid = ""

						if data.match(/flashPlayer\"\,\s\".+/g)
							link_key = data.match(/flashPlayer\"\,\s\".+/g)[0].replace(/0\.\d.+/g,'').replace(/\s\"/g,'').replace(/\"\,$/g,'').replace(/flashPlayer.+\,/g,'')
						else link_key = ""

						if data.match(/inpHiddenGenre.+/g)
							genre = data.match(/inpHiddenGenre.+/g)[0].replace(/inpHiddenGenre.+value\=|\"|\"\s\/\>|\s\/\>/g,'')
						else genre = ''

						data = ""

						video.type = type
						video.link_key = link_key
						video.videoid = videoid
						video.genre = genre

						@stats.passedItemCount += 1
						@stats.totalItemCount += 1

						@connection.query @query._insertIntoNCTVideos, video, (err)=>
								if err then console.log "Cannot insert video:#{_video.videoid} to table. ERROR: #{err}".red
								else @_updateVideosPlays video.videoid

						@utils.printUpdateRunning video.video_key, @stats, "Fetching..."
						if @stats.totalItemCount is @stats.totalItems
							@utils.printFinalResult @stats

					catch e 
						console.log "Video has an error: #{e}"
						@stats.failedItemCount +=1
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount +=1
	updateVideoLinkKey : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching Videos'data  to table: #{@table.Videos}".magenta
		_q = "Select video_key from #{@table.Videos}"
		@connection.query _q, (err, videos)=>
			if err then console.log "CANNT get videos from database"
			else
				@stats.totalItems = videos.length
				console.log videos.length + "----------"
				@stats.currentTable = @table.Videos
				for album, index in videos
					# if index < 10
						@_updateVideoLinkKey album.video_key 
	#-----------------------------------------
	
	## Fetch video from file, take from the site and put into database
	fetchVideosByArtist : () =>
		@connect()
		artists = fs.readFileSync "./log/test/artist.txt" , "utf8"
		artists = JSON.parse artists
		console.log " |"+"Fetching artists, albums  to table: #{@table.Videos}".magenta
		@stats.totalItems = artists.length
		@stats.currentTable = @table.Songs
		@_fetchVideosByArtist name for name in artists
		null
	#-----------------------------------------------------------
	_updateVideosPlays : (ids)->
		if ids.join?
			idList = ids.join?(',')
		else 
			idList = ids
			ids = ids.split(' ')
		link = "http://www.nhaccuatui.com/wg/get-counter?listSongIds=#{idList}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try 
						data = JSON.parse data
						for id in ids
							# console.log id
							_q = "update #{@table.Videos} SET plays=#{data.data.songs[id]} where videoid=#{id};"
							@connection.query _q, (err)=>
								if err  
									console.log "Cannot update the total plays of the Video #{id} into database. ERROR: #{err}"
						data = ""
					catch e 
						console.log "Video has an error: #{e}"
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	updateVideosPlays : ()->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching albums'data  to table: #{@table.Videos}".magenta
		_q = "Select videoid from NCTVideos"
		@connection.query _q, (err, videos)=>
			if err then console.log "CANNT get videos from database"
			else
				@stats.totalItems = videos.length
				console.log videos.length + "----------"
				@stats.currentTable = @table.Videos
				a = []
				for video, index in videos
					a.push video.videoid
					if index%1 is 0
							@_updateVideosPlays a 
							a = []
	#---------------------------------------------------------------------------------
	_fetchVideoByTopic : (topicLink,page = 1) ->
		link = topicLink + page

		XXXXXXXX = "FAKE VAR"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					if data.match(/<a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/mv.+/g)
						arr = data.match(/<a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/mv.+/g)
						videos = []
						thumbs = []
						durations = []
						video_artists = []

						for item, index in arr
							videos.push item if index%2 is 0
						
						if  data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
							thumbs = data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
							thumbs[i] = thumb.replace(/src\=\"|\"\swidth/g,'') for thumb, i in thumbs
						else 
							thumbs[i] = '' for video, i in videos
							console.log "#{XXXXXXXX}: current Page: #{page} has no thummbinial"

						if data.match(/<a\s.+www\.nhaccuatui\.com\/tim\-kiem.+/g)
							video_artists = data.match(/<a\s.+www\.nhaccuatui\.com\/tim\-kiem.+/g)
							for _artist, index in video_artists
								video_artists[index] = _artist.split(/\>\,\s</g).map (v)->
									v.replace(/a\shref.+_blank\"\>|\/a|<\/p\>|<|\>/g,'')
						else 
							video_artists[i] = '' for video, i in videos
							console.log "#{XXXXXXXX}: current Page: #{page} has no artists names"

						if data.match(/<\!\-\-<div\sclass\=\"times\"\>.+/g)
							durations = data.match(/<\!\-\-<div\sclass\=\"times\"\>.+/g)
											.map (v)->
												v = v.replace(/<\!\-\-<div\sclass\=\"times\"\>|<\/div\>\-\-\>/g,'').split(':')
												time = parseInt(v[0],10)*60 + parseInt(v[1],10)

						else 
							durations[i] = '' for video, i in videos

						# console.log JSON.stringify durations
						
						# @stats.passedItemCount +=1
						# for video, index in videos
						# 	_video = {}
						# 	if video.match(/<a.+\.html/)
						# 		_video.video_key = video.match(/<a.+\.html/)[0].replace(/\.html/g,'').replace(/<a.+\./,'')
						# 	else _video.video_key = ''

						# 	if video.match(/title\=.+\"\>/)
						# 		_video.video_name = encoder.htmlDecode video.match(/title\=.+\"\>/)[0].replace(/title\=\"|\"\>/g,'')
						# 	else _video.video_name = ''
						# 	_video.thumbnail = thumbs[index]
						# 	_video.video_artists = JSON.stringify video_artists[index]
						# 	_video.duration = durations[index]
						# 	if _video.thumbnail
						# 		if _video.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)
						# 			_video.created = _video.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)[0].replace(/\//g,'-')
						# 		else if _video.thumbnail.match(/\d{4}_\d{2}\//g)
						# 			_video.created = _video.thumbnail.match(/\d{4}_\d{2}\//g)[0].replace(/_/g,':').replace(/\//g,'')
						# 			_video.created += ":01"
						# 	@connection.query @query._insertIntoNCTVideos, _video, (err)->
						# 		if err then console.log "Cannot insert video:#{_video.videoid} to table. ERROR: #{err}".red
						
						#------------ special usage for topic: the-loai-khac
						@stats.passedItemCount +=1
						for video, index in videos
							_video = {}
							if video.match(/<a.+\.html\"\stitle\=/g)
								_video.video_key = video.match(/<a.+\.html\"\stitle\=/g)[0].replace(/\.html|\"\stitle\=/g,'').replace(/<a.+\./,'')
							else _video.video_key = ''

							if video.match(/<a\shref.+title\=.+\"\>/)
								_video.video_name = encoder.htmlDecode video.match(/<a\shref.+title\=.+\"\>/)[0].replace(/<a\shref.+title\=\"|\"\>/g,'')
							else _video.video_name = ''
							_video.thumbnail = thumbs[index]
							_video.video_artists = JSON.stringify video_artists[index]
							_video.duration = durations[index]
							if _video.thumbnail
								if _video.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)
									_video.created = _video.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)[0].replace(/\//g,'-')
								else if _video.thumbnail.match(/\d{4}_\d{2}\//g)
									_video.created = _video.thumbnail.match(/\d{4}_\d{2}\//g)[0].replace(/_/g,':').replace(/\//g,'')
									_video.created += ":01"
							@connection.query @query._insertIntoNCTVideos, _video, (err)->
								if err then console.log "Cannot insert video:#{_video.videoid} to table. ERROR: #{err}".red
						
					# else console.log "#{XXXXXXXX}: has no video at current Page: #{page} ".red

					# @_fetchAlbum _video
					# console.log _video
					# console.log "#{XXXXXXXX}: current Page: #{page} has #{videos.length} --------------------".red
					data = ""
					@utils.printRunning @stats
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats
			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1		
	fetchVideoByTopic : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching albums'data  to table: #{@table.Videos}".magenta

		# topics = "video-moi viet-nam au-my han-quoc nhac-nhat nhac-hoa shining-show sea-show house-of-dreams the-loai-khac".split(' ')
		topics = "the-loai-khac".split(' ')
		#http://www.nhaccuatui.com/tim-kiem/giai-tri?q=Pokemon&b=&page=30

		# link = "http://www.nhaccuatui.com/playlist/nhac-tre.html?page="
		# link2 = "http://www.nhaccuatui.com/playlist/nhac-tre.html?sort=1&page"
		# winvejtya belinh909
		url = "http://www.nhaccuatui.com/mv/"
		
		@stats.totalItems = 123617263187
		@stats.currentTable = @table.Videos
		for topic in topics
			# link1 =  url + topic + ".html" + "?page="
			# link2 =  url + topic + ".html" + "?sort=1&page="


			for page in [1..34]
				@_fetchVideoByTopic link1, page
				@_fetchVideoByTopic link2, page
		null		

	#---------------------------------------------------------------------------------
	_updateAlbumsAndSongs : (topicLink,page = 1) ->
		link = topicLink + page
		XXXXXXXX = link
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					# console.log "#{XXXXXXXX}: current Page: #{page}".red
					if data.match(/<h3\><a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/playlist.+/g)
						albums = data.match(/<h3\><a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/playlist.+/g)
						thumbs = []
						artists = []
						if  data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
							thumbs = data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
							thumbs[i] = thumb.replace(/src\=\"|\"\swidth/g,'') for thumb, i in thumbs
						else 
							thumbs[i] = '' for album, i in albums
							console.log "#{XXXXXXXX}: current Page: #{page} has no thumbnail"
						if data.match(/<a\shref.+www\.nhaccuatui\.com\/tim\-kiem.+/g)
							artists = data.match(/<a\shref.+www\.nhaccuatui\.com\/tim\-kiem.+/g)
							for _artist, index in artists
								artists[index] = _artist.split(/\>\,\s</g).map (v)->
									v.replace(/a\shref.+_blank\"\>|\/a|<\/p\>|<|\>/g,'')
						else 
							artists[i] = '' for album, i in albums
							console.log "#{XXXXXXXX}: current Page: #{page} has no artists names"
						if data.match /NCTCounter_pl_\d+/g
							albumids = data.match /NCTCounter_pl_\d+/g
						else albumids[i] = '0' for album, i in albumids

						for album, index in albums
							_album = 
								artist : encoder.htmlDecode JSON.stringify artists[index]
								albumid : parseInt albumids[index].replace(/NCTCounter_pl_/g, ''), 10
							if album.match(/<a.+\.html/)
								_album.album_key = album.match(/<a.+\.html/)[0].replace(/\.html/g,'').replace(/<a.+\./,'')
							else _album.album_key = ''

							if album.match(/title\=.+\"\>/)
								_album.title = encoder.htmlDecode album.match(/title\=.+\"\>/)[0].replace(/title\=\"|\"\>/g,'')
							else _album.title = ''
							_album.thumbnail = thumbs[index]

							if _album.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)
								_album.created = _album.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)[0].replace(/\//g,'-')
							if _album.thumbnail.match(/\/\d+\.jpg$/g)
								_t = new Date(parseInt(_album.thumbnail.match(/\/\d+\.jpg/g)[0].replace(/\/|\.jpg/g,'')))
								_album.created += " " + _t.getHours() + ":" + _t.getMinutes() + ":" + _t.getSeconds()
							
							
							do (_album) =>
								@stats.totalItemCount +=1 
								if _album.albumid > @log.maxAlbumId
									# find temporary max album id in album collection
									if _album.albumid > @log.tempMaxAlbumId 
										@log.tempMaxAlbumId  = _album.albumid
									@stats.passedItemCount +=1
									# @connection.query @query._insertIntoNCTAlbums, _album, (err)=>
									#  	if err then console.log "Cannot insert new album:#{_album.album_key} to table. ERROR: #{err}".red
									#  	else 
									 		# @_updateAlbumLinkKey _album.album_key
									@_updateAlbumStatsAndInsertSongs _album
								else @stats.failedItemCount += 1
								@utils.printUpdateRunning _album.album_key, @stats, "Fetching..."
								if @stats.totalItemCount is 9590
									@utils.printFinalResult @stats
							@utils.printUpdateRunning _album.album_key, @stats, "Fetching..."	
					# else console.log "#{XXXXXXXX}: has no album at current Page: #{page} ".red	
					data = ""
					# if @stats.totalItemCount is @stats.totalItems
					# 	@utils.printFinalResult @stats
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	###*
	 * updateAlbumsAndSongs()  
	 *   _updateAlbumsAndSongs(topic,link) - insert new albums into table
	 *     _updateAlbumStatsAndInsertSongs() - http://www.nhaccuatui.com/playlist/joke-link.#{album_key}.html
	 *        _updateAlbumTopic()
	 *        _updateSongLinkKey() - "http://www.nhaccuatui.com/bai-hat/joke-link.#{song_key}.html"
	 *            _updateSongPlays() - http://www.nhaccuatui.com/wg/get-counter?listSongIds=#{songid}
	###
	updateAlbumsAndSongs : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating albums and songs to table: #{@table.Albums}".magenta

		topics = "playlist-moi nhac-tre tru-tinh cach-mang tien-chien nhac-trinh thieu-nhi rap-viet rock-viet khong-loi au-my han-quoc nhac-hoa nhac-nhat nhac-phim the-loai-khac"
		# topics = "playlist-moi the-loai-khac"
		topics = topics.split(' ')
		url = "http://www.nhaccuatui.com/playlist/"
		#update max album id
		if @log.tempMaxAlbumId > @log.maxAlbumId
			 @log.maxAlbumId = @log.tempMaxAlbumId
		@stats.currentTable = @table.Albums
		for topic in topics
			link =  url + topic + ".html" + "?sort=1&page="
			for page in [1..34]
				@_updateAlbumsAndSongs link, page
		null
	_updateSongs_AlbumsTables : (album) ->
		link = "http://www.nhaccuatui.com/playlist/joke-link.#{album.album_key}.html"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try
						if data.match(/rel\=\"\d+\"\skey=.+/g)
							_songs = data.match(/rel\=\"\d+\"\skey=.+/g)
							songs = []
							@stats.totalItemCount +=  1
							@stats.passedItemCount += 1
							for _song, index in _songs
								_temp = _song.replace(/class.+/g,'')
								_songs_albums =
									songid : _temp.match(/rel.+key/g)[0].replace(/rel\=\"|\"\skey/g,'')
									albumid : album.albumid
								# songs.push _songs_albums
								@connection.query @query._insertIntoNCTSongs_Albums, _songs_albums, (err)=>
									if err then console.log "cannt insert into songs_albums"
							@utils.printRunning @stats
							if @stats.totalItemCount is @stats.totalItems
								@utils.printFinalResult @stats
						else _songs = ''
						data = ''	
					catch e
						console.log "ERROR while updating Album Stats And Inserting Songs.... #{e}"
						@stats.failedItemCount += 1
					
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	updateSongs_AlbumsTables : ()->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching songs albums to table: #{@table.Albums}".magenta
		_q = "Select albumid, album_key from #{@table.Albums}"
		@connection.query _q, (err, albums)=>
			if err then console.log "CANNT get songs albums from database"
			else
				# console.log albums
				@stats.totalItems = albums.length
				@stats.currentTable = @table.Albums
				for album in albums
					@_updateSongs_AlbumsTables(album)
	_updateVideos : (topicLink,page = 1) ->
		link = topicLink + page

		_nonsense = "Video"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					if data.match(/<h3\><a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/mv.+/g)
						videos = data.match(/<h3\><a\shref\=\"http\:\/\/www\.nhaccuatui\.com\/mv.+/g)
						thumbs = []
						durations = []
						video_artists = []

						
						
						if  data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
							thumbs = data.match(/src\=\"http\:\/\/.+nct\.nixcdn\.com.+\"\swidth/g)
							thumbs[i] = thumb.replace(/src\=\"|\"\swidth/g,'') for thumb, i in thumbs
						else 
							thumbs[i] = '' for video, i in videos
							console.log "#{_nonsense}: current Page: #{page} has no thummbinial"

						if data.match(/<a\shref.+www\.nhaccuatui\.com\/tim\-kiem.+/g)
							video_artists = data.match(/<a\shref.+www\.nhaccuatui\.com\/tim\-kiem.+/g)
							for _artist, index in video_artists
								video_artists[index] = _artist.split(/\>\,\s</g).map (v)->
									v.replace(/a\shref.+_blank\"\>|\/a|<\/p\>|<|\>/g,'')
						else 
							video_artists[i] = '' for video, i in videos
							console.log "#{_nonsense}: current Page: #{page} has no artists names"

						if data.match(/<\!\-\-<div\sclass\=\"times\"\>.+/g)
							durations = data.match(/<\!\-\-<div\sclass\=\"times\"\>.+/g)
											.map (v)->
												v = v.replace(/<\!\-\-<div\sclass\=\"times\"\>|<\/div\>\-\-\>/g,'').split(':')
												time = parseInt(v[0],10)*60 + parseInt(v[1],10)

						else 
							durations[i] = '' for video, i in videos

						
						for video, index in videos
							_video = {}
							
							if video.match(/<h3\><a.+\.html\"\stitle\=/g)
								_video.video_key = video.match(/<h3\><a.+\.html\"\stitle\=/g)[0].replace(/<h3\>|\.html|\"\stitle\=/g,'').replace(/<a.+\./,'')
							else _video.video_key = ''

							if video.match(/<a\shref.+title\=.+\"\>/)
								_video.video_name = encoder.htmlDecode video.match(/<a\shref.+title\=.+\"\>/)[0].replace(/<a\shref.+title\=\"|\"\>/g,'')
							else _video.video_name = ''
							_video.thumbnail = thumbs[index]
							_video.video_artists = JSON.stringify video_artists[index]
							_video.duration = durations[index]
							if _video.thumbnail
								if _video.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)
									_video.created = _video.thumbnail.match(/\d{4}\/\d{2}\/\d{2}/g)[0].replace(/\//g,'-')
								else if _video.thumbnail.match(/\d{4}_\d{2}\//g)
									_video.created = _video.thumbnail.match(/\d{4}_\d{2}\//g)[0].replace(/_/g,':').replace(/\//g,'')
									_video.created += ":01"
							

							@_printUpdateAlbum "Fetching pages..."
							if new Date(_video.created) > new Date(@log.lastVideoUpdatedDate)
								if new Date(_video.created) > new Date(@log.tempLastVideoUpdatedDate)
									@log.tempLastVideoUpdatedDate = _video.created
									@_writeLog @log
								@stats.totalItems += 1
								@_updateVideoLinkKey _video
							
					data = ""
					
			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1			
	updateVideos : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating albums'data  to table: #{@table.Videos}".magenta

		topics = "video-moi viet-nam au-my han-quoc nhac-nhat nhac-hoa shining-show sea-show house-of-dreams the-loai-khac".split(' ')
		# topics = "video-moi the-loai-khac".split(' ')
		url = "http://www.nhaccuatui.com/mv/"
		if new Date(@log.tempLastVideoUpdatedDate) > new Date(@log.lastVideoUpdatedDate)
			 @log.lastVideoUpdatedDate = @log.tempLastVideoUpdatedDate
		@stats.currentTable = @table.Videos
		for topic in topics
			# link1 =  url + topic + ".html" + "?page="
			link =  url + topic + ".html" + "?sort=1&page="
			for page in [1..42]
				@_updateVideos link, page
		null		

	_updateLyrics : (songid)->
		link = "http://www.nhaccuatui.com/ajax/get-lyric?key=#{songid}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try
						@stats.totalItemCount +=1
						if not data.match(/Hiện\schưa\scó\slời\sbài\shát\snào/)
							
							@stats.passedItemCount +=1
							data = JSON.parse data
							lyric = encoder.htmlDecode data.data.html.replace(/\r|\n|\t/g,'')
										.replace(/<div\sclass\=\"more-add\".+/g,'')
										.replace(/<div.+hidden\;\">|<\/div>/g,'').trim()
							data = ""
							_u = "update #{@table.Songs} set lyric=#{@connection.escape(lyric)} where songid=#{songid}"
							@connection.query _u, (err)->
								if err then console.log "Cannt insert lyric of the song: #{songid}. ERROR: #{err}"
						else 
							@stats.failedItemCount += 1
						@utils.printRunning @stats
						if @stats.totalItemCount is @stats.totalItems
							@utils.printFinalResult @stats
					catch e
						console.log "ERROR while updating Lyric of Song: #{songid}. ERROR: #{e}"
						@stats.failedItemCount += 1
					
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount += 1
	updateLyrics : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching songs lyrics to table: #{@table.Songs}".magenta
		_q = "Select songid from #{@table.Songs} where lyric is null order by songid DESC LIMIT 50000"
		@connection.query _q, (err, songs)=>
			if err then console.log "CANNT get songs Songs from database"
			else
				# console.log Songs
				@stats.totalItems = songs.length
				console.log "Updating lyrics. Total records is:"+@stats.totalItems
				@stats.currentTable = @table.Songs
				for song in songs
					@_updateLyrics(song.songid)

	showStats : ->
		@_printTableStats NCT_CONFIG.table


module.exports = Nhaccuatui
