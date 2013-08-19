Module = require './module'
colors = require '../node_modules/colors'


class Song extends Module
	constructor : ->
		Utils = require './utils'
		@utils = new Utils()
		events = require('events')
		@eventEmitter = new events.EventEmitter()
		super()
		@initialize()
		
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
			console.log ""
			@stats.failedItemCount +=1
		# @utils.printRunning @stats
		extraInfo = "(#{@stats.totalUpdatedItemCount}⬆ + #{@stats.totalInsertedItemCount}⬅ + #{@stats.failedItemCount}✘)"
		extraInfo += "     Speed: #{Math.round(@stats.totalItemCount/(Date.now() - @stats.markedTimer)*1000)}i/s"
		@progressBar.op(@stats.totalItemCount,extraInfo)
		if @stats.totalItemCount is @stats.totalItems
			@utils.printFinalResult(@stats, @destinationTable.prefix + @destinationTable.type)
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
	runNextTable : ->
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


module.exports = Song