Module = require './module'
colors = require '../node_modules/colors'


class MovingSite extends Module
	constructor : ->
		Utils = require './utils'
		@utils = new Utils()
		super()
		@initialize()
		events = require('events')
		@eventEmitter = new events.EventEmitter()		
	initialize : ->
		printResutls = require('util').print
		@utils.printFinalResult = (stats,destinationTable) ->
			stats.totalDuration = Date.now() - stats.markedTimer
			console.log ""
			size = 80
			console.log "+#{Array(size-2).join('-')}+"
			message0 = "From table: [#{destinationTable} ❯❯ #{stats.currentTable}]"
			console.log "|#{message0.blue}#{Array(size-2-message0.length).join(' ')}|"
			message  = "Total:#{stats.passedItemCount}✔/#{stats.totalItemCount} | "
			message += "(#{stats.totalUpdatedItemCount}⬆ + #{stats.totalInsertedItemCount}⬅ "
			message += " + #{stats.failedItemCount}✘) | t=#{@_getTime(stats.totalDuration,stats)} | "
			message += "ν=#{Math.round(stats.totalItemCount/stats.totalDuration*1000)}items/s"
			console.log "|#{message}#{Array(size-2-message.length).join(' ')}|"
			console.log "+#{Array(size-2).join('-')}+"

			# make reporter
			site = 
				total : stats.totalItemCount
				updated : stats.totalUpdatedItemCount
				inserted : stats.totalInsertedItemCount
				failed : stats.failedItemCount
				duration : stats.totalDuration
				speed : Math.round(stats.totalItemCount/stats.totalDuration*1000)
			return site
	updateStats : (err,currentId,type)->
		@stats.currentId = currentId
		@stats.totalItemCount +=1
		unless err
			switch type
				when "update" then @stats.totalUpdatedItemCount += 1
				when "insert" then @stats.totalInsertedItemCount += 1
				else 
					console.log "Invalid type"
			@stats.passedItemCount +=1
		else 
			console.log ""
			console.log err
			console.log "----"
			console.log "----"
			@stats.failedItemCount +=1
		# @utils.printRunning @stats
		extraInfo = "(#{@stats.totalUpdatedItemCount}⬆ + #{@stats.totalInsertedItemCount}⬅ + #{@stats.failedItemCount}✘)"
		extraInfo += "     Speed: #{Math.round(@stats.totalItemCount/(Date.now() - @stats.markedTimer)*1000)}i/s"
		@progressBar.show(@stats.totalItemCount,extraInfo)
		if @stats.totalItemCount is @stats.totalItems
			table = @destinationTable.prefix + @destinationTable.type
			@reporter[table] = @utils.printFinalResult(@stats, table)
			console.log ""
			return true
		else return false
	migrateItems : ->
		console.log "Migrating from [#{@destinationTable.prefix + @destinationTable.type}  ❯❯❯❯  #{@sourceTable}]".inverse.yellow
		items = new @Item(@sourceTable, @destinationTable,@connection)
		items.setMaxConcurrentJobs(1)
		items.setLimit(-1)
		items.runJob()
		isPaceInitailized = false
		items.on "item",  (err,data,cursor)=>
			if err  
				@updateStats(err,cursor)				
			else 
				if isPaceInitailized is false
					Pace = require 'pace'
					@progressBar = new Pace(items.getLimit())
					isPaceInitailized = true
					@stats.totalItems = items.getLimit()
				items.saveItem data, (err,type)=>
					if @updateStats(err,cursor,type) then items.emit("end")
						
		items.on "end", =>
			@runNextTable()
			# @migrateItems()
	runNextTable :  ->
		if @queueCursor < @queueDestinationTable.length-1
			@queueCursor = @queueCursor + 1 
			@destinationTable = 
				prefix : @queueDestinationTable[@queueCursor]
				type : @destinationTableType
			@resetStats()
			@stats.totalUpdatedItemCount = 0
			@stats.totalInsertedItemCount = 0
			@stats.currentTable = @sourceTable
			@migrateItems()
	createSongTable : ->
		@connect()
		# Item = new ItemConstruction("gm","songs",@connection)
		@Item  = require './construction/item'
		@queueDestinationTable = "ns gm nv ke cc nn zi nct csn".split(" ")
		# @queueDestinationTable = "ns zi nct gm nv ke cc nn csn mv vg".split(" ")
		@queueDestinationTable = "csn mv vg".split(" ")
		@queueCursor = -1
		@sourceTable = "songs"
		@destinationTableType = "songs"
		@runNextTable()
	createAlbumsTable : ->
		@connect()
		@Item  = require './construction/item'
		@queueDestinationTable = "ns gm nv ke cc nn zi nct csn".split(" ")
		@queueCursor = -1
		@sourceTable = "albums"
		@destinationTableType = "albums"
		@runNextTable()
	createVideosTable : ->
		@connect()
		@Item  = require './construction/item'
		@queueDestinationTable = "ns zi nct ke nv".split(" ")
		@queueDestinationTable = "ke nv".split(" ")
		@queueCursor = -1
		@sourceTable = "videos"
		@destinationTableType = "videos"
		@runNextTable()
	makeSitesJSON : ->
		@connect()
		Source = require('./helpers/source')
		Source.insertLastDatesToFile @connection, (message)->
			console.log message
			console.log "Last dates have been updated!!!".inverse.blue
			console.log "\nThe last dates:"
			sites = Source.getLastDate()
			for key,value of sites
				console.log "#{key}=>#{value}"
	getDuration : (mms) ->
		totalsec = Math.floor mms/1000
		sec = totalsec%60
		min = Math.floor totalsec/60
		if min isnt 0 then result = min + "m" + sec + "s" else result = sec + "s"
	getAggregatedResult :  (reporter)->
		class Model
			constructor : ->
				@name = ""
				@total = 0
				@updated = 0
				@inserted = 0
				@failed = 0
				@duration = 0
				@avgSpeed = 0
				@speed = 0
				@nitems = 0
		items = [new Model(),new Model(),new Model(),new Model()]
		items[0].name = "SONGS"
		items[1].name = "ALBUMS"
		items[2].name = "VIDEOS"
		items[3].name = "ALL"
		for table,result of reporter
			if table.search("songs") > -1
				index = 0
			if table.search("albums") > -1
				index = 1
			if table.search("videos") > -1
				index = 2
			items[index].total += result.total
			items[index].updated +=  result.updated
			items[index].inserted += result.inserted
			items[index].failed += result.failed
			items[index].duration += result.duration
			items[index].speed += result.speed
			items[index].nitems += 1

		for item, idx in items
			if idx is 3
				item = items[3]
				item.avgSpeed = (items[0].avgSpeed + items[1].avgSpeed + items[2].avgSpeed)/3|0
				item.total = items[0].total + items[1].total + items[2].total
				item.updated = items[0].updated + items[1].updated + items[2].updated
				item.inserted = items[0].inserted + items[1].inserted + items[2].inserted
				item.failed = items[0].failed + items[1].failed + items[2].failed
				item.duration = items[0].duration + items[1].duration + items[2].duration
			else item.avgSpeed = item.speed/item.nitems|0
		return items
	getTimeFormat : (mms) ->
		totalsec = Math.floor mms/1000
		sec = totalsec%60
		min = Math.floor totalsec/60
		if sec.toString().length is 1 then sec = "0" + sec
		if min isnt 0  
			if min.toString().length is 1 then min = "0" + min
			result = "#{min}:#{sec}"
		else 
			result = "00:#{sec}"
		return result
	saveReporter : ->
		rpt = "\n" + "## SITES UPDATE REPORT\n"
		rpt += "\n######on #{new Date()}"
		rpt += "\n|Table | total | updates | inserts | failures | duration | speed|"
		rpt += "\n|:------|:------:|:------:|:------:|:------:|:------:|:------:|"
		
		getAggItem = (item)=>
			return "\n|**#{item.name}**|**#{item.total}**|**#{item.updated}**|**#{item.inserted}**|**#{item.failed}**|**#{@getTimeFormat(item.duration)}**|**#{item.avgSpeed}**"

		items = @getAggregatedResult(@reporter)
		checkSong = true
		checkAlbum = true
		# console.log item for item in items
		for table,result of @reporter
			if table.search("albums") > -1
				index = 1
				if checkSong
					rpt += getAggItem(items[0])
					checkSong = false
			if table.search("videos") > -1
				index = 2
				if checkAlbum
					rpt += getAggItem(items[1])
					checkAlbum = false
			rpt += "\n|#{table} | #{result.total} | #{result.updated} | #{result.inserted} | #{result.failed} | #{@getTimeFormat(result.duration)} | #{result.speed}"

		rpt += getAggItem(items[2])
		rpt += getAggItem(items[3])
			
		# PRINT TOTAL RESULT
		rpt += "\n\n"
		fs = require 'fs'
		dt = new Date()
		date = dt.getFullYear()  + "" +  (dt.getMonth()+1) +  dt.getDate()
		fileName = "updates_#{date}.md"
		path = "./reporters/#{fileName}"
		fs.writeFileSync path, rpt
		console.log "Status : Done, Message: The  reporter has been saved on disk. Path: #{path}".inverse.blue
	showReporter : ->
		width = 11 # default is 11 columns

		printRow = ->
			args = Array::slice.call(arguments)
			text = ""
			for arg in args
				text += arg + Array(12-arg.toString().length).join(' ')
			return text
		getAggItem = (item)=>
			return printRow(item.name,item.total,item.updated,item.inserted,item.failed,@getTimeFormat(item.duration),item.avgSpeed)
		
		items = @getAggregatedResult(@reporter)
		checkSong = true
		checkAlbum = true
		console.log ""
		console.log "FINAL REPORTER:".inverse.cyan
		console.log printRow("Table","total","updates","inserts","failures","duration","speed")
		for table,result of @reporter
			if table.search("albums") > -1
				index = 1
				if checkSong
					console.log getAggItem(items[0])
					console.log ""
					checkSong = false
			if table.search("videos") > -1
				index = 2
				if checkAlbum
					console.log getAggItem(items[1])
					console.log ""
					checkAlbum = false
			console.log printRow(table,result.total,result.updated,result.inserted,result.failed,@getTimeFormat(result.duration),result.speed)
		
		console.log getAggItem(items[2])
		console.log ""
		console.log getAggItem(items[3])
		console.log ""
	runSite : (site)=>

		Source = require('./helpers/source')
		checktime = Source.getLastDate(site)
		condition = " checktime > '#{checktime}' "
		@destinationTable = 
			prefix : site
			type : @destinationTableType
		@resetStats()
		@stats.totalUpdatedItemCount = 0
		@stats.totalInsertedItemCount = 0
		@stats.currentTable = @sourceTable
		console.log "Migrating from [#{@destinationTable.prefix + @destinationTable.type} ❯❯❯❯ #{@sourceTable}]".inverse.yellow
		@progressBar.reset()
		Item  = require './construction/item'
		items = new Item(@sourceTable,@destinationTable,@connection)
		items.setMaxConcurrentJobs(1)
		items.setLimit(-1)
		isPaceInitailized = false
		items.runJob condition
		items.on "item", (err,data,cursor)=>
			if err  
				@updateStats(err,cursor)				
			else 
				if isPaceInitailized is false
					totalItems = items.getLimit()
					@progressBar.setTotal(totalItems)
					isPaceInitailized = true
					@stats.totalItems = totalItems
				items.saveItem data, (err,type)=>
					if @updateStats(err,cursor,type)  
						err = null
						items.emit("end")			
		items.on "end", =>
			# console.log JSON.stringify items
			
			if items.getLimit() is 0
				console.log "No items found!" 
				console.log ""
			
			# console.log "reset"
			
			
			if @currentCursor < @sites.length-1
				@currentCursor +=1
				@runSite(@sites[@currentCursor])
			else 
				console.log "ALL SITES COMPLETED".inverse.green
				event = "end::#{@destinationTableType}"
				@eventEmitter.emit event			
	runType : (sites,sourceTable,destinationTable)->
		@connect()
		@sites = sites
		@sourceTable = sourceTable
		@destinationTableType = destinationTable
		@currentCursor = 0
		@runSite(@sites[@currentCursor])
	updateSongs :   ->
		sites = "ns gm nv cc ke nn zi nct csn".split(" ")
		@runType(sites,"songs","songs")
	updateAlbums : ->
		sites = "ns gm nv ke cc nn zi nct csn".split(" ")
		@runType(sites,"albums","albums")
	updateVideos : ->
		sites = "ns zi nct".split(" ") #remove keeng, nhacvui
		@runType(sites,"videos","videos")	
	update : ->
		globalMarker = Date.now()
		marker = Date.now()
		ProgressBar = require './helpers/progress_bar'
		@progressBar = new ProgressBar()
		@reporter = {}

		@updateSongs()
		@eventEmitter.on "end::songs", =>
			console.log "Completed in #{@getDuration(Date.now()-marker)}. Updating albums........."
			marker = Date.now()
			@updateAlbums()
			@eventEmitter.on "end::albums",=>
				console.log "Completed in #{@getDuration(Date.now()-marker)}. Updating videos........."
				marker = Date.now()
				@updateVideos()
			@eventEmitter.on "end::videos",=>
				console.log "Completed in #{@getDuration(Date.now()-marker)}"
				@showReporter()
				@saveReporter()
				console.log "Operation completed in #{@getDuration(Date.now()-globalMarker)}".inverse.green
				console.log "Update lasted dates"
				@makeSitesJSON()

module.exports = MovingSite