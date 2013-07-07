Site = require "./Site"
class Zazoo extends Site
	constructor : ->
		super "ZZ"
		# @logPath = "./log/ZZLog.txt"
		# @log = {}
		# @_readLog()
		@table.Artists = "ZZArtists"
		@table.Clips = "ZZClips"
		@table.Lyrics  = "ZZLyrics"


	# callback(err:String,data:String,options:Object)
	requestItemLinkWithPostMethod: (link,formData,callback)->
		onSucess = (data,options)=>
			callback(null,data,options)
		onFail = (err,options)=>
			callback(err,null,options)
		options = 
			link : link
			formData : formData
		@getFileByHTTPWithPostMethod link,formData,onSucess,onFail,options
	updateStats : (isSuccessful)->
		@stats.totalItemCount += 1
		if isSuccessful
			@stats.passedItemCount +=1
		else 
			@stats.failedItemCount +=1

		@utils.printRunning @stats
		if @stats.totalItems is @stats.totalItemCount
			@utils.printFinalResult @stats
			return true
		else return false
	getLyrics : ->
		@connect()
		@connection.query "select YoutubeID as id from #{@table.Clips} limit 1",(err,results)=>
			if err then console.log "cannt get id #{err}"
			else 
				results = [{id : "a84L1hVVEls"},{id : "GWcXuu16ttc"},{id : "hiQoq-wqZxg"},{id : "is6gtilerPk"},{id : "LlDBUMX2DiY"},{id : "nC4fJkmIv0E"},{id : "nWuZMBtrc1E"},{id : "qQYpF2pCkLI"},{id : "rJOsjP33nF4"},{id : "weRHyjj34ZE"},{id : "WGt-8adyabk"},{id : "wIg8kNfJpsg"}]
				for clip in results
					do (clip)=>
						# console.log clip.id
						@stats.totalItems = results.length
						link = 'http://lyrics.zazoo.it/getlyrics'
						_value = {"format":"timed","keyword_id":"","clip_id":"","artist_name":"","song_title":"","page_title":"","clip_url":"http://www.youtube.com/watch?v=0Gl2QnHNpkA","request_id":"m2rvh01xuu40a4i_698","duration_ms":0,"view_count":0,"upload_date":"","extension_version":"1.0.23"}
						_value.clip_url = "http://www.youtube.com/watch?v=#{clip.id}"
						values = JSON.stringify(_value)
						# console.log values
						dataString = "values=#{values}"
						@requestItemLinkWithPostMethod link, dataString, (err,data,options)=>
							if err 
								@updateStats(false)
								console.log _value.clip_url + "----" + err

							else 
								@updateStats(true)
								song = JSON.parse(data).data
								_song = 
									youtube_id : clip.id
									title  :  song.song_title
									lyric : song.timed_set_lyrics
									artist : song.artist_name
									copyright : song.copyright
									writer : song.writer
								@connection.query "INSERT IGNORE INTO #{@table.Lyrics} SET ?", _song, (err)->
									if err then console.log err

	getArtists : ->
		@connect()
		link = 'http://api.zazoo.it/api/playlists/artists/'
		_value = {}
		values = JSON.stringify(_value)
		dataString = ""
		@requestItemLinkWithPostMethod link, dataString, (err,data,options)=>
			if err then console.log err
			else 
				artists = JSON.parse(data).data
				console.log "# of artists #{artists.length}"
				for artist in artists
					do (artist)=>
						_artist = artist
						_artist.OwnedByKeywords = JSON.stringify(_artist.OwnedByKeywords)
						_artist.OwnedKeywords = JSON.stringify(_artist.OwnedKeywords)
						_artist.RelatedKeywords = JSON.stringify(_artist.RelatedKeywords)
						@connection.query "INSERT IGNORE INTO #{@table.Artists} SET ?", _artist, (err)->
							if err then console.log err
	getClipsOfAnArtist : ->
		@connect()
		
		@connection.query "select KeywordID as id from #{@table.Artists}",(err,results)=>
			if err then console.log "cannt get id #{err}"
			else 
				for artist in results
					do (artist)=>
						# console.log artist.id
						@stats.totalItems = results.length
						# console.log @stats

						link = 'http://api.zazoo.it/api/playlists/artists/clips/'
						values = "APIKey=23fdffd9fd764cb&ElementID=ClipBodyContent&KeywordID=#{artist.id}&ClipID=0&StartingLetter=&ResultsLimit=-1  "
						dataString = "#{values}"
						@requestItemLinkWithPostMethod link, dataString, (err,data,options)=>
							if err  
								@updateStats(false)
								console.log err
							else 
								@updateStats(true)
								clips =  JSON.parse(data).data
								for clip in clips
									do (clip)=>
										_clip = clip
										_clip.YoutubeID = _clip.URL.replace(/^.+watch\?v\=/,'')
										@connection.query "INSERT IGNORE INTO #{@table.Clips} SET ?", _clip, (err)->
											if err then console.log err






module.exports = Zazoo