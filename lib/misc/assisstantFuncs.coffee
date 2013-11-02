http = require 'http'

HTTP = {}
HTTP.get = (link,callback) ->
	http.get link, (res) =>
			res.setEncoding 'utf8'
			data = ''
			# onSucess res.headers.location
			if res.statusCode isnt 302 and res.statusCode isnt 404
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					
					callback null,data
			else callback("The link is temporary moved: #{res.statusCode} #{JSON.stringify res.headers}",nul)
		.on 'error', (e) =>
			callback  "Cannot get file from server. ERROR: " + e.message,null
HTTP.getHeaders = (link,callback) ->
	req = http.get link, (res) =>
		callback null, res.statusCode,res.headers
		req.abort()
		return 0
	req.on 'error', (e) =>
		callback  "Cannot get file from server. ERROR: " + e.message,null
	
NCT = {}
NCT.getLink = (key,type,callback)->
	switch type
		when "songs" then query = "key1"
		when "albums" then query = "key2"
		when "videos" then query = "key3"
	url = "http://www.nhaccuatui.com/flash/xml?#{query}=#{key}"
	HTTP.get url,(err,data)->
		errInfo = null
		if err then errInfo = err
		if data and data.trim() is ""
			errInfo =  "NO LINK FOUND"
		callback errInfo, data


class MediaLink 
	constructor : ->
		PGWrapper = require '../pgwrapper'
		@wp = new PGWrapper()
		@wp.getConnection()
		@title = ""
		@artists = null
		@index = 0
		@items = []
		@id = 0
	addItem : (item,site,id,link)->
		item = 
			id : id
			title : item.title
			artists : item.artists
			site : site
			link : link
			
		@items.push item
		# console.log "#{@index}:\t#{site}\t#{id}"
		# console.log "#{index}:\t#{site}\t#{id}\t#{link}"
		@index +=1
	getId : ->
		return @id
	getTitle : ->
		return @title
	getArtists : ->
		return @artists
	getItems : ->
		return @items
	setItems : (items)->
		@items = items
	checkItemLink : (item,callback)->
		HTTP.getHeaders item.link, (err,statusCode,headers)->
			if err then callback(err)
			else 
				errMsg = null
				if headers["content-type"].search("text/html") > -1
					errMsg = "Content type is html"
				if statusCode is 200
					errMsg = null
				if statusCode is 302 and headers["location"]
					errMsg = null
				callback(errMsg)
	getSource : (source,item,type,callback)->
		table = source.site + type
		@wp.getQueryMethod "select * from #{table} where id=#{source.id}",(err,results)=>
			if err then console.log err
			else 
				newItem = results[0]
				link = newItem.link
				if source.site isnt "csn" and source.site isnt "nct"
					switch source.site
						when "gm" then link = "http://farm11.gox.vn:8080/streams/" + link
						when "ns" then link = link.replace(/st01\.freesocialmusic/,"st02.freesocialmusic")
						when "ke" 
							switch type
								when "songs" then link = link.replace(/\/medias\//,'/medias_7/')
								when "videos" then link = link.replace(/\/media\./,'/media2.')
								else console.log "invalid type input xxx"
					link = link.replace(/\s/g,'%20').replace(/\?.+$/,'')
					@addItem(item,source.site,source.id,link)
					callback()
				else 
					if source.site is "csn"
						fmts = newItem.formats
						for fmt in fmts
							day = new Date().getDay()
							link = fmt.link.replace(/(downloads\/[0-9]+\/)[0-9]\//,"$1#{day}/")
							#, bitrate: #{fmt.bitrate}
							@addItem(item,source.site,source.id,link)
						callback()
					if source.site is "nct"
						
						NCT.getLink newItem.link_key,type, (err,data)=>
							if err 
								console.log "#{source.site}\t#{source.id}\tNOT FOUND"
							else 
								link = data.match(/<location>[^]+<!\[CDATA\[(.+)\]\]>[^]+<\/location>/)?[1]
								@addItem(item,source.site,source.id,link)
							callback()
	getMediaItems : (id,table,callback)->
		count = 0
		@wp.getQueryMethod "select * from #{table} where id=#{id}",(err,results)=>
			if err then console.log err
			else 
				item = results[0]
				@id  = id
				@title = item.title
				@artists = item.artists
				for source in item.sources
					@getSource source,item,table, =>
						count +=1
						if count is item.sources.length
							callback @items
	endDBConnection : ->
		@wp.endConnection()

class Assisstant
	constructor : ->
		pg = require 'pg'
		config =  require '../pgwrapper/config'
		@client = new pg.Client config


	httpGet : (link, callback) ->
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				# onSucess res.headers.location
				if res.statusCode isnt 302 and res.statusCode isnt 404
					res.on 'data', (chunk) =>
						data += chunk;
					res.on 'end', () =>
						
						callback null, data
				else callback("The link is temporary moved: #{res.statusCode} #{JSON.stringify res.headers}",null)
			.on 'error', (e) =>
				callback  "Cannot get file from server. ERROR: " + e.message,null
	searchES : (terms,callback)->
		url = "http://localhost:9200/music/songs/_search?q=" + terms
		# console.log url
		@httpGet url, (err,data)->
			if err then console.log err
			else 
				hits = JSON.parse(data).hits.hits
				# for hit in hits 
				# 	console.log hit._source
				
				
				results = []
				count = 0
				xml = ""
				media = new MediaLink()
				if hits.length > 0
					for hit in hits
						do (hit) =>
							media.getMediaItems hit._source.id,"songs", (recordings)=>
								for rcd in recordings
									results.push rcd
								count += 1
								if count is hits.length
									# convert to XML
									# sqlString = require('../pgwrapper/SqlString')
									# escape = (value)->
									# 	sqlString.escape(value, false, 'local')
									xml += '<?xml version="1.0" encoding="UTF-8"?>\n'
									xml += "<songs>\n"
									for ret, index in results
										xml += "\t<song>\n"
										xml += "\t\t<order>#{index+1}</order>\n"
										xml += "\t\t<id>#{ret.id}</id>\n"
										xml += "\t\t<title><![CDATA[#{ ret.title}]]></title>\n"
										if ret.artists isnt null
											xml += "\t\t<artists><![CDATA[#{ ret.artists.join(", ")}]]></artists>\n"
										else 
											xml += "\t\t<artists></artists>\n"
										xml += "\t\t<site>#{ret.site}</site>\n"
										xml += "\t\t<link>#{ret.link.replace("http://st02.freesocialmusic.com/","http://st01.freesocialmusic.com/")}</link>\n"
										xml += "\t</song>\n"
									xml += "</songs>\n"
									# console.log xml
									callback(xml)
									media.endDBConnection()
				else 
					xml += '<?xml version="1.0" encoding="UTF-8"?>\n'
					xml += "<songs>\n"
					xml += "</songs>\n"
					callback(xml)
					media.endDBConnection()

							


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