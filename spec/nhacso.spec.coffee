http = require 'http'
getFileByHTTP = (link, callback) ->
    http.get link, (res) =>
        res.setEncoding 'utf8'
        data = ''
        # callback res.headers.location
        if res.statusCode isnt 302
          res.on 'data', (chunk) =>
            data += chunk;
          res.on 'end', () =>
            
            callback data
        else callback(null)
      .on 'error', (e) =>
        console.log  "Cannot get file. ERROR: " + e.message
describe "The site nhacso.net", ->
  Nhacso = require '../lib/nhacso'
  ns = new Nhacso()
  nsSong = {}
  waitingTime = 500
  describe "contains a song", ->
    it "having an encoded id of 1285971: #{ns._decodeId(1285971)}", ->
      runs ()->
        ns.connect()
        id = 1285971
        link = "http://nhacso.net/nghe-nhac/link-joke.#{ns._decodeId(id)}==.html"
        # console.log "Fetching from link #{link}"
        options = 
          id : id
          song : {}
        getFileByHTTP link, (data)=>
          # console.log "AHDFKJASHKDHASKJHDKSJA"
          nsSong = ns.processSong data, options
          # console.log nsSong
      waits(waitingTime)
      runs ->
       # console.log zing.song
       expect(ns._decodeId(1285971)).toEqual("X1pZVkpYbg")
    it "being official", ->
      expect(nsSong.official).toEqual(1)
    it "having bitrate of 320 kbps",->
      expect(nsSong.bitrate).toEqual(320)
    it "having the number of plays which is an integer",->
      expect(nsSong.plays).toMatch(/\d+/)
    it "whose topic is Nhạc Trữ Tình", ->
      expect(nsSong.topic).toEqual('Nhạc Trữ Tình')
    it "having lyric", ->
      expect(nsSong.islyric).toEqual(1)
    it "whose lyric begins from Em dấu yêu ơi anh...giắt nhau về",->
      expect(nsSong.lyric).toEqual("Em dấu yêu ơi anh đang quay về mười năm xa vắng\nanh đã đưa em, đưa em đi tìm một giấc mơ đời\nmười năm lạc loài phải không em\nmười năm hận thù trĩu trong tim\nta trót trao nhau thân, ta chót vong ân\nmang tuổi hoa niên, làm kiếp lưu đầy\nBóng tà ngả trên lưng đồi cỏ non\nGió hiền thoáng vi vu hàng lau xanh\nngoài kia là đồng thơm hương lúa mới\nbên lũy tre xanh ngả nghiêng hàng dừa\nvà đây là giòng sông ta thương mến,\nsoi bóng chung đôi những ngày ấu thơ\nAnh sẽ đưa em, đưa em xa rời vùng mây tăm tối\nAnh sẽ đưa em, đưa em đi về, về lối chân hiền\ncòn ai đợi chờ nữa không em\ncòn ai giận hờn nữa không em\nem hãy theo anh, men lối ăn năn\nta thoát cơn mê cùng giắt nhau về ")
# Fetching another link
    it "whose title is Vó Ngựa Trên Đồi Cỏ Non", ->
      runs ()->
        ns.connect()
        id = 1285971
        link = "http://nhacso.net/flash/song/xnl/1/id/" + ns._decodeId(id)
        # console.log "Fetching from link #{link}"
        options = 
          id : id
        getFileByHTTP link, (data)=>
          ns.data = data
          # console.log ns.data
      waits(waitingTime)
      runs ->
       # console.log zing.song
       expect(ns.getValueXML(ns.data,"name",1)).toEqual("Vó Ngựa Trên Đồi Cỏ Non")
    it "whose artist is Trường Vũ",->
       expect(ns.getValueXML(ns.data,"artist",0)).toEqual("Trường Vũ")
    it "having artistid of 2428",->
      expect(parseInt(ns.getValueXML(ns.data,"artistlink",0).replace(/\.html/g,'').replace(/^.+-/g,''),10)).toEqual(2428)
    it "whose author is Ngân Giang",->
      expect(ns.getValueXML(ns.data,"author",0)).toEqual("Ngân Giang")
    it "having authorid of 963",->
      expect(parseInt(ns.getValueXML(ns.data, "authorlink",0).replace(/\.html/g,'').replace(/^.+-/g,''),10)).toEqual(963)
    it "having total playing time is 320",->
      expect(parseInt(ns.data.match(/totalTime.+totalTime/)?[0].replace(/^.+>|<.+$/g,''),10)).toEqual(320)
    it "having mp3link is http://st01.freesocialmusic.com/....7480.mp3",->
      expect(ns.getValueXML(ns.data, "mp3link", 0)).toEqual("http://st01.freesocialmusic.com/mp3/2013/05/10/1178050012/136817005912_7480.mp3")
    it "having created time of 2013-5-10 14:14:19",->
      ts = ns.getValueXML(ns.data, "mp3link", 0).match(/\/[0-9]+_/g)[0].replace(/\//, "").replace(/_/, "")
      ts = parseInt(ts)*Math.pow(10,13-ts.length)
      created = ns.formatDate new Date(ts)
      expect(created).toEqual("2013-5-10 14:14:19")
      ns.end()




