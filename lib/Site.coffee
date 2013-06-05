http = require 'http'
xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require 'colors'
events = require('events')


Encoder = require('node-html-encoder').Encoder
encoder = new Encoder('entity');


class Site extends Module
	constructor : (PREFIX) ->
		if PREFIX?
			@table = 
				Songs : PREFIX + "Songs"
				Albums: PREFIX + "Albums"
				Songs_Albums: PREFIX + "Songs_Albums"
				Videos : PREFIX + "Videos"
			@query = 
				_insertIntoSongs : "INSERT IGNORE INTO " + @table.Songs + " SET ?"
				_insertIntoAlbums : "INSERT IGNORE INTO " + @table.Albums + " SET ?"
				_insertIntoSongs_Albums : "INSERT IGNORE INTO " + @table.Songs_Albums + " SET ?"
				_insertIntoVideos : "INSERT IGNORE INTO " + @table.Videos + " SET ?"
			@utils = new Utils()
			@parser = new xml2js.Parser();
			@eventEmitter = new events.EventEmitter()
			super()
		else console.log "You do not specify any PREFIX".red
	
	getFileByHTTP : (link, onSucess, onFail, options) ->
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				# onSucess res.headers.location
				if res.statusCode isnt 302 and res.statusCode isnt 404
					res.on 'data', (chunk) =>
						data += chunk;
					res.on 'end', () =>
						
						onSucess data, options
				else onFail("The link is temporary moved",options)
			.on 'error', (e) =>
				onFail  "Cannot get file from server. ERROR: " + e.message, options

	###*
	 * Process the string or an Array of string: HTML decode, trim
	 * @param  {[string] | [array]} 
	 * @return {[string]}  [resulted string]
	###
	processStringorArray : (a)->
		if a instanceof Array
			JSON.stringify a.map((v)->encoder.htmlDecode(v).trim())
		else 
			encoder.htmlDecode(a).trim()

	# format Datetimt to insert into table
	formatDate : (dt)->
		dt.getFullYear() + "-" + (dt.getMonth()+1) + "-" + dt.getDate() + " " + dt.getHours() + ":" + dt.getMinutes() + ":" + dt.getSeconds()

	showStartupMessage : (message,table)->
		console.log "Running on: #{new Date(Date.now())}"
		console.log " |"+"#{message} #{table}".magenta
		@stats.currentTable = table
	showStats : ->
		@_printTableStats @table


module.exports = Site
