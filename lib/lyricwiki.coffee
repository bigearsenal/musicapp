Site = require "./Site"
http = require 'http'
url = require('url')
zlib = require('zlib')



class SongFreaks extends Site
      constructor: ->
        super "LW"
        @logPath = "./log/LWLog.txt"
        @table.Artists = "LWArtists"
        @log = {}
        @_readLog()

      _getFieldFromTable : (params, callback)->
            _q = "Select #{params.sourceField} from #{params.table}"
            _q += " WHERE #{params.condition} LIMIT #{params.skip},#{params.limit}" if params.limit
            # console.log _q
            @connection.query _q, (err, results)=>
                  callback results    
      getGzipped : (link, onSucess, onFail, options) ->
            headers =
                  'Accept-Encoding': 'gzip'
            params = 
                  'host' : url.parse(link).host
                  'path' : url.parse(link).path
                  'method' : "GET"
                  'headers': headers
            # console.log params
            buffer = []
            http.get(params, (res) ->
                  gunzip = zlib.createGunzip()
                  res.pipe gunzip
                  gunzip.on("data", (data) ->
                    buffer.push data.toString()
                  ).on("end", ->
                        # console.log buffer.join("")
                        onSucess buffer.join(""),options
                  ).on "error", (e) ->
                    onFail e,options
            ).on "error", (e) ->
             onFail e,options  
      processSong: (data,options)=>
            try 

                  song = JSON.parse data
                  if song.albums.length is 0
                        # console.log "--#{options.name}-- has no album".red
                        @onSongFail "no album", options
                  else 
                        @eventEmitter.emit "result-song", song, options

                  return song
            catch error
                  console.log "ERROR : at link #{options.name}. ---> #{error}"
      onSongFail : (error, options)=>
            # console.log "err --#{options.name}-- has an error: #{error}"
            @stats.totalItemCount +=1
            @stats.failedItemCount +=1
            @stats.currentId  = options.id
            @utils.printRunning @stats
            if @stats.totalItems is @stats.totalItemCount
                  @utils.printFinalResult @stats
                  @count +=1
                  console.log " |GET NEXT STEP :#{@count}".inverse.red
                  @resetStats()
                  @_getSongsLyrics()
      _getSong : (artist)=>
            options = 
                  id : artist.id
                  name : artist.name
            link = "http://lyrics.wikia.com/api.php?artist=#{encodeURIComponent artist.name}&fmt=json"
            # console.log "#{link}".inverse.red
            @getFileByHTTP link, @processSong, @onSongFail, options      
      fetchSongs : ->
            @connect()
            @showStartupMessage "Fetching songs to table", @table.Songs
            @albumId = 0

            @eventEmitter.on "result-song", (song, options)=>
                  @stats.totalItemCount +=1
                  @stats.passedItemCount +=1
                  @stats.currentId  = options.id
                  # @log.lastSongId = song.songid
                  # @temp.totalFail = 0
                  if song isnt null
                        artist = song.artist
                        count = 0
                        for album in song.albums
                              do (album)=>
                                    @albumId += 1
                                   for recording in album.songs
                                          _song = 
                                                title : recording
                                                artist_id : options.id
                                                artist : artist
                                                album : album.album
                                                album_id : @albumId
                                          _song.year = album.year if album.year
                                          count +=1
                                          @connection.query @query._insertIntoSongs, _song, (err)->
                                                if err  then console.log "Cannt insert song: #{song.id}. SITE: #{options.site} into database. ERROR: #{err}"
                        
                  else 
                        @stats.passedItemCount -=1
                        @stats.failedItemCount +=1
                  @utils.printRunning @stats

                  if @stats.totalItems is @stats.totalItemCount
                        @utils.printFinalResult @stats
            

            params =
                  sourceField : "#{@table.Artists}.name"
                  table : @table.Artists
                  limit : 70000
                  condition : " id > 0 "

            params =
                  sourceField : "anbinh.name"
                  table : "anbinh"
                  limit : 70000
                  condition : " id > 0 "
            
            @_getFieldFromTable params, (artists)=>
                  @stats.totalItems = artists.length
                  console.log " |# of items : #{@stats.totalItems}"
                  for artist in artists
                        # console.log artist
                        @_getSong artist

      # THIS PART FOR UPDATEING LYRIC 
      processSongLyric: (data,options)=>
            try 

                  song = 
                        id : options.id
                        title : options.title
                        artist : options.artist
                        lyric : ""
                        download_done : 1

                  if data.match(/class='lyricbox'.+Instrumental.+TrebleClef/)
                        song.lyric = "Instrumental"
                  
                  lyric = data.match(/class='lyricbox'.+<\/a><\/div>(.+)<\!--/)?[1]

                  if lyric 
                        song.lyric = @processStringorArray lyric

                  musicbrainzLink = data.match(/http:\/\/musicbrainz.+html/)?[0]
                  if musicbrainzLink then song.musicbrainz_link  = musicbrainzLink

                  allmusicLink  = data.match(/http:\/\/www\.allmusic\.com.+/)?[0]
                  if allmusicLink then song.allmusic_link = allmusicLink.replace(/".+$/,'')

                  youtubeLink = data.match(/http:\/\/youtube\.com.+/)?[0]
                  if youtubeLink then song.youtube_link = youtubeLink.replace(/".+$/,'')

                  isGracenote = data.match(/View the Gracenote/)?[0]
                  if isGracenote then song.isGracenote = 1

                  if song.lyric is "" then song.download_done = 0

                  @eventEmitter.emit "result-song", song, options

                  return song
            catch error
                console.log "ERROR : at link #{options.name}. ---> #{error}"
      _getSongsLyrics : (artist)=>
            params =
                  sourceField : "id, #{@table.Songs}.title,#{@table.Songs}.artist"
                  table : @table.Songs
                  limit : @temp.nItems
                  skip : @temp.nItemsSkipped
                  condition : " download_done is null"
            
            # console.log params
            @_getFieldFromTable params, (songs)=>

                  # FOR TESTING
                  # songs = [{id : 123, artist : "He Said", title : "Halfway House"}]
                  # test = {id : 123, artist : "Justin bieber", title : "never say never"}
                  # songs.push test

                  @stats.totalItems = songs.length
                  @stats.currentTable = @table.Songs
                  console.log " |# of items : #{@stats.totalItems}"
                  console.log " |Getting from range: #{songs[0].id} ---> #{songs[songs.length-1].id}"
                  for song in songs
                        # console.log song
                        options = 
                             id : song.id
                             title : song.title
                             artist : song.artist

                        uri = song.artist.replace(/\s/g,'_') + ':' + song.title.replace(/\s/g,'_')

                        link = "http://lyrics.wikia.com/#{encodeURIComponent uri}"
                        # console.log "#{link}".inverse.red
                        @getFileByHTTP link, @processSongLyric, @onSongFail, options 
                
      updateSongsLyrics : ->
            @connect()
            @showStartupMessage "Fetching songs lyric to table", @table.Songs
            @count = 0
            
            @temp = 
                  nItems : 1000
                  nItemsSkipped : 8000
            console.log " |The number of items to skip: #{@temp.nItemsSkipped}"

            @eventEmitter.on "result-song", (song, options)=>
                  @stats.totalItemCount +=1
                  @stats.passedItemCount +=1
                  @stats.currentId  = options.id
                  # @log.lastSongId = song.songid
                  # @temp.totalFail = 0
                  if song isnt null
                        _u = "UPDATE #{@table.Songs} SET "
                        _u += "  musicbrainz_link = #{@connection.escape song.musicbrainz_link}, " if song.musicbrainz_link
                        _u += "  allmusic_link = #{@connection.escape song.allmusic_link}, " if song.allmusic_link
                        _u += "  youtube_link = #{@connection.escape song.youtube_link}, " if song.youtube_link
                        _u += "  isGracenote = #{@connection.escape song.isGracenote}, " if song.isGracenote
                        _u += "  download_done = #{song.download_done}, "
                        _u += "  lyric = #{@connection.escape song.lyric} "
                        _u += " where id=#{song.id}"
                        # console.log song
                        # console.log _u
                        @connection.query _u, (err)->
                              if err then console.log "Cannot insert song #{song.id} . ERROR: #{err}"
                  else 
                        @stats.passedItemCount -=1
                        @stats.failedItemCount +=1
                  @utils.printRunning @stats

                  if @stats.totalItems is @stats.totalItemCount
                        @utils.printFinalResult @stats
                        @count +=1
                        console.log " |GET NEXT STEP :#{@count}".inverse.red
                        @resetStats()
                        @_getSongsLyrics()


            @_getSongsLyrics()


      # THIS PART FOR UPDATE METRO LYRIC
      # --------------------------------------------------------------------------------
       onSongMetroLyricFail : (error, options)=>
            # console.log "err  has an errorq: #{error}, #{options.id}"
            @stats.totalItemCount +=1
            @stats.failedItemCount +=1
            _u = "UPDATE #{@table.Songs} SET "
            _u += "  download_metrolyric_done = -1 "
            _u += " where id=#{options.id}"
            # console.log song
            # console.log _u
            @connection.query _u, (err)->
                  if err then console.log "Cannot insert song #{song.id} . ERROR: #{err}"
            @utils.printRunning @stats
            if @stats.totalItems is @stats.totalItemCount
                  @utils.printFinalResult @stats
                  @count +=1
                  console.log " |GET NEXT STEP :#{@count}".inverse.red
                  @resetStats()
                  @_getSongsMetrolyrics()
       processSongMetrolyric: (data,options)=>
            try 

                  song = 
                        id : options.id
                        title : options.title
                        artist : options.artist
                        lyric : ""
                        tags : ""
                        download_metrolyric_done : 1

                  lyric = data.match(/line line\-s.+/g)
                  if lyric then song.lyric = @processStringorArray lyric.map((v)-> 
                        _t = v.replace(/<\/span>$|<\/span>.+$/,'').replace(/^.+>/,'')
                        if _t.match(/From\: http\:\/\/www\.metrolyrics\.com/) then return null
                        else return _t
                        ).filter((v)-> if v is null then return false else return true ).join('<br/>')

                  tags = data.match(/tag\-tag first.+/)?[0]
                  if tags then song.tags = @processStringorArray tags.split(/<\/a>/).map((v)->
                        v.replace(/^.+>/,'')
                        ).filter((v)-> if v is null or v is "" then return false else return true )

                  if song.lyric is "" then song.download_metrolyric_done = 0

                  @eventEmitter.emit "result-song", song, options

                  return song
            catch error
                console.log "ERROR : at link #{options.link}. ---> #{error}"
      _getSongsMetrolyrics : (artist)=>
            params =
                sourceField : "id, #{@table.Songs}.title,#{@table.Songs}.artist"
                table : @table.Songs
                limit : @temp.nItems
                skip : @temp.nItemsSkipped
                condition : " download_metrolyric_done is null"
            
            @_getFieldFromTable params, (songs)=>

                  # songs = [{id : 123232323, artist : "Justin Bieber", title : "Never say never"},{id:343232323,artist : "heaven shall burn", title : "to harvest the storm"}]

                  @stats.totalItems = songs.length
                  console.log " |# of items : #{@stats.totalItems}"
                  console.log " |Getting from range: #{songs[0].id} ---> #{songs[songs.length-1].id}"
                  for song in songs
                          # console.log song
                        options = 
                              id : song.id
                              title : song.title
                              artist : song.artist
      
                        uri = song.title.replace(/\s/g,'-').toLowerCase() + "-lyrics-" +  song.artist.replace(/\s/g,'-').toLowerCase()
      
                        link = "http://www.metrolyrics.com/#{encodeURIComponent(uri).toLowerCase()}.html"
                        options.link = link
                        # console.log "#{link}".inverse.red
                        @getFileByHTTP link, @processSongMetrolyric, @onSongMetroLyricFail, options 
              
      updateSongsMetrolyrics :->
            @connect()
            @showStartupMessage "Fetching METROLYRIC of songs to table", @table.Songs
            @count = 0
            @stats.currentTable = @table.Songs
            @temp = 
                nItems : 1000
                nItemsSkipped : 0
            console.log " |The number of items to skip: #{@temp.nItemsSkipped}"

            @eventEmitter.on "result-song", (song, options)=>
                @stats.totalItemCount +=1
                @stats.passedItemCount +=1
                @stats.currentId  = options.id
                # @log.lastSongId = song.songid
                # @temp.totalFail = 0
                if song isnt null
                      _u = "UPDATE #{@table.Songs} SET "
                      _u += "  tags = #{@connection.escape song.tags}, " if song.tags
                      _u += "  download_metrolyric_done = #{song.download_metrolyric_done}, "
                      _u += "  metrolyric = #{@connection.escape song.lyric} "
                      _u += " where id=#{song.id}"
                      # console.log song
                      # console.log _u
                      @connection.query _u, (err)->
                            if err then console.log "Cannot insert song #{song.id} . ERROR: #{err}"
                else 
                      @stats.passedItemCount -=1
                      @stats.failedItemCount +=1
                @utils.printRunning @stats

                if @stats.totalItems is @stats.totalItemCount
                      @utils.printFinalResult @stats
                      @count +=1
                      console.log " |GET NEXT STEP :#{@count}".inverse.red
                      @resetStats()
                      @_getSongsMetrolyrics()


            @_getSongsMetrolyrics()
      showStats : ->
        @_printTableStats @table


module.exports = SongFreaks



