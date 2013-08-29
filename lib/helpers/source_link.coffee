
colors = require 'colors'
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
	addItem : (site,id,link)->
		item = 
			id : id
			title : @title
			artists : @artists
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
	getSource : (source,type,callback)->
		table = source.site + type
		@wp.getQueryMethod "select * from #{table} where id=#{source.id}",(err,results)=>
			if err then console.log err
			else 
				item = results[0]
				link = item.link
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
					@addItem(source.site,source.id,link)
					callback()
				else 
					if source.site is "csn"
						fmts = item.formats
						for fmt in fmts
							day = new Date().getDay()
							link = fmt.link.replace(/(downloads\/[0-9]+\/)[0-9]\//,"$1#{day}/")
							#, bitrate: #{fmt.bitrate}
							@addItem(source.site,source.id,link)
						callback()
					if source.site is "nct"
						
						NCT.getLink item.link_key,type, (err,data)=>
							if err 
								console.log "#{source.site}\t#{source.id}\tNOT FOUND"
							else 
								link = data.match(/<location>[^]+<!\[CDATA\[(.+)\]\]>[^]+<\/location>/)?[1]
								@addItem(source.site,source.id,link)
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
					@getSource source,table, =>
						count +=1
						if count is item.sources.length
							callback @items
	endDBConnection : ->
		@wp.endConnection()


playlist = []



# READLINE INTERFACE

console.log "SELECT YOUR COMMAND: "
console.log "s[NUMBER]: select song\t v[NUMBER]: select video"
console.log "ds: default song\t dv: default video"
console.log "fs: search song\t fv: search video"

readline = require 'readline'
rl = readline.createInterface
	input: process.stdin,
	output: process.stdout
rl.setPrompt('', 0)

Media = require './media'
media = null

playRecordingList = (id,type)->
	_items = new MediaLink()
	_items.getMediaItems id, type, (recordings)->
		console.log "❯❯❯❯ Playing playlist [#{recordings.length} items]"
		validRecordings = []
		invalidRecordings = []
		count = 0
		for rcd in recordings
			do (rcd)->
				_items.checkItemLink rcd, (err)->
					count +=1
					if err then invalidRecordings.push rcd
					else 
						validRecordings.push rcd
					if count is recordings.length
						console.log "DONE".inverse.green
						for piece in invalidRecordings
							console.log "#{piece.site}:#{piece.id} - #{piece.link}".red



						media = new Media(validRecordings)
						media.play()

findingID = (table,title)->
	console.log "Finding `#{title}` on table: #{table}"
	PGWrapper = require '../pgwrapper'
	wp = new PGWrapper()
	wp.getConnection()
	wp.getQueryMethod "select * from #{table} where lower(trim(title))=lower(trim('#{title}')) ",(err,results)->
		if err then console.log err
		else 
			if results.length is 0
				console.log "NO RESULTS".inverse.red
			else 
				console.log "List of items".inverse.green
				for result in results
					idText = result.id + new Array(8-result.id.toString().length).join(" ")
					artists = if result.artists then result.artists.join(",") else ""
					console.log "#{idText} - #{result.title} - #{artists}"
			wp.endConnection()

rl.on "line", (line) ->
	command = line.trim()
	# if command is "all"
	# 	console.log "❯❯❯❯ Playing playlist [#{playlist.length} items]"
	# 	media = new Media(playlist)
	# 	media.play()
	matched = false
	if command.match(/^s([0-9]+)$/)
		id = command.match(/^s([0-9]+)$/)[1]
		id = parseInt(id,10)
		playRecordingList(id,"songs")
		matched = true
	if command.match(/^v([0-9]+)$/)
		id = command.match(/^v([0-9]+)$/)[1]
		id = parseInt(id,10)
		playRecordingList(id,"videos")
		matched = true
	if command.match(/^f[sva].+$/)
		command = command.match(/^f(.)\s?(.+)/)
		type = command[1]
		title  = command[2]
		switch type.trim()
			when "s" then table = "songs"
			when "v" then table = "videos"
			else table = "songs"
		findingID(table,title)
		matched = true
	if command is "ds"
		# play default songs
		playRecordingList(987,"songs")
		matched = true
	if command is "dv"
		# play default videos
		playRecordingList(2816,"videos")
		matched = true
	if command in ["quit","exit"]
		matched = true
		rl.close()
	unless matched
		console.log "Your command: #{command} invalid"
		console.log "You have to enter a number or command 'quit' or 'exit' "

	rl.prompt()
rl.on "close", ->
  console.log ""
  console.log "YOU HAVE TERMINATED PROGRAM!".inverse.red
  if media
  	media.quit()
  process.exit 0

		



