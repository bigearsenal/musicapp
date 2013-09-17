Site = require "./Site"
http = require 'http'
http.globalAgent.maxSockets = 100
class SongFreaks extends Site
      constructor: ->
        super "sf"
        @logPath = "./log/SFLog.txt"
        @log = {}
        @_readLog()

      _getFieldFromTable : (params, callback)->
            _q = "Select #{params.sourceField} from #{params.table}"
            _q += " WHERE #{params.condition} LIMIT #{params.limit}" if params.limit
            @connection.query _q, (err, results)=>
                  callback results

      getFileByHTTPForward : (link, onSucess, onFail, options) ->
            # console.log link
            http.get link, (res) =>
                        res.setEncoding 'utf8'
                        data = ''
                        # onSucess res.headers.location
                        if res.headers.location
                              @getFileByHTTPForward res.headers.location,onSucess,onFail,options
                        else 
                              if res.statusCode isnt 404
                                    res.on 'data', (chunk) =>
                                          data += chunk;
                                    res.on 'end', () =>
                                          onSucess data, options
                              else onFail("The link is temporary moved: #{res.statusCode} #{JSON.stringify res.headers}",options)
                  .on 'error', (e) =>
                        onFail  "Cannot get file from server. ERROR: " + e.message, options
      # Turn "AN BINH" into "An Binh"
      formatProperName : (str)->
            return str.split(' ').map((v)-> v.split('').map((v,i)-> if i>0 then v.toLowerCase() else v).join('')).join(' ')          
      processSongAtSongFreaksSite : (data,options)=>
            song = 
                  id : options.id
                  title : ""
                  artistids : []
                  artists : null
                  albumid : 0
                  album : ""
                  lyric : ""
                  writers : ""
                  copyright : ""
                  

            title  = data.match(/<meta property=\"og:title\".+content=\"(.+)\" /)?[1]
            if title then song.title = @processStringorArray title

            artists = data.match(/By:[^]+From the album/)?[0]
            if artists  
                  song.artists = artists.split(',').map (v)=> @processStringorArray v.replace(/<\/a>[^]+$/,'').replace(/^[^]+>/,'').trim()
                  # artistids = artists.split(',').map (v)-> v.match(/<a href=\".+\/([0-9]+)\"/)?[1]
                  # if artistids then song.artistids = artistids.map (v)-> parseInt v,10

            album = data.match(/From the album:[^]+content-info/)?[0]
            if album
                  song.album = @processStringorArray album.replace(/<\/a>[^]+$/,'').replace(/^[^]+>/,'').trim()
                  # albumid = album.match(/<a href=\".+\/([0-9]+)\"/)?[1]
                  # if albumid then song.albumid = parseInt albumid,10
            
            lyric = data.match(/lyrics SCREENONLY\">\s+[^]+<p class=\"lyrics PRINTONLY\">/)?[0]
            if lyric then song.lyric = @processStringorArray lyric.replace(/lyrics SCREENONLY\">/,'')
                                                                                            .replace(/<p class=\"lyrics PRINTONLY\">/,'')
                                                                                            .replace(/<\/p><br \/>/,'').trim()
            
            writers = data.match(/lyricWriters\">\s+(.+)/)?[1]
            if writers then song.writers =  @processStringorArray writers.replace(/Writer\(s\):/,'').trim().split(',').map (v)=> @formatProperName v.trim()

            copyright = data.match(/lyricCopyright\">\s+(.+)/)?[1]
            if copyright then song.copyright = @processStringorArray(copyright.replace(/Copyright:/,'').trim()).replace(/Lyrics ©/,'').trim()

            if song.lyric is "" then song = null

            options.site = "songfreaks"
            @eventEmitter.emit "result-song", song, options
            
            song
      processSongAtLyricsOverLoadSite : (data,options)=>
            song = 
                  id : options.id
                  title : ""
                  artist_ids : ""
                  artists : ""
                  album_id : 0
                  album : ""
                  lyric : ""
                  writers : ""
                  copyright : ""
                  
            title = data.match(/artistName.+\">(.+)<\/span>/)?[1]
            if title then song.title = @processStringorArray title

            artists = data.match(/Performed By:<\/h2>[^]+Albums:/)?[0]
            if artists
                  song.artists =  @processStringorArray artists.split(',').map (v)-> v.replace(/<\/a>[^]+$|<\/a>$/,'').replace(/^[^]+>/,'')
                  artist_ids = artists.split(',').map (v)-> v.match(/class=.+\/([0-9]+)\"/)?[1]
                  if artist_ids  then song.artist_ids = JSON.stringify artist_ids.map (v)-> parseInt v,10

            album = data.match(/Albums:<\/h2>\s+(.+)/)?[1]
            if album 
                  song.album =  @processStringorArray album.replace(/<br.+$/,'').replace(/^.+>/,'')
                  album_id = album.match(/class=.+\/([0-9]+)\"/)?[1]
                  if album_id  then song.album_id = parseInt album_id,10

            lyric = data.match(/<p class=\"lyrics\">([^]+)lyricsDisplay/)?[1]
            if lyric then song.lyric =  @processStringorArray lyric.replace(/<\/p>\n\t\t<\/div>[^]+$/,'')

            writers = data.match(/Writer\(s\):(.+)<\/p>/)?[1]
            if writers then song.writers = @processStringorArray writers.split(',').map (v)=> @formatProperName v

            copyright = data.match(/Copyright:(.+)<\/p>/)?[1]
            if copyright then song.copyright = @processStringorArray(copyright).replace(/Lyrics ©/,'').trim()

            if song.lyric is "" then song = null

            options.site = "lyricsoverload"
            @eventEmitter.emit "result-song", song, options
            
            song
      onSongFail : (error, options)=>
            # console.log "Song #{options.id} has an error: #{error}"
            @stats.totalItemCount +=1
            @stats.failedItemCount +=1
            @utils.printRunning @stats

            if @stats.totalItems is @stats.totalItemCount
                  @utils.printFinalResult @stats
                  if @temp.currentStep < @temp.nSteps
                      console.log "NEXT STEP #{@temp.currentStep+1}".inverse.red
                      @resetStats()
                      @_getSongs @temp.currentStep+1
                  else console.log "DONE!!!!!!!!!!!!".inverse.green

      _getSongs : (step)=>
            
            first = @temp.firstRange+(step-1)*@temp.nNum
            last = @temp.firstRange+(step*@temp.nNum)-1
            @temp.currentStep = step
            @stats.currentTable = @table.Songs
            @stats.totalItems = (last-first+1)/1
            console.log "CURRENT STEP #{@temp.currentStep} (#{first}->#{last})".inverse.red
            for id in [first..last] by 1
                  do (id)=>
                        options = 
                              id : id
                        # if (Math.random()*2|0) is 0
                        # console.log "run with song freaks"
                        link = "http://www.songfreaks.com/joke-link/lyrics/joke-link/#{id}"
                        @getFileByHTTPForward link, @processSongAtSongFreaksSite, @onSongFail, options
                        # else 
                        #       # console.log "run with lyric over load"
                        #       link = "http://www.lyricsoverload.com/lyrics/joke-link/#{id}"
                        #       @getFileByHTTP link, @processSongAtLyricsOverLoadSite, @onSongFail, options      
      fetchSongs : (range0, range1) =>
            @connect()
            @showStartupMessage "Updating songs to table", @table.Songs
            console.log " |Getting songs from range: #{range0} - #{range1}"
            
            # [range0,range1]=[1,100]
            
            totalItems = range1-range0+1
            @temp = 
                  nNum : 1000
            if (totalItems%@temp.nNum is 0)
                  nSteps  = totalItems/@temp.nNum
            else nSteps = (totalItems/@temp.nNum|0)+1
            
            @temp.nSteps = nSteps
            @temp.currentStep = 1
            @temp.firstRange = range0
            
            console.log " |Total steps: #{@temp.nSteps}. Each step has #{@temp.nNum} items. Total items: #{totalItems}"

            @eventEmitter.on "result-song", (song, options)=>
                  @stats.totalItemCount +=1
                  @stats.passedItemCount +=1
                  @stats.currentId  = options.id
                  # @log.lastSongId = song.songid
                  # @temp.totalFail = 0
                  # console.log song
                  # process.exit 0
                  if song isnt null
                        # console.log song
                        @connection.query @query._insertIntoSongs, song, (err)->
                              if err   
                                    console.log "Cannt insert song: #{song.id}. SITE: #{options.site} into database. ERROR: #{err}"
                                    console.log ""
                                    console.log ""
                  else 
                        @stats.passedItemCount -=1
                        @stats.failedItemCount +=1
                  @utils.printRunning @stats

                  if @stats.totalItems is @stats.totalItemCount
                        @utils.printFinalResult @stats
                        if @temp.currentStep < @temp.nSteps
                            @resetStats()
                            @_getSongs @temp.currentStep+1
                        else console.log "DONE!!!!!!!!!!!!".inverse.green

            @_getSongs 1



      showStats : ->
        @_printTableStats @table


module.exports = SongFreaks





