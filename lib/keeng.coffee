http = require 'http'
xml2js = require 'xml2js'
Module = require './module'
Utils = require './utils'
colors = require 'colors'
fs = require 'fs'

KE_CONFIG = 
	table : 
		Songs : "KESongs"

class Keeng extends Module
	constructor : (@mysqlConfig, @config = KE_CONFIG) ->
		@table = @config.table
		@query = 
			_insertIntoKESongs : "INSERT INTO " + @table.Songs + " SET ?"
		@utils = new Utils()
		@parser = new xml2js.Parser();
		super @mysqlConfig
		

	createTables : ->
		@connect()
		songsQuery = "CREATE TABLE IF NOT EXISTS " + @table.Songs + " (
					id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
					albumid varchar(20),
					album_name varchar(255),
					songid varchar(20),
					song_name varchar(255),
					artist_name varchar(255),
					album_plays int,
					album_link varchar(255),
					song_link varchar(255)
					);"
		@connection.query songsQuery, (err, result)=>
			if err then console.log "Cannot create table" else console.log "Tables: #{@table.Songs} have been created!"
			@end()
	resetTables : ->
		@connect()
		songsQuery = "truncate table #{@table.Songs} ;"
		@connection.query songsQuery, (err, result)=>
			if err then console.log "Cannot truncate tables" else console.log "Tables: #{@table.Songs} have been truncated!"
			@end()

	_updateAlbum : (pageId) ->
		link = "http://www.keeng.vn/album/album-moi.html?page=" + pageId
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					items = data.match(/class\=\"link\sname-song\sunder\".+/g)
					data  = ""
					for item, i in items
						album = 
							title : item.match(/^class.+name-single/g)[0]
									.match(/^class.+\<\/a\>/g)[0]
									.replace(/^class.+\"\>/,'')
									.replace(/\<\/a\>/,'').trim()
							artist_name : item.replace(/^class.+\"\>/g,'').replace(/\<\/a\>\<\/p\>/,'').trim()
							id :  item.match(/^.+name-single/g)[0]
									.match(/^.+ title/)[0]
									.replace(/^.+\/.+\/.+\//,'')
									.replace(/\.html.+/,'')
						if @temp.isNewPage
							do (album, i) =>
								_query = "select * from #{@table.Songs} where albumid=#{@connection.escape(album.id)}"
								@connection.query _query, (err, result)=>
									if err then console.log "We have error: #{err}"
									else
										if result.toString() is ''
											@temp.albumList.push album
											# @_updateSongs album #fetch new album
											if i is items.length-1 then @_updateAlbum pageId+1
										else
											if pageId is 1 and i is 0 then console.log "Table: #{@table.Songs} is up-to-date"
											@temp.isNewPage = false
											if @temp.check is false 
												@temp.check = true
												@_updateSongs album for album in @temp.albumList
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	_updateSongs : (album) ->
		link = "http://www.keeng.vn/album/get-album-xml?album_identify=#{album.id}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					data = data.replace(/\r/g,'')
					titles = data.match(/\<title\>.+\<\/title\>/g)
					locations = data.match(/\<location\>.+\<\/location\>/g)
					ids = data.match(/\<info\>.+\<\/info\>/g)
					@stats.totalItemCount+=1
					if locations isnt null
						@stats.passedItemCount +=1
						for i in [0..locations.length-1]
							song = 
								albumid : album.id
								album_name : album.title
								songid : ids[i+1].replace(/\<info\>/,'').replace(/<\/info\>/,'').trim()
								song_name : titles[i+1].replace(/\<title\>/,'').replace(/<\/title\>/,'').trim()
								song_link : locations[i].replace(/\<location\>/,'').replace(/<\/location\>/,'').trim()
								artist_name : album.artist_name
							if song.song_link.match(/\d{4}\/\d{2}\/\d{2}/) isnt null then song.created = song.song_link.match(/\d{4}\/\d{2}\/\d{2}/)[0].replace(/\//g,'-')
							@connection.query @query._insertIntoKESongs, song, (err)->
								if err then console.log "CANNOT insert songid #{song.songid}. ERROR: #{err}".red
						@utils.printUpdateRunning album.id, @stats, "Fetching"
					else
						@stats.failedItemCount+=1
					if @stats.totalItemCount is @temp.albumList.length
						@utils.printFinalResult @stats

			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	
	_fetchAlbum : (pageId) ->
		link = "http://www.keeng.vn/album/album-moi.html?page=" + pageId
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					items = data.match(/class\=\"link\sname-song\sunder\".+/g)
					data  = ""
					for item, i in items
						album = 
							title : item.match(/^class.+name-single/g)[0]
									.match(/^class.+\<\/a\>/g)[0]
									.replace(/^class.+\"\>/,'')
									.replace(/\<\/a\>/,'').trim()
							artist_name : item.replace(/^class.+\"\>/g,'').replace(/\<\/a\>\<\/p\>/,'').trim()
							id :  item.match(/^.+name-single/g)[0]
									.match(/^.+ title/)[0]
									.replace(/^.+\/.+\/.+\//,'')
									.replace(/\.html.+/,'')
						@_fetchSongs album	
			
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1	
	_fetchSongs : (album) ->
		link = "http://www.keeng.vn/album/get-album-xml?album_identify=#{album.id}"
		http.get link, (res) =>
				res.setEncoding 'utf8'
				data = ''
				res.on 'data', (chunk) =>
					data += chunk;
				res.on 'end', () =>
					data = data.replace(/\r/g,'')
					titles = data.match(/\<title\>.+\<\/title\>/g)
					locations = data.match(/\<location\>.+\<\/location\>/g)
					ids = data.match(/\<info\>.+\<\/info\>/g)
					@stats.totalItemCount+=1
					if locations isnt null
						@stats.passedItemCount +=1
						for i in [0..locations.length-1]
							song = 
								albumid : album.id
								album_name : album.title
								songid : ids[i+1].replace(/\<info\>/,'').replace(/<\/info\>/,'').trim()
								song_name : titles[i+1].replace(/\<title\>/,'').replace(/<\/title\>/,'').trim()
								song_link : locations[i].replace(/\<location\>/,'').replace(/<\/location\>/,'').trim()
								artist_name : album.artist_name
							if song.song_link.match(/\d{4}\/\d{2}\/\d{2}/) isnt null then song.created = song.song_link.match(/\d{4}\/\d{2}\/\d{2}/)[0].replace(/\//g,'-')
							@connection.query @query._insertIntoKESongs, song, (err)->
								if err then console.log "CANNOT insert songid #{song.songid}".red
						@utils.printRunning @stats
							
					else
						@stats.failedItemCount+=1
					if @stats.totalItemCount is @stats.totalItems
							@utils.printFinalResult @stats
			.on 'error', (e) =>
				console.log  "Got error: " + e.message
				@stats.failedItemCount+=1
	
	fetchAlbums : (range0 = 0, range1 = 0) =>
		@connect()
		console.log " |"+"Fetching songid: #{range0}..#{range1} to table: #{@table.Songs}".magenta
		@stats.totalItems = (range1 - range0 + 1)*25
		[@stats.range0, @stats.range1] = [range0, range1]
		@stats.currentTable = @table.Albums
		@_fetchAlbum id for id in [range0..range1]
		null

	update : ->
		#update songs and albums
		@connect()
		@stats.currentTable = @table.Songs
		@temp = 
			albumList : []
			check : false #used to check the last new album
			isNewPage : true #to check if a page contains old albums. If not, fetch new page
		console.log " |"+"Updating Albums + Songs to table: #{@table.Songs}".magenta
		@_updateAlbum(1)

	showStats : ->
		@_printTableStats KE_CONFIG.table


module.exports = Keeng
