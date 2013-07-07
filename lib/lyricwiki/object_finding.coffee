class ObjectFinding
	constructor : (@table,@connection)->
		@maxArtistId = 0
		@maxAlbumId = 0
	getMaxArtistId : ->
		return @maxArtistId
	getMaxAlbumId : ->
		return @maxAlbumId 
	getMaxId : (field,table,callback)->
		select = "Select max(#{field}) as max from #{table}"
		@connection.query select, (err, result)->
			if err then	callback "Cannot find max #{field} of #{table}", null
			else 
				for item in result
					callback null, item.max
	getMaxArtistIdinDB : (callback) ->
		@getMaxId "id", @table.Artists, (err,maxId)=>
			@maxArtistId = maxId
			callback(err,maxId)
	getMaxAlbumIdinDB : (callback) ->
		@getMaxId "id", @table.Albums, (err,maxId)=>
			@maxAlbumId = maxId
			callback(err,maxId)
	# result is yes/no
	# callback(error:String,isFound:Boolean)
	isNewArtist : (name, callback)->
		_s = "Select id, name from #{@table.Artists} where name=#{@connection.escape name} "
		# console.log _s
		@connection.query _s, (err, result)->
			# console.log result
			if err then callback "Cannot find name of new artist. ERROR; #{err}"
			else 
				if result.length > 1
					callback "multiple values found. ERROR occurs"
				if result.length is 0
					callback null, no
				else if result.length is 1
					callback null, yes
	# callback(error:String,isFound:Boolean)
	isNewAlbum : (albumTitle,artistId,callback)->
		_s = "Select id,title, artist_id from #{@table.Albums} where title=#{@connection.escape albumTitle} and artist_id = #{artistId} "
		# console.log _s
		@connection.query _s, (err, result)->
			# console.log result
			if err then callback "Cannot find name of new artist. ERROR; #{err}"
			else 
				if result.length > 1
					callback "multiple values of #{albumTitle} found . ERROR occurs"
				if result.length is 0
					callback null, no
				else if result.length is 1
					callback null, yes
	#callback(err:String,id)
	findItem : (fields,table,condition,callback)->
		_select = "Select #{fields} from #{table} where #{condition}"
		# console.log _select
		@connection.query _select, (err, result)->
			if err then	callback "Cannot find #{field} of #{table}", null
			else 
				if result.length is 0 then callback "Cannt find item on condition #{condition}",null
				if result.length > 1 then callback "multiple values on condition #{condition} ERROR has occured!",null
				if result.length is 1
					callback null, result[0]
	
	#callback(err:String,result:Object)
	findArtist : (artistName, callback)->
		# console.log "ANBINH"
		@findItem "id,name",@table.Artists, "name=#{@connection.escape artistName}", (err,result)->
			if err then callback err,null
			else 
				callback null, result
	#callback(err:String,result:Object)
	findAlbum : (albumTitle,albumArtistId, callback)->
		# console.log "ANBINH"
		@findItem "id,title,artist_id",@table.Albums, "title=#{@connection.escape albumTitle} and artist_id = #{albumArtistId}", (err,result)->
			if err then callback err,null
			else 
				callback null, result

	addNewAlbum : (album,callback)->
		@findAlbum album.title, album.artist_id, (err, result)=>
			if err 
				@getMaxAlbumIdinDB (err,maxId)=>
					if err then callback "#{err}", null
					else 
						@maxAlbumId = maxId
						album = 
							id : @maxAlbumId + 1
							title : album.title
							artist_id : album.artist_id
							artist : album.artist
							year : album.year
							created_at : album.created_at
						@connection.query "INSERT IGNORE INTO #{@table.Albums} SET ?",album, (err)->
							if err then callback err
							else callback null,album
			else callback null, result				
	addNewSong : (song,callback)->
		if song.id
			delete song.id
		@connection.query "INSERT IGNORE INTO #{@table.Songs} SET ?",song, (err)->
			callback err
				
	# callback(newArtists: Array)
	filterNewArtists : (artists,callback)->
		newArtists = []
		count = 0
		for artist in artists 
			do (artist)=>
				@isNewArtist artist, (err,isFound)->
					count +=1
					if err then console.log "#{err}"
					else 
						if isFound is yes
							# console.log "#{artist} is not new"
						else 
							# console.log "#{artist} is new".inverse.green
							newArtists.push artist
					if count is artists.length
						callback(newArtists)
	# callback(newAlbums: Array)
	filterNewAlbums : (albums,callback)->
		newAlbums = []
		count = 0
		for album in albums 
			do (album)=>
				@isNewAlbum album.title,album.artist_id, (err,isFound)->
					count +=1
					if err then console.log "#{err}"
					else 
						if isFound is yes
							# console.log "#{JSON.stringify album} is not new"
						else 
							# console.log "#{JSON.stringify album} is new".inverse.green
							newAlbums.push album
					if count is albums.length
						callback(newAlbums)
	# callback(err:String,artists:Array)
	assignNewIDsToArtists : (artists,callback)->
		@getMaxArtistIdinDB (err,maxId)=>
			if err then callback "#{err}", null
			else 
				@maxArtistId = maxId
				_artists = []
				@filterNewArtists artists, (newArtists)=>
					for artist, index in newArtists
						_artist = 
							name : artist
							id : @maxArtistId + index + 1
						_artists.push _artist

					callback(null,_artists)
	# callback(err:String,artists:Array)
	assignNewIdsToAlbums : (albums,callback)->
		if albums.length > 0 
			@getMaxAlbumIdinDB (err,maxId)=>
				if err then callback "#{err}", null
				else 
					@maxAlbumId = maxId
					_albums = []
					@filterNewAlbums albums, (newAlbums)=>
						for album, index in newAlbums
							_album = 
								id : @maxAlbumId + index + 1
								title : album.title
								artist_id : album.artist_id
								artist : album.artist
								created_at  : album.created_at
								year : album.year
							_albums.push _album

						callback(null,_albums)
		else callback null,[]
	#callback(err:String)
	insertArtistsToDB : (artists, callback) ->
		@assignNewIDsToArtists artists, (err,newArtists)=>
			if err then console.log "#{err}"
			else  
				count = 0
				hasError = null
				if newArtists.length is 0 then callback null
				else 
					for artist, index in newArtists
						do (artist,index)=>
							@connection.query "INSERT IGNORE INTO #{@table.Artists} SET ?",artist, (err)->
								count +=1
								if err 
									console.log "Cannot insert new artist: #{artist}. ERROR:#{err}"
									hasError = yes
								if count is newArtists.length
									if hasError is yes
										callback "error has occured in insertArtistsToDB",
									else callback null
	#callback(err:String)
	insertAlbumsToDB : (artists,albums, callback) ->
		# console.log "insertAlbumsToDB triggered"
		@addArtistIds artists,albums,"album",(newAlbs)=>
			# console.log newAlbs
			@assignNewIdsToAlbums newAlbs, (err,newAlbums)=>
				if err then console.log "#{err}"
				else  
					# console.log "assignNewIdsToAlbums triggered inside insertAlbumsToDB"
					count = 0
					hasError = null
					if newAlbums.length is 0 then callback null
					else 
						for album, index in newAlbums
							do (album,index)=>
								@connection.query "INSERT IGNORE INTO #{@table.Albums} SET ?",album, (err)->
									count +=1
									if err 
										console.log "Cannot insert new album: #{album}. ERROR:#{err}"
										hasError = yes
									if count is newAlbums.length
										if hasError is yes
											callback "error has occured in insertAlbumsToDB",
										else callback null							
	# Insert new Artists 
	# Find the artist in DB
	#Parameters 
	#	artists:Array
	#	items:Array
	#	type="song"/"album"
	#	callback (_albums:Array)
	addArtistIds : (artists,items,type,callback)->
		@insertArtistsToDB artists,(err)=>
			if err then console.log err
			else 
				console.log "#{items.length} ArtistsIds have been inserted!"
				if items.length is 0 then callback null, []
				if type is "album"
					_albums = []
					count = 0
					for album in items
						do (album)=>
							@findArtist album.artist, (err,result)->
								count +=1
								if err then console.log err
								else
									_album = 
										title : album.title
										artist_id : result.id
										artist : album.artist
										created_at : album.created_at
										year : album.year
									_albums.push _album
								if count is items.length
									callback _albums
				if type is "song"
					_songs = []
					count = 0
					for song in items
						do (song)=>
							@findArtist song.artist, (err,result)->
								count +=1
								if err then console.log err
								else
									_song = 
										title : song.title
										artist_id : result.id
										artist : song.artist
										created_at : song.created_at
									_songs.push _song
								if count is items.length
									callback _songs


	# Find new artists and insert it into DB
	# Find new albums and insert it into DB
	# Assign artist id to correspondent song
	# Assign album id to correspondent song
	# callback (err:String,isDone:Boolean)
	insertNewArtistsAnNewAlbumsToDB : (artists,albums,callback)->
		@insertAlbumsToDB artists,albums,(err)=>
			if err then callback err + "in addArtistIdsAndAlbumIdsToNewSongs"
			else 
				callback null,yes
	#callback(err:String,result:object)
	findLastCreatedDate : (callback)->
		@connection.query "select max(created_at) as max from #{@table.Songs}", (err, result)->
			if err then callback err, null
			else 
				if result.length > 1 or result.length is 0 then callback "The returned value is invalid"
				else 
					if result.length is 1 
						if result[0].max
							callback null,result[0].max
						else callback "Max value can not be found!",null

module.exports = ObjectFinding
