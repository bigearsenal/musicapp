class Media 
	constructor : (@source)-> 
		# readline = require 'readline'
		# rl = readline.createInterface
		# 	input: process.stdin,
		# 	output: process.stdout
		# rl.setPrompt('', 0)
		# rl.prompt()
		@charm = require('../../node_modules/charm')()
		colors = require('../../node_modules/colors')
		@charm.pipe(process.stdout);
		keypress = require('../../node_modules/keypress')
		keypress(process.stdin)
		@_filteredMsg = ["Couldn't resolve name for AF_INET6","Requested audio codec","Audio device got stuck","MPlayer 1.1-4.2.1","Audio ","Cache","Resolving","Connecting","libavcodec","=====","Playing","Unsupported","Warning:","Failed to parse header","Server returned 404","Failed, exiting.","No stream found to handle url"]
		@checkStatusBar = true
		# play    = spawn("mplayer",["#{url}","-msgcolor","-msglevel","all=-1:statusline=6:cplayer=-1","-volume","100","-ss","20"])
		@totalLinesOfDisplayBarArea = 3
		@currentIndex = 0
		@isPlaylist = false
		@totalItemsInPlaylist = 0
	play : ->
		spawn = require('child_process').spawn
		if @source instanceof Array
			link = ""
			@totalItemsInPlaylist = @source.length
			@isPlaylist = true
			options = ["-slave","-quiet","-cache","8192","-cache-min","4"]
			for source in @source
				options.push source.link
			@player    = spawn("mplayer",options)
		else 
			@player    = spawn("mplayer",["-slave","-quiet","-cache","8192","-cache-min","4","#{@source.link}"])
		@player.isStopped = false
		@player.isPaused = false
		@player.pauseCount = 0
		@player.properties =
			length : 0
			position : 0
			percent : 0
			volume : 0
			bitrate : "N/A kbps"
			sample : "N/A"
			type : "audio"
			resolution : "N/A"
		@firstRun = true
		@player.stdout.on 'data', @processPlayerOutput
		@player.stderr.on 'data', @onErrorCallback
		@player.on 'close', @onCloseCallback
		setInterval(@getPlaybackInfo,300)
		process.stdin.on 'keypress', @setKeyCommands
	quit : ->
		if @player.isStopped is false
			@sendCommandToMPlayer("quit")
	
	onErrorCallback : (data)=>
		if data.toString().match(/Server returned 404: Not Found/)
			console.log "File not found"
			@quit()
			@player.stderr.on = ->
		
		unless @filterMessages(data.toString())
			console.log('Error: ' + data)
	onCloseCallback : (code) =>
		@player.isStopped = true
		@charm.up(@totalLinesOfDisplayBarArea-1).erase("line")
		@player.properties.percent = 100
		@drawStatusBar("done")
		process.stdin.removeListener 'keypress', @setKeyCommands
		@charm.left(100).erase("line").write("Song: #{@currentIndex} has been stopped with code #{code}\n")
		# play.stdin.pause()
		if @player and @player.stdin and @player.stdin.write
			@player.stdin.write = ->
	playNextStep : (step) ->
		if @isPlaylist
			@currentIndex +=step
			playNext = true
			if @currentIndex > @totalItemsInPlaylist-1
				@currentIndex = @totalItemsInPlaylist-1
				playNext = true
			else 
				if @currentIndex < 0
					@currentIndex = 0
					playNext = true
				else 
					if @currentIndex is @totalItemsInPlaylist
						playNext = false
						@charm.write("You have reached to the end of the playlist")
					else 
						if @currentIndex is 0
							playNext = false
							@charm.write("You have reached to the end of the playlist")

			if playNext				
				source = @source[@currentIndex]
				@charm.left(100).erase("line").write(" Playing next song - #{@currentIndex}: #{source.title} by #{source.artists.join("-")}")
				@charm.left(200)
				@sendCommandToMPlayer("pt_step #{step}")

					
		else @charm.write("No next item in the list")
	playNextItem : ->
		@playNextStep(1)
	playPreviousItem : ->
		@playNextStep(-1)
	bindingKey : (keyPresssed,bindedKey,command)->
		if keyPresssed and (keyPresssed.toString() is bindedKey or keyPresssed.name is bindedKey)
			if command instanceof Function is true
				command()
			else @sendCommandToMPlayer(command)
	sendCommandToMPlayer : (command)->
		@player.stdin.write(command+"\n")
	setKeyCommands : (chunk,key)=>
		@charm.left(100).erase("line")
		@bindingKey(chunk,"0","volume 100")
		@bindingKey(chunk,"9","volume -100")
		@bindingKey(key,"right","seek 10")
		@bindingKey(key,"left","seek -10")
		@bindingKey(key,"up","seek 60")
		@bindingKey(key,"down","seek -60")
		@bindingKey(chunk,"m","mute")
		@bindingKey(chunk,"q","quit")
		@bindingKey(chunk,"1","contrast 10")
		@bindingKey(chunk,"2","contrast -10")
		@bindingKey(chunk,"3","brightness 10")
		@bindingKey(chunk,"4","brightness -10")
		@bindingKey(chunk,"f","vo_fullscreen")
		if (chunk and chunk.toString() is "p") or (key and key.name is "space")
			@player.isPaused = not @player.isPaused

		if key and key.ctrl and key.name is "c"
			@quit()

		#load next item in playlist if available
		@bindingKey chunk,"n",=>
			@playNextItem()
		@bindingKey chunk,"b",=>
			@playPreviousItem()
		@bindingKey chunk,"j",=>
			@playNextStep(-10)
		@bindingKey chunk,"k",=>
			@playNextStep(10)
		# load new file
		@bindingKey chunk,"l",=>
			urls = []
			urls.push "http://st01.freesocialmusic.com/mp3/2011/08/06/1238057312/13126236515_1476.mp3"
			urls.push "http://mp3.zing.vn/xml/load-song/MjAxMCUyRjEwJTJGMDQlMkZiJTJGNSUyRmI1NDFkYTliZGJjMzFlNTY5YTBiYzVlMGM5OTYyMDYwLm1wMyU3QzI="
			urls.push "http://mp3.zing.vn/xml/load-song/MjAxMSUyRjAzJTJGMDglMkYzJTJGMCUyRjMwZGQzZTVlOWYxZTkzMjI5NWQ5YWYwZjI5Nzk3Yzg0Lm1wMyU3QzI="
			urls.push "http://data10.nghenhac.info/ah/ahha/d/de87409aa8100f2ecb95c2c57123ad5a.mp3"
			urls.push "http://music-hcm.24hstatic.com/uploadmusic2/746d93e8d9a5a3a5e04c04f5714cfd5b/5102f27c/uploadmusic/id_chan/Admin/Album/Tuan50-09/1/VA-Disney_Girlz_Rock_2-2008-C4/14-ashley_tisdale-fabulous.mp3"
			urls.push "http://music-hcm.24hstatic.com/uploadmusic2/e0618e51de26cb673072ee8419a37fb6/520155f7/uploadmusic/id_chan/Admin/Album/Tuan50-10/Mariah_Carey-The_Ballads-2008-MARiAH/Mariah_Carey-The_Ballads-2008-MARiAH/17-mariah_carey-endless_love_(with_luther_vandross).mp3"

			@sendCommandToMPlayer("loadfile #{urls[(Math.random()*6)|0]}\n")
	getMediaProperties : (output)->
		isPropertySet = false
		props = @player.properties
		if output.search("ANS_LENGTH") > -1
			props.length = parseInt(output.match("ANS_LENGTH=([0-9\.]+)")[1],10)
			isPropertySet = true
		if output.search("ANS_TIME_POSITION") > -1
			props.position = parseInt(output.match("ANS_TIME_POSITION=([0-9\.]+)")[1],10)
			isPropertySet = true
		if output.search("ANS_PERCENT_POSITION") > -1
			props.percent = output.match("ANS_PERCENT_POSITION=([0-9\.]+)")[1]
			isPropertySet = true
		if output.search("ANS_volume") > -1
			props.volume = parseInt(output.match("ANS_volume=([0-9]+)")[1],10)
			isPropertySet = true
		if output.search("ANS_AUDIO_BITRATE") > -1
			props.bitrate = output.match("ANS_AUDIO_BITRATE=\'(.+)\'")[1].replace(/kbps/,'').trim()
			isPropertySet = true
		if output.search("ANS_AUDIO_SAMPLES") > -1
			props.sample = output.match("ANS_AUDIO_SAMPLES=\'(.+)\'")[1].replace(/\s/g,'')
			isPropertySet = true
		if output.search("ANS_VIDEO_RESOLUTION") > -1
			resolution = output.match("ANS_VIDEO_RESOLUTION=\'(.+)\'")?[1]
			if resolution
				props.type = "video"
				props.resolution = resolution.replace(/\s/g,'')
			else props.type = "audio"
			isPropertySet = true
		if output.search("ANS_VIDEO_BITRATE") > -1
			vbitrate = output.match("ANS_VIDEO_BITRATE=\'(.+)\'")?[1]
			if vbitrate
				props.type = "video"
				props.vbitrate = vbitrate.replace(/kbps/,'').trim()
			else props.type = "audio"
			isPropertySet = true

		if isPropertySet then return true
		else  return false

	processPlayerOutput : (output)=>
		output = output.toString()
		if @getMediaProperties(output)
			@showStatusBar()
	getStatusLine : ->
		props = @player.properties
		if @player.isPaused and @player.pauseCount is 0
			ret = " ■ #{props.position}/#{props.length}s - #{props.percent}/100% - 🔊 :#{props.volume}/100"
		else 
			ret = " ▶ #{props.position}/#{props.length}s - #{props.percent}/100% - 🔊 :#{props.volume}/100"
		return ret
	filterMessages : (data)->
		for msg in @_filteredMsg
			pattern = new RegExp(msg,"gi")
			if data.match(pattern)
				return true
		return false
	formatTime : (totalSec)->
		min = totalSec/60|0
		if min.toString().length is 1
			min = "0" + min.toString()
		sec = totalSec%60
		if sec.toString().length is 1
			sec = "0" + sec.toString()
		if  parseInt(min,10) > 0
			return "#{min}:#{sec}"
		else return "00:#{sec}"
	drawStatusBar : (status) ->
		@barSize = 70
		props = @player.properties
		@current = parseInt(props.percent,10)
		@total = 100
		percent = @current 
		switch props.type
			when "audio"
				text = "[A] "
				text += "#{percent}% - #{@formatTime(props.position)}/#{@formatTime(props.length)} - Vol:#{props.volume} - [ab:#{props.bitrate}] - #{props.sample}"
			when "video" 
				text = "[V] "
				text += "#{percent}% - #{@formatTime(props.position)}/#{@formatTime(props.length)} - Vol:#{props.volume} - [ab:#{props.bitrate},vb:#{props.vbitrate}] - [#{props.resolution}]"
			else 
				text += " invalid type"
		len = text.length
		left = (@barSize - len) / 2 | 0
		right = ((@barSize - len) / 2 | 0) + (@barSize - len) % 2

		bar = Array(left + 1).join(" ") + text + Array(right + 1).join(" ")

		if status is "done"
				bar = bar.replace(/^\s\s\s\s/,'  ▶❚')
		else if status is "pause"
			bar = bar.replace(/^\s\s\s/,'  ■')
		else 
			if props.position%2 is 0
				bar = bar.replace(/^\s\s\s/,'  ▶')

		@charm.left(100).erase("line")
		@charm.foreground("black").background "green"
		i = 0

		while i < ((@current / @total) * @barSize) - 1
			@charm.write bar[i]
			i++
		@charm.foreground("black").background "white"
		while i < @barSize - 1
			@charm.write bar[i]
			i++
		@charm.display('reset').left(200).down(1).erase("line")
		if @isPlaylist
			source = @source[@currentIndex]
			@charm.write(" ♫ | #{@currentIndex}: #{source.title} by #{source.artists.join(" - ")} | #{source.site}.#{source.id}")
		else 
			@charm.write(" ♪ | #{@source.title} by #{@source.artists.join("-")} | #{@source.site}.#{@source.id}")
		@charm.left(200).down(1).erase("line")
	showStatusBar : (isStopped=false)->

		if isStopped
			@charm.up(@totalLinesOfDisplayBarArea-1)
			# @charm.left(100).write(@getStatusLine()).left(100).down(1).erase("line")
			@drawStatusBar("pause")
		else 
			if @firstRun is false then @charm.up(@totalLinesOfDisplayBarArea-1)
			else @firstRun = false
			@drawStatusBar("playing")
			# @charm.write(@getStatusLine()).write("            ").left(200).down(1).erase("line")
	getPlaybackInfo : =>
		if @player and @player.stdin
			if @player.isPaused  
				if @player.pauseCount is 0
					@sendCommandToMPlayer("pause")
					@showStatusBar(true)
					@player.pauseCount +=1
			else 
				@player.pauseCount = 0
				props = @player.properties
				@sendCommandToMPlayer("get_time_length")
				@sendCommandToMPlayer("get_time_pos")
				@sendCommandToMPlayer("get_percent_pos")
				@sendCommandToMPlayer("get_property volume")
				@sendCommandToMPlayer("get_audio_bitrate")
				@sendCommandToMPlayer("get_audio_samples")
				@sendCommandToMPlayer("get_video_resolution")
				@sendCommandToMPlayer("get_video_bitrate")

				
module.exports = Media
# url = "http://st01.freesocialmusic.com/mp3/2010/12/12/1012051944/129040114311_9875.mp3"
# # exec("mplayer -msgcolor -msglevel all=-1:statusline=6:cplayer=-1 -volume 100 #{url}", puts);



# media = new Media("http://st01.freesocialmusic.com/mp4/2011/12/19/1236052905/132428217222_1195.mp4")
# # media = new Media("http://st01.freesocialmusic.com/mp3/2010/12/12/1012051944/129040114311_9875.mp3")

# media.play()





