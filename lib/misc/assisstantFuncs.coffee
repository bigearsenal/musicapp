class Assisstant
	constructor : ->
		pg = require 'pg'
		config =  require '../pgwrapper/config'
		@client = new pg.Client config

	getID : (key)->
		NS = require '../helpers/NS'
		ZI = require '../helpers/ZI'
		if NS.checkKey(key)  
			console.log "Nhacso - ID: #{NS.getID(key)}"
			id = NS.getID(key)
			site = "ns"
		else 
			if ZI.checkKey(key)  
				console.log "Zing - ID: #{ZI.getID(key)}"
				id = ZI.getID(key)
				site = "zi"
			else console.log "Invalid key"
		
		songQuery = "select * from #{site}songs where id=#{id}"
		albumQuery = "select * from #{site}albums where id=#{id}"
		videoQuery = "select * from #{site}videos where id=#{id}"
		# @wp.getQueryMethod songQuery, (err,result)=>
		# 	if err then console.log err
		# 	else console.log result
		# 	@wp.getQueryMethod albumQuery, (err,result)=>
		# 		if err then console.log err
		# 		else console.log result
		# 		@wp.getQueryMethod videoQuery, (err,result)=>
		# 			if err then console.log err
		# 			else console.log result
		# 			@wp.endConnection()
	getAll : ->
		totalElements = 2000000
		_select  = "select id from songs limit #{totalElements}"
		# readline = require 'readline'
		# rl = readline.createInterface {input: process.stdin,output: process.stdout}
		# rl.setPrompt('---=>', 10)
		arr = []
		@client.connect()

		# create buffer array
		elementSize = 4
		size = totalElements*elementSize
		buffer = new Buffer(size)
		index = 0
		#end
		
		console.log "Getting array of #{totalElements} elements"

		query = @client.query _select
		query.on "row", (row)=>
			# console.log row
			offset = index*elementSize
			buffer.writeUInt32BE(parseInt(row.id,10),offset)
			index +=1
		query.on "end", (result)=>
			# console.log "FInal result:"
			# console.log result
			# for i in [0..result.rowCount-1]
			# 	console.log buffer.readUInt32BE(i*elementSize)
			console.log "END the result. total array: #{buffer.length}"
			count = 0
			for i in [0..result.rowCount-1]
				if (buffer.readUInt32BE(i*elementSize) >> 3 & 1) is 1 and (buffer.readUInt32BE(i*elementSize) >> 5 & 1) is 1 and (buffer.readUInt32BE(i*elementSize) >> 2 & 1) is 1
					count +=1
			console.log "number of item greater 4th bit is 1: #{count}"


		query.on "error", (err)=>
			console.log "we have an error:#{err}"


module.exports = Assisstant