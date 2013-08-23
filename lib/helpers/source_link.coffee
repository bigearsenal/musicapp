
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

NCT = {}
NCT.getLink = (key,type,callback)->
NCT.getLink = (key,type,callback)->
	url = "http://www.nhaccuatui.com/flash/xml?key1=#{key}"
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
	getSource : (source,type,callback)->
		table = source.site + type
		@wp.getQueryMethod "select * from #{table} where id=#{source.id}",(err,results)=>
			if err then console.log err
			else 
				item = results[0]
				link = item.link
				if source.site isnt "csn" and source.site isnt "nct"
					if source.site is "gm" then link = "http://farm11.gox.vn:8080/streams/" + link
					if source.site is "ke" 
						switch type
							when "songs" then link = link.replace(/\/medias\//,'/medias_7/')
							when "videos" then link = link.replace(/\/media\./,'/media2.')
					link = link.replace(/\s/g,'%20')
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
								console.log "#{source.site}\t#{source.id}\t#{NOT FOUND}"
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
# items = new MediaLink()
# items.getMediaItems 987, "songs", (songs)->
	
# 	console.log "Get links from`#{items.getTitle()}`, artists : #{items.getArtists().join(" - ")}, id:#{items.getId()}, nItems: #{songs.length}"
# 	playlist =  playlist.concat songs
# 	items.setItems([])
# 	items.getMediaItems 2816, "videos", (elements)->
		
# 		console.log "Get links from`#{items.getTitle()}`, artists : #{items.getArtists().join(" - ")}, id:#{items.getId()}, nItems: #{elements.length}"
# 		playlist =  playlist.concat elements
# 		console.log "Fetching done".inverse.green
# 		items.endDBConnection()
# getLinks(987,"songs")
# getLinks(5401,"videos")



# READLINE INTERFACE

console.log "SELECT YOUR COMMAND: "
console.log "s[NUMBER]: select song\t v[NUMBER]: select video"
console.log "ds: default song\t dv: default video"

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
		media = new Media(recordings)
		media.play()

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

		



