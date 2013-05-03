mysql = require 'mysql'
fs = require 'fs'
moduleKeywords = ['extended', 'included']
MYSQL_DEFAULT_CONFIG = 
	user : 'root'
	password: 'root'
	database: 'anbinh'
	port: '8889'

class Module
	constructor : (@serverConfig = MYSQL_DEFAULT_CONFIG) ->
		@stats = 
			totalItemCount :0
			passedItemCount :0
			failedItemCount : 0
			markedTimer : Date.now()
			totalDuration : 0
			totalItems : 0
			range0 : 0
			range1 : 0
			currentId : 0
			currentTable : ""
		@logPath = ""
		@hasConnection = false
	connect : ->
		if @hasConnection is false
			@connection = mysql.createConnection @serverConfig
			@connection.connect()
			@hasConnection = true
		@
	resetStats : ->
		@stats = 
			totalItemCount :0
			passedItemCount :0
			failedItemCount : 0
			markedTimer : Date.now()
			totalDuration : 0
			totalItems : 0
			range0 : 0
			range1 : 0
	end : ->
		@connection.end()
		@
	_readLog : ->
		data = fs.readFileSync @logPath , "utf8"
		@log = JSON.parse(data)
	_writeLog : (log) ->
		log.updated_at = new Date().getTime()
		fs.writeFileSync @logPath,JSON.stringify(log),"utf8"

	_printTableStats : (tables) ->
		@connect()
		for key, value of tables
			do (key, value) =>
				_query = "Select count(*) count from #{value}"
				@connection.query _query, (err,result)->
					console.log "Total records of #{value}: #{result[0].count}"

	@extend: (obj) ->
    	for key, value of obj when key not in moduleKeywords
      		@[key] = value

   		obj.extended?.apply(@)
    	this

  	@include: (obj) ->
   		for key, value of obj when key not in moduleKeywords
      # Assign properties to the prototype
      	@::[key] = value

    	obj.included?.apply(@)
    	this

module.exports = Module