Site = require "./Site"
http = require 'http'
url = require('url')
zlib = require('zlib')



class LyricWiki extends Site
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
      
      # this version removes all the status code 301 and 404. Applied only for lyricwiki
      getFileByHTTPv2 : (link, onSucess, onFail, options) ->
            # console.log "ansdas"
            # console.log link
            http.get link, (res) =>
                        res.setEncoding 'utf8'
                        data = ''
                        # onSucess res.headers.location
                        res.on 'data', (chunk) =>
                              data += chunk;
                        res.on 'end', () =>
                              
                              onSucess data, options
                        
                  .on 'error', (e) =>
                        onFail  "Cannot get file from server. ERROR: " + e.message, options

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
      insertStatement : (query, options)->
            @connection.query query, (err)->
                  if err then console.log "Cannot insert song #{options.id} . ERROR: #{err}"

      onSongFail : (error, options)=>
            # console.log "err --#{options.id}-- has an error: #{error}"

            _u = "UPDATE #{@table.Songs} SET "
            _u += "  download_done = -1 "
            _u += " where id=#{options.id}"
            # console.log "HWWE"
            @stats.totalItemCount +=1
            @stats.failedItemCount +=1
            @stats.currentId  = options.id
            @utils.printRunning @stats
            # console.log _u
            @insertStatement _u, options
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

      # THIS PART FOR UPDATING LYRIC 
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

                  if song.lyric is "" then song.download_done = -1


                  @eventEmitter.emit "result-song", song, options

                  return song
            catch error
                console.log "ERROR : at link #{options.name}. ---> #{error}"
      _getSongsLyrics : (source = "lyricwiki")=>
            params =
                  sourceField : "id, #{@table.Songs}.title,#{@table.Songs}.artist"
                  table : @table.Songs
                  limit : @temp.nItems
                  skip : @temp.nItemsSkipped
                  condition : @temp.condition
            
            # console.log params
            @_getFieldFromTable params, (songs)=>

                  # FOR TESTING
                  # songs = [{id : 640472, artist : "David Coverdale", title : "Coverdale/Page:Don't Leave Me This Way"}]
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
                             source : source

                        if song.title.search(':') > -1 then uri = song.title.replace(/\s+/g,'_')
                        else  uri = song.artist.replace(/\s+/g,'_') + ':' + song.title.replace(/\s+/g,'_')

                        if source is "lyricwiki" 
                              # console.log uri
                              link = "http://lyrics.wikia.com/#{encodeURIComponent uri}"
                              # console.log "#{link}".inverse.red
                              # link = "http://google.com"
                              @getFileByHTTPv2 link, @processSongLyric, @onSongFail, options 
                        else if source is "gracenote"
                              # uri = uri.replace(/®/,'').replace(/Hank_Williams_Jr/,"Hank_Williams_Jr")
                              link = "http://lyrics.wikia.com/Gracenote:#{encodeURIComponent uri}"
                              # link = link.replace("\%3A",':')
                              # link = "http://lyrics.wikia.com/Gracenote:Lester_Flatt_%26_Earl_Scruggs:Give_Mother_My_Crown"
                              # console.log "#{link}".inverse.red
                              @getFileByHTTPv2 link, @processGraceNoteSongLyric, @onGraceNoteSongFail, options 
                
      updateSongsLyrics : ->
            @connect()
            @showStartupMessage "Fetching songs lyric to table", @table.Songs
            @count = 0
            
            @temp = 
                  nItems : 1500
                  nItemsSkipped : 10
                  # condition : " download_done is null"
                  condition : " download_done=0 "
            console.log " |The number of items to skip: #{@temp.nItemsSkipped}"

            @eventEmitter.on "result-song", (song, options)=>
                  @stats.totalItemCount +=1
                  @stats.passedItemCount +=1
                  @stats.currentId  = options.id
                  # @log.lastSongId = song.songid
                  # @temp.totalFail = 0
                  if song isnt null
                        _u = "UPDATE #{@table.Songs} SET "
                        # _u += "  musicbrainz_link = #{@connection.escape song.musicbrainz_link}, " if song.musicbrainz_link
                        # _u += "  allmusic_link = #{@connection.escape song.allmusic_link}, " if song.allmusic_link
                        # _u += "  youtube_link = #{@connection.escape song.youtube_link}, " if song.youtube_link
                        _u += "  isGracenote=#{@connection.escape song.isGracenote}, " if song.isGracenote
                        _u += "  download_done=#{song.download_done}, "
                        _u += "  lyric=#{@connection.escape song.lyric} "
                        _u += " where id=#{song.id}"
                        # console.log song
                        # console.log _u
                        @insertStatement _u, options
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


      # THIS PART FOR GRACENOTE LYRIC
      # ------------------------------------------------------------------------------------------
      processGraceNoteSongLyric: (data,options)=>
            try 

                  song = 
                        id : options.id
                        title : options.title
                        artist : options.artist
                        gracenote_songwriters  : ""
                        gracenote_publishers : ""
                        gracenote_lyric : ""
                        download_gracenote_done : 1

                  gracenote_songwriters = data.match(/Songwriters.+/)?[0]
                  if gracenote_songwriters then song.gracenote_songwriters = @processStringorArray gracenote_songwriters
                                                                                                                                    .replace(/<\/em>|<\/em>.+$/,'')
                                                                                                                                    .replace(/^.+<em>/,'')

                  gracenote_publishers = data.match(/Publishers.+/)?[0]
                  if gracenote_publishers then song.gracenote_publishers = @processStringorArray gracenote_publishers
                                                                                                                                    .replace(/<\/em>|<\/em>.+$/,'')
                                                                                                                                    .replace(/^.+<em>/,'')                                                                                                               
                  lyric = data.match(/class='lyricbox'.+<\/a><\/div>\s+(.+)<\!--/)?[1]
                  if not lyric then lyric = data.match(/class='lyricbox'.+<\/a><\/div>(.+)<\!--/)?[1]

                  if lyric 
                        song.gracenote_lyric = @processStringorArray lyric.replace(/^<p>/,'')

                  if song.gracenote_lyric is "" then song.download_gracenote_done = 0

                  # console.log data.match(/class='lyricbox'.+/)?[0]

                  @eventEmitter.emit "result-song", song, options

                  return song
            catch error
                console.log "ERROR : at link #{options.name}. ---> #{error}"
      onGraceNoteSongFail : (error, options)=>
            # console.log "err --#{options.id}-- has an error: #{error}"

            _u = "UPDATE #{@table.Songs} SET "
            _u += "  download_gracenote_done = -1 "
            _u += " where id=#{options.id}"
            @stats.totalItemCount +=1
            @stats.failedItemCount +=1
            @stats.currentId  = options.id
            @utils.printRunning @stats
            # console.log _u
            @insertStatement _u, options
            if @stats.totalItems is @stats.totalItemCount
                  @utils.printFinalResult @stats
                  @count +=1
                  console.log " |GET NEXT STEP :#{@count}".inverse.red
                  @resetStats()
                  @_getSongsLyrics("gracenote")
      updateGraceNoteSongsLyrics : ->
            @connect()
            @showStartupMessage "Fetching GRACENOTE songs lyric to table", @table.Songs
            @count = 0
            
            @temp = 
                  nItems : 1000
                  nItemsSkipped : 0
                  # condition : "  download_gracenote_done is null and isGracenote=1 "
                  condition : " download_done=1 and download_gracenote_done=0 "
            console.log " |The number of items to skip: #{@temp.nItemsSkipped}"

            @eventEmitter.on "result-song", (song, options)=>
                  @stats.totalItemCount +=1
                  @stats.passedItemCount +=1
                  @stats.currentId  = options.id
                  # @log.lastSongId = song.songid
                  # @temp.totalFail = 0
                  if song isnt null
                        _u = "UPDATE #{@table.Songs} SET "
                        _u += "  gracenote_songwriters = #{@connection.escape song.gracenote_songwriters}, "
                        _u += "  gracenote_publishers = #{@connection.escape song.gracenote_publishers}, "
                        _u += "  gracenote_lyric = #{@connection.escape song.gracenote_lyric}, " 
                        _u += "  download_gracenote_done = #{song.download_gracenote_done} "
                        _u += " where id=#{song.id}"
                        # console.log song
                        # console.log _u
                        @insertStatement _u, options
                  else 
                        @stats.passedItemCount -=1
                        @stats.failedItemCount +=1
                  @utils.printRunning @stats

                  if @stats.totalItems is @stats.totalItemCount
                        @utils.printFinalResult @stats
                        @count +=1
                        console.log " |GET NEXT STEP :#{@count}".inverse.red
                        @resetStats()
                        @_getSongsLyrics("gracenote")


            @_getSongsLyrics("gracenote")
      # THIS PART FOR UPDATING METRO LYRIC
      # --------------------------------------------------------------------------------
       onAlbumFail : (error, options)=>
            # console.log "err  has an errorq: #{error}, #{options.id}"
            @stats.totalItemCount +=1
            @stats.failedItemCount +=1
            _u = "UPDATE #{@table.Albums} SET "
            _u += "  download_done = -1 "
            _u += " where id=#{options.id}"
            # console.log album
            # console.log _u
            @connection.query _u, (err)->
                  if err then console.log "Cannot insert album #{options.id} . ERROR: #{err}"
            @utils.printRunning @stats
            if @stats.totalItems is @stats.totalItemCount
                  @utils.printFinalResult @stats
                  @count +=1
                  console.log " |GET NEXT STEP :#{@count}".inverse.red
                  @resetStats()
                  @_getAlbum()
       processAlbum: (data,options)=>
            try 

                  album = 
                        id : options.id
                        title : options.title
                        artist : options.artist
                        year : options.year
                        genre : ""
                        duration : 0
                        thumbnail : ""
                        allmusic_link : ""
                        discogs_link : ""
                        musicbrainz_link : ""
                        download_done : 1

                  # DO SOMETHING
                  duration = data.match(/Length:.+<\/td><\/tr>.+/)?[0]
                  if duration 
                        duration = duration.replace(/<\/td><\/tr>.+/,'').replace(/^.+>/,'').split(":").map (v)-> parseInt v,10
                        if duration.length is 2
                              album.duration = duration[0]*60 + duration[1]
                        else if duration.length is 3
                              album.duration = duration[0]*3600 + duration[1]*60 + duration[2]
                        else console.log "ERROR ar duration. #{options.id} ---"

                  genre = data.match(/Genre:.+<\/a><\/td><\/tr>.+/)?[0]
                  if genre then album.genre = @processStringorArray genre.replace(/<\/a><\/td><\/tr>.+/,'').replace(/^.+>/,'')

                  thumbnail = data.match(/<\/div><\/div><\/div><td>.+/)?[0]
                  if thumbnail then album.thumbnail = thumbnail.replace(/" class.+/,'').replace(/^.+"/,'')

                  musicbrainz_link = data.match(/MusicBrainz:.+/)?[0]
                  if musicbrainz_link then album.musicbrainz_link = musicbrainz_link.replace(/">.+/,'').replace(/^.+"/,'')

                  discogs_link = data.match(/Discogs:.+/)?[0]
                  if discogs_link then album.discogs_link = discogs_link.replace(/">.+/,'').replace(/^.+"/,'')

                  allmusic_link = data.match(/allmusic:.+/)?[0]
                  if allmusic_link then album.allmusic_link = allmusic_link.replace(/">.+/,'').replace(/^.+"/,'')

                  if  album.thumbnail is "" and album.musicbrainz_link is "" and album.discogs_link is "" and album.allmusic_link is "" and album.genre is "" and album.duration is 0
                        album.download_done = 0

                  @eventEmitter.emit "result-album", album, options

                  return album
            catch error
                console.log "ERROR : at link #{options.link}. ---> #{error}"
      _getAlbum : (artist)=>
            params =
                sourceField : "id, #{@table.Albums}.title,#{@table.Albums}.artist,#{@table.Albums}.year"
                table : @table.Albums
                limit : @temp.nItems
                skip : @temp.nItemsSkipped
                condition : " year is not null and download_done is null"
                # condition : " id=160884 "
            
            @_getFieldFromTable params, (albums)=>
                  @stats.totalItems = albums.length
                  console.log " |# of items : #{@stats.totalItems}"
                  console.log " |Getting from range: #{albums[0].id} ---> #{albums[albums.length-1].id}"
                  for album in albums
                          # console.log album
                        options = 
                              id : album.id
                              title : album.title
                              artist : album.artist
                              year : album.year
      
                        uri = "#{album.artist}:#{album.title}_(#{album.year})".replace(/\s/g,'_')
      
                        link = "http://lyrics.wikia.com/#{encodeURIComponent(uri)}"
                        options.link = link
                        # console.log "#{options.id} \t- #{link}".inverse.red
                        @getFileByHTTPv2 link, @processAlbum, @onAlbumFail, options 
      updateAlbums :->
            @connect()
            @showStartupMessage "Fetching METROLYRIC of albums to table", @table.Albums
            @count = 0
            @stats.currentTable = @table.Albums
            @temp = 
                nItems : 1000
                nItemsSkipped : 0
            console.log " |The number of items to skip: #{@temp.nItemsSkipped}"

            @eventEmitter.on "result-album", (album, options)=>
                @stats.totalItemCount +=1
                @stats.passedItemCount +=1
                @stats.currentId  = options.id
                if album isnt null
                      _u = "UPDATE #{@table.Albums} SET "
                      _u += "  genre = #{@connection.escape album.genre}, " 
                      _u += "  duration = #{album.duration}, "
                      _u += "  thumbnail = #{@connection.escape album.thumbnail}, "
                      _u += "  allmusic_link = #{@connection.escape album.allmusic_link}, "
                      _u += "  discogs_link = #{@connection.escape album.discogs_link}, "
                      _u += "  musicbrainz_link = #{@connection.escape album.musicbrainz_link}, "
                      _u += "  download_done = #{album.download_done} "
                      _u += " where id=#{album.id}"
                      # console.log album
                      # console.log _u
                      @connection.query _u, (err)->
                            if err then console.log "Cannot insert album #{album.id} . ERROR: #{err}"
                else 
                      @stats.passedItemCount -=1
                      @stats.failedItemCount +=1
                @utils.printRunning @stats

                if @stats.totalItems is @stats.totalItemCount
                      @utils.printFinalResult @stats
                      @count +=1
                      console.log " |GET NEXT STEP :#{@count}".inverse.red
                      @resetStats()
                      @_getAlbum()


            @_getAlbum()


      # THIS PART FOR fetching GENRE
      # --------------------------------------------------------------------------------
      onItemFail : (err, options)=>
            console.log "Link: {options.link} has an error. ERROR:#{err}"
            @stats.totalItemCount +=1
            @stats.failedItemCount +=1
            @utils.printUpdateRunning @stats.totalItemCount*200, @stats, "Fetching...."
      processItem : (data,options)=>
            nextlink = data.match(/previous 200.+href=\"(.+)\" title.+next 200/)?[1]
            @eventEmitter.emit "item-processing", data, options
            if nextlink then @_getItem "http://lyrics.wikia.com#{nextlink}"
      _getItem : (link)->
            options = 
                  link : link
                  genre : link.replace(/http\:\/\/lyrics\.wikia\.com\//,'')
            # console.log "#{link}".inverse.red
            @getFileByHTTP link, @processItem, @onItemFail, options  
      fetchItems: (uri) ->
            @connect()
            

            link = "http://lyrics.wikia.com/#{uri}"
            @_getItem link
      updateStats : (options)->
            @stats.totalItemCount +=1
            @stats.passedItemCount +=1
            @utils.printUpdateRunning @stats.totalItemCount*200, @stats, "Fetching...."


      insertItemIntoDB : (item,insertStatement)->
            # console.log item
            # console.log insertStatement
            # item = { artist: 'Adamski', genre: 'Acid House' }
            # item =  
            #       artist: 'Alabama 3',
            #       album: 'Outlaw',
            #       year: '2005',
            #       genre: 'Acid House' 

            @connection.query insertStatement, item, (err)->
                  if err then console.log "We have an  error at item: #{item} --> #{err}".red

      # fetchGenres : ->
      #       @connect()
      #       @fetchItems "Category:Genre"
      #       @eventEmitter.on "item-result", (items, options)=>
      #             @updateStats(options)
      #             # console.log "ANSDNSAD"
      #             for item in items
      #                   @insertItemIntoDB item, "INSERT IGNORE INTO LWGenres SET ?"
      #       @eventEmitter.on "item-processing", (data,options)=>

      #             items = []

      #             temps = data.match(/CategoryTreeSection.+/g)
      #             temps.map (v)->
      #                   _t = 
      #                         name : v.replace(/<\/a>.+/,'').replace(/^.+>/,'').replace(/Genre\//,'')
      #                         link : v.replace(/^.+href=\"/,'').replace(/\">.+$/,'')
      #                         npages : v.match(/([0-9]+) page/)?[1]
      #                   items.push _t
      #             # console.log items
      #             @eventEmitter.emit "item-result", items, options
      _getAlbumsArtistsGenres  : (langs)->
            @showStartupMessage "Fetching items to table", @table.Songs
            for lang in langs
                  @fetchItems lang
                  # console.log lang
            @eventEmitter.on "item-result", (items, options)=>
                  @updateStats(options)
                  # console.log "ANSDNSAD"
                  for item in items
                        if item isnt undefined
                              @insertItemIntoDB item, "INSERT IGNORE INTO LWAlbumsArtistsGenres SET ?"
                        else 
                              @stats.totalItemCount +=1
                              @stats.failedItemCount +=1
            @eventEmitter.on "item-processing", (data,options)=>

                  items = []
                  temps = data.match(/<li><a href=\".+/g)
                  if temps
                        temps.map (v)=>
                              _temp = v.replace(/<\/a>.+/,'').replace(/^.+>/,'').split(":")
                              if _temp.length is 2
                                    _t = 
                                          artist : @processStringorArray _temp[0]
                                          album : @processStringorArray _temp[1].replace(/(\([0-9]+\))/,'')
                                          year : _temp[1].match(/\(([0-9]+)\)/)?[1]
                                          genre : @processStringorArray decodeURIComponent options.link.replace(/http\:\/\/lyrics\.wikia\.com\/Category\:Genre\//,'').replace(/\?pagefrom.+/,'').replace(/_/g,' ')
                              else if _temp.length is 1
                                    _t = 
                                          artist : @processStringorArray _temp[0]
                                          genre : @processStringorArray decodeURIComponent options.link.replace(/http\:\/\/lyrics\.wikia\.com\/Category\:Genre\//,'').replace(/\?pagefrom.+/,'').replace(/_/g,' ')
                              else if _temp.length is 3
                                    _t = 
                                          artist : @processStringorArray _temp[0]+":"+_temp[1]
                                          album : @processStringorArray _temp[2].replace(/(\([0-9]+\))/,'')
                                          year : _temp[1].match(/\(([0-9]+)\)/)?[2]
                                          genre : @processStringorArray decodeURIComponent options.link.replace(/http\:\/\/lyrics\.wikia\.com\/Category\:Genre\//,'').replace(/\?pagefrom.+/,'').replace(/_/g,' ')

                              else console.log "#{options.link} ..... #{_temp}"
                              items.push _t
                  # console.log items
                  @eventEmitter.emit "item-result", items, options
      fetchAlbumsArtistsGenres : ->
            @connect()
            @connection.query "select link from LWGenres", (err,results)=>
                  if err then console.log "#{err}"
                  else 
                        console.log "#n results #{results.length}"
                        genres = []
                        # results = [{link : "/Category:Genre/Acoustic"}]
                        for genre in results
                              genres.push genre.link.replace(/\/Category\:/,'Category:')
                        @_getAlbumsArtistsGenres genres
            # lang = "Category:Language/Japanese"

      showStats : ->
        @_printTableStats @table


module.exports = LyricWiki



