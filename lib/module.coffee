
fs = require 'fs'
moduleKeywords = ['extended', 'included']
MYSQL_DEFAULT_CONFIG = 
	user : 'root'
	password: 'root'
	database: 'anbinh'
	port: '8889'
	multipleStatements : true

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
		@postgresqlEnable = true
		Array::unique = -> @filter (a, b) => (@.indexOf(a, b + 1) < 0)
		
		if @postgresqlEnable
			PGWrapper = require '../lib/pgwrapper'
			@wp = new PGWrapper()
			@connection = 
				escape : (str)=>
					return @wp.escape(str)
				connect : =>
					@wp.getConnection()
				getQuery : (query,item)=>
					@wp.getQuery(query,item)
				query : (query,param1,callback)=>
					@wp.getQueryMethod(query,param1,callback)
				end : =>
					@wp.endConnection()
		else 
			mysql = require '../node_modules/mysql'
			@connection = mysql.createConnection @serverConfig

	connect : ->
		if @hasConnection is false
			@connection.connect()
			@hasConnection = true

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
		@hasConnection = false
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


module.exports = Module