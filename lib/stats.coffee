Site = require "./Site"
fs = require 'fs'
colors = require 'colors'
class Stats extends Site
	constructor: ->
		super "XX"
		@connect()
	recordCount : (tables, message)->
		tableCount = 0
		totalTables = tables.length
		itemCount = 0
		items = []
		
		for table in tables
			_qs = "select count(id) as count from #{table}"
			
			@connection.query _qs, (err,results)->
				if err then console.log "cannt not get total songs from table"
				else 
					tableCount += 1
					for result in results
						itemCount += parseInt(result.count,10)
						items.push parseInt(result.count,10)
						# console.log result.count
					
					if tableCount is totalTables
						console.log "|album table | records |"
						console.log "|-----|------:|"
						# print final result
						for table,idx in tables
							# text = table + new Array(12-table.length).join(" ")
							# text1 =  new Array(8-items[idx].toString().length).join(" ") +  items[idx].toString()
							console.log "|#{table} | #{items[idx]}|"
						# console.log "#{message + itemCount}".inverse.green
						console.log "| **total**  |  **#{itemCount}** |"
	fetchTable : ->
		_q = "SELECT * FROM pg_catalog.pg_tables where schemaname='public'"
		@connection.query _q, (err, results)=>
			if err then console.log "eroore babay"
			else 
				songTables = []
				albumTables = []
				videosTables = []
				for item in results
					table = item.tablename
					unless table.match(/^en/) or table.match(/^dz/) or table.match(/^(aa|ab|ac|sf|lw)/)
						if table.match(/[a-zA-Z]+songs$/)
							songTables.push table
						if table.match(/[a-zA-Z]+albums$/)
							albumTables.push table
						if table.match(/[a-zA-Z]+videos$/)
							videosTables.push table
			
				@recordCount albumTables, "total albums is "
			
				@recordCount songTables, "total songs is "
			
				@recordCount videosTables, "total videos is "
module.exports = Stats