

class PostgresqlWrapper
	constructor : (configPath,mysql)->
		@pg = require '../node_modules/pg'
		# fs = require 'fs'
		config =  require './pgwrapper/config'
		@client = new @pg.Client config
		@debugEnable  = false

	escape : (value) ->
		sqlString = require('./pgwrapper/SqlString')
		return sqlString.escape(value, false, 'local')

	isSelectStatement : (statement)->
		if statement.length > 20
			if statement.substring(0,20).toLowerCase().match(/^select/)
				return true
			else return false
		else
			if statement.toLowerCase().match(/^select/)
				return true
			else return false
	isInsertStatement : (statement)->
		if statement.length > 20
			if statement.substring(0,20).toLowerCase().match(/^insert/)
				return true
			else return false
		else
			if statement.toLowerCase().match(/^insert/)
				return true
			else return false
	isUpdateStatement : (statement)->
		if statement.length > 20
			if statement.substring(0,20).toLowerCase().match(/^update/)
				return true
			else return false
		else
			if statement.toLowerCase().match(/^update/)
				return true
			else return false
	isDeleteStatement : (statement)->
		if statement.length > 20
			if statement.substring(0,20).toLowerCase().match(/^delete/)
				return true
			else return false
		else
			if statement.toLowerCase().match(/^delete/)
				return true
			else return false
	transformInsertQuery : (query,item)->
		try 
			if item
				fields = []
				values = []
				for key,value of item 
					fields.push key
					if value instanceof Array
						if value.length > 0
							values.push "ARRAY[#{value.map((v)=>if v.trim then @escape(v.trim()) else @escape(v) ).join(',')}]"
						else values.push "'{}'"
					else
						if value is undefined
							values.push @escape(null)
						else
							if value isnt null and value.match?
								if value.match(/^\[(".+"),?\]$/)
									try 
										arr = JSON.parse value
										if arr.length > 0
											values.push "ARRAY[#{arr.map((v)=>if v.trim then @escape(v.trim()) else @escape(v) ).join(',')}]"
										else values.push "'{}'"
									catch e
										console.log "Error found while parsing insert statement, #{e}"
										console.log "#{query}".red
										values.push @escape value.trim()
								else 
									values.push @escape value.trim()
							else values.push @escape value
				_q = query.replace(/into (\w+) /i,"into \"$1\" ")
				_q = _q.replace(/insert ignore/gi,"insert")
				_q = _q.replace(/SET\s+\?/gi,"(#{fields.join(',')})")
				_q += " VALUES(#{values.join(',')})"
			else 
				console.log "need to specify object to insert"
		catch e
			console.log "transformInsertQuery() called : #{e}"
			console.log item
			# process.exit 0
		return _q

	transformUpdateQuery : (query)->
		_q = query
		value = query.match(/\=['"](\[(".+"),?\])['"]/)?[1]


		# transform query such as: `update zisongs set song_artist='[\"Nhạc Trẻ\",\"Việt Nam\"]' where sid=2000000000`
		# into `update zisongs set song_artist=ARRAY['Nhạc Trẻ','Việt Nam'] where sid=2000000000`
		# 
		if value 
			try 
				arr = JSON.parse value
				xx = "ARRAY[#{arr.map((v)=>@escape(v.trim())).join(',')}]"
				_q = _q.replace(/\=['"]\[(".+"),?\]['"]/,"=#{xx}")
			catch e
				console.log "Error found while parsing update statement, #{e}"
				console.log "#{query}".red

		else 
			# transform query such as: `update zisongs set song_artist=\'[\\\"Nhạc Trẻ\\\",\\\"Việt Nam\\\"]\' where sid=2000000000`
			# into `update zisongs set song_artist=ARRAY['Nhạc Trẻ','Việt Nam'] where sid=2000000000`
			# 
			value = query.match(/\=['"](\[(\\".+\\"),?\])['"]/)?[1]
			if value 
				try 
					if @debugEnable then console.log "#{value} called inside transformUpdateQuery()"
					value = value.replace(/\\/g,'')
					arr = JSON.parse value
					xx = "ARRAY[#{arr.map((v)=>@escape(v.trim())).join(',')}]"
					_q = _q.replace(/\=['"](\[(\\".+\\"),?\])['"]/,"=#{xx}")
				catch e
					console.log "Error no.2 found while parsing update statement, #{e}"
					console.log "#{query}".red

		return _q

	transformDeleteQuery : (query)->
		_q = ""
		# console.log query
		_q = query.replace(/delete\s+\*\s+/gi,'DELETE ')
		# console.log _q
		# console.log query
		return _q

	transformQuery : (query, item)->
		_q = ""
		# console.log query + "*********"
		if @isSelectStatement(query)
			# console.log "select TRIGGER"
			_q = query.replace(/from (\w+) /i,"from \"$1\" ")

		else 
			if @isInsertStatement(query)
				# console.log "insert TRIGGER"
				_q = @transformInsertQuery query, item

			else 
				if @isUpdateStatement(query)
					# console.log "update TRIGGER"
					_q = @transformUpdateQuery query

				else
					if @isDeleteStatement(query)
						# console.log "DELETE TRIGGER"
						_q = @transformDeleteQuery query
					else
						_q = query
		return _q
	transformResults : (results) ->
		if results then return results.rows
		else return results

	getConnection : ->
		return @client.connect()
	endConnection : ->
		return @client.end()

	getQuery : (query,item)->
		_query =  ""
		if item
			_query = @transformQuery query, item
		else 
			_query = @transformQuery query
		return _query

	getQueryMethod : (query,param1,callback) ->
		_query =  ""
		# console.log "#{query} asdfasdfsdf"
		if callback
			_query = @transformQuery query, param1
		else 
			_query = @transformQuery query
		if @debugEnable then console.log "#{_query} is called inside getQueryMethod()"
		# console.log @client.query
		# process.exit 0
		@client.query _query, (err, results)=>
			# console.log err
			# console.log "inside query called!!!"
			if err 
				errorMessage = "#{_query} invalid, #{err.toString()}"
				# console.log err.toString() duplicate key value violates unique constraint
				if query.search(/^insert ignore/ig) > -1 and err.toString().search(/duplicate key value violates unique constraint/gi) > -1
					errorMessage = null
					# console.log "triggered...#{err}"
					# console.log _query
					results = 
						rows : []
			else errorMessage = err

			if callback
				callback errorMessage, @transformResults results
			else 
				param1 errorMessage, @transformResults results

	getEscapeMethod : ->





module.exports = PostgresqlWrapper