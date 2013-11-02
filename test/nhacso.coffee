getFileByHTTP = require('./utils').getFileByHTTP
chai = require "chai"
expect = chai.expect
describe 'THE WEBSITE NHACSO.NET', ->
      Nhacso = require '../lib/nhacso'
      ns = new Nhacso()
      nsSong = {}
      album = {}
      video = {}
      encode = (id) ->
        arr = [id.slice(0,2),id.slice(2,3),id.slice(3,4),id.slice(4,6),id.slice(6,7),id.slice(7,8),id.slice(8,10)].filter (e) -> e if e isnt ''
        a = ['bw bg bQ bA aw ag aQ aA Zw Zg'.split(' '),
         'fedcbaZYXW'.split(''),
         'NJFBdZVRtp'.split(''),
         'U0 Uk UU UE V0 Vk VU VE W0 Wk'.split(' '),
         'RQTSVUXWZY'.split(''),
         'hlptx159BF'.split(''),
         ' X1 XF XV Wl W1 WF WV Vl V1'.split(' ')]
        parseInt(arr.map((v,i) -> a[6-i].indexOf(v)).join(''), 10)
      describe "Song ID: X1pZVkpYbg", ->
            it 'should be official, 320kbps, "Nhạc Trữ Tình", and has lyric',(done)->
                  encoded_id = "X1pZVkpYbg"
                  link = "http://nhacso.net/nghe-nhac/link-joke.#{encoded_id}==.html"
                  options =
                        id : encode(encoded_id)
                        song : {}
                  getFileByHTTP link, (data)=>
                        # console.log "AHDFKJASHKDHASKJHDKSJA"
                        nsSong = ns.processSong data, options
                        # console.log nsSong
                        expect(ns._decodeId(1285971)).to.equal("X1pZVkpYbg")
                        expect(nsSong.official).to.equal(1)
                        expect(nsSong.bitrate).to.equal(320)
                        expect(nsSong.plays).to.match(/\d+/)
                        expect(nsSong.topics).to.eql(["Nhạc Trữ Tình"])
                        expect(nsSong.islyric).to.equal(1)
                        expect(nsSong.lyric).to.equal("Em dấu yêu ơi anh đang quay về mười năm xa vắng\nanh đã đưa em, đưa em đi tìm một giấc mơ đời\nmười năm lạc loài phải không em\nmười năm hận thù trĩu trong tim\nta trót trao nhau thân, ta chót vong ân\nmang tuổi hoa niên, làm kiếp lưu đầy\nBóng tà ngả trên lưng đồi cỏ non\nGió hiền thoáng vi vu hàng lau xanh\nngoài kia là đồng thơm hương lúa mới\nbên lũy tre xanh ngả nghiêng hàng dừa\nvà đây là giòng sông ta thương mến,\nsoi bóng chung đôi những ngày ấu thơ\nAnh sẽ đưa em, đưa em xa rời vùng mây tăm tối\nAnh sẽ đưa em, đưa em đi về, về lối chân hiền\ncòn ai đợi chờ nữa không em\ncòn ai giận hờn nữa không em\nem hãy theo anh, men lối ăn năn\nta thoát cơn mê cùng giắt nhau về ")
                        done()
            it 'should be called "Vó Ngựa Trên Đồi Cỏ Non" and has certain properties',(done)->
                  id = 1285971
                  link = "http://nhacso.net/flash/song/xnl/1/id/" + ns._decodeId(id)
                  # console.log "Fetching from link #{link}"
                  options =
                    id : id
                  getFileByHTTP link, (data)=>
                        ns.data = data
                        expect(ns.getValueXML(ns.data,"name",1)).to.equal("Vó Ngựa Trên Đồi Cỏ Non")
                        expect(ns.getValueXML(ns.data,"artist",0)).to.equal("Trường Vũ")
                        expect(parseInt(ns.getValueXML(ns.data,"artistlink",0).replace(/\.html/g,'').replace(/^.+-/g,''),10)).to.equal(2428)
                        expect(ns.getValueXML(ns.data,"author",0)).to.equal("Ngân Giang")
                        expect(parseInt(ns.getValueXML(ns.data, "authorlink",0).replace(/\.html/g,'').replace(/^.+-/g,''),10)).to.equal(963)
                        expect(parseInt(ns.data.match(/totalTime.+totalTime/)?[0].replace(/^.+>|<.+$/g,''),10)).to.equal(320)
                        expect(ns.getValueXML(ns.data, "mp3link", 0)).to.match(/http:\/\/st[0-9]{2}\.freesocialmusic\.com\/mp3\/2013\/05\/10\/1178050012\/136817005912_7480\.mp3/)
                        ts = ns.getValueXML(ns.data, "mp3link", 0).match(/\/[0-9]+_/g)[0].replace(/\//, "").replace(/_/, "")
                        ts = parseInt(ts)*Math.pow(10,13-ts.length)
                        created = ns.formatDate new Date(ts)
                        expect(created).to.equal("2013-5-10 14:14:19")
                        done()
      describe "Album ID: WF5YUEVY",->
            it 'should be called "B-Sides And Other Things I Forgot" and has certain properties',(done)->
                  encoded_id = "WF5YUEVY"
                  link = "http://nhacso.net/nghe-album/ab.#{encoded_id}.html"
                  options =
                        id : encode(encoded_id)
                  getFileByHTTP link, (data)=>
                        # disable callback function
                        ns._updateAlbum = ->
                        ns.getTotalSongsInAlbum = ->
                        ns.onAlbumFail = ->
                        album = ns.processAlbum data, options
                        # console.log album
                        expect(album.id).to.equal(669367)
                        expect(album.title).to.equal("B-Sides And Other Things I Forgot")
                        expect(album.artists).to.eql(["Blue Stahli"])
                        expect(album.artistid).to.equal(97145)
                        expect(album.coverart).to.equal("http://st.nhacso.net/images/album/2013/05/09/1072071738/136807196518_99_120x120.jpg")
                        expect( album.songids).to.eql([1285687,1285688,1285689,1285690,1285691,1285692,1285693,1285694,1285695,1285696,1285697,1285698])
                        done()
            it 'should contain 12 songs',(done)->
                  link = "http://nhacso.net/album/gettotalsong?listIds=#{album.id}"
                  # console.log link
                  getFileByHTTP link, (data)=>
                        data = JSON.parse data
                        # console.log data
                        strId = "nsn:album:total:song:id:#{album.id}"
                        nsongs = parseInt data.result[strId].TotalSong,10
                        expect(nsongs).to.equal(12)
                        done()
            it 'should be released in 2013 and has description ',(done)->
                  link = "http://nhacso.net/album/getdescandissuetime?listIds=#{album.id}"
                  getFileByHTTP link, (data)=>
                        data = JSON.parse(data).result[0]
                        # console.log data
                        released_date = data.IssueTime
                        description = ns.processStringorArray data.AlbumDesc
                        expect(parseInt(released_date,10)).to.equal(2013)
                        expect(description).to.equal("Label: FiXT\r\nGenre: Alternative")
                        done()
            it 'should have been played more than 42 times ',(done)->
                  link = "http://nhacso.net/statistic/albumtotallisten?listIds=#{album.id}"
                  getFileByHTTP link, (data)=>
                        data = JSON.parse(data)
                        plays = parseInt(data.result["#{album.id}"].totalListen,10)
                        expect(plays).to.be.above(42)
                        done()
      describe "Video ID: X15RV0N",->
            it 'should be called "Người Yêu Cũ" and has certain properties' ,(done)->
                  encoded_id = "X15RV0N"
                  link = "http://nhacso.net/xem-video/joke-link.#{encoded_id}=.html"
                  options =
                        id : encode(encoded_id)
                  getFileByHTTP link, (data)=>
                        ns.getVideoDurationAndSublink = ->
                        video = ns.processVideo data,options
                        expect(video.id).to.equal(16040)
                        expect(video.title).to.equal("Người Yêu Cũ")
                        expect(video.artists).to.eql(["Phan Mạnh Quỳnh"])
                        expect(video.topics).to.eql(["Nhạc Trẻ"])
                        expect(video.plays).to.be.at.least(1310)
                        expect(video.official).to.equal(1)
                        expect(video.producerid).to.equal(0)
                        expect(video.link).to.match(/http:\/\/st[0-9]{2}\.freesocialmusic\.com\/mp4\/2013\/05\/09\/1430055571\/13680778242_4392\.mp4/)
                        expect(video.thumbnail).to.equal('http://st.nhacso.net/images/video/2013/05/09/1430055571/136807791310_2665_190x110.jpg')
                        expect(video.date_created).to.equal('2013-5-9 12:37:4')
                        done()
            it 'should have subtitle and 303 second long',(done)->
                  link = "http://nhacso.net/flash/video/xnl/1/id/" + ns._decodeId(video.id)
                  # console.log link
                  getFileByHTTP link, (data)=>
                        duration = parseInt(ns.getValueXML(data, "duration", 0).replace(/<\/duration>|<duration>/g,''),10)
                        sublink = ns.getValueXML data, "subUrl", 0
                        expect(duration).to.equal(303)
                        expect(sublink).to.equal("http://nhacso.net/flash/crypting/1/xnl/id/X15RV0M=")
                        done()