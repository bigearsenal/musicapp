class Assisstant
	constructor : ->
		#do sth
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
		PGWrapper = require '../pgwrapper'
		wp = new PGWrapper()
		wp.getConnection()
		songQuery = "select * from #{site}songs where id=#{id}"
		albumQuery = "select * from #{site}albums where id=#{id}"
		videoQuery = "select * from #{site}videos where id=#{id}"
		wp.getQueryMethod songQuery, (err,result)->
			if err then console.log err
			else console.log result
			wp.getQueryMethod albumQuery, (err,result)->
				if err then console.log err
				else console.log result
				wp.getQueryMethod videoQuery, (err,result)->
					if err then console.log err
					else console.log result
					wp.endConnection()


module.exports = Assisstant