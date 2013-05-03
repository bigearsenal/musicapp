printResutls = require('util').print
colors = require 'colors'

class Utils 
	convertToDate : (link) ->
		parseInt(link.match(/\/[0-9]+_/g)[0].replace(/\//,'').replace(/_/,''))*100

	isInteger : (str="") ->
		if str.search(/^[0-9]+$/g) is -1
			false
		else true

	_getTime : (mms) ->
		totalsec = Math.floor mms/1000
		sec = totalsec%60
		min = Math.floor totalsec/60
		if min isnt 0 then result = min + "m" + sec + "s" else result = sec + "s"
	
	_getTimeRemain : (avgspeed,stats) ->
		secondsLeft = Math.round (stats.totalItems-stats.totalItemCount)/avgspeed 
		sec = secondsLeft%60
		min = Math.floor secondsLeft/60
		if min isnt 0 then result = min + "m" + sec + "s" else result = sec + "s"
	
	printFinalResult : (stats) ->
		stats.totalDuration = Date.now() - stats.markedTimer
		console.log ""
		console.log " |------------------------------------------------------|"
		console.log " | "+"TABLE: #{stats.currentTable}".blue 
		console.log " |------------------------------------------------------|"
		console.log " | The number of items:\t\t\t" + stats.totalItemCount + "\t\t|"
		console.log " | The number of items added to DB:\t" + stats.passedItemCount + "\t\t|"
		console.log " | Total items failed:\t\t\t" + stats.failedItemCount + "\t\t|"
		console.log " | The process completed in:\t\t" + @_getTime(stats.totalDuration,stats) + "\t\t|"
		console.log " | The average speed:\t\t\t" + Math.round(stats.totalItemCount/stats.totalDuration*1000) + " item/s" + "\t|"
		console.log " |------------------------------------------------------|"
	
	printUpdateRunning : (id,stats,info) ->
		tempDuration = Date.now() - stats.markedTimer
		message  = " |"+"#{info}".inverse.magenta
		message += " | t:"  + @_getTime(tempDuration)
		message += " | id:" + id
		message += " | n:"+ stats.totalItemCount
		message += " | pass:"+stats.passedItemCount
		message += " | fail:"+stats.failedItemCount
		message += " | speed:"+Math.round(stats.totalItemCount/tempDuration*1000)+ "|\r"
		printResutls message

	printRunning : (stats) ->
		tempDuration = Date.now() - stats.markedTimer
		percent = stats.totalItemCount/stats.totalItems*100
		message  = " | " + percent.toFixed(2) + "%"
		message += " | t:"  + @_getTime(tempDuration,stats)
		message += " | id:" + stats.currentId
		message += " | n:"+ stats.totalItemCount
		message += " | pass:"+stats.passedItemCount
		message += " | fail:"+stats.failedItemCount
		message += " | speed:"+Math.round(stats.totalItemCount/tempDuration*1000)
		message += " | t_left:" + @_getTimeRemain(stats.totalItemCount/tempDuration*1000,stats) + "|\r"
		printResutls message

	printMessage : (message)->
		printResutls message + "\r"
	test : -> console.log "daonguyenanbinh"

module.exports = Utils