class ObjectTransformation
	constructor : (@table,@connection)->
		@fs = require 'fs'
		@path = '/Volumes/Data/website/database/'
		@fileName = "sample.sql"
		@filePath = @path + @fileName
	setFileName : (fileName)->
		@fileName = fileName
		@filePath = @path + @fileName
		# @fs.writeFileSync @filePath, ""
	setPath : (path)->
		@path = path
	groupBy : (obj, value, context) ->
		
		# This function is ported from underscore library
		ArrayProto = Array.prototype
		ObjProto = Object.prototype
		nativeForEach  = ArrayProto.forEach
		hasOwnProperty   = ObjProto.hasOwnProperty
		has = (obj, key) -> hasOwnProperty.call obj, key
		each = (obj, iterator, context) ->
			return  unless obj?
			if nativeForEach and obj.forEach is nativeForEach
				obj.forEach iterator, context
			else if obj.length is +obj.length
				i = 0
				l = obj.length
				while i < l
					return  if iterator.call(context, obj[i], i, obj) is breaker
					i++
			else
				for key of obj
					return  if iterator.call(context, obj[key], key, obj) is breaker  if has(obj, key)
		isFunction = (obj) -> typeof obj is "function"
		identity = (value) -> value
		lookupIterator = (value) ->
			(if isFunction(value) then value else (obj) ->
				obj[value]
			)
		group = (obj, value, context, behavior) ->
			result = {}
			iterator = lookupIterator((if not value? then identity else value))
			each obj, (value, index) ->
				key = iterator.call(context, value, index, obj)
				behavior result, key, value
			result
		group obj, value, context, (result, key, value) ->
			((if has(result, key) then result[key] else (result[key] = []))).push value
	getInsertStatement : (objects,table)->	
		getStatementFromObject = (object,table)=>
			columns = []
			values = []
			for key,value of object
				columns.push "#{table}.#{key}"
				values.push  @connection.escape value
			return "INSERT IGNORE INTO #{table} (#{columns.join(',')}) VALUES (#{values.join(",")})"

		if objects instanceof Array 
			statements = []
			for object in objects
				statements.push getStatementFromObject object, table
			if statements.length > 0
				return statements.join(";")+";"
			else return ""
		else  
			statement = getStatementFromObject objects, table
			statement += ";"
			return statement

module.exports = ObjectTransformation