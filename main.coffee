#!/usr/local/bin/coffee
readline = require 'readline'
colors = require './node_modules/colors'

mysqlConfig =
	user : 'root'
	password: 'root'
	database: 'anbinh'
	port: '8889'
	multipleStatements: true

rl = readline.createInterface
  input: process.stdin,
  output: process.stdout

class FunctionFactory
	constructor : (@className,@classRoot="./lib/",@mysqlConfig) ->
		@classPath = @classRoot + @className
		@methods = [""]
		classCreator = require @classPath
		@classInstance = new classCreator(@mysqlConfig)

	addMethod :  (methodObject)->
		@methods.push methodObject

	runWithRange : (callback) ->
		console.log "STEP 3:".inverse.blue + " " + "Enter range:".underline.blue
		console.log "Syntax is NUMBER+SPACE_KEY+NUMBER For instance:12323 12323".grey
		rl.question "Select range => ", (range) ->
			if range.search(/^\d+\s+\d+$/) is 0
				range0 = parseInt range.split(' ')[0]
				range1 = parseInt range.split(' ')[1]
				callback range0, range1
			else console.log "Wrong type".red

	runWithInput : (callback)->
		console.log "STEP 3:".inverse.blue + " " + "Enter input:".underline.blue
		rl.question " => ", (input) ->
			callback input

	logStartupInfo : ->
		console.log "Running with "+"#{@className}".inverse.green
		console.log ""
		info = ""
		isRangeContained = false
		for method,index in @methods
			if index > 0
				if method.rangeEnable is true
					isRangeContained  = true
					info +=  " " + " #{index} ".inverse.yellow + " #{method.info} ".inverse.blue + "(R)".inverse.red + "\t"
				else
					info +=  " " + " #{index} ".inverse.yellow +  " #{method.info} ".inverse.blue + "\t"
				if index%4 is 0 or index is @methods.length-1
					console.log info
					console.log ""
					info = ""
		if isRangeContained
			console.log "(R)".inverse.red + " means function is called with range"

	logErrorMessage : (str)->
		console.log "#{str}".red
		console.log "Enter site number:"

	executeMethodAtIndex : (index)->
		if index in ["q","quit","cancel","exit"]
			@logErrorMessage "Command has been dismissed!!!"
		else
			if index.match(/^[0-9]+$/g)
				if index > 0
					index = parseInt(index,10)
					if index in [1..@methods.length-1]
						if @methods[index].rangeEnable and @methods[index].rangeEnable is true
							@runWithRange @classInstance[@methods[index].name]
						else
							if @methods[index].inputEnable and @methods[index].inputEnable is true
								@runWithInput @classInstance[@methods[index].name]
							else @classInstance[@methods[index].name]()
					else @logErrorMessage "Index out out method range"
				else  @logErrorMessage "Zero index invalid"
			else @logErrorMessage "Index has to be number"

	run : (readline) ->
		@logStartupInfo()
		readline.question "Select method index => ", (answer) =>
			@executeMethodAtIndex(answer.trim())

Main =
	nhacso : ->
		func = new FunctionFactory("nhacso","./lib/",mysqlConfig)
		func.addMethod {name : "update", info : "Update albums, songs and videos"}
		func.addMethod {name : "updateSongs", info : "Update songs"}
		func.addMethod {name : "updateAlbums", info : "Update albums"}
		func.addMethod {name : "updateVideos", info : "Update videos"}
		func.addMethod {name : "updateSongWithRange", info : "Update songs with range", rangeEnable : true}
		func.addMethod {name : "updateSongsCategory", info : "update songs category"}
		func.addMethod {name : "updateAlbumsCategory", info : "update albums category"}
		func.addMethod {name : "updateVideos", info : "update videos"}	
		func.addMethod {name : "updateGenreAndLabel", info : "update genres and labels of new albums added today"}	
			
		func.run(rl)
	gomusic : ->
		func = new FunctionFactory("gomusic","./lib/",mysqlConfig)
		func.addMethod {name : "update", info : "Update albums, songs"}
		func.addMethod {name : "updateAlbums", info : "Update albums"}
		func.addMethod {name : "resetTables", info : "reset tables"}
		func.addMethod {name : "showStats", info : "show statistics"}
		
		func.run(rl)
	nhacvui : ->
		func = new FunctionFactory("nhacvui","./lib/",mysqlConfig)
		func.addMethod {name : "update", info : "Update albums & songs"}
		func.addMethod {name : "updateAlbums", info : "Update albums only"}
		func.addMethod {name : "fetchSongs", info : "Getting songs", rangeEnable : true}
		func.addMethod {name : "fetchAlbums", info : "Getting albums", rangeEnable : true}
		func.addMethod {name : "fetchAlbumName", info : "Getting albums name", rangeEnable : true}
		func.addMethod {name : "updateSongsStats", info : "Update songs' statistics"}
		func.addMethod {name : "showStats", info : "Show statistics"}
		func.addMethod {name : "updateArtistsDONW1", info : "asdfja sdlkfj ab asdfasd"}
		
		func.run(rl)
	keeng : ->
		func = new FunctionFactory("keeng","./lib/",mysqlConfig)
		func.addMethod {name : "update", info : "Update albums & songs"}
		func.addMethod {name : "updateVideos", info : "Update songs"}
		func.addMethod {name : "updateAlbumStats", info : "Update album plays, add lyrics, artists to songs"}
		func.addMethod {name : "fetchAlbums", info : "Getting albums", rangeEnable : true}
		func.addMethod {name : "fetchVideos", info : "Getting videos", rangeEnable : true}
		func.addMethod {name : "showStats", info : "Show statistics"}
		
		func.run(rl)
	chacha : ->
		func = new FunctionFactory("chacha","./lib/",mysqlConfig)
		func.addMethod {name : "update", info : "Update albums & songs"}
		func.addMethod {name : "updateAlbums", info : "Update albums"}
		func.addMethod {name : "fetchSongs", info : "Getting songs", rangeEnable : true}
		func.addMethod {name : "fetchAlbums", info : "Getting albums", rangeEnable : true}
		func.addMethod {name : "getSongsTopic", info : "Getting songs' topics"}
		func.addMethod {name : "showStats", info : "Show statistics"}
		func.addMethod {name : "updateAlbumsStats", info : "UPDATE ALBUMS PLAYS AND TOPICS"}
		func.run(rl)
	nghenhac : ->
		func = new FunctionFactory("nghenhac","./lib/",mysqlConfig)
		func.addMethod {name : "update", info : "Update albums & songs"}
		func.addMethod {name : "updateSongs", info : "Update songs"}
		func.addMethod {name : "updateAlbums", info : "Update albums"}
		func.addMethod {name : "fetchSongs", info : "Getting songs", rangeEnable : true}
		func.addMethod {name : "fetchAlbums", info : "Getting albums", rangeEnable : true}
		func.addMethod {name : "showStats", info : "Show statistics"}
		func.run(rl)
	mp3zing : ->
		func = new FunctionFactory("zing","./lib/",mysqlConfig)
		func.addMethod {name : "update", info : "Update albums, songs and videos"}
		func.addMethod {name : "updateSongs", info : "Update songs"}
		func.addMethod {name : "updateAlbums", info : "Update albums"}
		func.addMethod {name : "updateVideos", info : "Update videos"}
		func.addMethod {name : "updateSongsWithRange", info : "Update songs with range", rangeEnable : true}
		func.addMethod {name : "updateAlbumsWithRange", info : "Update albums with range", rangeEnable : true}
		func.addMethod {name : "updateVideosWithRange", info : "Update videos with range", rangeEnable : true}
		func.run(rl)
	nhaccuatui : ->
		func = new FunctionFactory("nhaccuatui","./lib/",mysqlConfig)
		func.addMethod {name : "update", info : "Update albums, songs and videos"}		
		# func.addMethod {name : "updateSongsPlays", info : "Update songs' plays"}
		# func.addMethod {name : "fetchArtist", info : "Fetching artists"}
		# func.addMethod {name : "getSongs", info : "Getting song"}
		# func.addMethod {name : "getSongsPlays", info : "Getting songs' plays"}
		# func.addMethod {name : "getAlbumsPlays", info : "Getting albums' plays"}
		func.addMethod {name : "updateAlbumsAndSongs", info : "Update albums and songs"}
		func.addMethod {name : "updateSongsByCategory", info : "Update songs by category"}
		func.addMethod {name : "updateVideosByCategory", info : "Update videos by category"}
		func.addMethod {name : "fetchSongWhereTitleIsNull", info : "fetchSongWhereTitleIsNull"}
		func.run(rl)
	musicvnn: ->
		func = new FunctionFactory("musicvnn","./lib/",mysqlConfig)
		func.addMethod {name : "fetchSongs", info : "Fetching songs"}
		func.addMethod {name : "showStats", info : "Show statistics"}
		func.run(rl)
	vietgiaitri : ->
		func = new FunctionFactory("vietgiaitri","./lib/",mysqlConfig)
		func.addMethod {name : "fetchSongs", info : "Fetching songs"}
		func.addMethod {name : "showStats", info : "Show statistics"}
		func.run(rl)
	chiasenhac : ->
		func = new FunctionFactory("chiasenhac","./lib/",mysqlConfig)
		func.addMethod {name : "updateSongs", info : "Update songs and albums"}
		func.addMethod {name : "updateAlbums", info : "Update albums"}
		# func.addMethod {name : "fetchSongs", info : "Getting songs", rangeEnable : true}
		# func.addMethod {name : "fetchSongsStats", info : "Getting songs' statistics"}
		func.addMethod {name : "showStats", info : "Show statistics"}
		# func.addMethod {name : "updateVideoLessthan10exp5", info : "xxxxx"}
		func.run(rl)
	songfreaks : ->
		func = new FunctionFactory("songfreaks","./lib/",mysqlConfig)
		func.addMethod {name : "updateSongs", info : "Update songs' lyrics"}
		func.addMethod {name : "fetchSongs", info : "Getting songs", rangeEnable : true}
		func.run(rl)
	lyricwiki : ->
		func = new FunctionFactory("lyricwiki","./lib/",mysqlConfig)
		func.addMethod {name : "updateLyrics", info : "Update songs' lyrics"}
		func.addMethod {name : "updateGraceNoteSongsLyrics", info : "Update gracenote lyrics"}
		# func.addMethod {name : "fetchSongs", info : "xxxxxx"}
		# func.addMethod {name : "updateSongsLyrics", info : "xxxxxx"}
		# func.addMethod {name : "updateGraceNoteSongsLyrics", info : "xxxxxx"}
		# func.addMethod {name : "fetchGenres", info : "xxxxxx"}
		# func.addMethod {name : "fetchAlbumsArtistsGenres", info : "xxxxxx"}
		func.run(rl)
	echonest : ->
		func = new FunctionFactory("echonest","./lib/",mysqlConfig)
		func.addMethod {name : "updateSongs", info : "Update songs"}
		func.addMethod {name : "testWithProxy", info : "http get with proxy"}
		# func.addMethod {name : "fetchArtists", info : "xxxxxx"}
		# func.addMethod {name : "fetchSongsFromArtists", info : "xxxxxx"}
		# func.addMethod {name : "fetchABunchOfArtistsInDB_first", info : "xxxxxx"}
		# func.addMethod {name : "downloadArtists", info : "xxxxxx"}
		# func.addMethod {name : "putArtistsFromDiskToDB", info : "xxxxxx"}
		# func.addMethod {name : "putSongsFromDiskToDB", info : "xxxxxx"}
		# func.addMethod {name : "downloadVideos", info : "xxxxxx"}
		# func.addMethod {name : "putVideosFromDiskToDB", info : "xxxxxx"}
		# func.addMethod {name : "downloadImages", info : "xxxxxx"}
		func.run(rl)
	zazoo : ->
		func = new FunctionFactory("zazoo","./lib/",mysqlConfig)
		func.addMethod {name : "getArtists", info : "Getting all artists"}
		func.addMethod {name : "getClipsOfAnArtist", info : "Getting metadata of video clips of an artist"}
		func.addMethod {name : "getLyrics", info : "Getting lyrics"}
		func.run(rl)
	deezer : ->
		func = new FunctionFactory("deezer","./lib/",mysqlConfig)
		func.addMethod {name : "getAlbums", info : "Getting albums"}
		func.addMethod {name : "getArtists", info : "Getting artists"}
		func.addMethod {name : "getGenres", info : "Getting genres"}
		func.run(rl)
	hdviet : ->
		func = new FunctionFactory("hdviet","./lib/movies/",mysqlConfig)
		func.addMethod {name : "test", info : "test"}
		func.run(rl)
	reporter : ->
		func = new FunctionFactory("reporter","./lib/",mysqlConfig)
		func.addMethod {name : "getSitesReporter", info : "Save updated sites reporter"}
		func.addMethod {name : "getTablesSchema", info : "Save tables schema"}
		func.run(rl)
	moving_site : ->
		func = new FunctionFactory("movingSite","./lib/",mysqlConfig)
		func.addMethod {name : "update", info : "UPDATE ALL (SONGS,ALBUMS,VIDEOS)"}
		func.addMethod {name : "createSongTablexxx", info : "create grand song table"}
		func.addMethod {name : "makeSitesJSON", info : "make sites JSON data"}
		func.addMethod {name : "createAlbumsTable", info : "create grand albums table"}
		func.addMethod {name : "createVideosTable", info : "create grand videos table"}
		func.run(rl)
	assisstant_funcs : ->
		func = new FunctionFactory("assisstantFuncs","./lib/misc/",mysqlConfig)
		func.addMethod {name : "getID", info : "get ID which is one of ns,zi,nct",inputEnable : true}
		func.addMethod {name : "searchES", info : "search term on ES",inputEnable : false}

		func.addMethod {name : "getAll", info : "get al ids of songs to test memory"}
		func.run(rl)
	allmusic : ->
		func = new FunctionFactory("allmusic","./lib/",mysqlConfig)
		func.addMethod {name : "getAlbums", info : "get album id"}
		func.addMethod {name : "getRatings", info : "get ratings"}
		func.addMethod {name : "getSimilars", info : "get similars"}
		func.addMethod {name : "getCredits", info : "get credits"}
		
		
		func.run(rl)
Main.execute = (site)->
	Main[site.toLowerCase()]()


# registerFuncs = ["","nhacso","gomusic","nhacvui","keeng","chacha","nghenhac","mp3zing","nhaccuatui","chiasenhac","vietgiaitri","musicvnn","songfreaks","lyricwiki","echonest","zazoo","deezer","getstats"]

registerFuncs = []
registerFuncs.push {name: "nhacso", activated : true}
registerFuncs.push {name: "gomusic", activated : true}
registerFuncs.push {name: "nhacvui", activated : true}
registerFuncs.push {name: "keeng", activated : true}
registerFuncs.push {name: "chacha", activated : true}
registerFuncs.push {name: "nghenhac", activated : true}
registerFuncs.push {name: "mp3zing", activated : true}
registerFuncs.push {name: "nhaccuatui", activated : true}
registerFuncs.push {name: "chiasenhac", activated : true}
registerFuncs.push {name: "vietgiaitri", activated : false}
registerFuncs.push {name: "musicvnn", activated : false}
registerFuncs.push {name: "songfreaks", activated : true}
registerFuncs.push {name: "echonest", activated : false}
registerFuncs.push {name: "lyricwiki", activated : true}
registerFuncs.push {name: "zazoo", activated : false}
registerFuncs.push {name: "deezer", activated : true}
registerFuncs.push {name: "assisstant_funcs", activated : true}
registerFuncs.push {name: "hdviet", activated : false}
registerFuncs.push {name: "reporter", activated : true}
registerFuncs.push {name: "moving_site", activated : true}
registerFuncs.push {name: "allmusic", activated : true}
activatedFuncs = [""]
disableFuncs = [""]

startingLog = ->
	console.log "STEP 1:".inverse.blue + " " + "Choose the following sites:\n".underline.blue
	info = ""

	show = (funcs, activated=true)->
		for func,index in funcs
			if index > 0
				if activated
					info +=  " " + " #{index} ".inverse.yellow + " #{func.name} ".inverse.cyan + "\t"
				else
					info +=  " " + "#{index}.".underline.grey + "#{func.name}".underline.grey + "\t"
				if index%9 is 0 or index is funcs.length-1
					console.log info
					console.log ""
					info = ""

	# only show the activated site
	
	registerFuncs.forEach (v)-> if v.activated then activatedFuncs.push v
	show(activatedFuncs,true)

	console.log "Disable sites:"
	registerFuncs.forEach (v)-> if  not v.activated then disableFuncs.push v
	show(disableFuncs,false)

	console.log "\tType 'q' to quit".white

rl.setPrompt('=>', 3)
startingLog()
rl.prompt()
rl.on("line", (line) ->
	index = line.trim()
	if index.match(/[0-9]+/)
		index = parseInt index,10
		if index in [1..activatedFuncs.length-1]
			Main.execute(activatedFuncs[index].name)
		else 
			console.log "Your index out of range"
	else
		if index in ["q","quit","exit"]
			rl.close()
		else
			console.log "You have to enter a number or character 'q' "

	rl.prompt()
).on "close", ->
  console.log ""
  console.log "YOU HAVE LOGGED OUT!".inverse.red
  process.exit 0







