Site = require "./Site"
fs = require 'fs'

class VietGiaitri extends Site
	constructor: ->
		super "VG"
	fetchSongs : ->
	  @showStartupMessage "Fetching Songs from table", @table.Songs
	  [range0,range1] = [100001,110000]
	  @connect()
	  @stats.totalItems = range1 - range0 + 1
	  console.log "The # of items is #{@stats.totalItems}"
	  for id in [range0..range1]
	    do (id)=>
		  	link = "http://nhac.vietgiaitri.com/bai-hat/joke-link-#{id}.vgt"
		  	options = 
		  		id : id
		  	
		  	callbackOnSucess = (data,options)=>
		  		try 
		  			@stats.totalItemCount++
		  			if data.search(/Xin lỗi không tồn tại bài hát này/) is -1
					  	data = JSON.stringify data
					  	_item = 
					  		id : options.id
					  	@stats.currentId = _item.id
					  	
					  	_item.name = data.match(/javascript:togglecategory\(\'player\'\,1\).+menu_build_menu/g)?[0]
					  	if _item.name isnt undefined
					  		_item.name = @processStringorArray _item.name.replace(/<\/div>\\n\\t<\/div>\\n<script.+$/g,'')
					  						 .replace(/^.+>/g,'')
					  	_table = data.match(/menu_build_menu.+VGT_Music_Player/g)?[0]


					  	if _table isnt undefined
					  		_table = _table.replace(/\\r/g,'\r').replace(/\\n/g,'\n').replace(/\\t/g,'\t')
					  		_fields = _table.match(/row2.+/g)
					  		if _fields.length > 7
					  			# author field
					  			_item.authors = _fields[0].replace(/<\/a>.+$/g,'').replace(/^.+>/g,'').trim()
					  			if _item.authors isnt "Chưa có" and _item.authors isnt "Không biết" and _item.authors isnt "không biết"
					  				_item.authors = @processStringorArray _item.authors.split(" - ")
					  			else _item.authors = ""
					  			#------------------------------
					  			_item.created = @formatDate(new Date(_fields[1].replace(/<\/td>.+$/g,'').replace(/^.+>/g,'')))
					  			# artist field
					  			_item.artists = _fields[2].replace(/<\/a>.+$/g,'').replace(/^.+>/g,'').trim()
					  			if _item.artists isnt "Chưa có" and _item.artists isnt "Không biết" and _item.artists isnt "không biết"
					  				_item.artists = @processStringorArray _item.artists.split(" - ")
					  			else _item.artists = ""
					  			#-----------------------------
					  			_item.plays = _fields[6].replace(/<\/td>/g,'').replace(/^.+>/g,'')
					  			_item.topic = @processStringorArray _fields[7].split('br>').map (v)-> v.replace(/<\/a>.+$/g,'').replace(/^.+>/g,'')

					  	_link = data.match(/flashvars\=.+repeat\=/g)?[0]
					  	_link = decodeURIComponent _link.match(/http.+$/)?[0] if _link isnt undefined
					  	data  = ''
					  	_options = 
					  		item : _item
					  	_callbackOnSuccess = (data,_options)=>
					  		try 
						  		@parser.parseString data, (err, result)=>
						  			_options.item.link = result.playlist.trackList[0].track[0].location[0]
						  			# console.log _options.item
						  			@connection.query @query._insertIntoSongs, _options.item, (error)=>
						  				if error then console.log "cannt insert songs into table. ERROR: #{error}" 
						  	catch e
			  					@stats.failedItemCount++
					  	_callbackOnFail = (err)=>
					  		console.log err
					  		@stats.failedItemCount++
					  	@getFileByHTTP _link, _callbackOnSuccess, _callbackOnFail, _options

					  	# console.log _fields
					  	
					  	@stats.passedItemCount++
					  	@utils.printRunning @stats

					  	if @stats.totalItemCount is @stats.totalItems
					  			@utils.printFinalResult @stats
		  			else 
		  				@stats.failedItemCount++

		  		catch e
		  			@stats.failedItemCount++
		  		# -----------------------------------
		  		# console.log  _info
		  		# console.log _item
		  	callbackOnFail = (ErrorMessage)=>
		  		console.log ErrorMessage
		  		@stats.failedItemCount++
		  	@getFileByHTTP link, callbackOnSucess, callbackOnFail, options

module.exports = VietGiaitri