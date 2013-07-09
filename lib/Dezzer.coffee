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
	requestItemLink: (link,formData,callback)->
		onSucess = (data,options)=>
			callback(null,data,options)
		onFail = (err,options)=>
			callback(err,null,options)
		options = 
			link : link
			formData : formData
		@getFileByHTTP link,formData,onSucess,onFail,options
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
	getAlbums : ->
		@connect()
		link = "http://api.deezer.com/2.0/album/302127"
		@re
		





module.exports = Zazoo