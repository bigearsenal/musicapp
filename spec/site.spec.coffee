describe "The site mp3.zing.vn", ->
  Zing = require '../lib/zing'
  zing = new Zing()
  waitingTime = 200
  
  describe "contains a song", ->
    it "has an id of 1382402055", ->
      runs ()->
        zing.connect()
        songid = 1382402055
        link = "http://mp3.zing.vn/bai-hat/joke-link/#{zing._convertToId songid}.html"
        zing._getFileByHTTP link, (data)->
          # console.log data
          zing._processSong songid, data
      
      waits(waitingTime)
      runs ->
       # console.log zing.song
       expect(zing.song.sid).toEqual(1382402055)
    it "of encoded id of ZW6ZC807", ->
      expect(zing.song.songid).toEqual("ZW6ZC807")
    it "of total plays of 31", ->
      expect(parseInt(zing.song.plays,10)).toEqual(31)
    it "whose author is nobody", ->
      expect(zing.song.author).toEqual('')
    it "whose topics are Âu Mỹ,Pop,Audiophile", ->
      expect(zing.song.topic).toEqual('["Âu Mỹ","Pop","Audiophile"]')
    it "whose name is Meditation", ->
      expect(zing.song.song_name).toEqual('Meditation')
    it "whose artist is Olivia Ong", ->
      expect(zing.song.song_artist).toEqual('["Olivia Ong"]')
    it "has link of http://m.mp3.zing.vn/xml/song-load/MjAxMyUyRjA0JTJGMDclMkY3JTJGNCUyRjc0ZGQ3YWM4MzMyNTQxZDEwNjNhNTg4MGM5MWU1NGQxLm1wMyU3QzI=", ->
      expect(zing.song.song_link).toEqual('http://m.mp3.zing.vn/xml/song-load/MjAxMyUyRjA0JTJGMDclMkY3JTJGNCUyRjc0ZGQ3YWM4MzMyNTQxZDEwNjNhNTg4MGM5MWU1NGQxLm1wMyU3QzI=')
    it "whose link is decoded into 2013/04/07/7/4/74dd7ac8332541d1063a5880c91e54d1.mp3",->
      expect(zing.song.path).toEqual('2013/04/07/7/4/74dd7ac8332541d1063a5880c91e54d1.mp3')
    it "created on 2013-04-07",->
      expect(zing.song.created).toEqual('2013-04-07')
      zing.end()

  describe "contains an album", ->
    result = ""
    it "having an id of 1381671200", ->
      runs ()->
        zing.connect()
        albumid = 1381671200
        link = "http://mp3.zing.vn/album/joke-link/#{zing._convertToId albumid}.html"
        zing._getFileByHTTP link, (data)->
          # console.log data
          result = zing._processAlbum albumid, data
      
      waits(waitingTime)
      runs ->
       # console.log zing.song
       expect(result.aid).toEqual(1381671200)
       # console.log result
       zing.end()
       # console.log result
    it "having an albumid of ZWZAAIW0", ->
      expect(result.albumid).toEqual("ZWZAAIW0")
    # it "having album_encodedId of LHJntknaVJvJHnHtLFJTDGLG", ->
    #   expect(result.album_encodedId).toEqual("LHJntknaVJvJHnHtLFJTDGLG")
    it "whose name is Anh Muốn Quay Lại... Đến Khi Nào",->
      expect(result.album_name).toEqual("Anh Muốn Quay Lại... Đến Khi Nào")
    it "whose author is Khắc Việt", ->
      expect(result.album_artist).toEqual('["Khắc Việt"]')      
    it "whose topic are Việt Nam,Nhạc Trẻ",->
      expect(result.topic).toEqual('["Việt Nam","Nhạc Trẻ"]') 
    # it "played 1158877 times", ->
    #   expect(parseInt(result.plays,10)).toEqual(1158877)
    it "released in 2013",->
      expect(parseInt(result.released_year,10)).toEqual(2013)
    it "having 2 songs",->
       expect(parseInt(result.nsongs,10)).toEqual(2)
    it "having thumbnail of http://image.mp3.zdn.vn/thumb/165_165/covers/5/2/5284f196b781e762b443f762a612172f_1365388107.jpg", ->
      expect(result.album_thumbnail).toEqual('http://image.mp3.zdn.vn/thumb/165_165/covers/5/2/5284f196b781e762b443f762a612172f_1365388107.jpg')
    it "having desciption starting with 'Đến khi nào.....'",->
      expect(result.description).toMatch(/Đến\skhi\snào.+/)
    it "created on 2013-4-8 9:28:27",->
      expect(result.created).toEqual("2013-4-8 9:28:27")



