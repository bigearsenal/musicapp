#!/usr/local/bin/mocha
chai = require "chai"
expect = chai.expect
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

getRedirectFileByHTTP = (link, onSucess, onFail, options) ->
    http.get link, (res) =>
        res.setEncoding 'utf8'
        data = ''
        # onSucess res.headers.location
        # console.log res.statusCode
        if res.statusCode isnt 302 and res.statusCode isnt 301
          res.on 'data', (chunk) =>
            data += chunk;
          res.on 'end', () =>
            onSucess data, options
        else 
          if res.statusCode is 301
            getRedirectFileByHTTP res.headers.location,onSucess,onFail,options
          else 
            onFail("The link: #{link} is temporary moved",options)
      .on 'error', (e) =>
        onFail  "Cannot get file: #{link} from server. ERROR: " + e.message, options
        @stats.totalItemCount +=1
        @stats.failedItemCount +=1
describe 'THE WEBSITE MP3.ZING.VN', ->
      Zing = require '../lib/zing'
      zing = new Zing()
      song = {}
      describe 'Song ID: ZW6ZC807', ->
            it 'should be encoded into 1382402055, has plays, topic and no author',(done) ->
                  zing.connect()
                  songid = 1382402055
                  link = "http://mp3.zing.vn/bai-hat/joke-link/#{zing._convertToId songid}.html"
                  getFileByHTTP link, (data)->
                        #console.log "anbinh"
                        zing._getFileByHTTP = ->
                        song = zing._processSong songid, data
                        # console.log song
                        expect(song.songid).to.equal("ZW6ZC807")
                        expect(parseInt(song.plays,10)).to.match(/\d+/)
                        expect(song.author).to.equal("")
                        expect(song.topic).to.equal('["Âu Mỹ","Pop","Audiophile"]')
                        done()
            it 'should be called Meditation, composed by Olivia Ong, created on 2013-04-07, has link and path',(done)->
                  zing.connect()
                  link = "http://m.mp3.zing.vn/xml/song/LnJGtLnNAQQxJQQyLDcyDHLG"
                  getFileByHTTP link, (data)->
                        data = JSON.parse data
                        song.song_name = data.data[0].title.trim()
                        song.song_artist = JSON.stringify data.data[0].performer.trim().split(',')
                        song.song_link = data.data[0].source

                        _str =  song.song_link.replace(/^.+load-song\//g,'').replace(/^.+song-load\//g,'')
                        testArr = []
                        testArr.push zing._decodeString _str.slice(i, i+4) for i in [0.._str.length-1] by 4
                        path =  decodeURIComponent testArr.join('').match(/.+mp3/g)

                        created = path.match(/^\d{4}\/\d{2}\/\d{2}/)?[0].replace(/\//g,"-")
                        song.path = path
                        song.created = created
                        expect(song.song_name).to.equal('Meditation')
                        expect(song.song_artist).to.equal('["Olivia Ong"]')
                        expect(song.song_link).to.equal('http://m.mp3.zing.vn/xml/song-load/MjAxMyUyRjA0JTJGMDclMkY3JTJGNCUyRjc0ZGQ3YWM4MzMyNTQxZDEwNjNhNTg4MGM5MWU1NGQxLm1wMyU3QzI=')
                        expect(song.path).to.equal('2013/04/07/7/4/74dd7ac8332541d1063a5880c91e54d1.mp3')
                        expect(song.created).to.equal('2013-04-07')
                        done()
      describe "Album ID: ZWZAAIW0",->
            it 'should be called "Anh Muốn Quay Lại... Đến Khi Nào" and has certain properties', (done)->
                  zing.connect()
                  albumid = 1381671200
                  link = "http://mp3.zing.vn/album/joke-link/#{zing._convertToId albumid}.html"
                  getFileByHTTP link, (data)->
                        # console.log data
                        result = zing._processAlbum albumid, data
                        # console.log result
                        expect(result.albumid).to.equal("ZWZAAIW0")
                        expect(result.album_name).to.equal("Anh Muốn Quay Lại... Đến Khi Nào")
                        expect(result.album_artist).to.equal('["Khắc Việt"]')
                        expect(result.topic).to.equal('["Việt Nam","Nhạc Trẻ"]')
                        expect(parseInt(result.plays,10)).to.match(/\d+/)
                        expect(parseInt(result.released_year,10)).to.equal(2013)
                        expect(parseInt(result.nsongs,10)).to.equal(2)
                        # console.log result
                        # expect(result.songids.length).to.equal(2)
                        expect(result.album_thumbnail).to.equal('http://image.mp3.zdn.vn/thumb/165_165/covers/5/2/5284f196b781e762b443f762a612172f_1365388107.jpg')
                        expect(result.description).to.equal('“Đến khi nào”. “Anh muốn quay lại” là nỗi nhớ người yêu da diết được Khắc Việt chuyển tải qua giai điệu sâu lắng từ đầu đến cuối. Đúng như tựa đề, “Anh muốn quay lại” như một đề nghị muộn màng khi tình cảm đã chia ly. Trong khi đó “Đến khi nào” lại là một tình yêu rộng lượng của người con trai sẵn sàng hy sinh để đem lại hạnh phúc cho người mình yêu. Việc sử dụng điệp từ “Đến khi nào” nhiều lần trong ca khúc cùng tên khiến cho người nghe đồng cảm nhiều hơn với tình yêu chung thủy của chàng trai trong ca khúc này. ')
                        expect(result.created).to.equal("2013-4-8 9:28:27")
                        done()
      describe "Video ID: ZWZ9ZO0U",->
            it 'should be called "Kiếp Phong Trần" by "Lâm Hùng" and has certain properties ', (done)->
                  zing.connect()
                  vid = 1381585668
                  link = "http://mp3.zing.vn/video-clip/joke-link/#{zing._convertToId vid}.html"
                  getFileByHTTP link, (data)->
                        video = zing._processVideo vid, data
                        # console.log video
                        expect(video.vid).to.equal(1381585668)
                        expect(video.title).to.equal('Kiếp Phong Trần')
                        expect(video.artists).to.equal('["Lâm Hùng"]')
                        expect(video.topic).to.equal('["Việt Nam","Nhạc Trẻ"]')
                        expect(parseInt(video.plays,10)).to.be.at.least(1014646)
                        expect(video.thumbnail).to.equal('http://image.mp3.zdn.vn/thumb/240_135/thumb_video/1/e/1ebf84dd6270b3978273b47f980c854a_1340685814.jpg')
                        expect(video.link).to.match(/http:\/\/mp3.zing.vn\/html5\/video\/[a-zA-Z0-9]{24}/)
                        expect(video.lyric).to.equal('Kiếp phong trần bạn đường sương gió, giang hồ phiêu lãng vũ trụ là nhà. Ánh trăng vàng làm đèn đêm thâu, tựa mình trên cát sương giăng làm màn. 2. Nắng chan hoà miền trời thanh câm tú, ngỡ ngàng tựa như bước trên bồng lai. Mong quên đời phàm trần còn nhiều trên vai, tranh giành như thế tốt hơn làm người. ĐK1: Đời nam nhi chí trai dọc ngang núi sông, dù gian khó quyết không nao núng lòng. Đường ta đi chông gai không làm nhụt chí hiên ngang, đường thênh thang bước chân vui miệt mài. ĐK2: Đàn réo rắt chất ngất bầu không gian sẽ xoa dịu ta quên nỗi đau thương trầm luân. Đàn hỡi có nói giúp cho lòng ta xin nhân gian thôi hận thù cho nét môi tươi rạng ngời. Ta vui cùng non bồng lãng du, ta vui cùng bạn đường gió sương. Trọn niềm vui xóa tan đau thương sầu kiếp.\t\t"')
                        expect(video.created).to.equal('2012-6-26')
                        done()
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
                        expect(ns._decodeId(1285971)).to.equal("X1pZVkpYbg")
                        expect(nsSong.official).to.equal(1)
                        expect(nsSong.bitrate).to.equal(320)
                        expect(nsSong.plays).to.match(/\d+/)
                        expect(nsSong.topic).to.equal('Nhạc Trữ Tình')
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
                        expect(album.albumid).to.equal(669367)
                        expect(album.title).to.equal("B-Sides And Other Things I Forgot")
                        expect(album.artist).to.equal("Blue Stahli")
                        expect(album.artistid).to.equal(97145)
                        expect(album.thumbnail).to.equal("http://st.nhacso.net/images/album/2013/05/09/1072071738/136807196518_99_120x120.jpg")
                        expect( album.songs).to.eql([1285687,1285688,1285689,1285690,1285691,1285692,1285693,1285694,1285695,1285696,1285697,1285698])
                        done()
            it 'should contain 12 songs',(done)->
                  link = "http://nhacso.net/album/gettotalsong?listIds=#{album.albumid}"
                  getFileByHTTP link, (data)=>
                        data = JSON.parse data
                        strId = "nsn:album:total:song:id:#{album.albumid}"
                        nsongs = parseInt data.result[strId].TotalSong,10
                        expect(nsongs).to.equal(12)
                        done()
            it 'should be released in 2013 and has description ',(done)->
                  link = "http://nhacso.net/album/getdescandissuetime?listIds=#{album.albumid}"
                  getFileByHTTP link, (data)=>
                        data = JSON.parse(data).result[0]
                        # console.log data
                        released_date = data.IssueTime
                        description = ns.processStringorArray data.AlbumDesc
                        expect(parseInt(released_date,10)).to.equal(2013)
                        expect(description).to.equal("Label: FiXT\r\nGenre: Alternative")
                        done()
            it 'should have been played more than 42 times ',(done)->
                  link = "http://nhacso.net/statistic/albumtotallisten?listIds=#{album.albumid}"
                  getFileByHTTP link, (data)=>
                        data = JSON.parse(data)
                        plays = parseInt(data.result["#{album.albumid}"].totalListen,10)
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
                        expect(video.videoid).to.equal(16040)
                        expect(video.title).to.equal("Người Yêu Cũ")
                        expect(video.artists).to.equal('["Phan Mạnh Quỳnh"]')
                        expect(video.topic).to.equal('Nhạc Trẻ')
                        expect(video.plays).to.be.at.least(1310)
                        expect(video.official).to.equal(1)
                        expect(video.producerid).to.equal(0)
                        expect(video.link).to.match(/http:\/\/st[0-9]{2}\.freesocialmusic\.com\/mp4\/2013\/05\/09\/1430055571\/13680778242_4392\.mp4/)
                        expect(video.thumbnail).to.equal('http://st.nhacso.net/images/video/2013/05/09/1430055571/136807791310_2665_190x110.jpg')
                        expect(video.created).to.equal('2013-5-9 12:37:4')
                        done()
            it 'should have subtitle and 303 second long',(done)->
                  link = "http://nhacso.net/flash/video/xnl/1/id/" + ns._decodeId(video.videoid)
                  # console.log link
                  getFileByHTTP link, (data)=>
                        duration = parseInt(ns.getValueXML(data, "duration", 0).replace(/<\/duration>|<duration>/g,''),10)
                        sublink = ns.getValueXML data, "subUrl", 0
                        expect(duration).to.equal(303)
                        expect(sublink).to.equal("http://nhacso.net/flash/crypting/1/xnl/id/X15RV0M=")
                        done()
describe "THE WEBSITE MUSIC.GO.VN",->
      GM = require '../lib/gomusic'
      gm = new GM()
      describe "Song ID: 183352",->
            it 'should be called "Xa Mất Rồi" by "Thủy Tiên" and has certain properties',(done)->
                  link = "http://music.go.vn/Ajax/SongHandler.ashx?type=getsonginfo&sid=183352"
                  getFileByHTTP link, (data)->
                        gm.connect()
                        gm.connection.query = ->
                        song = gm._storeSong JSON.parse data
                        # console.log song
                        expect(song.SongId).to.equal(183352)
                        expect(song.SongName).to.equal('Xa Mất Rồi')
                        expect(song.ArtistId).to.equal(22054)
                        expect(song.ArtistName).to.equal('Thủy Tiên')
                        expect(song.ArtistDisplayName).to.equal('Thủy Tiên')
                        expect(song.TopicId).to.equal(69)
                        expect(song.TopicName).to.equal('Nhạc Trẻ')
                        expect(song.GenreId).to.equal(50)
                        expect(song.GenreName).to.equal('Dance / Electronic')
                        expect(song.RegionId).to.equal(27)
                        expect(song.RegionName).to.equal('Nhạc Việt Nam')
                        expect(song.Thumbnail).to.equal('/Album/2013/5/9/91FDCFCE4056D4BBB89743E0806A6208.jpg')
                        expect(song.Tags).to.equal('')
                        expect(song.Lyric).to.equal('<p><span>Và giờ này ... Đôi tay em không thể nào giữ lấy</span><br /><span>Từng kỷ niệm ... Mà theo em dần chìm vào quên lãng</span><br /><span>Cho nỗi buồn... Từng đêm kéo đến ... Và khiến nỗi nhớ như dài thêm</span><br /><br /><span>Còn lại gì ... Từ khi anh ra đi xa em mãi?</span><br /><span>Còn lại gì ... Một mình giờ này lạc trong tê tái ?</span><br /><span>Hỡi người ơi ... Tình yêu chúng ta ... Giờ là khúc ca ... Chẳng thế viết tiếp</span><br /><br /><span>ĐK : Và đến lúc em rời xa ... Con tim anh mới nhận ra</span><br /><span>Khoảnh khắc có em kề bên ... Ôi bao nhiêu phút êm đềm ...</span><br /><span>Mình đã xa mất rồi ... xa mất rồi ...</span><br /><span>Tìm đâu hơi ấm những lúc ta mặn nồng ...</span><br /><br /><span>Khoảnh khắc xa rời nhau ... anh buông đôi tay thật mau</span><br /><span>Dù biết em còn yêu ... Nhưng anh chẳng muốn quay lại ...</span><br /><span>Bỏ mặc em với nỗi đau ... Với kỉ niệm</span><br /><span>Tìm đâu hơi ấm, ký ức của hôm nào</span><br /><span>Đã xa mất rồi ...</span></p>')
                        expect(song.FilePath).to.equal('UserFiles/2013/5/9/zorba11/20130509105933.mp3')
                        expect(song.Bitrate).to.equal(320)
                        expect(song.Duration).to.equal(248)
                        expect(song.FileSize).to.equal(9928620)
                        expect(song.PlayCount).to.be.at.least(32)
                        expect(song.CreateTime).to.equal('2013-05-09')
                        expect(song.UpdateTime).to.equal('2013-05-09')
                        done()
      describe "Album ID: 18963",->
            it 'should be called "Có Bao Điều" by "Tiêu Châu Như Quỳnh" and has certain properties ',(done)->
                  link = "http://music.go.vn/Ajax/AlbumHandler.ashx?type=getinfo&album=18963"
                  getFileByHTTP link, (data)->
                        gm.connect()
                        gm.connection.query = ->
                        album = gm._storeAlbum JSON.parse(data)
                        expect(album.AlbumId).to.equal(18963)
                        expect(album.AlbumName).to.equal('Có Bao Điều')
                        expect(album.MasterArtistId).to.equal(31996)
                        expect(album.MasterArtistName).to.equal('Tiêu Châu Như Quỳnh')
                        expect(album.TopicId).to.equal(69)
                        expect(album.TopicName).to.equal('Nhạc Trẻ')
                        expect(album.GenreId).to.equal(3)
                        expect(album.GenreName).to.equal('Pop')
                        expect(album.RegionId).to.equal(27)
                        expect(album.RegionName).to.equal('Nhạc Việt Nam')
                        expect(album.Duration).to.equal(1212)
                        expect(album.ReleaseDate).to.equal('2013-01-01')
                        expect(album.Tags).to.equal('')
                        expect(album.Thumbnail).to.equal('/Album/2013/5/8/4DBA6D485070AE248339AEC2C3B9DB14.jpg')
                        expect(album.Description).to.equal('<p><span>Album "C&oacute; bao điều" gồm 5 b&agrave;i h&aacute;t l&agrave; những giai điệu hiện đại thể hiện m&agrave;u sắc tươi tắn của tuổi trẻ, chứa chan t&igrave;nh cảm của một người con g&aacute;i y&ecirc;u đời.</span><br /><br /><span>Trong đ&oacute; c&oacute; 4 b&agrave;i do ch&iacute;nh Như Quỳnh s&aacute;ng t&aacute;c, ca kh&uacute;c "C&oacute; bao điều" viết về đề t&agrave;i x&atilde; hội với trăn trở của một c&ocirc; g&aacute;i trẻ qua những mảnh đời k&eacute;m may mắn v&agrave; niềm tin về một ng&agrave;y mai tươi s&aacute;ng hơn, "Đ&ocirc;i mắt đen" th&igrave; lại mang giai điệu nhẹ nh&agrave;ng, s&acirc;u lắng được Như Quỳnh s&aacute;ng t&aacute;c trong những năm học lớp 12 để d&agrave;nh tặng cho một người bạn th&acirc;n của m&igrave;nh, "Khoảng c&aacute;ch của đ&ocirc;i ta" chứa đựng cảm x&uacute;c day dứt khi hai người y&ecirc;u nhau m&agrave; kh&ocirc;ng thể đến với nhau do những định kiến khắc nghiệt của x&atilde; hội...</span></p>')
                        expect(album.SongCount).to.equal(5)
                        expect(album.PlayCount).to.be.at.least(1)
                        expect(album.CreateTime).to.equal('2013-05-08')
                        expect(album.UpdateTime).to.equal('2013-05-09')
                        done()
describe "THE WEBSITE NHAC.VUI.VN",->
      NV = require '../lib/nhacvui'
      nv = new NV()
      describe "Song ID: 318186",->
            it 'should be called "Anh Sẽ Quên" by "MT Phan" and has link property',(done)->
                  id = 318186
                  link = "http://hcm.nhac.vui.vn/asx2.php?type=1&id=#{id}"
                  getFileByHTTP link, (data)->
                        nv.getSongStats = ->
                        xml2js = require 'xml2js'
                        parser = new xml2js.Parser()
                        parser.parseString data, (err, result) =>
                              song = result.rss.channel[0].item[0]
                              song = nv._storeSong id, song
                              expect(song.song_name).to.equal('Anh Sẽ Quên')
                              expect(song.artist_name).to.equal('MT Phan')
                              expect(song.link).to.match(/http:\/\/music-hcm\.24hstatic\.com\/uploadmusic2\/[0-9a-f]{32}\/[0-9a-f]{8}\/uploadmusic\/id_chan\/2-2013\/huylun\/Rap\/NewTrack\/128\/Anh Se Quen - MT Phan\.mp3/)
                              done()
            it 'should have author, plays, topic, lyric properties',(done)->
                  id = 318186
                  link = "http://hcm.nhac.vui.vn/-m#{id}c2p1a1.html"
                  getFileByHTTP link, (data)->
                        item =
                              song_name : ""
                              artist_name : ""
                              link : ""
                        song = nv.processSongCallback id, data, item
                        expect(parseInt(song.plays,10)).to.be.at.least(22)
                        expect(song.topic).to.equal('Rap Việt')
                        expect(song.author).to.equal('Rap Việt')
                        expect(song.lyric).to.match(/Anh sẽ quên - MT Phan.+một mình ỡ nơi góc tối.. lòng lại buồn.+chĩ là do anh tưỡng tượng ra trong cơn mê.+ anh viết về em/)
                        done()
      describe "Album ID: 26989",->
            it 'should be called "April\'s Spring" by "Forty" and has certain properties ',(done)->
                  id = 26989
                  link = "http://hcm.nhac.vui.vn/-a#{id}p1.html"
                  getFileByHTTP link, (data)->
                        result = nv.processAlbumData id, data
                        expect(result.album.aid).to.equal(26989)
                        expect(result.album.album_name).to.equal('April\'s Spring')
                        expect(result.album.album_artist).to.equal('Forty')
                        expect(result.album.topic).to.equal('Nhạc Hàn Quốc')
                        expect(parseInt(result.album.plays,10)).to.be.at.least(39)
                        expect(parseInt(result.album.nsongs,10)).to.equal(2)
                        expect(result.album.thumbnail).to.equal('http://nv-ad-hcm.24hstatic.com/upload/album/2-2013/1366001419_Aprils-Spring-Album-40-(Forty).jpg')
                        expect(result.album.created).to.equal('2013-4-1 11:50:19')
                        expect(result.songids).to.eql([ '314212', '314211' ])
                        done()
describe "THE WEBSITE CHACHA.VN",->
      Chacha = require '../lib/chacha'
      chacha = new Chacha()
      describe "Song ID: 614150",->
            it 'should be called "Lòng mẹ" by "Khánh Ly" and has certain properties',(done)->
                  id = 614150
                  link = "http://www.chacha.vn/song/play/#{id}"
                  getFileByHTTP link, (data)->
                        data = JSON.parse data
                        chacha.connect()
                        chacha.connection.query = ->
                        chacha.end()
                        song = chacha._storeSong data
                        expect(parseInt(song.songid,10)).to.equal(614150)
                        expect(song.song_name).to.equal('Lòng mẹ')
                        expect(song.artistid).to.equal(206)
                        expect(song.artist_name).to.equal('Khánh Ly')
                        expect(song.duration).to.equal(335)
                        expect(song.bitrate).to.equal(128)
                        expect(song.thumbnail).to.equal('http://s2.chacha.vn/artists//s5/206/206.jpg?v=0')
                        expect(song.link).to.equal('http://audio.chacha.vn/songs/output/74/614150/2/s/ - .mp3?s=1')
                        done()
      describe "Album ID: 9456",->
            it 'should be called "Xin Còn Gọi Tên Nhau" by "Tình Khúc Trường Sa" and has certain properties ',(done)->
                  id = 9456
                  link = "http://www.chacha.vn/album/fake-link,#{id}.html"
                  getFileByHTTP link, (data)->
                        options =
                          id : id
                        album = chacha.processAlbum data, options
                        expect(album.albumid).to.equal(9456)
                        expect(album.album_name).to.equal('Xin Còn Gọi Tên Nhau')
                        expect(album.album_artist).to.equal('Tình Khúc Trường Sa')
                        expect(album.nsongs).to.equal(11)
                        expect(album.thumbnail).to.equal('http://s2.chacha.vn/albums//s2/1/9456/9456.jpg')
                        expect(album.plays).to.be.at.least(93)
                        expect(album.description).to.equal("")
                        expect(album.songs).to.eql([ '535549', '611624', '611630', '611634', '443173', '611636', '611638', '611642', '611644', '611650', '611652' ])
                        done()
describe "THE WEBSITE NGHENHAC.INFO",->
      Nghenhac = require '../lib/nghenhac'
      nghenhac = new Nghenhac()
      describe "Song ID: 12600",->
            it 'should be called "Cây guitar ngày hôm qua" by "Quách Thành Danh" and has certain properties',(done)->
                  id = 12600
                  link = "http://nghenhac.info/joke/#{id}/joke.html"
                  getFileByHTTP link, (data)->
                        options =
                          id : id
                        song = nghenhac.processSong data, options
                        expect(song.id).to.equal(12600)
                        expect(song.encoded_id).to.equal("F95CF637BF2C1067")
                        expect(song.name).to.equal('Cây guitar ngày hôm qua')
                        expect(song.artist_id).to.equal('6303')
                        expect(song.artist).to.equal('Quách Thành Danh')
                        expect(song.author).to.equal('')
                        expect(song.albumid).to.equal('40')
                        expect(song.topic).to.equal('["Nhạc Hải Ngoại"]')
                        expect(song.plays).to.be.at.least(40)
                        expect(song.lyric).to.equal('Cây đàn guitar của ngày hôm qua,đã mua khi tôi lên mươ.Chiều chiều ra sân bâng quơ hát chơi lòng hay ước mơ xa vời.<br>   Tôi mơ làm cánh chim trời, phiêu du vờn bay khắp nơi,sánh bước bên em tôi đâu ngờ tới .<br>   Cây đàn guitar của ngày hôm qua, bạn thân yêu trong cuộc đời .<br>   Buồn buồn ra sân bâng quơ hát chơi mẹ tôi lắng nghe miệng cười .<br>   Tôi mơ một đêm trăng rằm guitar cùng em hát ca,ước muốn xa xôi tôi đâu ngờ tới .Ôi guitar của tôi.<br>   Tháng năm vụt qua mau, mẹ tôi nay tóc điểm bạc màu sương gió . Có ai nào ngờ đâu em đã đến,đến bên tôi cho đời xanh mãi .<br>   Tháng năm dần trôi mau,mẹ tôi nay tóc điểm bạc màu sương gió .Có ai nào ngờ đâu emđã đến ,đến bên tôi cho đời xanh mãi .<br>  Gay đàn cuitar của ngày hôm qua giờ đây xác thân hao gầy . Dòng đời cứ thế bon chen khắp nơi một hôm bước chân rã rời .<br>  khi tim mình thôi mơ mộng trên môi can khô tiếng ca<br>  Nhức nhối trong tim hư danh tàn úa . Ôi guitar của tôi . Ôi guitar của tôi..........<br>')
                        expect(song.link).to.equal('http://data20.nghenhac.info/magpie/anhso/magolon.net/qtd/qtd_cayguitarngayhomqua.mp3')
                        done()
      describe "Album ID: 21159",->
            it 'should be called "Tay đấm huyền thoại IV (Rocky IV)" by "Various Artists" and has certain properties',(done)->
                  id = 21159
                  link = "http://nghenhac.info/Album/joke-link/#{id}/.html"
                  getFileByHTTP link, (data)->
                        options =
                          id : id
                        album = nghenhac.processAlbum data, options
                        expect(album.id).to.equal(21159)
                        expect(album.encoded_id).to.equal('2DE1BC9C93DC64BE')
                        expect(album.name).to.equal('Tay đấm huyền thoại IV (Rocky IV)')
                        expect(album.artist).to.equal('Various Artists')
                        expect(album.topic).to.equal('["Nhạc Phim","Quốc Tế"]')
                        expect(album.nsongs).to.be.at.least(10)
                        expect(album.plays).to.at.least(0)
                        expect(album.thumbnail).to.equal('http://img.nghenhac.info/Album/21159.jpg')
                        expect(album.songs).to.eql([ '287141','287140','287139','287138','287137','287136','287135','287134','287133','287132' ])
                        done()
describe "THE WEBSITE KEENG.VN",->
      # Keeng = require '../lib/keeng'
      # keeng = new Keeng()
      describe "Album ID: 0CK929BT",->
            it 'should be called "Quang Lê: Tiếng Hát Người Xa Xứ" and has 28 songs',(done)->
                  id = "0CK929BT"
                  link = "http://www.keeng.vn/album/get-album-xml?album_identify=#{id}"
                  getFileByHTTP link, (data)->
                        album =
                          id : "0CK929BT"
                          title : "Quang Lê: Tiếng Hát Người Xa Xứ"
                          artist_name : "Quang Lê"
                        Encoder = require('node-html-encoder').Encoder
                        encoder = new Encoder('entity');
                        data = data.replace(/\r/g,'')
                        titles = data.match(/\<title\>.+\<\/title\>/g)
                        locations = data.match(/\<location\>.+\<\/location\>/g)
                        ids = data.match(/\<info\>.+\<\/info\>/g)
                        songs = []
                        if locations isnt null
                              for i in [0..locations.length-1]
                                    song =
                                          albumid : album.id
                                          album_name : encoder.htmlDecode album.title
                                          songid : ids[i+1].replace(/\<info\>/,'').replace(/<\/info\>/,'').trim()
                                          song_name : encoder.htmlDecode titles[i+1].replace(/\<title\>/,'').replace(/<\/title\>/,'').trim()
                                          song_link : locations[i].replace(/\<location\>/,'').replace(/<\/location\>/,'').trim()
                                          artist_name : encoder.htmlDecode album.artist_name
                                    if song.song_link.match(/\d{4}\/\d{2}\/\d{2}/) isnt null then song.created = song.song_link.match(/\d{4}\/\d{2}\/\d{2}/)[0].replace(/\//g,'-')
                                    songs.push song
                        expect(songs.length).to.equal(23)
                        expect(songs[0].albumid).to.equal("0CK929BT")
                        expect(songs[0].album_name).to.equal("Quang Lê: Tiếng Hát Người Xa Xứ")
                        expect(songs[0].songid).to.equal("92BF4C8D")
                        expect(songs[0].song_name).to.equal('Đôi Mắt Người Xưa')
                        expect(songs[0].song_link).to.equal('http://media.keeng.vn/medias/audio/2012/04/15/14/doi-mat-nguoi-xua-166805.mp3')
                        expect(songs[0].artist_name).to.equal("Quang Lê")
                        expect(songs[0].created).to.equal('2012-04-15')
                        done()

describe "THE WEBSITE NHACCUATUI.COM",->
      Nhaccuatui = require '../lib/nhaccuatui'
      nhaccuatui = new Nhaccuatui()
      describe "Song ID: W5JMxHZr08Sb",->
            it 'should be called "Ván Cờ Cuối Cùng" by "Afan","YunjBoo" and has certain properties',(done)->
                  song =
                        id : 2529341
                        key : "W5JMxHZr08Sb"
                  link = "http://www.nhaccuatui.com/bai-hat/joke-link.#{song.key}.html"
                  # console.log link
                  getRedirectFileByHTTP link, (data)->
                        options =
                              id : song.id
                              key : song.key
                        nhaccuatui.processSimilarSongs = ->
                        # console.log "asdasd"
                        # console.log data
                        song = nhaccuatui.processSong data, options
                        # console.log song
                        expect(song.id).to.equal(2529341)
                        expect(song.key).to.equal("W5JMxHZr08Sb")
                        expect(song.title).to.equal('Ván Cờ Cuối Cùng')
                        expect(song.artists).to.equal('["Afan","YunjBoo"]')
                        expect(song.topic).to.equal('Rap Việt')
                        expect(song.bitrate).to.equal('320')
                        expect(song.type).to.equal('song')
                        expect(song.link_key).to.equal('d4304846929dab954e4f823d40a2d2a6')
                        expect(song.lyric).to.equal('Mel:\n<br />Ngày đánh mất tình yêu em mới hiểu\n<br />Và em biết em đã sai thật nhiều.\n<br />Buông đôi tay, dẫu đang nắm thật chặt\n<br />Tìm vui mới …với những nối đau.\n<br />Đêm đêm dòng lệ ướt trên mi\n<br />Vì ngày qua đã không, cố giữ lấy.\n<br />Nuốt nước mắt, sâu trong lòng\n<br />Xin người thứ tha…\n<br />\n<br />Verse 1:\n<br />Thôi baby àh..- mọi chuyện đã vậy rồi\n<br />Có hối hận..- hay tiếc nuối..-cũng ko thay đổi\n<br />Từng là người mà em yêu nhất…- nay bây giờ cũng chính làm em đau\n<br />Hãy lau khô những giọt nước mắt..- để anh ko thấy em thêm sầu\n<br />Ván cờ ngày hôm nay….- là do anh sai đi nước bước\n<br />Ko thể lường trước mọi việc xảy ra..- quên em đi..-là bắt buộc\n<br />Vì ta đã từng ..- Đúng\n<br />Yêu nhau thật nhìu ..-Đúng\n<br />Xoá tan 1 phút chỉ vì câu nói anh ko còn yêu….-huh’\n<br />Em hãy đi đi..-anh sẽ chờ đợi dù rất đau đớn\n<br />Nói lời tạm biệt..-gởi vài lời chúc..- dù biết ai đó đang rất giận hờn\n<br />Anh sẽ ko vậy đâu..-sẽ ko mềm lòng đau\n<br />Buông tay em yêu là cách tốt nhất..-để cho sợi dây kia..-ko còn rời nhau\n<br />Thắc mắc vì tại sao..- yêu nhau rồi như thế\n<br />Trả lời 1 câu rằng : Vì Anh Đây Ko Thể\n<br />Afan à…- mày rất ngu ngốc\n<br />Có rồi ko biết gìn giữ..-để bây giờ lạc mất..- rồi mày ngồi khóc …..! \n<br />\n<br />\n<br />Mel:\n<br />Ngày đánh mất tình yêu em mới hiểu\n<br />Và em biết em đã sai thật nhiều.\n<br />Buông đôi tay, dẫu đang nắm thật chặt\n<br />Tìm vui mới …với những nối đau.\n<br />Đêm đêm dòng lệ ướt trên mi\n<br />Vì ngày qua đã không, cố giữ lấy.\n<br />Nuốt nước mắt, sâu trong lòng\n<br />Xin người thứ tha…\n<br />\n<br />\n<br />Verse 2 :\n<br />Và ver 2 này..- trước tiên anh gởi lời xin lỗi\n<br />Xin lỗi tất cả..- vì tình yêu này..- anh ko muốn nói [Goodbye]\n<br />Trao nhau nhiều lắm…-rồi yêu nhìu lắm..-tại sao mình ko biết giữ\n<br />Để rồi 1 ngày cả 2 mất hết…-đợi chờ 1 lần để tha thứ\n<br />Ko cần nữa..-vì chính bản thân anh thay đổi\n<br />Em đã cố..-giải thích tất cả tại sao ko nghe…-anh là thằng tồi\n<br />Em…- đừng miễn cưỡng nữa ?\n<br />Vì cái tình cảm..-đã ko còn giá trị..-nó chỉ là thừa\n<br />Hãy cố đi tìm 1 người tốt hơn…- xin đừng bao giờ nhắc anh nữa\n<br />Khoảng trống mòn mỏi đợi chờ lấp đầy..-ko bao giờ ..-nó được chất chứa\n<br />Vì sao đêm nay…-Cái ngôi saoem thích nhất\n<br />Nó cũng xoá đi..-chạy theo thời gian..-mà bao lâu qua anh đã tích cực…rồi\n<br />Soi sáng cho em..-một con đường riêng..- và hạnh phúc\n<br />Bước chân anh đã chậm nhịp\n<br />quay lại nhìn anh thầm chúc\n<br />Tất cả trở lại ban đầu..- bàn tay ngày xưa..-nhường người đến sau\n<br />Kết thúc ở sau màn mưa…-nhìn lại quá khứ..-chỉ có mình anh ngồi thầm khắc sâu…!\n<br />\n<br />[Bridge]:\n<br />Sẽ còn sẽ còn sẽ còn\n<br />Những ký ức xưa…\n<br />Chỉ còn chỉ còn\n<br />Mình em với đêm\n<br />Từng nỗi nhớ thoáng qua đêm đêm\n<br />Một lần nỡ đánh mất con tim anh\n<br />Để giờ em bơ vơ ngậm ngùi\n<br />Bên em nỗi nhớ…!\n<br />\n<br />Mel :\n<br />Ngày đánh mất tình yêu em mới hiểu\n<br />Và em biết em đã sai thật nhiều.\n<br />Buông đôi tay, dẫu đang nắm thật chặt\n<br />Tìm vui mới …với những nối đau.\n<br />Đêm đêm dòng lệ ướt trên mi\n<br />Vì ngày qua đã không, cố giữ lấy.\n<br />Nuốt nước mắt, sâu trong lòng\n<br />Xin người thứ tha…')
                        done()
            it 'should be played at least 3816 times',(done)->
                  id = 2529341
                  link = "http://www.nhaccuatui.com/wg/get-counter?listSongIds=#{id}"
                  getFileByHTTP link, (data)->
                        data = JSON.parse data
                        song = data.data.songs
                        expect(song[id]).to.be.at.least(3816)
                        done()
      describe "Album ID: 0nXnIALOOIP2",->
            it 'should be called "Tuyết Lạnh (2013)" by "Thúy Vy", "Lương Mạnh Hùng" and has certain properties',(done)->
                  album =
                        id : 11997829
                        key : "0nXnIALOOIP2"
                  link = "http://www.nhaccuatui.com/playlist/joke-link.#{album.key}.html"
                  # console.log link
                  getRedirectFileByHTTP link, (data)->
                        options =
                              id : album.id
                              key : album.key
                              plays : 0 # the plays will be tested later
                        album = nhaccuatui.processAlbum data, options
                        # console.log album
                        expect(album.id).to.equal(11997829)
                        expect(album.key).to.equal("0nXnIALOOIP2")
                        expect(album.title).to.equal('Tuyết Lạnh (2013)')
                        expect(album.artists).to.equal('["Thúy Vy","Lương Mạnh Hùng"]')
                        expect(album.topic).to.equal('Trữ Tình')
                        expect(album.nsongs).to.equal(3)
                        expect(album.thumbnail).to.equal('http://p.img.nct.nixcdn.com/playlist/2013/04/25/e/5/8/5/1366902514487.jpg')
                        expect(album.link_key).to.equal('1ffc9e71de0805c18a588165a200b008')
                        expect(album.created).to.equal('2013-04-25 22:8:34')
                        expect(album.songs).to.eql([ { id: '2505185', key: 'MCFGGOJ52cLM' },{ id: '2505189', key: 'PZAjh6mFUDhR' },{ id: '2507968', key: 'pxdnb4Wgb9gv' } ])
                        done()
            it 'should be played at least 1158 times',(done)->
                  id = 11997829
                  link = "http://www.nhaccuatui.com/wg/get-counter?listPlaylistIds=#{id}"
                  getFileByHTTP link, (data)->
                        data = JSON.parse data
                        album = data.data.playlists
                        expect(album[id]).to.be.at.least(1158)
                        done()



      describe "Video ID : UJ7TXPPXNkMB",->
            it 'should be called "Đi Tìm Lại Chính Anh" by "Only T, Kaisoul, Alyboy, Trinh Py" and has certain properties',(done)->
                  video =
                        id : 2612146
                        key : "UJ7TXPPXNkMB"
                  link = "http://www.nhaccuatui.com/video/joke-link.#{video.key}.html"
                  getRedirectFileByHTTP link, (data)->
                        options =
                              id : video.id
                              key : video.key
                        video = nhaccuatui.processVideo data, options
                        expect(video.id).to.equal(2612146)
                        expect(video.key).to.equal("UJ7TXPPXNkMB")
                        expect(video.title).to.equal('Đi Tìm Lại Chính Anh')
                        expect(video.artists).to.equal('["Only T","Kaisoul","Alyboy","Trinh Py"]')
                        expect(video.topic).to.equal('["Việt Nam","Rap Việt"]')
                        # expect(video.bitrate).to.equal('320')
                        expect(video.type).to.equal('mv')
                        expect(video.thumbnail).to.equal('http://m.img.nct.nixcdn.com/mv/2013/06/20/8/0/e/d/1371661683442_640.jpg')
                        expect(video.link_key).to.equal('baae98a4bd1c7ba3e1bc6640f36f5af0')
                        # new version in June 2013 does not support lyric of videos
                        expect(video.lyric).to.equal('')
                        done()

      describe "Videos from Nhạc Trẻ category: page 1",->
            it 'should have 30 songs with KEYs', (done)->
                  link = "http://www.nhaccuatui.com/video-am-nhac-viet-nam-nhac-tre.html"
                  getFileByHTTP link, (data)->
                        options =
                              link : "video-am-nhac-viet-nam-nhac-tre"
                        videos = nhaccuatui.getVideosFromData data, options
                        expect(videos.length).to.equal(30)
                        
                        done()

