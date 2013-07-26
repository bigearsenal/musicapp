Site = require "../Site"


class HDViet extends Site
	constructor: ->
		super "hdv"
		RC4 = require './RC4'
		@rc4 = new RC4()
		@fs = require 'fs'
	getLink : (link,options,callback)->
		onSuccess = (data,_options)->
			callback(null,data,_options)
		onFail = (err,_options)->
			callback(err,null,_options)

		if callback #means that options is available
			_options = options
		else 
			# when user does not put options value
			callback = options
			_options = null
		# console.log "#{link} ..............."
		@getFileByHTTP link,onSuccess,onFail,_options
	
	getFileMetadata : (link,findEpisode,callback)->
		
		# console.log link + " getFileMetadata() called"
		@getLink link, (err,data,options)=>
			if err 
				callback(err,null)
			else
				decryptedData =  @rc4.decrypt(data,"HDVN@T@oanL@c")

				title = link.match(/([0-9]+)\.xml/)?[1]
				# @fs.writeFileSync './hdviet_m3u8/2839.xml',decryptedData
				if decryptedData.match(/episode/) and findEpisode is true
					# we find an episode

					episodes = decryptedData.match(/<link lable=.+/g)
					episodes = episodes.map (v)-> v.match(/http.+xml/)?[0]
					# console.log episodes
					playlist = 
						title : title
						type : "series"
						elinks : episodes
				else
					href = decryptedData.match(/playlist.+source="(.+)"/)?[1]
					playlist = 
						title : title
						type : "movie"
						link : href

				callback(null,playlist)
	
	decodePlaylist : (playlist,callback)->
		@getLink playlist.link, (err,data,options)=>
			if err 
				callback err,null
			else 
				
				data =  @rc4.decrypt(data,'hdviet123#@!')
				
				# console.log data
				formats = data.match(/.+m3u8/g)
				_file = 
					title : playlist.title
					type : playlist.type
					links : []
				links = []
				links.push playlist.link.replace(/playlist.+$/,format) for format in formats
				_file.links = links
				callback null,_file

	getPlaylistOfASeries : (file,callback) ->
		console.log "The id belongs to series"
		console.log "Finding episodes in series....."
		count = 0
		_file = 
			title : file.title
			type : file.type
			episodes : []	
		totalCount = 	file.elinks.length			
		for elink in file.elinks
			do (elink)=>
				@getFileMetadata elink, false, (err,file)=>
					if err 
						callback err,null
					else 
						if file.type is "movie"
							count +=1
							_file.episodes.push file.link

						if count is totalCount
							callback null, _file

	getPlaylist : (movieid,callback)->
		link = "http://movies.hdviet.com/#{movieid}.xml"
		@getFileMetadata link, true, (err,playlist)=>
			if err  
				callback err + " at ------- ",null
			else 
				if playlist.type is "movie"
					console.log "Getting #{playlist.link}"
					# link has format http://cdn-v04.vn-hd.com/19072013/Pacific_Rim_2013_Sieu_Dai_Chien_SD/playlist_800.m3u8
					# console.log playlist
					@decodePlaylist playlist, (err, playlist)->
						callback err,playlist
					
				else 
					if playlist.type is "series"
						@getPlaylistOfASeries playlist, (err, playlist)=>
							if err 
								console.log err
							else 
								result = 
									title : playlist.title
									type : playlist.type
									episodes : []
								count = 0
								totalCount = playlist.episodes.length
								for episode in playlist.episodes
									do (episode)=>
										link = episode
										_episode = 
											title : link.match(/(E[0-9]+)/)?[1]
											type : "episode"
											link : link
										@decodePlaylist _episode, (err, playlist)=>
											count +=1
											if err 
												console.log err
											else 
												result.episodes.push playlist
											if totalCount is count
												callback err, result
	getm3u8Content : (item,callback) ->
		
		links = item.links
		url  = links[links.length-2]

		base = url.replace(/([0-9]+).m3u8$/,"")
		fileName = item.title + "_" + url.match(/([0-9]+)+\.m3u8/)?[0]
		# console.log fileName
		# console.log "#{url} in getm3u8Content()"
		# console.log base
		@getLink url,(err,data)=>
			if err
				callback(err,null)
			else 
				data =  @rc4.decrypt(data,'hdviet123#@!')
				m3u8FileContent =  data.replace(/(.+ts)/g,base+"$1")
				result = 
					fileName : fileName
					content : m3u8FileContent
				callback null,result
	savem3u8Content : (movieid)->
		movieid = 3971
		# movieid = 4267
		# @getm3u8Content movieid,(err,result)->
		# 	if err
		# 		console.log err
		# 	else 
		# 		fs = require 'fs'
		# 		basePath = './hdviet_m3u8/'
		# 		currentPath = basePath + result.fileName
		# 		fs.writeFileSync currentPath, result.content
		# 		console.log "File saved to #{currentPath}"
		# 		process.exit 0
		@getFileMetadata "http://movies.hdviet.com/3971.e1.xml", false, (err,file)->
			if err then console.log err
			else 
				console.log file

	test : ->
		# 4267 3971
		# @getPlaylist 4267, (err,playlist)=>
		# 	console.log playlist

		@getPlaylist 3971, (err,playlist)=>
			# console.log JSON.stringify playlist
			episodes = playlist.episodes
			# console.log episodes
			for ep in episodes
				@getm3u8Content ep,(err,result)->
					if err
						console.log err
					else 
						fs = require('fs')
						path = './hdviet_m3u8/' + result.fileName
						fs.writeFileSync path, result.content
						console.log "#{path} has been written!!!"



module.exports = HDViet