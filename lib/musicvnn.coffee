Site = require "./Site"
fs = require 'fs'

class MusicVNN extends Site
	constructor: ->
		super "MV"
	fetchSongs : ->
	  @showStartupMessage "Fetching Songs from table", @table.Songs
	  [range0,range1] = [72197,72197]
	  @connect()
	  @stats.totalItems = range1 - range0 + 1
	  for id in [range0..range1]
	    do (id)=>
		  	link = "http://music.vnn.vn/nhac/detail/#{id}/joke.link-.htm"
		  	options = 
		  		id : id
		  	callbackOnSucess = (data,options)=>
		  		@stats.totalItemCount++
		  		if data.search("Object reference not set to an instance of an object") is -1
		  			try
				  		data = JSON.stringify data
				  		_item = 
				  			id : options.id
				  		
				  		_info = data.match(/title_song.+lượt\snghe\s\|/)?[0].trim()
				  		_info = _info.replace(/\\r|\\t|\\n/g,'')

				  		_item.name  = @processStringorArray _info.match(/^.+<\/a>\s-\s<span>/)?[0]
				  												.replace(/<\/a>\s-\s<span>/g,'')
				  												.replace(/^.+>/g,'')
				  		_item.name = _item.name.replace(/Gieohạt/i,"gieo hạt") #remove when not used

				  		_item.artists = @processStringorArray _info.replace(/<\/a><\/span>.+$/g,'')
				  												.replace(/^.+>/g,'').split(" ft. ")

				  		_item.plays = @processStringorArray _info.replace(/lượt\snghe.+$/g,'')
				  												.replace(/^.+\||\./g,'')
				  		if _info.search(/<\/a>\s+\|.+$/g,'') > -1
					  		_item.topic = @processStringorArray _info.replace(/<\/a>\s+\|.+$/g,'')
					  												.replace(/^.+>/g,'')
					  	else _item.topic = ''
				  		_item.link = @processStringorArray "http://music.vnn.vn" + data.match(/file.+controlbar/)?[0].replace(/',.+$/g,'').replace(/^.+'/g,'')

				  		@stats.passedItemCount++

				  		# insert into tables
				  		if _item.link.search(/mp4/g) > -1 or _item.link.search(/flv/g) > -1
				  			@connection.query @query._insertIntoVideos, _item, (err)->
				  				if err then console.log "Cannt insert. ERROR: #{err}"
				  		else
				  			@connection.query @query._insertIntoSongs, _item, (err)->
				  				if err then console.log "Cannt insert. ERROR: #{err}" 
				  	
			  	else @stats.failedItemCount++	
			  	
			  	@utils.printRunning @stats

			  	if @stats.totalItemCount is @stats.totalItems
			  			@utils.printFinalResult @stats
		  		# -----------------------------------
		  		# console.log  _info
		  		# console.log _item
		  	callbackOnFail = (ErrorMessage)=>
		  		console.log ErrorMessage
		  		@stats.failedItemCount++
		  	@getFileByHTTP link, callbackOnSucess, callbackOnFail, options

module.exports = MusicVNN