Site = require "./Site"


class Nhacso extends Site
      constructor: ->
        super "CSN"
        @logPath = "./log/CSNLog.txt"
        @log = {}
        @_readLog()

      _getFieldFromTable : (params, callback)->
            _q = "Select #{params.sourceField} from #{params.table}"
            _q += " WHERE #{params.condition} LIMIT #{params.limit}" if params.limit
            @connection.query _q, (err, results)=>
                  callback results
      processSong : (data,options)=>
            song = 
                  id : options.id
                  title : ""
                  artists : ""
                  topic : ""
                  downloads : 0
                  formats : []
                  file_href : ""
                  is_lyric : ""
                  date_created : "0000-00-00"
                  # lyric : ""  // it is omitted 
            temp = data.match(/plt-text.+Download: <a href=\"(.+html)\">(.+) - (.+)<\/a><\/div>/)
            if temp
                  song.file_href = "http://chiasenhac.com/" + temp[1]
                  song.title = @processStringorArray temp[2]
                  song.artists = @processStringorArray temp[3].split(';').map (v)-> v.trim()
                  temp = temp[0].replace(/\-&gt; Download.+$/,'')
                  temp = temp.split(/\-&gt;/).map (v)-> v.replace(/<\/a>/,'').replace(/^.+>/,'').replace(/\.\.\./,'').trim()
                  _t = []
                  temp.forEach (v,index)->  if index > 0 then v.split(/,/).forEach (v1)-> _t.push v1.trim() else _t.push v
                  _t = _t.map (v)-> v.replace(v[0],v[0].toUpperCase())
                  song.topic = JSON.stringify _t

            downloads = data.match(/<a href=\"http:\/\/download.+\"([0-9]+) downloads/)
            if downloads then song.downloads = parseInt downloads[1],10

            # this part for the diffrent kinds of formats and links
            formats = data.match(/<a href.+Link Download.+/g)
            mobileLink = data.match(/<a href.+Mobile Download.+/g)
            if not formats and mobileLink then  formats = mobileLink
            else if formats and mobileLink then  formats = mobileLink.concat(formats)
            # console.log formats
            if formats
                  formats = formats.map (v)-> 
                          _t = v.match(/<a href=\"(.+)" onmouseover.+Link Download \d: ([a-zA-Z0-9]+) .+>(.+)<\/span> (.+) MB/)
                          if not _t then _t = v.match(/<a href=\"(.+)" onmouseover.+Link Download \d: ([a-zA-Z0-9]+) .+>(Lossless).+> (.+) MB/)
                          if not _t then _t = v.match(/<a href=\"(.+)" onmouseover.+Mobile Download: ([a-zA-Z0-9]+) (.+) (.+) MB/)
                          if not _t then _t = v.match(/<a href=\"(.+)" onmouseover.+Link Download.+: ([a-zA-Z0-9]+) (\d+kbps) (.+) MB/)
                          
                          # console.log v + "-------"
                          if _t
                                _format = 
                                      link : _t[1].replace(/(http.+\/).+(\..+$)/,"$1file-name$2")
                                      type : _t[2].toLowerCase()
                                      file_size : parseFloat(_t[4])*1024|0
                                if song.topic.search('Video Clip') > -1
                                      _format.resolution = _t[3].toLowerCase()
                                else _format.bitrate = _t[3].toLowerCase()
                                return _format
                          else return null
                  # eleminate the null value
                  formats = formats.filter (v)-> if v isnt null then return true else false
                  
                  # replace the link 500kps and lossless with available link,  apply for registered user only
                  # and reduce the link length
                  song.formats = JSON.stringify formats.map (v)-> 
                        if v
                                if v.bitrate is '500kbps'
                                      _temp = "/" + formats[1].bitrate.replace(/kbps/,"") + "/"
                                      v.link = formats[1].link.replace(_temp,'/m4a/').replace(/\.mp3/,'.m4a')
                                if v.bitrate is 'lossless'
                                      _temp = "/" + formats[1].bitrate.replace(/kbps/,"") + "/"
                                      v.link = formats[1].link.replace(_temp,'/flac/').replace(/\.mp3/,'.flac')
                                if v.resolution is "hd 720p"
                                      v.link = formats[1].link.replace(/\/\d{3}\//,'/m4a/').replace(/\.mp3/,'.mp4')
                                if v.resolution is "hd 1080p"
                                      v.link = formats[1].link.replace(/\/\d{3}\//,'/flac/').replace(/\.mp3/,'.mp4')
                        return v

            isLyric = data.match(/(<span class=\"genmed\"><b>.+\s+<span class=\"gen\">).+/)
            if isLyric
                  song.is_lyric = 1
            else song.is_lyric = 0

            dateCreated = data.match(/Upload at (.+)\"/)
            if dateCreated then song.date_created = dateCreated[1].replace(/(\d+)\/(\d+)\/(\d+) (\d+):(\d+)/,'$3-$2-$1 $4:$5')

            if song.title is "" and song.artists is "" and song.formats.length is 0
                  song = null
            
            @eventEmitter.emit "result-song", song
            
            song
      onSongFail : (error, options)=>
          # console.log "Song #{options.id} has an error: #{error}"
          @stats.totalItemCount +=1
          @stats.failedItemCount +=1
          @utils.printRunning @stats
      _getSong : (id)=>
            link = "http://download.chiasenhac.com/download.php?m=#{id}"
            options = 
              id : id
            @getFileByHTTP link, @processSong, @onSongFail, options
      fetchSongs : (range0, range1) =>
            @connect()
            @showStartupMessage "Updating songs to table", @table.Songs
            console.log " |Getting songs from range: #{range0} - #{range1}"
            @stats.currentTable = @table.Songs
            # [range0,range1]=[1030109,1030109]
            @stats.totalItems = range1-range0+1
            @eventEmitter.on "result-song", (song)=>
                    @stats.totalItemCount +=1
                    @stats.passedItemCount +=1
                    # @log.lastSongId = song.songid
                    # @temp.totalFail = 0
                    if song isnt null
                          # console.log song
                          @connection.query @query._insertIntoSongs, song, (err)->
                            if err then console.log "Cannt insert song: #{song.id} into database. ERROR: #{err}"
                    else 
                          @stats.passedItemCount -=1
                          @stats.failedItemCount +=1
                    @utils.printRunning @stats
            
            for id in [range0..range1]
                do (id)=>
                    @_getSong id

      # get song stats : album' name, album link, lyric
      processSongStats : (data, options) =>
            song =
                  id : options.id 
                  author : ""
                  album_title : ""
                  album_link : ""
                  album_coverart : ""
                  producer : ""
                  plays : 0
                  date_released : ""
                  lyric : ""


            author = data.match(/>Sáng tác:.+/)?[0]
            if author
                  song.author = @processStringorArray JSON.stringify author.split('>;').map (v)-> v.replace(/<\/a><\/b>.+$/,'').replace(/^.+>/,'').replace(/<\/a.+$|<\/a/,'')

            album = data.match(/>Album:.+/)?[0]
            if album 
                  song.album_title = @processStringorArray album.replace(/<\/a>.+$/,'').replace(/^.+>/,'')
                  song.album_link = album.replace(/^.+<a href=\"/,'').replace(/html.+$/,'html')

            coverart  = data.match(/id=\"fulllyric\".+\s+.+<img src=\"(http.+)\" width/)?[1]
            if coverart then song.album_coverart = coverart

            producer = data.match(/Sản xuất:.+/)?[0]
            if producer then song.producer = @processStringorArray producer.replace(/<\/b>.+$/,'').replace(/^.+<b>/,'').replace(/<a href=.+\">/,'').replace(/<\/a>/,'').trim()

            plays = data.match(/<img.+title=\"([0-9\.]+) listen\"/)?[1]
            if plays then song.plays = parseInt plays.replace(/\./g,''),10

            dateReleased = data.match(/Năm phát hành.+<b>(.+)<\/b>/)
            if dateReleased  then song.date_released = dateReleased[1]
            else if song.producer.search(/[0-9]{4}/) > -1 then song.date_released = song.producer.match(/[0-9]{4}/)?[0]

            lyric = data.match(/<p class=\"genmed\"[^]+id=\"morelyric\"/)?[0]
            if lyric then song.lyric = @processStringorArray lyric.replace(/<\/div>[^]+$/,'').replace(/^.+\">/,'')
                                                        .replace(/<span style=\".+com<\/span>/,'')
                                                        .replace(/(on)? ChiaSeNhac.com/g,'').replace(/<\/span>|<\/p>/,'')

            @eventEmitter.emit "result-song-stats", song
            song
      _getSongStat : ->
            params = 
                  sourceField : "id, file_href"
                  table : @table.Songs
                  limit : 10000
                  condition : " plays is null "
            @stats.totalItems = params.limit
            @_getFieldFromTable params, (songs)=>
                  # songs = [{id : 2, file_href : 'http://chiasenhac.com/mp3/vietnam/v-pop/ngay-xua-anh-hoi~minh-tuyet~2.html'}]
                  for song in songs
                        link = song.file_href
                        options = 
                              id : song.id
                        @getFileByHTTP link, @processSongStats, @onSongFail, options
      fetchSongsStats : ->
            @connect()
            @showStartupMessage "Updating songs stats to table", @table.Songs
            @stats.currentTable = @table.Songs
            @globalCount = 0
            @eventEmitter.on "result-song-stats", (song)=>
                        @stats.totalItemCount +=1
                        @stats.passedItemCount +=1
                        @stats.currentId = song.id
                        if song isnt null
                                  _u = " update #{@table.Songs} SET "
                                  _u += " author= #{@connection.escape song.author}, "
                                  _u += " album_title=#{@connection.escape song.album_title}, "
                                  _u += " album_link=#{@connection.escape song.album_link}, "
                                  _u += " album_coverart=#{@connection.escape song.album_coverart}, "
                                  _u += " producer=#{@connection.escape song.producer}, "
                                  _u += " plays=#{song.plays}, "
                                  _u += " date_released=#{@connection.escape song.date_released}, "
                                  _u += " lyric=#{@connection.escape song.lyric} "
                                  _u += " WHERE id=#{song.id} "
                                  @connection.query _u,(err)->
                                        if err then console.log " Cannot update song #{song.id}. ERROR: #{err}"
                        else 
                              @stats.passedItemCount -=1
                              @stats.failedItemCount +=1
                        @utils.printRunning @stats
                        if @stats.totalItemCount is @stats.totalItems
                              @utils.printFinalResult @stats
                              @globalCount +=1
                              console.log "GOING TO NEXT STEP: #{@globalCount}".inverse.red
                              @resetStats()
                              @_getSongStat()


            @_getSongStat()

      showStats : ->
        @_printTableStats NS_CONFIG.table


module.exports = Nhacso
