http = require 'http'
xml2js = require '../node_modules/xml2js'
Module = require './module'
Utils = require './utils'
colors = require '../node_modules/colors'
fs = require 'fs'

events = require('events')

Encoder = require('../node_modules/node-html-encoder').Encoder
encoder = new Encoder('entity');

NV_CONFIG = 
	table : 
		Songs : "nvsongs"
		Albums : "nvalbums"
		Songs_Albums : "nvsongs_albums"
		Videos : "nvvideos"
	logPath : "./log/NVLog.txt"
http.globalAgent.maxSockets = 10
class Nhacvui extends Module
	constructor : (@mysqlConfig, @config = NV_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoNVSongs : "INSERT INTO " + @table.Songs + " SET ?"
			_insertIntoNVAlbums : "INSERT INTO " + @table.Albums + " SET ?"
			_insertIntoNVSongs_Albums : "INSERT INTO " + @table.Songs_Albums + " SET ?"
			_insertIntoNVVideos : "INSERT INTO " + @table.Videos + " SET ?"
		@utils = new Utils()
		@parser = new xml2js.Parser()
		@eventEmitter = new events.EventEmitter()
		super @mysqlConfig
		@logPath = @config.logPath
		@log = {}
		@_readLog()
		String::stripHtmlTags = (tag)->
			if not tag then tag = ""
			@.replace(RegExp("</?" + tag + "[^<>]*>", "gi"), "")
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
				else onFail("The link is temporary moved",options)
			.on 'error', (e) =>
				onFail  "Cannot get file from server. ERROR: " + e.message, options

	getFiles : (range,processLinkCallback,processDataCallback)->
		for id in [range.first..range.last]
			do (id) =>
				href = processLinkCallback(id)
				@getFileByHTTP href,((data)=>
					@stats.totalItemCount +=1
					if data isnt null
						@stats.passedItemCount +=1
						result = processDataCallback(id,data)
						# insertIntoDBCallback(result)
						@eventEmitter.emit 'result', result
					else @stats.failedItemCount +=1

					@utils.printRunning @stats
					@stats.currentId = id

					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats

				), (err) ->
					console.log "We have an error while fetching files"


	formatDate : (dt)->
		dt.getFullYear() + "-" + (dt.getMonth()+1) + "-" + dt.getDate() + " " + dt.getHours() + ":" + dt.getMinutes() + ":" + dt.getSeconds()
	refineAuthorOrArtist : (str)->
		return encoder.htmlDecode(str).split().splitBySeperator(' / ').splitBySeperator(' - ')
			.splitBySeperator(' – ').splitBySeperator(', ').splitBySeperator(' ft ')
			.splitBySeperator(' feat ').splitBySeperator(' ft. ').splitBySeperator(' feat. ')
			.splitBySeperator(' Feat. ').splitBySeperator(' Ft. ').splitBySeperator(' & ')
			.splitBySeperator(' vs. ').splitBySeperator('- ').splitBySeperator(' & ')
			.replaceElement('Đang Cập Nhật...','').replaceElement('Đang Cập Nhật (QT)','')
			.replaceElement('Đang Cập Nhật (VN)','').replaceElement('Nhạc Phim QT','Nhạc Phim Quốc Tế')
			.replaceElement('Nhiều Ca Sỹ','Various Artists')
	processSongCallback : (id,data, item)->
		if !data.match(/Bài\shát\skhông\stồn\stại/)
			# console.log data
			_t = data.match(/<div class="nghenhac-info">.+/g)?[0]
			artists = data.match(/<div class="nghenhac-baihat">.+/g)?[0]
			if artists
				temp = artists.stripHtmlTags().split(' - ')
				artists = temp[temp.length-1]
				temp.length = temp.length-1
				title = encoder.htmlDecode temp.join(' - ')

				if artists.match(/Đang Cập Nhật/gi)
					artists = ""
				
				artists  = @refineAuthorOrArtist(artists)
			else 
				artists = null
			song = 
				id : id
				title : title
				artists : artists
				plays : 0
				topics : null
				authors : null
				link : item.link
				lyric : ""
				type : item.type
			if _t isnt undefined
				_t = _t.stripHtmlTags()
				# console.log _t
				if _t.match(/Lượt nghe:\s+([0-9]+)/)?[1]
					song.plays = parseInt(_t.match(/Lượt nghe:\s+([0-9,]+)/)?[1].trim().replace(/,/g,''),10)
				song.topics = encoder.htmlDecode _t.match(/Thể loại:(.+?)\|/)?[1].trim()
				if song.topics
					song.topics = song.topics.split().splitBySeperator(' / ').splitBySeperator('/')
						.splitBySeperator(' & ')
				song.authors = encoder.htmlDecode _t.match(/Nhạc sĩ:(.+?)\|/)?[1].trim()


			song.lyric = encoder.htmlDecode data.match(/media_title.+/g)?[0].replace(/<\/div><div\s.+$/g,'').replace(/^.+<\/span><\/i><\/div>/g,'').trim()
			# console.log song.lyric + "------"
			# console.log data
			if song.lyric 
				if song.lyric.match(/Hiện\sbài\shát.+chưa\scó\slời/)
					song.lyric = ""
			if song.lyric is undefined then song.lyric = ""

			

			if song.authors is undefined then song.authors = null
			if song.authors and song.authors.match(/Đang\sCập\sNhật/i)
				song.authors = null

			if song.authors isnt null and song.authors isnt undefined
				song.authors = @refineAuthorOrArtist(song.authors)

		else song = null

		song
	getSongStats : (id,item)->
		if item.link.match(/mp3/)
			item.type = "song"
			href = "http://hcm.nhac.vui.vn/-m#{id}c2p1a1.html"
		else 
			item.type = "video"
			href = "http://hcm.nhac.vui.vn/-clip#{id}c2.html"
		
		# console.log href
		@stats.currentId = id
		@getFileByHTTP href,(data)=>
			# console.log data + "   -------"
			@stats.totalItemCount +=1
			@utils.printUpdateRunning id, @stats, "Fetching..."
			if data isnt null
				@stats.passedItemCount +=1
				# console.log data
				result = @processSongCallback(id,data,item)
				if result isnt null
					# console.log result
					# process.exit 0
					if result.type is 'song'
						@connection.query @query._insertIntoNVSongs, result, (err)->
							if err then console.log "Can not insert new song #{result.id} : #{err}"
					else 
						@connection.query @query._insertIntoNVVideos, result, (err)->
							if err then console.log "Can not insert new video: #{result.id} #{err}"
				else 
						@stats.failedItemCount +=1
						@stats.passedItemCount -=1
				
			else 
				@stats.failedItemCount +=1	
	_storeSong : (id, song) ->
		_item = 
			songid : id
			song_name : encoder.htmlDecode song.title[0].trim()
			artist_name : encoder.htmlDecode song.description[0].replace("Thể hiện: ","").trim()
			link : song['jwplayer:file'][0]
		range =
		      first : id
		      last : id
		@getSongStats id, _item	
		_item		


	_storeSong320 : (id, song) ->
		_item = 
			songid : id
			annotation : encoder.htmlDecode song.annotation[0].replace("Thể hiện: ","").trim()
			link320 : song.location[0]
		_query = "update #{@table.Songs} set annotation=#{@connection.escape(_item.annotation)}, link320=#{@connection.escape(_item.link320)} where songid=#{_item.songid}"
		@connection.query _query, (err) ->
		 	if err then console.log "Cannot update the song: #{_item.songid} into table. ERROR: " + err + "....." + _query	
	_storeAlbum : (id,album) ->
		for song in album
			_item = 
				id : id
				title : encoder.htmlDecode song.title[0].trim()
				artists : encoder.htmlDecode song.description[0].replace("Thể hiện: ","").trim()
				link : song['jwplayer:file'][0]
			@connection.query @query._insertIntoNVAlbums,_item,(err) =>
				if err then console.log "Cannot get id: #{_item.id}. ERROR: ".red + err
				else @_updateAlbumName _item.id 
	_storeAlbumName : (id, album)->
		_query = "UPDATE #{@table.Albums} SET " +
				" title   = #{@connection.escape(album.album_name)},"+
				" artists = #{@connection.escape(album.album_artist)}," +
				" topics = #{@connection.escape(album.topic)}," +
				" plays = #{album.plays}" +
				" where id = #{id};"
		
		@connection.query _query, (err)->
			if err then console.log "Cant not update id: #{id}. ERROR: " + err

	_updateSong : (id) ->
		# console.log id
		# console.log "# of FAILED ITEMS is : " + @temp.totalFail + " songid is " + id
		link = "http://hcm.nhac.vui.vn/asx2.php?type=1&id=" + id
		@stats.currentTable = @table.Songs
		@getFileByHTTP link, (data) =>
			@parser.parseString data, (err, result) =>
				song = result.rss.channel[0].item[0]
				# @stats.totalItemCount+=1
				@utils.printUpdateRunning id, @stats, "Fetching..."
				# console.log(typeof song.title[0])
				if typeof song.title[0] isnt 'object' and	song.title[0] isnt ""
					@stats.currentId = id
					@_storeSong id, song
					@_updateSong id+1
					@log.lastSongId = id
				else 
					@stats.totalItemCount +=1
					@stats.failedItemCount+=1
					@temp.totalFail+=1
					if @temp.totalFail < 100
						@_updateSong id+1
					else
						if @stats.passedItemCount is 0
							console.log ""
							console.log "Table: #{@table.Songs} is up-to-date"
						else 
							# console.log "WE ARE DONE!"
							@utils.printFinalResult @stats
							@_writeLog @log
						# @end()
						@resetStats()
						@updateAlbums()

				

	_updateSong320 : (id) ->
		link = "http://hcm.nhac.vui.vn/asx2.php?type=5&id=" + id
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					@parser.parseString data, (err, result) =>
						song = result.rss.channel[0].track[0]
						data = ""
						if typeof song.title[0] isnt 'object'
							@_storeSong320 id, song
			.on 'error', (e) =>
				console.log  "Got error: " + e.message		
	_updateAlbum : (id) ->
		# update album
		href = "http://hcm.nhac.vui.vn/-a#{id}p1.html"
		@getFileByHTTP href,((data)=>
			@stats.totalItemCount +=1
			if data isnt null
				@stats.passedItemCount +=1
				result = @processAlbumData(id,data)
				
				# insertIntoDBCallback(result)
				@eventEmitter.emit 'result', result
			else @stats.failedItemCount +=1

			@utils.printUpdateRunning id, @stats, "Fetching..."

			if @temp.totalFail < 100
				@_updateAlbum id+1
			else 
				if @stats.totalItemCount is 100
					console.log ""
					console.log "Table: #{@table.Albums} is up-to-date"
				else 
					@utils.printFinalResult @stats
					@_writeLog @log

		), (err) =>
			console.log "We have an error while fetching files"
			@stats.totalItemCount +=1
			@stats.failedItemCount +=1
			@utils.printUpdateRunning id, @stats, "Fetching..."

		
		
	_updateAlbumName : (id) ->
		link = "http://hcm.nhac.vui.vn/-a#{id}p1.html"
		# Album không tồn tại.
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					if data.search('Album không tồn tại.') is -1
						title_artist = data.match(/nghenhac-baihat.+/g)[0]
							.replace(/\<\/h\d\>\<\/div\>/g,'')
							.replace(/^.+>/g,'')

						plays = data.match(/Lượt\snghe:.+/g)?[0]
							.replace(/<\/p>/g,'')
							.replace(/^.+>/g,'')
							.replace(/,/g,'').trim()

						topic = data.match(/Thể\sloại:.+/g)?[0]
							.replace(/<\/a><\/p>.+$/g,'')
							.replace(/^.+>/g,'')
						data = ""
						
						#split by dash sign (-) EX: "Cpop Chart (15/6 - 22/6 ) - Various Artists"
						#_name = "Cpop Chart (15/6 - 22/6 )" and _artist="Various Artists"
						_arr = title_artist.split(/\s\-\s/)
						_artist = _arr[_arr.length-1]
						_arr.splice(_arr.length-1,1)
						_name = _arr.join(" - ")
						_arr = ""

						album = 
							album_name : encoder.htmlDecode _name.trim()
							album_artist : encoder.htmlDecode _artist.trim()
							topic : topic
							plays : plays

						@_storeAlbumName id, album
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	
	_fetchSong : (id) ->
		# fetch song
		link = "http://hcm.nhac.vui.vn/asx2.php?type=1&id=" + id
		@stats.currentTable = @table.Songs
		@stats.currentId  = id
		@getFileByHTTP link, (data) =>
			@parser.parseString data, (err, result) =>
				song = result.rss.channel[0].item[0]
				# @stats.totalItemCount+=1
				@utils.printRunning @stats
				if typeof song.title[0] isnt 'object'	
					@stats.currentId = id
					@_storeSong id, song
				else 
					@stats.failedItemCount+=1
					
			if @stats.totalItems is @stats.totalItemCount
				@utils.printFinalResult @stats
		
	_fetchAlbum : (range0 = 0, range1 = 0) ->
		# console.log range1
		range = 
			first : range0
			last : range1
		
		processLinkCallback  = (id)-> "http://hcm.nhac.vui.vn/-a#{id}p1.html"
		@getFiles range,processLinkCallback,@processAlbumData

	_fetchAlbumName : (id) ->
		link = "http://hcm.nhac.vui.vn/-a#{id}p1.html"
		# Album không tồn tại.
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					# console.log JSON.stringify data
					@stats.totalItemCount+=1
					if data.search('Album không tồn tại.') is -1
						@stats.passedItemCount+=1
						title_artist = data.match(/\<div\sclass=\"nghenhac-baihat\"\>\<h2\>.+/)[0]
							.replace(/\<div\sclass=\"nghenhac-baihat\"\>\<h2\>/,'')
							.replace(/\<\/h2\>\<\/div\>/,'')

						type_plays = data.match(/\<div\sclass=\"nghenhac-info\"\>.+/)[0]
							.replace(/\<div\sclass=\"nghenhac-info\"\>/,'')
							.replace(/Thể loại:\s\<a\shref=\"\/.+\.html\"\stitle=\".+\"\>/,'')
							.replace(/\<\/a\>\s/,'')
							.replace(/Nghe:\s/,'')
							.replace(/\<\/div\>/,'')
						data = ""
						
						#seperate by dash sign (-) EX: "Cpop Chart (15/6 - 22/6 ) - Various Artists"
						#_name = "Cpop Chart (15/6 - 22/6 )" and _artist="Various Artists"
						_arr = title_artist.split(/\s\-\s/)
						_artist = _arr[_arr.length-1]
						_arr.splice(_arr.length-1,1)
						_name = _arr.join(" - ")
						_arr = ""

						album = 
							album_name : encoder.htmlDecode _name.trim()
							album_artist : encoder.htmlDecode _artist.trim()
							topic : encoder.htmlDecode type_plays.split('|')[0].trim()
							plays : type_plays.split('|')[1].replace(/\,/g,'').trim()

						@_storeAlbumName id, album
						
					else 
						@stats.failedItemCount+=1

					@utils.printRunning @stats
					if @stats.totalItemCount is @stats.totalItems
						@utils.printFinalResult @stats	
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	
	fetchSongs : (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching songid: #{range0}..#{range1} to table: #{ @table.Songs}".magenta
		@stats.totalItems = range1 - range0 + 1
		[@stats.range0, @stats.range1] = [range0, range1]
		@stats.currentTable = @table.Songs
		@_fetchSong id for id in [range0..range1]
		null
	fetchAlbums : (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching albumid: #{range0}..#{range1} to table: #{@table.Albums}".magenta
		@stats.totalItems = range1 - range0 + 1
		[@stats.range0, @stats.range1] = [range0, range1]
		@stats.currentTable = @table.Albums
		@stats.totalItems = range1 - range0 + 1
		console.log "THE # OF ALBUMS IS #{@stats.totalItems}"

		# event 'result' triggered when called
		@eventEmitter.on 'result', (result)=>
			if result isnt null
				# console.log result
				
				@connection.query @query._insertIntoNVAlbums, result.album, (err)=>
					if err then console.log "cannt insert album: #{result.album.aid} into table. ERROR: #{err}"
					else 
						for sid in result.songids
							do (sid,result)=>
								@connection.query @query._insertIntoNVSongs_Albums, {"sid" : sid,"aid" : result.album.aid}, (err)->
									if err then console.log "cannt insert song: #{sid} - album: #{result.album.aid}"

			else 
				@stats.failedItemCount +=1
				@stats.passedItemCount -=1

		for id in [range0..range1]
			do (id)=>
				@_fetchAlbum id, id
		null
	fetchAlbumName : (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching album's names from id: #{range0}..#{range1} to table: #{@table.Albums}".magenta
		@stats.totalItems = range1 - range0 + 1
		[@stats.range0, @stats.range1] = [range0, range1]
		@stats.currentTable = @table.Albums
		@_fetchAlbumName id for id in [range0..range1]
		null
	
	processAlbumData : (id,data)=>
		if data.search('Album không tồn tại.') is -1
			@log.lastAlbumId = id
			title_artist = data.match(/nghenhac-baihat.+/g)[0]
				.replace(/\<\/h\d\>\<\/div\>/g,'')
				.replace(/^.+>/g,'')

			plays = data.match(/Lượt\snghe:.+/g)?[0]
				.replace(/<\/p>/g,'')
				.replace(/^.+>/g,'')
				.replace(/,/g,'').trim()

			topic = data.match(/Thể\sloại:.+/g)?[0]
				.replace(/<\/a><\/p>.+$/g,'')
				.replace(/^.+>/g,'')
			

			nsongs = data.match(/Số\sbài\shát:\s.+/g)?[0]
				.replace(/<\/p>$/g,'')
				.replace(/^.+>/g,'')

			thumbnail = data.match(/albumInfo-img.+[\n\t\r]+.+/g)?[0]
											.replace(/\"\salt.+$/g,'').replace(/^.+\s.+\"/g,'')

			date_created = ""

			if thumbnail?.match(/\d+_/g)
				date_created = thumbnail.match(/\d{10,14}_/g)?[0]?.replace(/_/g,'')

			if !thumbnail?.match(/http/)
				thumbnail = "http://hcm.nhac.vui.vn" + thumbnail

			songids = data.match(/javascript:liked_onclick\(\'\d+\'\)/g)
			songids = songids?.map (v)-> parseInt v.match(/\d+/)[0],10
			data = ""
			
			#split by dash sign (-) EX: "Cpop Chart (15/6 - 22/6 ) - Various Artists"
			#_name = "Cpop Chart (15/6 - 22/6 )" and _artist="Various Artists"
			_arr = title_artist.split(/\s\-\s/)
			_artist = _arr[_arr.length-1]
			_arr.splice(_arr.length-1,1)
			_name = _arr.join(" - ")
			_arr = ""

			album = 
				id : id
				title : encoder.htmlDecode _name.trim()
				artists : @refineAuthorOrArtist _artist.trim()
				topics : topic.split().splitBySeperator(' / ').splitBySeperator('/')
						.splitBySeperator(' & ')
				plays : parseInt plays,10
				nsongs : parseInt nsongs,10
				coverart : thumbnail
				songids : songids
			
			if date_created isnt "" then album.date_created = @formatDate new Date(parseInt(date_created,0)*1000)
			else album.date_created = null

			result = 
				album : album

		else return null
		result

	update : ->
		@connect()
		@_readLog()
		@temp = {}
		@temp.totalFail = 0
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating Songs to table: #{@table.Songs}".magenta 
		@_updateSong @log.lastSongId+1
		# @_updateSong 341077

	updateAlbums : ->
		@connect()
		@_readLog()
		@temp = {}
		@temp.totalFail = 0
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"Updating Albums to table: #{@table.Albums}".magenta 
		@eventEmitter.on 'result', (result)=>
			if result isnt null
				# console.log @log.lastAlbumId
				
				# console.log result.album
				# process.exit 0

				@connection.query @query._insertIntoNVAlbums, result.album, (err)=>
					if err then console.log "cannt insert album: #{result.album.aid} into table. ERROR: #{err}"

			else 
				@stats.failedItemCount +=1
				@stats.passedItemCount -=1
				@temp.totalFail +=1
		@_updateAlbum @log.lastAlbumId+1

	updateSongsStats : ->
		range = 
			first : 314048
			last : 314116
		@stats.totalItems = range.last - range.first + 1
		@stats.currentTable = @table.Songs

		console.log "THE # OF ITEMS IS #{@stats.totalItems}"

		@connect()

		processLinkCallback  = (id)-> "http://hcm.nhac.vui.vn/-m#{id}c2p1a1.html"
		processSongCallback = (id,data)->
			if !data.match(/Bài\shát\skhông\stồn\stại/)
				_t = data.match(/Nhạc\ssĩ:.+/g)?[0]
				song = 
					songid : id
					plays : 0
					topic : ""
					author : ""
					lyric : ""
				if _t isnt undefined
					song.plays = _t.match(/Lượt\snghe.+/g)[0].replace(/<\/div>.+/g,'').replace(/Lượt\snghe:|,/g,'').trim()
					song.topic = _t.replace(/<\/a>.+$/g,'').replace(/^.+>/g,'').trim()
					song.author = encoder.htmlDecode _t.replace(/<\/span>.+/g,'').replace(/^.+>/g,'').trim()

				song.lyric = data.match(/media_title.+/g)?[0].replace(/<\/div><div\s.+$/g,'').replace(/^.+<\/span><\/i><\/div>/g,'').trim()

				if song.lyric
					if song.lyric.match(/Hiện\sbài\shát.+chưa\scó\slời/)
						song.lyric = ""

				if song.author.match(/Đang\sCập\sNhật/)
					song.author = ""
				song
			else 
				song = null
			song
		
		@eventEmitter.on 'result', (result)=>
			if result isnt null
				_q = "update #{@table.Songs} set " + 
						 "plays = #{@connection.escape result.plays}, " + 
						 "topic = #{@connection.escape result.topic}, " + 
						 "author = #{@connection.escape result.author}, " + 
						 "lyric = #{@connection.escape result.lyric} " + 
						 "where songid = #{result.songid} "
				@connection.query _q, (err)->
					if err then console.log "cannt insert into databaseq"
			else 
				@stats.failedItemCount +=1
				@stats.passedItemCount -=1

		@getFiles range,processLinkCallback,processSongCallback

	showStats : ->
		@_printTableStats NV_CONFIG.table



module.exports = Nhacvui
