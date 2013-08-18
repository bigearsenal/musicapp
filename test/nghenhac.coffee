getFileByHTTP = require('./utils').getFileByHTTP
chai = require "chai"
expect = chai.expect
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
                        # console.log song
                        expect(song.id).to.equal(12600)
                        expect(song.key).to.equal("F95CF637BF2C1067")
                        expect(song.title).to.equal('Cây guitar ngày hôm qua')
                        expect(song.artistid).to.equal(6303)
                        expect(song.artists).to.eql(['Quách Thành Danh'])
                        expect(song.authors).to.eql(null)
                        expect(song.albumid).to.equal('40')
                        expect(song.topics).to.eql(["Nhạc Hải Ngoại"])
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
                        expect(album.key).to.equal('2DE1BC9C93DC64BE')
                        expect(album.title).to.equal('Tay đấm huyền thoại IV (Rocky IV)')
                        expect(album.artists).to.eql(['Various Artists'])
                        expect(album.topics).to.eql(["Nhạc Phim","Quốc Tế"])
                        expect(album.nsongs).to.be.at.least(10)
                        expect(album.plays).to.at.least(0)
                        expect(album.coverart).to.equal('http://img.nghenhac.info/Album/21159.jpg')
                        expect(album.songids).to.eql([ 287141,287140,287139,287138,287137,287136,287135,287134,287133,287132 ])
                        done()