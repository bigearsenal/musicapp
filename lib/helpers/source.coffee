class Source
	constructor : (@connection) 
		# do sth
	@safeFactor : 10*60*1000 # in miliseconds 
	@getLastDate : (site)->
		path = "./lib/data/sites.json"
		file = require('fs').readFileSync path,"utf8"
		file = JSON.parse file
		if site
			return file[site]
		else return file
	@formatDate : (d)->
		return 	"#{d.getFullYear()}-#{d.getMonth()+1}-#{d.getDate()} #{d.getHours()}:#{d.getMinutes()}:#{d.getSeconds()}"
	@setLastDate : (site,dateString)->
		path = "./lib/data/sites.json"
		fs = require('fs')
		file = fs.readFileSync path,"utf8"
		file = JSON.parse file
		file[site] = dateString
		content = JSON.stringify(file)
		content = content.replace(/,/g,',\n')
		fs.writeFileSync path, content
	@insertLastDatesToFileFromLogs : (sites)->
		for site in sites
			prefix = site.toUpperCase()
			fileName = prefix + "Log.txt"
			path = './log/' + fileName
			fs = require 'fs'
			file = fs.readFileSync path,"utf8"
			file = JSON.parse(file)
			lastTimestamp = file.updated_at
			lastTimestamp += Source.safeFactor
			lastDate = new Date(lastTimestamp)
			lastDateString = Source.formatDate lastDate
			Source.setLastDate site,lastDateString
			return "done"
	@insertLastDatesToFileFromDB : (sites,type,connection,callback)->
		count = 0
		for site in sites
			do (site)->
				table = site + type
				connection.query "select max(checktime) as max from #{table}", (err,values)->
					count += 1
					if err then console.log err
					else 
						date = values[0].max 
						ts = date.getTime() + Source.safeFactor
						lastDateString = Source.formatDate(new Date(ts))
						Source.setLastDate site,lastDateString
					if count is sites.length
						callback("Completed!")
	@insertLastDatesToFile: (connection,callback)->
		sites = ["zi","ns","cc","gm","nn","nv","csn"]
		Source.insertLastDatesToFileFromLogs(sites)
		Source.insertLastDatesToFileFromDB ["nct","ke","lw","vg"],"songs",connection,callback


module.exports = Source