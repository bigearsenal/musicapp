http = require 'http'
xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require 'colors'
fs = require 'fs'

Encoder = require('node-html-encoder').Encoder
encoder = new Encoder('entity');

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
		super @mysqlConfig
		@logPath = @config.logPath
		@log = {}
		@_readLog()

	createTables : ->
		@connect()
		songsQuery = "CREATE TABLE IF NOT EXISTS " + @table.Songs + " (
					id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
					albumid varchar(100),
					album_encodedId varchar(255),
					album_name varchar(255),
					album_thumbnail varchar(300),
					album_artist varchar(255),
					song_name varchar(255),
					song_artist varchar(255),
					song_link varchar(255)
					);"
		artistsQuery = "CREATE TABLE IF NOT EXISTS " + @table.Artists + " (
					id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
					name varchar(100),
					real_name varchar(100),
					dateofbirth varchar(100),
					publisher varchar(50),
					country varchar(300),
					topic varchar(255),
					description text
					);"
		artistsVideos = "CREATE TABLE IF NOT EXISTS " + @table.Videos + " (
					id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
					videoid varchar(150),
					video_encodedId varchar(150),
					title varchar(150),
					artist varchar(100),
					video_artist varchar(100),
					thumbnail varchar(255),
					topic varchar(150),
					plays int,
					link varchar(300)
					);"
		_query = songsQuery + artistsQuery + artistsVideos
		@connection.query _query, (err, result)=>
			if err then console.log "Cannot create table" else console.log "Tables: #{@table.Songs} have been created!"
			@end()
	resetTables : ->
		@connect()
		songsQuery = "truncate table #{@table.Songs} ;"
		@connection.query songsQuery, (err, result)=>
			if err then console.log "Cannot truncate tables" else console.log "Tables: #{@table.Songs} have been truncated!"
			@end()

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

	_storeSong : (songs,songs_albums) ->
		try 
			for song, index in songs
				do (song, index) =>
					# console.log album
					# console.log song
					_song = 
						sid : songs_albums.sids[index]
						songid : @_convertToId songs_albums.sids[index]
						song_name : encoder.htmlDecode song.title[0].trim()
						song_artist : encoder.htmlDecode song.performer[0].trim()
						song_link : song.source[0]
					_str =  _song.song_link.replace(/^.+load-song\//g,'').replace(/^.+song-load\//g,'')
					
					testArr = []
					testArr.push @_decodeString _str.slice(i, i+4) for i in [0.._str.length-1] by 4
					path =  decodeURIComponent testArr.join('').match(/.+mp3/g)

					created = path.match(/^\d{4}\/\d{2}\/\d{2}/)?[0].replace(/\//g,"-")

					_song.path = path
					_song.created = created

					# console.log _song
					@connection.query @query._insertIntoZISongs, _song, (err)=>
						if err then console.log "Cannot insert song #{_song.songid}: ERROR: #{err}"
						else 
							_item = 
								aid : songs_albums.aid
								sid : _song.sid
							_tempSong = 
								sid : _song.sid
							@_updateLyric _tempSong
							@connection.query @query._insertIntoZISongs_Albums, _item, (err)->
								if err then console.log "Cannot insert new record into Songs_Albums. ERROR: #{err}"
		catch e
			console.log "ERROR while storing songs of Album: #{songs_albums.aid}. ERROR: #{e}".red


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

	_fetchArtistVideo : (artistName,page = 1) ->
		link = "http://mp3.zing.vn/nghe-si/#{artistName}/video-clip?p=#{page}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@stats.totalItemCount +=1
					if res.statusCode isnt 302 and res.statusCode isnt 400
						# console.log "#{artistName}: current Page: #{page}".red
						if data.match(/Hiện\schưa\scó\svideo\snào/g) is null
							try 
								videos = data.match(/new-video-img.+/g)
								@stats.passedItemCount +=1
								for video in videos
									_video = 
										artist : artistName
									
									if video.match(/\/[0-9a-zA-Z]+\.html/g)
										_video.videoid = video.match(/\/[0-9a-zA-Z]+\.html/g)[0].replace(/\//g,'').replace(/\.html/g,'')
									else _video.videoid = ""
									if video.match(/title\=\".+\"\>\<img/g)
										_temp = video.match(/title\=\".+\"\>\<img/g)[0].replace(/title\=\"/g,'').replace(/\"\>\<img/g,'')
										if _temp.match(/\s-\s/g)
											_temp = _temp.split(' - ')
											if _temp.length > 1 
												_t =  encoder.htmlDecode _temp[_temp.length-1]
												_video.video_artist = JSON.stringify _t.split(',')
												_temp.pop()
											else 
												_video.video_artist = ""

											_video.title = encoder.htmlDecode _temp.join(' - ')
									else _video.title = ""
									if video.match(/src\=\".+/g)
										_video.thumbnail = video.match(/src\=\".+/g)[0].replace(/src\=\"/g,'').replace(/\"\>\<\/a\>/g,'')
									else _video.thumbnail = ""


									@_fetchVideo _video
									# console.log _video
								# console.log "#{artistName}: current Page: #{page} has #{albums.length} --------------------".red

								# callback if page is greater than 1
								if page is 1
									if data.match(/Trang\s\d.+/g)
										totalPage = data.match(/Trang\s\d.+/g).length
									else totalPage = 1
									# console.log "#{artistName} has #{totalPage} page(s) "
									@_fetchArtistVideo artistName, p for p in [2..totalPage] if totalPage > 1
								data = ""
							catch e
								"ERROR at artist: #{artistName}".red
						else
							@stats.failedItemCount+=1
							# console.log "ARTIST: #{artistName} does not have any album". magenta

					else
						@stats.failedItemCount+=1
						# console.log "ARTIST: #{artistName} does not exit". magenta
					
					@utils.printRunning @stats
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats

			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	_fetchArtist : (artistName,page = 1) ->
		link = "http://mp3.zing.vn/nghe-si/#{artistName}/album?p=#{page}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@stats.totalItemCount +=1
					if res.statusCode isnt 302 and res.statusCode isnt 400
						# console.log "#{artistName}: current Page: #{page}".red
						if data.match(/Hiện\schưa\scó\salbum\snào/g) is null
							try 
								albums = data.match(/new-album-img.+/g)
								@stats.passedItemCount +=1
								for album in albums
									_album = 
										artistName : artistName
										id : album.match(/\/[0-9a-zA-Z]+\.html/g)[0].replace(/\//g,'').replace(/\.html/g,'')
										title : album.match(/title\=\".+\"\>\<img/g)[0].replace(/title\=\"/g,'').replace(/\"\>\<img/g,'')
										thumbnail : album.match(/src\=\".+/g)[0].replace(/src\=\"/g,'').replace(/\"\>\<\/a\>/g,'')

									@_fetchAlbum _album
									# console.log _album
								# console.log "#{artistName}: current Page: #{page} has #{albums.length} --------------------".red

								# callback if page is greater than 1
								if page is 1
									if data.match(/Trang\s\d.+/g)
										totalPage = data.match(/Trang\s\d.+/g).length
									else totalPage = 1
									# console.log "#{artistName} has #{totalPage} page(s) "
									@_fetchArtist artistName, p for p in [2..totalPage] if totalPage > 1
								data = ""
							catch e
								"ERROR at artist: #{artistName}".red
						else
							@stats.failedItemCount+=1
							# console.log "ARTIST: #{artistName} does not have any album". magenta

					else
						@stats.failedItemCount+=1
						# console.log "ARTIST: #{artistName} does not exit". magenta
					
					@utils.printRunning @stats
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats

			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	_fetchArtistProfile : (artistName) ->
		link = "http://mp3.zing.vn/nghe-si/#{artistName}/tieu-su"
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
	_fetchAlbum : (album) ->
		link = "http://mp3.zing.vn/album/joke-link/#{album.albumid}.html"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					_album = album
					if data.match(/xmlURL.+\&amp\;/g) is null then console.log "ERROR : album #{album.albumid}: #{album.album_name} of #{album.album_artist} does not exist".red
					else 
						_album.album_encodedId = data.match(/xmlURL.+\&amp\;/g)[0].replace(/xmlURL\=http\:\/\/mp3\.zing\.vn\/xml\/album\-xml\//g,'').replace(/\&amp\;/,'')
						_q = "update #{@table.Albums} set album_encodedId=#{@connection.escape(_album.album_encodedId)} where albumid=#{@connection.escape(album.albumid)}"
						@connection.query @query._insertIntoZIAlbums, _album, (err)->
							if err then console.log "Cannot insert into table. ERROR: #{err}"
						@_fetchSongs _album
						data = ""
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	_fetchAlbumEncodedId : (album) ->
		link = "http://mp3.zing.vn/album/joke-link/#{album.albumid}.html"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					_album = album
					if data.match(/xmlURL.+\&amp\;/g) is null
						console.log "ERROR : album #{album.albumid}: #{album.album_name} of #{album.album_artist} does not exist".red
						@stats.passedItemCount -=1
						@stats.failedItemCount +=1

					else 
						_album.album_encodedId = data.match(/xmlURL.+\&amp\;/g)[0].replace(/xmlURL\=http\:\/\/mp3\.zing\.vn\/xml\/album\-xml\//g,'').replace(/\&amp\;/,'')
						_q = "update #{@table.Albums} set album_encodedId=#{@connection.escape(_album.album_encodedId)} where albumid=#{@connection.escape(album.albumid)}"
						@connection.query @query._insertIntoZIAlbums, _album, (err)=>
							if err then console.log "Cannot insert into table. ERROR: #{err}"
							else 
								@_fetchSongs _album					
						data = ""
					@utils.printUpdateRunning _album.albumid, @stats, "Fetching"
					if @stats.totalItemCount is 1200
						@utils.printFinalResult @stats
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	_updateAlbumStats : (albumid)->
		link = "http://mp3.zing.vn/album/joke-link/#{albumid}.html"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try 
						album = 
							id : albumid
						if data.match(/xmlURL.+\&amp\;/g) is null then console.log "ERROR : album #{albumid}: does not exist".red
						else 
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
								album.description = data.match(/_albumIntro\"\sclass\=\"rows2.+/g)[0]
														.replace(/_albumIntro.+\"\>|\<br\s\/\>|\<\/p\>/g,'')
							if data.match(/_divPlsLite.+\"\sclass/g)
								arr = []
								_songids = data.match(/_divPlsLite.+\"\sclass/g)
								arr.push _songid.replace(/_divPlsLite|\"\sclass/g,'') for _songid in _songids
								item =
									albumid : albumid
									songids : arr
							else album.description = ""
							data = ""
							
							@_updateSongIds item

							_updateQuery = "UPDATE #{@table.Albums} set plays=#{@connection.escape(album.plays)}," + 
										   "released_year=#{@connection.escape(album.released_year)}," + 
										   "nsongs=#{@connection.escape(album.nsongs)}," + 
										   "topic=#{@connection.escape(album.topic)}," + 
										   "description=#{@connection.escape(album.description)}" + 
										   " WHERE albumid = #{@connection.escape(album.id)}"
							# console.log _updateQuery
							@connection.query _updateQuery, (err)->
								if err then console.log "CAN NOT update album #{album.id}. ERROR: #{err}".red

					catch e
						console.log "CANNOT fetch ALBUM TOPIC: #{albumid}. ERROR: #{e}"
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount +=1
	_fetchSongs : (album_encodedId, songs_albums) ->
		link = "http://mp3.zing.vn/xml/album-xml/#{album_encodedId}"
		# console.log link
		# console.log link
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@parser.parseString data, (err, result) =>
						# console.log result.data.item
						@_storeSong(result.data.item, songs_albums)
						data = ""

			.on 'error', (e) =>
				console.log  "Got error: " + e.message

	_fetchVideo : (video) ->
		link = "http://mp3.zing.vn/video-clip/joke-link/#{video.videoid}.html"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					_video = video
					try 
						if data.match(/xmlURL.+\&amp\;/g) is null then console.log "ERROR : video #{video.videoid}: #{video.title} of #{video.artist} does not exist".red
						else 
							_video.video_encodedId = data.match(/xmlURL.+\&amp\;/g)[0].replace(/xmlURL\=http\:\/\/mp3\.zing\.vn\/xml\/video\-xml\//g,'').replace(/\&amp\;/,'')
							if data.match(/Thể\sloại\:/g)
									_temp= data.match(/Thể\sloại\:.+/g)[0]				
									_topics = _temp.split('|')[0].replace(/Thể\sloại\:.|\/span\>|\<\/p\>/g,'').split(',')
									_video.plays = _temp.split('|')[1].replace(/Lượt\sxem\:|\s|\<\/p\>|\./g,'')
									arr = []
									arr.push _topic.replace(/\<a.+\"\>|\<\/a\>/g,'').trim() for _topic in _topics
									_video.topic = JSON.stringify arr
								else _video.topic = ''
							# @_fetchVideoLink _video
							@connection.query @query._insertIntoZIVideos, video, (err)->
								if err then console.log "Cannot insert video #{video.videoid} into table. Error: #{err}"
					catch e 
						console.log "Cannot get link of video data: #{video.videoid}. Error: #{err}"
						data = ""
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
	_fetchVideoLink : (video) ->
		link = "http://mp3.zing.vn/xml/video-xml/#{video.video_encodedId}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try 
						@stats.totalItemCount +=1
						@parser.parseString data, (err, result) =>
							video.link =  result.data.item[0].f480[0]
							_q = "update #{@table.Videos} SET link=#{@connection.escape(video.link)} where id=#{video.id}"
							@stats.passedItemCount +=1
							@connection.query _q, (err)->
								if err then console.log "Cannot update video #{video.videoid} into table. Error: #{err}"
							data = ""
							@utils.printUpdateRunning video.id, @stats, "Fetching..."
							if @stats.totalItemCount is @stats.totalItems
								@utils.printFinalResult @stats
					catch e 
						console.log "Cannot get link of video: #{video.videoid}. Error: #{err}"
						@stats.failedItemCount +=1
			
			.on 'error', (e) =>
				console.log  "Got error at func: _fetchVideoLink: " + e.message
				@stats.failedItemCount +=1
	_updateSongIds : (item)->
		try
			_query = "select id from #{@table.Songs} where albumid=#{@connection.escape(item.albumid)} order by id asc"
			# console.log _query
			@connection.query _query, (err,songs)=>
				if err then console.log "Cannt update songids, ERROR: #{err}"
				else 
					# console.log songs
					# console.log item
					for i in [0..songs.length-1]
						_q = "update #{@table.Songs} set songid=#{@connection.escape(item.songids[i])} where id=#{songs[i].id} and albumid=#{@connection.escape(item.albumid)}"
						@connection.query  _q, (err)=>
							if err then console.log "CANNT UPDATE songid. ERROR: #{err}"
		catch e
			console.log "CAN NOT update songids in album: #{item.albumid}. ERROR: #{e}".red
	_fetchAlbumTopic : (albumid)->
		link = "http://mp3.zing.vn/album/joke-link/#{albumid}.html"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					try 
						album = 
							id : albumid
						@stats.totalItemCount +=1
						@stats.currentId = albumid
						if data.match(/xmlURL.+\&amp\;/g) is null then console.log "ERROR : album #{albumid}: does not exist".red
						else 
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
								album.description = data.match(/_albumIntro\"\sclass\=\"rows2.+/g)[0]
														.replace(/_albumIntro.+\"\>|\<br\s\/\>|\<\/p\>/g,'')
							if data.match(/_divPlsLite.+\"\sclass/g)
								arr = []
								_songids = data.match(/_divPlsLite.+\"\sclass/g)
								arr.push _songid.replace(/_divPlsLite|\"\sclass/g,'') for _songid in _songids
								item =
									albumid : albumid
									songids : arr
							else album.description = ""
							data = ""
							@stats.passedItemCount +=1
							@_updateSongIds item
							# _updateQuery = "UPDATE #{@table.Albums} set plays=#{@connection.escape(album.plays)}," + 
							# 			   "released_year=#{@connection.escape(album.released_year)}," + 
							# 			   "nsongs=#{@connection.escape(album.nsongs)}," + 
							# 			   "topic=#{@connection.escape(album.topic)}," + 
							# 			   "description=#{@connection.escape(album.description)}" + 
							# 			   " WHERE albumid = #{@connection.escape(album.id)}"
							# console.log _updateQuery
							# @connection.query _updateQuery, (err)->
							# 	if err then console.log "CAN NOT update album #{album.id}. ERROR: #{err}".red
							@utils.printRunning @stats

							if @stats.totalItems is @stats.totalItemCount
								@utils.printFinalResult @stats
					catch e
						console.log "CANNOT fetch ALBUM TOPIC: #{albumid}. ERROR: #{e}"
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount +=1
	_fetchAlbumByGenre : (link0,page = 1) ->
		link = link0 + page
		# console.log link
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					# console.log data

					@stats.totalItemCount +=1
					if data.match(/album\-detail\-img.+/g)
						albums = data.match(/album\-detail\-img.+/g)
						@stats.passedItemCount +=1
						for album in albums
							_album = 
								albumid : album.match(/\/[0-9a-zA-Z]+\.html/g)[0].replace(/\//g,'').replace(/\.html/g,'')
								album_thumbnail : album.match(/src\=\".+/g)[0].replace(/src\=\"/g,'').replace(/\/><\/a><\/span>|\"\s/g,'')
							if _album.album_thumbnail.match(/_\d+\..+$/)
								_t = _album.album_thumbnail.match(/_\d+\..+$/)[0].replace(/_|\..+$/,'')
								_t = new Date(parseInt(_t,10)*1000)
								_created = _t.getFullYear() + "-" + (_t.getMonth()+1) + "-" + _t.getDate() + " " + _t.getHours() + ":" + _t.getMinutes() + ":" + _t.getSeconds()
								_album.created = _created
							item = album.match(/title\=\".+\"\shref/g)[0].replace(/title\=\"/g,'').replace(/\"\shref/g,'')

							_album.album_artist = item.split(' - ')[1]
							_album.album_name = item.split(' - ')[0]
							@_fetchAlbum _album
							# console.log _album

							@connection.query @query._insertIntoZIAlbums, _album, (err)->
								if err then console.log "Cannot insert into table. ERROR: #{err}"
						# console.log "#{artistName}: current Page: #{page} has #{albums.length} --------------------".red

						# callback if page is greater than 1
						
						data = ""

						
					else 
						@stats.failedItemCount += 1
						@utils.printRunning @stats

					@utils.printRunning @stats
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	

	fetchAlbumTopic : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching albums topic to table: #{@table.Songs}".magenta
		@stats.currentTable = @table.Songs
		# _query = "select albumid, album_name, album_thumbnail, album_artist, album_encodedId from #{@table.Albums}"
		_query = "select id,albumid from ZISongs where songid='' and albumid='ZWZA70I0' group by albumid"
		@connection.query _query, (err, albums)=>
			console.log albums.length
			@stats.totalItems = albums.length
			for album in albums
				# @_fetchAlbum album
				# @_fetchSongs album
				@_fetchAlbumTopic album.albumid
				
		null
	fetchArtist : () =>
		@connect()
		artists = fs.readFileSync "./log/artist.txt" , "utf8"
		artists = JSON.parse artists
		console.log " |"+"Fetching artists, albums and songs to table: #{@table.Songs}".magenta
		@stats.totalItems = artists.length
		@stats.currentTable = @table.Songs
		@_fetchArtist name for name in artists
		null
	fetchArtistProfile : () ->
		@connect()
		artists = fs.readFileSync "./log/test/artist.txt" , "utf8"
		artists = JSON.parse artists
		console.log " |"+"Fetching artists profile table: #{@table.Artists}".magenta
		@stats.totalItems = artists.length
		@stats.currentTable = @table.Artists
		@_fetchArtistProfile name for name in artists
		null
	fetchVideo : () ->
		@connect()
		artists = fs.readFileSync "./log/test/video_artist.txt" , "utf8"
		artists = JSON.parse artists
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching videos to table: #{@table.Artists}".magenta
		@stats.totalItems = artists.length
		@stats.currentTable = @table.Artists
		@_fetchArtistVideo name for name in artists
		null
	fetchAlbumByGenre : ->
		@connect()
		console.log " |"+"Fetching artists, albums and songs by genre to table: #{@table.Albums}".magenta
		@stats.currentTable = @table.Albums
		topics = "Viet-Nam/IWZ9Z08I Nhac-Tre/IWZ9Z088 Nhac-Cach-Mang/IWZ9Z08C Cai-Luong/IWZ9Z0C6 Nhac-Tru-Tinh/IWZ9Z08B Nhac-Que-Huong/IWZ9Z08D Nhac-Trinh/IWZ9Z08E Rock-Viet/IWZ9Z08A Nhac-Thieu-Nhi/IWZ9Z08F Nhac-Phim/IWZ9Z0BA Rap-Viet/IWZ9Z089 Nhac-Khong-Loi/IWZ9Z090 Nhac-Dance/IWZ9Z0CW "
		topics+= "Au-My/IWZ9Z08O Pop/IWZ9Z097 Electronic-Dance/IWZ9Z09A Trance-House-Techno/IWZ9Z0C7 Nhac-Phim/IWZ9Z0EC Rock/IWZ9Z099 R-B-Soul/IWZ9Z09D Blues-Jazz/IWZ9Z09C Audiophile/IWZ9Z0EO Rap-Hip-Hop/IWZ9Z09B Gospel/IWZ9Z0DE New-Age-World-Music/IWZ9Z098 Country/IWZ9Z096 Indie/IWZ9Z0CA Folk/IWZ9Z09E "
		topics+= "Han-Quoc/IWZ9Z08W Pop-Ballad/IWZ9Z09W Electronic-Dance/IWZ9Z09O Rap-Hip-Hop/IWZ9Z09I Nhac-Phim/IWZ9Z0BB Rock/IWZ9Z09Z R-B/IWZ9Z09U "
		topics+= "Nhat-Ban/IWZ9Z08Z Pop-Ballad/IWZ9Z0AZ R-B/IWZ9Z0A7 Pop-Dance/IWZ9Z0A6 Nhac-Phim/IWZ9Z0EE Rap-Hip-Hop/IWZ9Z0AU Rock/IWZ9Z0A8 "
		topics+= "Hoa-Ngu/IWZ9Z08U Pop/IWZ9Z0EU Dan-Toc/IWZ9Z0E7 Singapore/IWZ9Z0AW Rock/IWZ9Z0EZ Trung-Quoc/IWZ9Z0A0 Malaysia/IWZ9Z0AO Hong-Kong/IWZ9Z0AI Audiophile/IWZ9Z0DF Nhac-Phim/IWZ9Z0ED Dai-Loan/IWZ9Z09F "
		topics+= "Hoa-Tau/IWZ9Z086 Classical/IWZ9Z0BI Cello/IWZ9Z0AD Nhac-Cu-Khac/IWZ9Z0E8 Piano/IWZ9Z0B0 New-Age-World-Music/IWZ9Z0BO Guitar/IWZ9Z0A9 Nhac-Cu-Dan-Toc/IWZ9Z0AA Violin/IWZ9Z0BU Saxophone/IWZ9Z0B7 "
		# console.log topics
		topics = topics.split(' ')
		# console.log topics.length
		for topic in topics
			link = "http://mp3.zing.vn/the-loai-album/" + topic + ".html?sort=release_date&p="
			link1 = "http://mp3.zing.vn/the-loai-album/" + topic + ".html?sort=hot&p="
			link2 = "http://mp3.zing.vn/the-loai-album/" + topic + ".html?sort=total_play&filter=day&p="
			link3 = "http://mp3.zing.vn/the-loai-album/" + topic + ".html?sort=total_play&filter=week&p="
			link4 = "http://mp3.zing.vn/the-loai-album/" + topic + ".html?sort=total_play&filter=month&p="
			for page in [1..20]
				@_fetchAlbumByGenre link, page
				@_fetchAlbumByGenre link1, page
				@_fetchAlbumByGenre link2, page
				@_fetchAlbumByGenre link3, page
				@_fetchAlbumByGenre link4, page
		null
	fetchVideoLink : ->
		@connect()

		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Fetching video links to table: #{@table.Artists}".magenta
		@connection.query "select id, video_encodedId from #{@table.Videos} where link is null", (err,videos)=>
			if err then console.log "cannt query songs"
			else
				@stats.totalItems =  videos.length
				for video, index in videos
					@_fetchVideoLink video
		# @stats.totalItems = artists.length
		# @stats.currentTable = @table.Artists
		# @_fetchVideoLink name for name in artists
		null
	
	updateAlbumCreatedTime : ->
		@connect()
		_q = "select album_thumbnail, albumid from #{@table.Albums}"
		@connection.query _q, (err, albums)=>
			if not err 
				for item in albums
					do (item) =>
						# console.log item
						if item.album_thumbnail.match(/_\d+\..+$/)
							time = item.album_thumbnail.match(/_\d+\..+$/)[0].replace(/_|\..+$/,'')
							time = new Date(parseInt(time,10)*1000)
							r = time.getFullYear() + "-" + (time.getMonth()+1) + "-" + time.getDate() + " " + time.getHours() + ":" + time.getMinutes() + ":" + time.getSeconds()
							_update = "update #{@table.Albums} set created=#{@connection.escape(r)} where albumid=#{@connection.escape(item.albumid)}"
							@connection.query _update, (err)=>
								if err then console.log "sdkjhaskgdhfsdhgfkdsjh"


	_update : (link0,page = 1) ->
		link = link0 + page
		# console.log link
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					# console.log data

					
					if data.match(/album\-detail\-img.+/g)
						albums = data.match(/album\-detail\-img.+/g)
						
						for album in albums
							_album = 
								albumid : album.match(/\/[0-9a-zA-Z]+\.html/g)[0].replace(/\//g,'').replace(/\.html/g,'')
								album_thumbnail : album.match(/src\=\".+/g)[0].replace(/src\=\"/g,'').replace(/\/><\/a><\/span>|\"\s/g,'')
							if _album.album_thumbnail.match(/_\d+\..+$/)
								_t = _album.album_thumbnail.match(/_\d+\..+$/)[0].replace(/_|\..+$/,'')
								_t = new Date(parseInt(_t,10)*1000)
								_created = _t.getFullYear() + "-" + (_t.getMonth()+1) + "-" + _t.getDate() + " " + _t.getHours() + ":" + _t.getMinutes() + ":" + _t.getSeconds()
								_album.created = _created
							item = album.match(/title\=\".+\"\shref/g)[0].replace(/title\=\"/g,'').replace(/\"\shref/g,'')

							_album.album_artist = item.split(' - ')[1]
							_album.album_name = item.split(' - ')[0]
							# @_fetchAlbum _album
							# console.log _album
							do (_album) =>
								@connection.query "select albumid from #{@table.Albums} where albumid=#{@connection.escape(_album.albumid)}", (err,result)=>
									if err then console.log "error while checking duplication of album. ERROR: #{err}"
									else
										@stats.totalItemCount +=1 
										if JSON.stringify(result) is '[]' 
											@stats.passedItemCount +=1
											# console.log _album
											@_fetchAlbumEncodedId _album
										else @stats.failedItemCount += 1
									# console.log @stats
									@utils.printUpdateRunning _album.albumid, @stats, "Fetching"
									if @stats.totalItemCount is 1200
										@utils.printFinalResult @stats
						data = ""
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	###*
	 * update albums and the relating songs to tables
	 * update() - scan 20 pages in every topic => _update() - scan single link in particular topic 
	 * => _fetchAlbumEncodedId() - fetch and album_encodedId and insert album into table
	 * => _fetchSongs() => _storeSongs() => _updateAlbumStats() => _updateSongIds()
	###
	update : ->
		@connect()
		console.log " |"+"Updating albums and songs".magenta
		@stats.currentTable = @table.Albums
		topics = "Viet-Nam/IWZ9Z08I Au-My/IWZ9Z08O Han-Quoc/IWZ9Z08W Nhat-Ban/IWZ9Z08Z Hoa-Ngu/IWZ9Z08U Hoa-Tau/IWZ9Z086"
		topics = topics.split(' ')
		for topic in topics
			link = "http://mp3.zing.vn/the-loai-album/" + topic + ".html?sort=release_date&p="
			for page in [1..20]
				@_update link, page
	
	updateIdFromAlbum : ->
		params = 
			sourceField : "albumid"
			table : @table.Songs
		@connect()
		@_getFieldFromTable params, (songid)=>
			_update = "update #{@params.table} SET albumida=#{@_convertToInt songid} where albumid=#{@connection.escape songid}"
			@connection.query _update, (err)->
				if err then console.log "Cannt update albumid"
	_getAlbum : (albumid)->
		link = "http://mp3.zing.vn/album/joke-link/#{albumid}.html"
		@_getFileByHTTP link, (data)=>
			try 
				@stats.totalItemCount +=1
				@stats.currentId = albumid
				if data isnt null
					album = 
						aid : @_convertToInt albumid
						albumid : albumid
					if data.match(/xmlURL.+\&amp\;/g) is null 
						@stats.failedItemCount += 1
						# @temp.totalFail+=1
						# console.log "ERROR : album #{albumid}: does not exist".red
					else

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
							album.album_artist = encoder.htmlDecode _tempArr[_tempArr.length-1]
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
							songs_albums =
								aid : album.aid
								sids : arr.map (v)=> @_convertToInt v
						else album.description = ""
						data = ""
						
						# console.log album
						# console.log songs_albums
						# Starting to insert new album
						# @temp.totalFail = 0
						@log.lastAlbumId = album.aid
						@connection.query @query._insertIntoZIAlbums, album, (err)=>
							if err then console.log "cannt insert new album: #{album.albumid}. ERROR: #{err}"
							else @_fetchSongs album.album_encodedId, songs_albums

						@stats.passedItemCount +=1		
				else 
					# @temp.totalFail+=1
					@stats.failedItemCount +=1

				@utils.printRunning @stats

				if @stats.totalFail is @stats.totalItemCount
					@utils.printFinalResult @stats
					# @_writeLog @log
				# else @_getAlbum @_convertToId(@_convertToInt(albumid)+1)

			catch e
				console.log "CANNOT fetch albumid : #{albumid}. ERROR: #{e}"
				@stats.failedItemCount +=1
				# @temp.totalFail+=1

	updateAlbumsLeft : ->
		
		file = fs.readFileSync "./album222.txt", "utf8"
		a = JSON.parse file
		@stats.totalItems = a.length
		@stats.currentTable = @table.Albums
		console.log "The number of albums: #{a.length}"
		# @temp.totalFail = 0
		@connect()
		for i in [0..a.length-1]
			@_getAlbum @_convertToId a[i]
	updateSongsAndAlbums : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Update Albums and Songs to table: #{@table.Albums} and #{@table.Songs}".magenta
		@temp = {}
		@temp.totalFail = 0

		@_getAlbum @_convertToId(@log.lastAlbumId+1)
	updateSongsStatsAndLyrics : (range0, range1) =>
		@connect()
		skippedRows = range0-1
		nItems = range1-range0+1
		@stats.currentTable = @table.Songs
		@stats.totalItems = nItems
		# _q = "Select sid from #{@table.Songs} where plays is null LIMIT #{skippedRows},#{nItems} "
		_q = "Select sid from #{@table.Songs} where plays is null "
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Update Songs author, topic and plays to table  : #{@table.Songs}".magenta
		console.log " |" + "It has been skipped #{skippedRows} rows and selected #{nItems} ones ".magenta

		@connection.query _q, (err, songs)=>
			if err then console.log "Cannot get songs from database. ERROR: #{err}"
			else 
				for song in songs 
					do (song)=>
						try 
							link = "http://mp3.zing.vn/bai-hat/joke-link/#{@_convertToId song.sid}.html"
							@_getFileByHTTP link, (data)=>
								@stats.totalItemCount +=1
								@stats.currentId = song.sid
								if data isnt null
									_song = 
										sid : song.sid
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

									_u = "update #{@table.Songs} SET plays=#{_song.plays}, "+
										 "topic = #{@connection.escape _song.topic}, " +
										 "author = #{@connection.escape _song.author} " +
										 "where sid= #{_song.sid} "
									
									_song = ""
									
									@stats.passedItemCount +=1
									@connection.query _u, (err)=>
										if err then console.log "cannt update song: #{song.sid}"

								else @stats.failedItemCount+=1

								@utils.printRunning @stats

								if @stats.totalItemCount is @stats.totalItems
									@utils.printFinalResult @stats
						catch e
							console.log "Error has occured during processing at song: #{song.sid}"
	updateSongsLeft : ->
		@connect()
		a = fs.readFileSync './song2.txt'
		a = JSON.parse a
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Update Songs left table  : #{@table.Songs}".magenta

		@stats.totalItems = a.length

		for songid in a
			do (songid)=>
				link = "http://mp3.zing.vn/bai-hat/joke-link/#{@_convertToId songid}.html"
				# console.log link
				@_getFileByHTTP link, (data)=>
					@stats.totalItemCount +=1
					@stats.currentId = songid
					if data isnt null
						_song = 
							sid : songid
							songid : @_convertToId songid

						# if data.match(/detail-title.+/g)
						# 	_temp = data.match(/detail-title.+/g)[0]
						# 						.replace(/detail-title/g,'')
						# 	_temp = _temp.split(/<span>-<\/span>/g)

						# 	_song.song_name = _temp[0].replace(/<\/h1>|>/g,'')
						# 	_song.song_artist = _temp[1].replace(/<\/a>.+$/g,'')
						# 								.replace(/^.+>/g,'')

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

						do (_song) =>
							@_getFileByHTTP _link, (data)=>
								data = JSON.parse data
								_song.song_name	= encoder.htmlDecode data.data[0].title
								_song.song_artist = encoder.htmlDecode data.data[0].performer
								_song.song_link = data.data[0].source
								@connection.query @query._insertIntoZISongs, _song, (err)=>
									if err then console.log "Cannot insert song: #{_song.songid} into table"
						_song = ""
						
						@stats.passedItemCount +=1
						
					else @stats.failedItemCount+=1

					@utils.printRunning @stats

					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats
	updateSongsLyrics : (range0,range1)=>
		@connect()
		skippedRows = range0-1
		nItems = range1-range0+1
		@stats.currentTable = @table.Songs
		@stats.totalItems = nItems
		# _q = "Select sid from #{@table.Songs} order by sid ASC LIMIT #{skippedRows},#{nItems} "
		_q = "Select sid from #{@table.Songs} where sid > 1382365890 and lyric is null"
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Update Songs lyrics to table  : #{@table.Songs}".magenta
		console.log " |" + "It has been skipped #{skippedRows} rows and selected #{nItems} ones ".magenta

		# console.log _q
		@connection.query _q, (err, songs)=>
			if err then console.log "Cannot get songs from database. ERROR: #{err}"
			else 
				for song in songs 
					do (song)=>
						try 
							link = "http://mp3.zing.vn/ajax/lyrics/lyrics?from=0&id=#{@_convertToId song.sid}&callback="
							# console.log link
							@_getFileByHTTP link, (data)=>
								try 
									@stats.totalItemCount +=1
									@stats.currentId = song.sid
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
																			.replace(/\\r/g,'').replace(/\\t/g,'').replace(/\\n/g,'')
										if t.search("Hiện chưa có lời bài hát") > -1
											t = ""
										t = encoder.htmlDecode t
										_u = "UPDATE #{@table.Songs} SET lyric=#{@connection.escape(t)} where sid=#{song.sid}"
										# console.log _u
										@connection.query _u, (err)->
											if err then console.log "Cannt update lyric #{song.sid}"

										@stats.passedItemCount +=1
										
									else 
										@stats.failedItemCount+=1
										console.log "FAILED"

									@utils.printRunning @stats

									if @stats.totalItemCount is @stats.totalItems
										@utils.printFinalResult @stats
								catch e
									@stats.failedItemCount+=1
						catch e
							console.log "Error has occured during processing at song: #{song.sid}"
	updateVideosLyrics : ->
		@connect()

		@stats.currentTable = @table.Videos
		# _q = "Select vid from #{@table.Videos} order by vid ASC LIMIT #{skippedRows},#{nItems} "
		_q = "Select vid from #{@table.Videos}"
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Update Videos lyrics to table  : #{@table.Videos}".magenta

		# console.log _q
		@connection.query _q, (err, videos)=>
			if err then console.log "Cannot get videos from database. ERROR: #{err}"
			else 
				@stats.totalItems = videos.length
				for video in videos 
					do (video)=>
						try 
							link = "http://mp3.zing.vn/ajax/lyric-v2/lyrics?id=#{@_convertToId video.vid}&from=0"
							# console.log link
							@_getFileByHTTP link, (data)=>
								try 
									@stats.totalItemCount +=1
									@stats.currentId = video.vid
									if data isnt null
										
										arr = JSON.parse(data).result

										bbb = arr.map (v)-> 
											v = v.match(/score\">\d+<\/span>/g)?[0].match(/\d+/g)?[0]
											if v isnt undefined then parseInt v,10 else 0

										zeroCount = 0
										bbb.map (v)->
											if v is 0 then zeroCount+=1

										index = bbb.indexOf Math.max bbb...

										# console.log bbb[index] + "<<<<=====    SCORE"

										if zeroCount is bbb.length then index = bbb.length-1

										# console.log bbb[index]
										t =  JSON.stringify(arr[index]).replace(/^.+<\/span><\/span>/g,'')
																			.replace(/<\/div>.+$/g,'')
																			.replace(/<\/p>\\n/g,'')
																			.replace(/\\r/g,'').replace(/\\t/g,'').replace(/\\n/g,'')
										if t.search("Hiện chưa có lời bài hát") > -1
											t = ""
										t = encoder.htmlDecode t
										_u = "UPDATE #{@table.Videos} SET lyric=#{@connection.escape(t)} where vid=#{video.vid}"
										# console.log _u
										@connection.query _u, (err)->
											if err then console.log "Cannt update lyric #{video.vid}"

										@stats.passedItemCount +=1
										
									else 
										@stats.failedItemCount+=1
										# console.log "FAILED"

									@utils.printRunning @stats

									if @stats.totalItemCount is @stats.totalItems
										@utils.printFinalResult @stats
								catch e
									@stats.failedItemCount+=1
						catch e
							console.log "Error has occured during processing at video: #{video.vid}"

	testPattern : (range0, range1) =>
		@connect()
		r0 = 1381664871
		r1 = 1381665770
		nSkipped = range0
		n0 = range1
		_q = "select aid,album_encodedId from ZIAlbums  where album_encodedId is not null ORDER BY aid ASC LIMIT #{nSkipped},#{n0} "
		a = []


		@connection.query _q, (err, results)=>
			if err then console.log "erroanenfadf "
			else 
				n = results.length
				console.log n
				character_14th = []
				for album, index in results
					# console.log album.album_encodedId
					a[index] = album.album_encodedId.split('')
					character_14th.push album.album_encodedId[13]
					# console.log(album.aid+" => "+JSON.stringify(a[index].join('')))

				# console.log JSON.stringify character_14th
				console.log "------------------"

				console.log results[0].aid + ".." + results[n-1].aid

				b = []
				for j in [0..23]
					b[j] = []
					for i in [0..n-1]
						b[j][i] = a[i][j]
				
				isElementInArr = (el, a)->
					check = false
					for value in a
						if el is value
							check = true 
					check

				reduce = (arr)->
					test = []
					for character in arr
						test.push character if not isElementInArr(character,test)
					test

				finale = []

				for i in [0..23]
					xxx = reduce b[i]

					_temp = xxx.sort().join('')
					finale.push _temp

					# console.log b[i].join('') + ":"+ (i) + " => " + JSON.stringify _temp
					console.log (i) + " => " + JSON.stringify _temp

				console.log JSON.stringify reduce finale

	testAAAA : ->
		@connect()
		_q = "select aid from ZIAlbums"
		a = [1381585028..1381667722]
		b = []
		@connection.query _q, (err, results)=>
			if err then console.log "cannt fetch songs"
			else 
				for album in results
					index = a.indexOf(album.aid) 
					if index isnt -1
						a[index] = 0

				for value in a
					if value isnt 0
						b.push value

				fs.writeFileSync "./album222.txt", JSON.stringify b

	updatePathAndCreated : ->
		@connect()
		@stats.currentTable = @table.Songs
		@stats.totalItems = 100000
		for i in [600001..600001] by 5000
			# _q = "select sid,song_link from ZISongs LIMIT #{i},5000"
			_q = "select sid,song_link from ZISongs where created is null"
			@connection.query _q, (err, results)=>
				if err then console.log "cannt fetch song"
				else 
					for value in results
						@stats.totalItemCount +=1
						@stats.currentId = value.sid

						_str =  value.song_link.replace(/^.+load-song\//g,'').replace(/^.+song-load\//g,'')
						testArr = []
						testArr.push @_decodeString _str.slice(i, i+4) for i in [0.._str.length-1] by 4
						path =  decodeURIComponent testArr.join('').match(/.+mp3/g)

						date = path.match(/^\d{4}\/\d{2}\/\d{2}/)?[0].replace(/\//g,"-")

						_u = "update #{@table.Songs} SET " +
							 "path=#{@connection.escape(path)}, " + 
							 "created=#{@connection.escape(date)} " +
							 "where sid=#{value.sid}"

						@connection.query _u, (err)->
							if err then console.log "Cannt update lyric #{value.sid}"

						@stats.passedItemCount +=1

						@utils.printRunning @stats

						if @stats.totalItemCount is @stats.totalItems
							@utils.printFinalResult @stats
	updateSplitArtistsofSongs : ->
		@connect()
		@stats.currentTable = @table.Songs
		@stats.totalItems = 120000
		for i in [600001..720000] by 5000
			_q = "select sid,song_artist from ZISongs LIMIT #{i},5000"
			# _q = "select sid,song_artist from ZISongs"
			@connection.query _q, (err, results)=>
				if err then console.log "cannt fetch song"
				else 
					for value in results
						@stats.totalItemCount +=1
						@stats.currentId = value.sid

						if value.song_artist.search(/[\".+\"]/g) isnt 1
							if value.song_artist.search(" ft. ") > -1
								artist = JSON.stringify value.song_artist.trim().split(' ft. ')
							else artist = JSON.stringify value.song_artist.trim().split(',')
							_u = "update #{@table.Songs} SET " +
								 "song_artist=#{@connection.escape(artist)} " +
								 "where sid=#{value.sid}"
							@connection.query _u, (err)->
								if err then console.log "Cannt update lyric #{value.sid}"

						@stats.passedItemCount +=1

						@utils.printRunning @stats

						if @stats.totalItemCount is @stats.totalItems
							@utils.printFinalResult @stats
	
	updateSplitArtistsofAlbums : ->
		@connect()
		@stats.currentTable = @table.Songs
		@stats.totalItems = 1
		for i in [1..1] by 5000
			_q = "select aid,album_artist from ZIAlbums"
			# _q = "select sid,album_artist from ZISongs"
			@connection.query _q, (err, results)=>
				if err then console.log "cannt fetch song"
				else 
					@stats.totalItems = results.length
					for value in results
						@stats.totalItemCount +=1
						@stats.currentId = value.aid

						if value.album_artist.search(/[\".+\"]/g) isnt 1
							if value.album_artist.search(" ft. ") > -1
								artist = JSON.stringify value.album_artist.trim().split(' ft. ')
							else artist = JSON.stringify value.album_artist.trim().split(',')
							_u = "update #{@table.Albums} SET " +
								 "album_artist=#{@connection.escape(artist)} " +
								 "where aid=#{value.aid}"
							@connection.query _u, (err)->
								if err then console.log "Cannt update lyric #{value.sid}"

						@stats.passedItemCount +=1

						@utils.printRunning @stats

						if @stats.totalItemCount is @stats.totalItems
							@utils.printFinalResult @stats
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

	updateVideos : ->
		@connect()

		@stats.currentTable = @table.Videos
		nItems = 100000
		

		startingNumber = 1381585048
		round = 8

		range0 = startingNumber + round*nItems
		range1 = startingNumber + (round+1)*nItems


		console.log "Running on: #{new Date(Date.now())}"
		console.log " |Starting from #{range0} -> #{range1}. Round is #{round}, nItems is #{nItems}"
		console.log " |"+"Update video to table  : #{@table.Videos}".magenta

		@stats.totalItems = nItems + 1
		
		for vid in [range0..range1-80000]
		# for vid in [1381945778..1381945778+100]
			do (vid)=>
				link = "http://mp3.zing.vn/video-clip/joke-link/#{@_convertToId vid}.html"
				@_getFileByHTTP link, (data)=>
					@stats.totalItemCount +=1
					@stats.currentId = vid
					
					if data isnt null
						if data.match(/xmlURL.+\&amp\;/g) is null then console.log "ERROR : video #{video.videoid}: #{video.title} of #{video.artist} does not exist".red
						else
							# _video = 
							# 	video_encodedId : data.match(/xmlURL.+\&amp\;/g)[0].replace(/xmlURL\=http\:\/\/mp3\.zing\.vn\/xml\/video\-xml\//g,'').replace(/\&amp\;/,'')
							_video = 
								vid : vid

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

							_video.created = "0000-00-00"

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
							# console.log _video
							# @_fetchVideoLink _video
							@connection.query @query._insertIntoZIVideos, _video, (err)->
								if err then console.log "Cannot insert video #{video.videoid} into table. Error: #{err}"
								else @_updateLyricForVideo _video.vid
						@stats.passedItemCount +=1		
					else 
						@stats.failedItemCount +=1

					@utils.printRunning @stats

					if @stats.totalItems is @stats.totalItemCount
						@utils.printFinalResult @stats

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

				if @temp.totalFail >= 1000
					@utils.printFinalResult @stats
					@_writeLog @log
				else @_updateAlbums albumid+1

			catch e
				console.log "CANNOT fetch albumid : #{albumid}. ERROR: #{e}"
				@stats.failedItemCount +=1
				@temp.totalFail+=1
	updateAlbums : ->
		@connect()
		@resetStats()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Update Albums and Songs_Albums to tables: #{@table.Albums} & #{@table.Songs_Albums}".magenta
		@temp = {}
		@temp.totalFail = 0
		@stats.currentTable = @table.Albums + " & " + @table.Songs_Albums
		@_updateAlbums @log.lastAlbumId+1

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
		_song = ""
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
					if @temp.totalFail < 1200
						@_updateSongs(songid + 1)

				@utils.printUpdateRunning songid, @stats, "Fetching....."

				if @temp.totalFail is 1200
					@utils.printFinalResult @stats
					@_writeLog @log
					@updateAlbums()
	updateSongs : ->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Update Songs to table: #{@table.Songs}".magenta
		@temp = {}
		@temp.totalFail = 0
		@stats.currentTable = @table.Songs

		@_updateSongs @log.lastSongId+1
	# ---------------------------------------
	# Update songs and albums with RANGE
	_updateSongsOrAlbumsWithRange : (range0, range1, isSong = true)->
		@connect()
		console.log "Running on: #{new Date(Date.now())}"
		if isSong 
			console.log " |"+"Update Songs to table: #{@table.Songs}".magenta
			@stats.currentTable = @table.Songs
		else 
			console.log " |"+"Update Albums to table: #{@table.Albums}".magenta
			@stats.currentTable = @table.Albums
		
		@stats.totalItems = range1 - range0 + 1

		for id in [range0..range1]
			do (id)=>
				if isSong then link = "http://mp3.zing.vn/bai-hat/joke-link/#{@_convertToId id}.html"
				else link = "http://mp3.zing.vn/album/joke-link/#{@_convertToId id}.html"
				@_getFileByHTTP link, (data)=>
					try 	
						@stats.totalItemCount +=1
						@stats.currentId = id
						if data isnt null
							if isSong then @_processSong id, data
							else @_processAlbum id, data
							data = ""
							@stats.passedItemCount +=1
						else 
							@stats.failedItemCount+=1

						@utils.printRunning @stats

						if @stats.totalItems is @stats.totalItemCount
							@utils.printFinalResult @stats
	updateSongsWithRange : (range0, range1) =>
		@_updateSongsOrAlbumsWithRange range0, range1, true
	updateAlbumsWithRange : (range0, range1) =>
		@_updateSongsOrAlbumsWithRange range0, range1, false
		
		

	findDiffenceBetween2Strings : (s1,s2)->
		# console.log "#{s1}".blue
		# console.log "#{s2}".green
		if s1.length is s2.length
			arr = []
			for i in [0..s1.length-1]
				if s1[i] isnt s2[i]
					arr.push i
			arr

		else 
			# console.log "ALERT: 2 strings are not equal. S1: #{s1.length}, S2: #{s2.length}"
			# console.log "#{s1}".blue
			# console.log "#{s2}".green
			[]
	###*
	 * TO GET PATTERN LIKE (38:M,c)----18-----=>(I,b)
	 * @return {[type]} [description]
	###
	test1 : ->
		base = "http://mp3.zing.vn/blog?"
		query = "DY4MMy8wMi8xMS84L2EvInagaMEOGFlMDY4MjdhNmQwMzExNDk1YmNjZTIyOTU5ODViOGUdUngWeBXAzfEZvInagaMEmUsICmV2ZXIgQWxvInagaMEWeBmV8SnVzdGFUZWV8MXwy"
		base62 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
		originalLink = base + query
		console.log originalLink
		@_getFileByHTTP (originalLink), (data)=>
			console.log data
			originalData =  JSON.stringify(data).replace(/fsfsdfdsfdserwrwq3\/[a-f0-9]+\/[a-f0-9]+/g,'')
											.replace(/\?q\=[a-f0-9]+\&amp;t\=[0-9]+/g,'')
			for i in [0..query.length-1]
				link = query.split('')
				# console.log "-----------------------"
				# console.log "#{link.join('')}".red
				for j in [0..base62.length-1]
					if query[i] isnt base62[j]
						do (i,j) =>
							link[i] = base62[j]

							# console.log query[i] + "=>" + base62[j] + ":" + link.join('')
							l = base + link.join('')


							@_getFileByHTTP (l), (d)=>
								if d isnt undefined
									secondaryData = JSON.stringify(d).replace(/fsfsdfdsfdserwrwq3\/[a-f0-9]+\/[a-f0-9]+/g,'')
															 .replace(/\?q\=[a-f0-9]+\&amp;t\=[0-9]+/g,'')
									indexes = @findDiffenceBetween2Strings originalData, secondaryData
									# console.log "Changing #{query[i]} at position #{i} to #{base62[j]}. At position : "+JSON.stringify(indexes) + ": the character "+ 
									# 			indexes.map((index)-> originalData[index]).join(' ') + "=>" + 
									# 			indexes.map((index)-> secondaryData[index]).join(' ') + ";"
									# 			
									# 			
									if indexes.length is 1
										arrayS = "0123456789abcdefmp/.".split('')
										if indexes.map((index)-> secondaryData[index]).join(' ') in arrayS
											console.log "(#{i}:#{query[i]},#{indexes.map((index)-> originalData[index]).join(' ')})----#{indexes[0]-28}-----=>(#{base62[j]},#{indexes.map((index)-> secondaryData[index]).join(' ')})" 
											# console.log originalData
											# console.log secondaryData

	test : ->
		base = "http://mp3.zing.vn/blog?"
		query   = "MjAxMyUyRjAzJTJGMDklMkY5JTJGYyUyRjljYmQzM2I4OWE4ZWUyOTU1YTcyZjI3MTU0ZGIzMTk1Lm1wMyU3QzI"
		suffix  = "**4MMy8wMi8xMS84L2EvInagaMEOGFlMDY4MjdhNmQwMzExNDk1YmNjZTIyOTU5ODViOGUdUngWeBXAzfEZvInagaMEmUsICmV2ZXIgQWxvInagaMEWeBmV8SnVzdGFUZWV8MXwy"
		
		base62 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz="

		base24_A = "IJKLMNOPQRSTUVWXYZabcdef"
		base24_B = "CDEFGHSTUVWXijklmnyz0123"
		originalLink = base + query
		
		# for i in base24_A 
		# 	for j in base24_B
				# str = i+j
				# uri = suffix.replace(/[*]+/g,str)
				# link = base + uri
				# do (i,j,link)=>
				# 	process.stdout.write "(#{i},#{j})\r"
				# 	@_getFileByHTTP (link), (data)=>
				# 		if data isnt undefined
				# 			data =  JSON.stringify(data).replace(/fsfsdfdsfdserwrwq3\/[a-f0-9]+\/[a-f0-9]+/g,'')
				# 			# console.log data
				# 			process.stdout.write "(#{i},#{j})\r"
				# 			# if i is "M" and j is "j"
				# 			# 	console.log link
				# 			# 	console.log "(#{i},#{j})--->" + data
				# 			# if data.length is 80 
				# 			if data[186] isnt "�" and data[187] isnt "�"
				# 				# if data[29] is "0"
				# 					# if data[28] in "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/.".split('')
				# 						nCounts +=1
				# 						# console.log data[186] + "---------------"
				# 						console.log "(#{i}#{j})=>(#{data[186]}#{data[187]})---(#{i.charCodeAt(0)},#{j.charCodeAt(0)})=>(#{data[186].charCodeAt(0)},#{data[187].charCodeAt(0)})"

				# 			if i is "z" and j is "z" then console.log nCounts


				# finding the third param IC[A-Z,a-z,0-9....]
		
		base62 =   "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"


		basei = "ABCDEFGH" # not in base24_A
		basej = "ABCDEFGHQRSTUVWXghijklmnwxyz0123" # not in base 24_B
		
		basek = "ABEFIJMNQRUVYZcdghklopstwx014589"
		baseC = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

		# # case 1
		# basei = "01234567"
		# basej = "IJKLYZabopqr4567"
		# basek = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
		# # end of case 1


		nCounts = 0

		suffix1 = "åæøxMyUyRjAzJTJGMDklMkY5JTJGYyUyRjljYmQzM2I4OWE4ZWUyOTU1YTcyZjI3MTU0ZGIzMTk1Lm1wMyU3QzI"


		#case 1 but in the case it depends on 4th character
		# basei = "I"
		# basej = "A"
		# basek = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
		# suffix1 = "0åæøMyUyRjAzJTJGMDklMkY5JTJGYyUyRjljYmQzM2I4OWE4ZWUyOTU1YTcyZjI3MTU0ZGIzMTk1Lm1wMyU3QzI"
		# #### end of case 1
		for i in basei
			for j in basej
				for k in basek
					uri = suffix1.replace(/[å]+/g,i).replace(/[æ]+/g,j).replace(/[ø]+/g,k)

					do (i,j,k,uri)=>
						link = base + uri
						process.stdout.write "(#{i},#{j},#{k})\r"
						@_getFileByHTTP (link), (data)=>
							if data isnt undefined
								data =  JSON.stringify(data).replace(/fsfsdfdsfdserwrwq3\/[a-f0-9]+\/[a-f0-9]+/g,'')
														.replace(/^..+zdn\.vn\/\//g,'')
														.replace(/\?q\=.+/,'')
								process.stdout.write "(#{i},#{j},#{k})\r"
								# if data.length is 80 
									# if data[28] isnt "�" and data[29] isnt "�" and data[30] isnt "�"
										# if data[29] is "0"
											# if data[28] in "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/.".split('')
								nCounts +=1
								# console.log data
								data = encoder.htmlDecode data
								if data[0] isnt "�" and data[1] isnt "�" and data[2] isnt "�"
									console.log "(#{uri.substr(0,4)})=>(#{data.substr(0,14)})---"+
										"(#{uri.substr(0,4).split('').map((v)->v.charCodeAt(0))})=>"+
										"(#{data.substr(0,14).split('').map((v)->v.charCodeAt(0))})"

								


	showStats : ->
		@_printTableStats ZI_CONFIG.table


module.exports = Zing
