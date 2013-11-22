getRedirectFileByHTTP = require('./utils').getRedirectFileByHTTP
getFileByHTTP = require('./utils').getFileByHTTP
chai = require "chai"
expect = chai.expect
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
                        expect(song.artists).to.eql(["Afan","YunjBoo"])
                        expect(song.topics).to.eql(['Rap Việt'])
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
                        expect(album.title).to.equal('Tuyết Lạnh')
                        expect(album.artists).to.eql(["Thúy Vy","Lương Mạnh Hùng"])
                        expect(album.topics).to.eql(['Trữ Tình'])
                        expect(album.nsongs).to.equal(3)
                        expect(album.coverart).to.equal('http://p.img.nct.nixcdn.com/playlist/2013/11/06/c/c/a/8/1383713236078.jpg')
                        expect(album.link_key).to.equal('1ffc9e71de0805c18a588165a200b008')
                        expect(album.date_created).to.equal('2013-11-06 11:47:16')
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
                        # console.log video
                        expect(video.id).to.equal(2612146)
                        expect(video.key).to.equal("UJ7TXPPXNkMB")
                        expect(video.title).to.equal('Đi Tìm Lại Chính Anh')
                        expect(video.artists).to.eql(["Only T","Kaisoul","Alyboy","Trinh Py"])
                        expect(video.topics).to.eql(["Việt Nam","Rap Việt"])
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
