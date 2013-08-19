getFileByHTTP = require('./utils').getFileByHTTP
chai = require "chai"
expect = chai.expect
describe 'THE WEBSITE CHIASENHAC', ->
      CSN = require '../lib/chiasenhac'
      csn = new CSN()
      song = {}
      describe 'Song ID: 1125631', ->
            it 'should be called "Nỗi Đau Ngự Trị (Extended Mix)" and has certain properties ',(done) ->
                  csn.connect()
                  id = 1125631
                  link = "http://download.chiasenhac.com/download.php?m=#{id}"
                  getFileByHTTP link, (data)->
                        options = 
                              id : id
                        song = csn.processSong data,options
                        expect(song.title).to.equal("Nỗi Đau Ngự Trị (Extended Mix)")
                        expect(song.artists).to.eql(["Lệ Quyên","DJ Triệu Lador"])
                        expect(song.topics).to.eql(["Việt Nam","Dance","Remix"])
                        expect(song.downloads).to.be.at.least(11)
                        expect(song.href).to.equal("http://chiasenhac.com/mp3/vietnam/v-dance-remix/noi-dau-ngu-tri-extended-mix~le-quyen-dj-trieu-lador~1125631.html")
                        expect(song.is_lyric).to.equal(1)
                        expect(song.date_created).to.match(/2013-0?8-17/)
                        
                        done()
      describe 'Song ID: 1125317', ->
            it 'should be called "Tôi Muốn Quên Người" and has certain stats and its albums properties ',(done) ->
                  csn.connect()
                  id = 1125317
                  link = "http://chiasenhac.com/mp3/vietnam/v-pop/toi-muon-quen-nguoi~the-son~#{id}.html"
                  getFileByHTTP link, (data)->
                        options = 
                              id : id
                              song : {}
                        song = csn.processSongStats data,options
                        # console.log song
                        expect(song.authors).to.eql(["Khánh Băng","Vũ Khanh"])
                        expect(song.album_title).to.equal("Những Tình Khúc Chọn Lọc")
                        expect(song.album_href).to.equal("http://playlist.chiasenhac.com/nghe-album/toi-muon-quen-nguoi~the-son~1125317.html")
                        expect(song.album_coverart).to.equal("http://data.chiasenhac.com/data/cover/9/8719.jpg")
                        expect(song.producer).to.equal("Thuý Nga TNCD156 (1998)")
                        expect(song.plays).to.be.at.least(0)
                        expect(song.date_released).to.equal("1998")
                        expect(song.lyric).to.equal("Tôi muốn quên em khi đường đời mình không chung lối <br />\nTôi muốn quên em khi câu thề em đã quên rồi <br />\nTôi muốn quên em vì sầu thương ngày đêm tàn phá <br />\nTôi muốn quên em vì đời tôi luống phong ba.<br />\n<br />\nTôi muốn xa em, xa kỷ niệm làm tôi ray rứt <br />\nTôi muốn xa em, xa cuộc tình lịm chết trong đời <br />\nTôi muốn xa em, xa đôi môi hồng nhiều gian nhiều dối <br />\nTôi muốn xa em, thôi nhé đừng nói yêu tôi.<br />\n<br />\nRồi tình yêu thương ấy chốn thiên đường hồn hoa lạc lối <br />\nTình yêu thương ấy biết đâu rằng em lừa dối <br />\nThôi đã hết rồi, đã hết rồi <br />\nThì tại sao người còn sống trong tôi <br />\n<br />\ncho mình đau xót thêm thôi. <br />\n<br />\nTôi muốn quên em trong men rượu nồng mềm môi cay đắng <br />\nTôi muốn quên em trong cuộc tình hồng đêm trắng quên đời <br />\nTôi biết yêu em như đem đời mình dìm trong ngục tối <br />\nTôi muốn quên em cho chết trọn kiếp đơn côi.")
                        done()