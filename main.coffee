#!/usr/local/bin/coffee
readline = require 'readline'
colors = require 'colors'

mysqlConfig = 
	user : 'root'
	password: 'root'
	database: 'anbinh'
	port: '8889'
	multipleStatements: true

rl = readline.createInterface
  input: process.stdin,
  output: process.stdout

runNhacso = ->
	Nhacso = require './lib/nhacso'
	console.log "Running with "+"nhacso.net".inverse.green
	testingConfig = 
		table :
			NSSongs : "ns_raw_songs"
			NSAlbums : "ns_raw_albums"
			NSSongs_Albums : "ns_raw_songs_albums"
			NSVideos : "ns_raw_videos"
		logPath : "./log/test_NSLog.txt"
	
	ns = new Nhacso(mysqlConfig)
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t" + "RESET_SOAL".inverse.red + "- reset songs and albums \t" + "RESET_VIDEO".inverse.red + "- reset video table "
	console.log "\t" + "stats".inverse.red + "- show stats \t"
	console.log "\t1.UPDATE ALBUMS, SONGS & VIDEOS\t2.updateSongsCategory\t"
	console.log "\t3.updateAlbumsCategory\t4.UPDATE VIDEOS ALONE"
	# console.log "\t5.fetchMaxTypeAlbum\t6............."

	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "RESET_SOAL" then ns.resetSongsAndAlbumsTable()
			when "RESET_VIDEO" then ns.resetVideosTable()
			when "stats" then ns.showStats()
			when "1" then ns.update()
			when "2" then ns.updateSongsCategory()
			when "3" then ns.updateAlbumsCategory()
			when "4" then ns.updateVideos()
			# when "4" then ns.fetchMaxTypeSong()
			# when "5" then ns.fetchMaxTypeAlbum()
			


			else console.log "Wrong type".red
runGomusic = ->
	Gomusic = require './lib/gomusic'
	console.log "Running with "+"music.go.vn".inverse.green
	gmTestingConfig = 
		table : 
			GMSongs : "gm_raw_songs"
			GMAlbums : "gm_raw_albums"
			GMSongs_Albums : "gm_raw_songs_albums"
		logPath : "./log/test_GMLog.txt"
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t1.update\t2.reset"
	console.log "\t3.show stats"
	gm = new Gomusic(mysqlConfig)
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "1" then gm.update()
			when "2" then gm.resetTables()
			when "3" then gm.showStats()
			# when "4" then gm.fetchAlbums 500000, 500110
			else console.log "Wrong type".red
runNhacvui = ->
	Nhacvui = require './lib/nhacvui'
	console.log "Running with "+"nhac.vui.vn".inverse.green
	nvTestingConfig = 
		table : 
			Songs : "nv_raw_songs"
			Albums : "nv_raw_albums"
			Songs_Albums : "nv_raw_songs_albums"
		logPath : "./log/test_NVLog.txt"
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t" + "CREATE".inverse.red + " tables\t" + "RESET".inverse.red + " tables "
	console.log "\t1.UPDATE SONGS & ALBUMS \t2.update albums"
	console.log "\t3.fetch songs\t4.fetch albums"
	console.log "\t5.fetch album's titles \t6.updateSongsStats"
	console.log "\t7.show stats"
	nv = new Nhacvui(mysqlConfig)
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "CREATE" then nv.createTables()
			when "RESET" then nv.resetTables()
			when "1" then nv.update()
			when "2" then nv.updateAlbums()
			when "3" then runWithRange(nv.fetchSongs)
			when "4" then runWithRange(nv.fetchAlbums)
			when "5" then runWithRange(nv.fetchAlbumName)
			when "6" then nv.updateSongsStats()
			when "7" then nv.showStats()
			# when "1" then nv.fetchSongs 23123, 23123
			else console.log "Wrong type".red
runKeeng = ->
	Keeng = require './lib/keeng'
	console.log "Running with "+"Keeng.vn".inverse.green
	keTestingConfig = 
		table : 
			Songs : "ke_raw_songs"
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t" + "CREATE".inverse.red + " tables\t" + "RESET".inverse.red + " tables "
	console.log "\t1.update albums+songs\t2.fetch albums+songs"
	console.log "\t3.show stats\t4.fetchVideos"
	console.log "\t5.updateVideos\t6.axxxxxxxxxx"
	ke = new Keeng(mysqlConfig)
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "CREATE" then ke.createTables()
			when "RESET" then ke.resetTables()
			when "1" then ke.update()
			when "2" then runWithRange(ke.fetchAlbums)
			when "3" then ke.showStats()
			when "4" then runWithRange ke.fetchVideos
			when "5" then ke.updateVideos()
			
			# when "1" then nv.fetchSongs 23123, 23123
			else console.log "Wrong type".red
runChacha = ->
	Chacha = require './lib/chacha'
	console.log "Running with "+"Chacha.vn".inverse.green
	ccTestingConfig = 
		table : 
			Songs : "cc_raw_songs"
			Albums : "cc_raw_albums"
		logPath : "./log/test_CCLog.txt"
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t" + "CREATE".inverse.red + " tables\t" + "RESET".inverse.red + " tables "
	console.log "\t1.UPDATE SONGS AND ALBUMS\t2.update albums"
	console.log "\t3.fetch songs\t4.fetch albums"
	console.log "\t5.show stats \t6.getSongsTopic"
	cc = new Chacha(mysqlConfig)
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "CREATE" then cc.createTables()
			when "RESET" then cc.resetTables()
			when "1" then cc.update()
			when "2" then cc.updateAlbums()
			when "3" then runWithRange(cc.fetchSongs)
			when "4" then runWithRange(cc.fetchAlbums)
			when "5" then cc.showStats()
			when "6" then cc.getSongsTopic()
			# when "1" then nv.fetchSongs 23123, 23123
			else console.log "Wrong type".red
runNghenhac = ->
	Nghenhac = require './lib/nghenhac'
	console.log "Running with "+"Nghenhac.info".inverse.green
	nnTestingConfig = 
		table : 
			Songs : "nn_raw_songs"
		logPath : "./log/test_NNLog.txt"
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t" + "CREATE".inverse.red + " tables\t" + "RESET".inverse.red + " tables "
	console.log "\t1.UPDATE SONGS AND ALBUMS \t2.fetch albums"
	console.log "\t3.fetch songs\t4.show stats"
	console.log "\t5.update songs\t6.update albums"
	nn = new Nghenhac(mysqlConfig)
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "CREATE" then nn.createTables()
			when "RESET" then nn.resetTables()
			when "1" then nn.update()
			when "2" then runWithRange(nn.fetchAlbums)
			when "3" then runWithRange(nn.fetchSongs)
			when "4" then nn.showStats()
			when "5" then nn.updateSongs()
			when "6" then nn.updateAlbums()
			else console.log "Wrong type".red
runZing = ->
	Zing = require './lib/zing'
	console.log "Running with "+"mp3.zing.vn".inverse.green
	nnTestingConfig = 
		table : 
			Songs : "zi_raw_songs"
		logPath : "./log/test_ZILog.txt"
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t" + "CREATE".inverse.red + " tables\t" + "RESET".inverse.red + " tables "

	console.log "\t1.UPDATE SONGS, ALBUMS & VIDEOS\t2.UPDATE ALBUMS"
	console.log "\t3.UPDATE VIDEOS\t4.UPDATE SONGS WITH RANGE"
	console.log "\t5.UPDATE ALBUMS WITH RANGE\t6.UPDATE VIDEOS WITH RANGE"

	zing = new Zing(mysqlConfig)
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "CREATE" then zing.createTables()
			when "RESET" then zing.resetTables()
			when "1" then zing.update()
			when "2" then zing.updateAlbums()
			when "3" then zing.updateVideos()
			when "4" then runWithRange zing.updateSongsWithRange
			when "5" then runWithRange zing.updateAlbumsWithRange
			when "6" then runWithRange zing.updateVideosWithRange

			
			

			else console.log "Wrong type".red
runNhaccuatui = ->
	Nhaccuatui = require './lib/nhaccuatui'
	console.log "Running with "+"nhaccuatui.com".inverse.green
	nnTestingConfig = 
		table : 
			Songs : "NCT_raw_songs"
		logPath : "./log/test_NCTLog.txt"
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t" + "CREATE".inverse.red + " tables\t" + "RESET".inverse.red + " tables "
	console.log "\t1.UPDATE SONGS & VIDEOS && ALBUMS\t2.updateSongsPlay"
	console.log "\t3.fetchArtist\t4.getSongs"
	console.log "\t5.getSongsPlays\t6.getAlbumsPlays"
	console.log "\t7.updateAlbumsAndSongs\t8.UPDATE SONG BY CATS"
	console.log "\t9.UPDATE VIDEOS BY CATS\t10.testing"
	
	nct = new Nhaccuatui(mysqlConfig)
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "CREATE" then nct.createTables()
			when "RESET" then nct.resetTables()
			when "1" then nct.update()
			when "2" then nct.updateSongsPlays()
			when "3" then nct.fetchArtist()
			when "4" then nct.getSongs()
			when "5" then nct.getSongsPlays()
			when "6" then nct.getAlbumsPlays()
			when "7" then nct.updateAlbumsAndSongs()
			when "8" then nct.updateSongsByCategory()
			when "9" then nct.updateVideosByCategory()
			when "10" then nct.testing()

			

			else console.log "Wrong type".red

runMusicVNN = ->
	MusicVNN = require './lib/musicvnn'
	console.log "Running with "+"musicvnn.vn".inverse.green
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t1.fetchSongs\t2.xxxxxxxxxxxx"
	console.log "\t3.show stats\t4.xxxxxxxxxxx"
	# console.log "\t5.updateVideos\t6.axxxxxxxxxx"
	musicvnn = new MusicVNN()
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "1" then musicvnn.fetchSongs()
			when "2" then runWithRange(musicvnn.xxxxx)
			when "3" then musicvnn.showStats()
			# when "4" then runWithRange musicvnn.fetchVideos
			# when "5" then musicvnn.updateVideos()
			
			# when "1" then nv.fetchSongs 23123, 23123
			else console.log "Wrong type".red
runVietGiaitri = ->
	VietGiaitri = require './lib/vietgiaitri'
	console.log "Running with "+"vietGiaitri.vn".inverse.green
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t1.fetchSongs\t2.xxxxxxxxxxxx"
	console.log "\t3.show stats\t4.xxxxxxxxxxx"
	# console.log "\t5.updateVideos\t6.axxxxxxxxxx"
	vietGiaitri = new VietGiaitri()
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "1" then vietGiaitri.fetchSongs()
			when "2" then runWithRange(vietGiaitri.xxxxx)
			when "3" then vietGiaitri.showStats()
			else console.log "Wrong type".red
runChiaSeNhac = ->
	ChiaSeNhac = require './lib/chiasenhac'
	console.log "Running with "+"Chiasenhac.vn".inverse.green
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t1.UPDATE SONGS & ALBUMS\t2.UPDATE ALBUMS"
	console.log "\t3.fetch Songs with range\t4.fetchSongsStats"
	console.log "\t5.show stats \t6.updateVideoLessthan10exp5"
	chiaSeNhac = new ChiaSeNhac()
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "1" then chiaSeNhac.updateSongs()
			when "2" then chiaSeNhac.updateAlbums()
			when "3" then runWithRange chiaSeNhac.fetchSongs
			when "4" then chiaSeNhac.fetchSongsStats()
			when "5" then chiaSeNhac.showStats()
			when "6" then chiaSeNhac.updateVideoLessthan10exp5()
			else console.log "Wrong type".red
runSongFreaks = ->
	SongFreaks = require './lib/songfreaks'
	console.log "Running with "+"songfreaks.com".inverse.green
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t1.XXXXXXXXXX \t2.fetchSongs"
	# console.log "\t3.fetch Songs with range\t4.fetchSongsStats"
	# console.log "\t5.show stats \t6.axxxxxxxxxx"
	songFreaks = new SongFreaks()
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "1" then songFreaks.updateSongs()
			when "2" then runWithRange songFreaks.fetchSongs
			
			else console.log "Wrong type".red

runLyricWiki = ->
	LyricWiki = require './lib/lyricwiki'
	console.log "Running with "+"LyricWiki.com".inverse.green
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t1.fetchSongs\t2.updateSongsLyrics"
	console.log "\t3.updateSongsMetrolyrics\t4.updateGraceNoteSongsLyrics"
	console.log "\t5.fetchGenres \t6.fetchAlbumsArtistsGenres"
	lyricWiki = new LyricWiki()
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "1" then lyricWiki.fetchSongs()
			when "2" then lyricWiki.updateSongsLyrics()
			when "3" then lyricWiki.updateSongsMetrolyrics()
			when "4" then lyricWiki.updateGraceNoteSongsLyrics()
			when "5" then lyricWiki.fetchGenres()
			when "6" then lyricWiki.fetchAlbumsArtistsGenres()
			else console.log "Wrong type".red
runStats = ->
	Stats = require './lib/stats'
	console.log "Running with "+"statistics".inverse.green
	console.log "STEP 2:".inverse.blue + " " + "Choose the type of command:".underline.blue
	console.log "\t1.fetchTable\t2.xxxxxxxxxxxx"
	console.log "\t3.show stats\t4.xxxxxxxxxxx"
	# console.log "\t5.updateVideos\t6.axxxxxxxxxx"
	stats = new Stats()
	rl.question "=> ", (answer) ->
		switch answer.trim()
			when "1" then stats.fetchTable()
			when "2" then runWithRange(stats.xxxxx)
			when "3" then stats.showStats()
			else console.log "Wrong type".red
runWithRange = (callback) ->
	console.log "STEP 3:".inverse.blue + " " + "Enter range:".underline.blue
	console.log "Syntax is NUMBER+SPACE_KEY+NUMBER For instance:12323 12323".grey
	rl.question "=> ", (range) ->
		if range.search(/^\d+\s+\d+$/) is 0 
			range0 = parseInt range.split(' ')[0]
			range1 = parseInt range.split(' ')[1]
			callback range0, range1
		else console.log "Wrong type".red

startingLog = ->
	console.log "STEP 1:".inverse.blue + " " + "Choose the following sites:\n".underline.blue
	console.log "        "+ "1.nhacso.net".inverse.green + "\t" + "2.music.go.vn".inverse.green + "\t" + 
				"3.nhac.vui.vn".inverse.green + "\t" + "4.keeng.vn".inverse.green  
	console.log ""
	console.log	"        "+ "5.chacha.vn".inverse.green + "\t" + "6.nghenhac.info".inverse.green+ "\t" + "7.mp3.zing.vn".inverse.green + "\t" + 
				"8.nhaccuatui.com".inverse.green
	console.log ""
	console.log	"        "+ "9.chiasenhac".inverse.green + "\t"+ "10.vietgiaitri".inverse.green+ "\t" + "11.music.vnn.vn".inverse.green
	console.log ""
	console.log	"        "+"12.songfreaks".inverse.green + "\t"+ "13.lyrics.wikia.com".inverse.green+ "\t"+  "14.STATISTICS".inverse.green 
	console.log "        Type 'q' to quit".grey

rl.setPrompt('=>', 3)
startingLog()
rl.prompt()
rl.on("line", (line) ->
	switch line.trim()
		when "1" then runNhacso()
		when "2" then runGomusic()
		when "3" then runNhacvui()
		when "4" then runKeeng()
		when "5" then runChacha()
		when "6" then runNghenhac()
		when "7" then runZing()
		when "8" then runNhaccuatui()
		when "9" then runChiaSeNhac()
		when "10" then runVietGiaitri()
		when "11" then runMusicVNN()
		when "12" then runSongFreaks()
		when "13" then runLyricWiki()
		when "14" then runStats()
		when "q"
			rl.close()
		else startingLog()
	rl.prompt()
).on "close", ->
  console.log ""
  console.log "YOU HAVE LOGGED OUT!".inverse.red
  process.exit 0






  