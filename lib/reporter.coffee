Site = require "./Site"
fs = require 'fs'
colors = require 'colors'
class Stats extends Site
	constructor: ->
		super "XX"
		@finalReporterText = ""
		@connect()
	recordCount : (tables, message)->
		tableCount = 0
		totalTables = tables.length
		itemCount = 0
		items = []
		
		for table in tables
			_qs = "select count(id) as count from #{table}" # precise count

			_qs = """
			SELECT c.reltuples::bigint AS count
			FROM   pg_class c
			JOIN   pg_namespace n ON n.oid = c.relnamespace
			WHERE  c.relname = '#{table}'
			AND    n.nspname = 'public'
			""" # estimated count
			
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
	getTableCount : (table,type="precise",callback)->
		if type is "precise"
			_qs = "select count(id) as count from #{table}" # precise count
		else 
			_qs = """
			SELECT c.reltuples::bigint AS count
			FROM   pg_class c
			JOIN   pg_namespace n ON n.oid = c.relnamespace
			WHERE  c.relname = '#{table}'
			AND    n.nspname = 'public'
			""" # estimated count
			# console.log _qs
		@connection.query _qs, (err,results)->
			if err then callback(null,0)
			else 
				if results.length is 0 then callback null,0
				else callback null,parseInt(results[0].count,10)
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
	formatNumber : (number, decimals, dec_point, thousands_sep) ->
		number = (number + "").replace(/[^0-9+\-Ee.]/g, "")
		n = (if not isFinite(+number) then 0 else +number)
		prec = (if not isFinite(+decimals) then 0 else Math.abs(decimals))
		sep = (if (typeof thousands_sep is "undefined") then "," else thousands_sep)
		dec = (if (typeof dec_point is "undefined") then "." else dec_point)
		s = ""
		toFixedFix = (n, prec) ->
			k = Math.pow(10, prec)
			"" + Math.round(n * k) / k		
		# Fix for IE parseFloat(0.55).toFixed(0) = 0;
		s = ((if prec then toFixedFix(n, prec) else "" + Math.round(n))).split(".")
		s[0] = s[0].replace(/\B(?=(?:\d{3})+(?!\d))/g, sep)  if s[0].length > 3
		if (s[1] or "").length < prec
			s[1] = s[1] or ""
			s[1] += new Array(prec - s[1].length + 1).join("0")
		s.join dec
	getSourceSite : (mode,onEnd)->
		sites = "csn cc ns gm ke nct mv nv nn vg zi".split(" ")
		sites = 
			csn : "chiasenhac"
			cc : "chacha"
			ns : "nhacso"
			gm : "gomusic"
			ke : "keeng"
			nv : "nhacvui"
			nct : "nhaccuatui"
			mv : "musicvnn"
			nn : "nghenhac"
			vg : "vietgiaitri"
			zi : "zing"

		reporter = {}
		for site,fullName of sites
			reporter[site] = 
				name : fullName
				nsongs : 0
				nalbums : 0
				nvideos : 0	
		getTableType = (reporter,type,callback)=>
			totalCount = 0
			itemCount = 0
			for site of reporter
				totalCount +=1
				do (site)=>
					@getTableCount site+type,mode, (err,count)->
						itemCount +=1
						if err then console.log err
						else 
							reporter[site]["n#{type}"] = count
						if itemCount is totalCount
							callback()
		count = 0
		onDone = ()=>
			@finalReporterText += "\n"
			@finalReporterText += "\n###Statistics of source sites"
			@finalReporterText += "\n" + "| table | songs | albums | videos |"
			@finalReporterText += "\n" + "|------|------:|--------:|-------:|"
			# calculate total
			totalSongs = 0
			totalAlbums = 0
			totalVideos = 0
			# convert an object to array
			arrayRpt = []
			for site,value of reporter
				arrayRpt.push value
			arrayRpt = arrayRpt.sort (a,b)-> a.nsongs - b.nsongs
			for tbl in arrayRpt
				# tbl = reporter[site]
				@finalReporterText += "\n" + "| #{tbl.name} | #{@formatNumber tbl.nsongs} | #{@formatNumber tbl.nalbums} |  #{@formatNumber tbl.nvideos} | "			
				totalSongs += tbl.nsongs
				totalAlbums += tbl.nalbums
				totalVideos += tbl.nvideos
			@finalReporterText += "\n" + "|**total** | **#{@formatNumber totalSongs}** |**#{@formatNumber totalAlbums}** | **#{@formatNumber totalVideos}** |"
			@finalReporterText += "\n" + ""
			# @finalReporterText += "\n" + "---"
			onEnd()
		getTableType reporter,"songs",->
			count += 1
			if count is 3 then onDone()
		getTableType reporter, "albums", ->
			count += 1
			if count is 3 then onDone()
		getTableType reporter, "videos", ->
			count += 1
			if count is 3 then onDone()
	getMainReporter : (mode,onEnd)->
		nsongs = 0
		nalbums = 0
		nvideos = 0
		count = 0
		onDone = =>
			@finalReporterText += "\n"
			@finalReporterText += "\n###Aggregated results from source sites"
			@finalReporterText += "\n" + "|songs | albums | videos |"
			@finalReporterText += "\n" + "|:------:|:--------:|:-------:|"
			@finalReporterText += "\n" + "|#{@formatNumber nsongs}|#{@formatNumber nalbums}|#{@formatNumber nvideos}|"
			@finalReporterText += "\n"
			# @finalReporterText += "\n---"
			onEnd()
		@getTableCount "songs",mode, (err,totalItem)->
			count +=1
			if err then console.log err
			else  nsongs = totalItem
			if count is 3 then onDone()
		@getTableCount "albums", mode,(err,totalItem)->
			count +=1
			if err then console.log err
			else  nalbums = totalItem
			if count is 3 then onDone()
		@getTableCount "videos",mode, (err,totalItem)->
			count +=1
			if err then console.log err
			else  nvideos = totalItem
			if count is 3 then onDone()
	getLyricReporter :  (mode,onEnd)->
		lwsongs = 0
		sfsongs = 0
		count = 0
		onDone = =>
			@finalReporterText += "\n"
			@finalReporterText += "\n###Total number of lyrics"
			@finalReporterText += "\n" + "|lyricwiki | songfreaks | total |"
			@finalReporterText += "\n" + "|:------:|:--------:|:-------:|"
			@finalReporterText += "\n" + "|#{@formatNumber lwsongs}|#{@formatNumber sfsongs}|#{@formatNumber lwsongs+sfsongs}|"
			@finalReporterText += "\n\n######Note: Gracenote included on lyricwiki\n"
			# @finalReporterText += "\n---"
			onEnd()
		@getTableCount "lwsongs",mode, (err,totalItem)->
			count +=1
			if err then console.log err
			else  lwsongs = totalItem
			if count is 2 then onDone()
		@getTableCount "sfsongs",mode, (err,totalItem)->
			count +=1
			if err then console.log err
			else  sfsongs = totalItem
			if count is 2 then onDone()
	getTablesByPattern : (pattern,mode,onEnd)->
		_q = "SELECT * FROM pg_catalog.pg_tables where schemaname='public'"
		finalResults = []
		onDone = =>
			if pattern is "^en+"
				@finalReporterText += "\n"
				@finalReporterText += "\n###Special report on table echonest"
				@finalReporterText += "\n" + "|table | items |table | items |table | items |"
				@finalReporterText += "\n" + "|:------:|:--------:|:------:|:--------:|:------:|:--------:|"
				for result,index in finalResults by 3
					first = finalResults[index]
					second = finalResults[index+1]
					last = finalResults[index+2]
					@finalReporterText += "\n|#{first.table}|#{@formatNumber result.count}|"
					if second
						@finalReporterText += "#{second.table}|#{@formatNumber second.count}|"
					if last
						@finalReporterText += "#{last.table}|#{@formatNumber last.count}|"
				@finalReporterText += "\n"
				onEnd()
			else 
				if pattern is "^dz+"
					@finalReporterText += "\n"
					@finalReporterText += "\n###Special report on table deezer"
					@finalReporterText += "\n" + "|table | artists |tracks |albums|"
					@finalReporterText += "\n" + "|:------:|:--------:|:------:|:--------:|"
					nartists = 0
					ntracks = 0
					nalbums = 0
					for result in finalResults
						if result.table is "dzalbums"
							nalbums = result.count
						if result.table is "dztracks"
							ntracks = result.count
						if result.table is "dzartists"
							nartists = result.count

					@finalReporterText += "\n" + "|deezer|#{@formatNumber nartists}|#{@formatNumber ntracks}|#{@formatNumber nalbums}"
					@finalReporterText += "\n"
					@finalReporterText += "\n"
					onEnd()

		@connection.query _q, (err, results)=>
			if err then console.log "error babay"
			else 
				tables = []
				tableCount = 0
				for item in results
					table = item.tablename
					if table.match(pattern)
						tables.push table 
				for table in tables
					do (table)=>
						@getTableCount table,mode,(err,n)=>
							tableCount +=1
							if err then console.log err
							else 
								finalResults.push {table : table, count : n}
							if tableCount is tables.length
								onDone()
	saveReporter : (name)->
		fs = require 'fs'

		# format date into form : YYYYMMDD
		dt = new Date()
		month = dt.getMonth()+1
		month = if month.toString().length is 1 then "0" + month else month
		day = dt.getDate()
		day = if day.toString().length is 1 then "0" + day else day
		date = dt.getFullYear()  + month +  day
		# end of format
		fileName = "#{name}_#{date}.md"
		path = "./reporters/#{fileName}"
		fs.exists path, (exists)=>
			unless exists 
				fs.appendFile path, @finalReporterText, (err,result)->
					if err then console.log err
					else console.log "Status : Done, Message: The  reporter has been saved on disk. Path: #{path}".inverse.green
			else 
				console.log "Status : Abort, Message: The  reporter exits. Path: #{path}".inverse.red

		@end()
	getSitesReporter : ->
		
		@finalReporterText += "\n" + "## SITES REPORT\n"
		@finalReporterText += "\n######on #{new Date()}"
		@getSourceSite "precise", =>
			@getMainReporter "precise",=>
				@getLyricReporter "fast",=>
					@getTablesByPattern "^en+","fast", =>
						@getTablesByPattern "^dz+","fast", =>
							@saveReporter("reporter")
	getTablesSchema : ->
		_q = "SELECT * FROM pg_catalog.pg_tables where schemaname='public'"
		@finalReporterText += "\n" + "## SCHEMA REPORT\n"
		@finalReporterText += "\n######on #{new Date()}"
		@connection.query _q, (err, results)=>
			if err then console.log "error babay"
			else 
				tables = []
				for item in results
					table = item.tablename
					tables.push table 
				totalCount = tables.length
				count = 0
				tables = tables.sort (a,b)-> return a.localeCompare(b)
				# console.log tables
				for table in tables by 1
					do (table)=>
						displayQuery = """
						SELECT * FROM information_schema.columns
						WHERE table_schema = 'public'
						  AND table_name   = '#{table}'
						"""
						tableText = "\n"
						tableText += "\n####{table}"
						tableText += "\n" + "|position|column | type | max | null | default|"
						tableText += "\n" + "|:------|:------|:--------|:-------:|:-------:|:-------:|"
						@connection.query displayQuery, (err,schema)=>
							count +=1
							if err then console.log err
							else 
								for column in schema
									defaultValue = if column.column_default is null then "*[NULL]*" else column.column_default
									max = if column.character_maximum_length is null then "*[NULL]*" else column.character_maximum_length
									hasNull = if column.is_nullable is "NO" then "✘" else "✔"
									tableText += "\n|#{column.ordinal_position}|#{column.column_name}|#{column.udt_name}| #{max} | #{hasNull} |#{defaultValue} |"
								tableText += "\n"
								@finalReporterText += tableText
							if count is totalCount
								console.log "DONE".inverse.green
								@saveReporter("schema")






module.exports = Stats