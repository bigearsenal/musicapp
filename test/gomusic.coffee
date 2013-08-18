getFileByHTTP = require('./utils').getFileByHTTP
chai = require "chai"
expect = chai.expect
describe "THE WEBSITE MUSIC.GO.VN",->
      GM = require '../lib/gomusic'
      gm = new GM()
      # console.log gm

      describe "Song ID: 183352",->
            it 'should be called "Xa Mất Rồi" by "Thủy Tiên" and has certain properties',(done)->
                  link = "http://music.go.vn/Ajax/SongHandler.ashx?type=getsonginfo&sid=183352"
                  getFileByHTTP link, (data)->
                        gm.connect()
                        gm.connection.query = ->
                        song = gm._storeSong JSON.parse data
                        # console.log song
                        expect(song.id).to.equal(183352)
                        expect(song.title).to.equal('Xa Mất Rồi')
                        expect(song.artistid).to.equal(22054)
                        expect(song.artists).to.eql(["Thủy Tiên"])
                        expect(song.artist_display).to.eql(["Thủy Tiên"])
                        expect(song.topicid).to.equal(69)
                        expect(song.topics).to.eql(["Nhạc Trẻ"])
                        expect(song.genreid).to.equal(50)
                        expect(song.genres).to.eql(["Dance","Electronic"])
                        expect(song.regionid).to.equal(27)
                        expect(song.regions).to.eql(["Nhạc Việt Nam"])
                        expect(song.coverart).to.equal('/Album/2013/5/9/91FDCFCE4056D4BBB89743E0806A6208.jpg')
                        expect(song.tags).to.eql([ '' ])
                        expect(song.lyric).to.equal('<p><span>Và giờ này ... Đôi tay em không thể nào giữ lấy</span><br /><span>Từng kỷ niệm ... Mà theo em dần chìm vào quên lãng</span><br /><span>Cho nỗi buồn... Từng đêm kéo đến ... Và khiến nỗi nhớ như dài thêm</span><br /><br /><span>Còn lại gì ... Từ khi anh ra đi xa em mãi?</span><br /><span>Còn lại gì ... Một mình giờ này lạc trong tê tái ?</span><br /><span>Hỡi người ơi ... Tình yêu chúng ta ... Giờ là khúc ca ... Chẳng thế viết tiếp</span><br /><br /><span>ĐK : Và đến lúc em rời xa ... Con tim anh mới nhận ra</span><br /><span>Khoảnh khắc có em kề bên ... Ôi bao nhiêu phút êm đềm ...</span><br /><span>Mình đã xa mất rồi ... xa mất rồi ...</span><br /><span>Tìm đâu hơi ấm những lúc ta mặn nồng ...</span><br /><br /><span>Khoảnh khắc xa rời nhau ... anh buông đôi tay thật mau</span><br /><span>Dù biết em còn yêu ... Nhưng anh chẳng muốn quay lại ...</span><br /><span>Bỏ mặc em với nỗi đau ... Với kỉ niệm</span><br /><span>Tìm đâu hơi ấm, ký ức của hôm nào</span><br /><span>Đã xa mất rồi ...</span></p>')
                        expect(song.link).to.equal('UserFiles/2013/5/9/zorba11/20130509105933.mp3')
                        expect(song.bitrate).to.equal(320)
                        expect(song.duration).to.equal(248)
                        expect(song.size).to.equal(9928620)
                        expect(song.plays).to.be.at.least(32)
                        expect(song.date_created).to.equal('2013-05-09')
                        expect(song.date_updated).to.equal('2013-05-09')
                        done()
      describe "Album ID: 18963",->
            it 'should be called "Có Bao Điều" by "Tiêu Châu Như Quỳnh" and has certain properties ',(done)->
                  link = "http://music.go.vn/Ajax/AlbumHandler.ashx?type=getinfo&album=18963"
                  getFileByHTTP link, (data)->
                        gm.connect()
                        gm.connection.query = ->
                        gm.utils.printUpdateRunning = ->
                        album = gm._storeAlbum JSON.parse(data)
                        # console.log album
                        expect(album.id).to.equal(18963)
                        expect(album.title).to.equal('Có Bao Điều')
                        expect(album.artistid).to.equal(31996)
                        expect(album.artists).to.eql(['Tiêu Châu Như Quỳnh'])
                        expect(album.topicid).to.equal(69)
                        expect(album.topics).to.eql(['Nhạc Trẻ'])
                        expect(album.genreid).to.equal(3)
                        expect(album.genres).to.eql(['Pop'])
                        expect(album.regionid).to.equal(27)
                        expect(album.regions).to.eql(['Nhạc Việt Nam'])
                        expect(album.duration).to.equal(1212)
                        expect(album.date_released).to.equal('2013-01-01')
                        expect(album.tags).to.eql([''])
                        expect(album.coverart).to.equal('/Album/2013/5/8/4DBA6D485070AE248339AEC2C3B9DB14.jpg')
                        expect(album.description).to.match(/là những giai điệu hiện đại thể hiện màu sắc tươi tắn của tuổi trẻ, chứa chan tình cảm của một người con gái yêu đời/)
                        expect(album.nsongs).to.equal(5)
                        expect(album.plays).to.be.at.least(1)
                        expect(album.date_created).to.equal('2013-05-08')
                        expect(album.date_updated).to.equal('2013-05-09')
                        done()