http = require 'http'
# xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require '../node_modules/colors'
events = require('events')
url = require 'url'

Encoder = require('../node_modules/node-html-encoder').Encoder
encoder = new Encoder('entity');

http.globalAgent.maxSockets = 100

class Site extends Module
	constructor : (PREFIX) ->
		if PREFIX?
			@table = 
				Songs : PREFIX + "songs"
				Albums: PREFIX + "albums"
				Songs_Albums: PREFIX + "songs_albums"
				Videos : PREFIX + "videos"
			@query = 
				_insertIntoSongs : "INSERT IGNORE INTO " + @table.Songs + " SET ?"
				_insertIntoAlbums : "INSERT IGNORE INTO " + @table.Albums + " SET ?"
				_insertIntoSongs_Albums : "INSERT IGNORE INTO " + @table.Songs_Albums + " SET ?"
				_insertIntoVideos : "INSERT IGNORE INTO " + @table.Videos + " SET ?"
			@utils = new Utils()
			# @parser = new xml2js.Parser();
			@eventEmitter = new events.EventEmitter()
			super()
		else console.log "You do not specify any PREFIX".red
	
	getFileByHTTPWithPostMethod : (link, dataString, onSucess, onFail, options) ->
		options  = url.parse link
		options.method = "POST"
		options.headers = 
				'Content-Type': 'application/x-www-form-urlencoded',  
				'Content-Length': dataString.length
		# console.log dataString
		req = http.request options, (res) =>
					res.setEncoding 'utf8'
					data = ''
					# onSucess res.headers.location
					if res.statusCode isnt 302 and res.statusCode isnt 404
						res.on 'data', (chunk) =>
							data += chunk;
						res.on 'end', () =>
							onSucess data, options
					else onFail("The link is temporary moved: #{res.statusCode}",options)
				.on 'error', (e) =>
					onFail  "Cannot get file from server. ERROR: " + e.message, options
		req.write(dataString)
		req.end()


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
				else onFail("The link is temporary moved: #{res.statusCode} #{JSON.stringify res.headers}",options)
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
			if a isnt undefined
				return encoder.htmlDecode(a).trim()
			else return undefined
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
