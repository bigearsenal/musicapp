getFileByHTTP = require('./utils').getFileByHTTP
chai = require "chai"
expect = chai.expect
describe "THE WEBSITE KEENG.VN",->
      Keeng = require '../lib/keeng'
      keeng = new Keeng()
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
                        expect(songs.length).to.equal(21)
                        expect(songs[0].albumid).to.equal("0CK929BT")
                        expect(songs[0].album_name).to.equal("Quang Lê: Tiếng Hát Người Xa Xứ")
                        expect(songs[0].songid).to.equal("92BF4C8D")
                        expect(songs[0].song_name).to.equal('Đôi Mắt Người Xưa')
                        expect(songs[0].song_link).to.match(/audio\/2012\/04\/15\/14\/doi-mat-nguoi-xua-166805.mp3/)
                        expect(songs[0].artist_name).to.equal("Quang Lê")
                        expect(songs[0].created).to.equal('2012-04-15')
                        done()
      describe "Album ID: LB93R8GU",->
            it 'should be called "Nonstop Lan & Điệp" and has 10 songs',(done)->
                  id = "LB93R8GU"
                  link = "http://www.keeng.vn/album/joke-link/#{id}.html"
                  al = 
                        key : "LB93R8GU"
                        nsongs : 10
                        songids : []
                        date_created : null
                  getFileByHTTP link, (data)->
                        album = keeng.proccessAlbumPage(al,data)
                        # console.log album
                        # console.log JSON.stringify album.songs
                        expect(album.title).to.equal("Nonstop Lan & Điệp")
                        expect(album.artists).to.eql(["Lâm Chấn Khang"])
                        expect(album.description).to.equal('Nhận được phản hồi khá tốt của khán giả về phim ca nhạc "Sóng Gió Truyền Kiếp", để đáp lại tình cảm của quý khán giả yêu mến, khi vừa vừa trở về từ chuyến lưu diễn ở Úc, Lâm Chấn Khang liền cho phát hành album Nonstop sôi động để gửi tặng quý khán giả trong thời gian anh bắt tay thực hiện Phim Ca Nhạc "Sóng Gió Nhân Tâm" Phần 2 & Single sắp tới của mình. Thể loại: Dance. Phát hành: 2013')
                        expect(album.coverart).to.match(/http\:\/\/media3\.keeng\.vn\:[0-9]+\/medias\/images\/images_thumb\/f_medias_6\/album\/image\/2013\/08\/13\/471b6a68185fb3e2136a7a9a8670595e56aee691_208_208\.jpg/)
                        expect(album.plays).to.be.at.least(55105)
                        expect(album.songs).to.eql([{"key":"JW8GX0H7","artists":["Lâm Chấn Khang"],"lyrics":["Chuyến Bay Đi Chuyến Bay Về (Remix)<p>Bóng chiều vừa tàn xuống<br />Em tiễn tôi đi trên chuyến bay về<br />Nghe trong tim nắng chiếu ê trề<br />Chợt nhìn nhau thấy trong lòng nhói đau<br />Mới vừa ngày hôm trước, hai đứa bên nhau trên chuyến bay tình<br />Em đưa tôi thăm chốn quê nhà<br />Mà giờ đây chuyến bay còn mỗi tôi</p><p>[ ĐK ]</p><p>Có chuyến bay đi sẽ có chuyến bay về<br />Giữ trong lòng từng ngày vui có người<br />Em tiễn tôi đi nước mắt tuôn rơi , làm tim tôi thêm rối bời<br />Hãy giữ cho nhau giây phút ngọt ngào<br />Dẫu mai này đời ra sao chẳng màng<br />Hạnh phúc mong manh hạnh phúc đơn sơ<br />Nguyện cầu sao không xóa mờ</p><p>Có chuyến bay đi sẽ có chuyến bay về<br />Chuyến bay nào là chuyến bay cuối cùng<br />Nơi cuối sân ga em vẫy tay chào<br />Chờ anh đi em khóc thầm<br />Cố bước chân đi đau nhói cõi lòng<br />Về bên kia anh rất buồn<br />Mong ước mai sau trên chuyến bay về<br />Được cùng em đến suốt đời<br />Ngắm mây trời cao...!</p>"]},{"key":"HVZP6U4J","artists":["Lâm Chấn Khang"],"lyrics":["Lan Và Điệp (Nonstop Remix)<p>Tôi kể người nghe đời Lan và Điệp, một chuyện tình cay đắng<br />Lúc tuổi còn thơ tôi vẫn thường mộng mơ đem viết thành bài ca<br />Thuở ấy Điệp vui như bướm trắng, say đắm bên Lan<br />Lan như bông hoa ngàn, thương yêu vô vàn,<br />nguyện thề non nước sẽ không hề lìa tan</p><p>Chuông đổ chiều sang , chiều tan trường về,<br />Điệp cùng Lan chung bước<br />Cuối nẻo đường đi, đôi bóng hẹn mùa thi Lan khóc đợi người đi<br />Lần cuối gặp nhau, Lan khẽ nói, thương mãi nghe anh,<br />em yêu anh chân tình nếu duyên không thành,<br />Điệp ơi Lan cắt tóc quên đời vì anh</p><p>Nhưng ai có ngờ, lời xưa đã chứng minh khi đời tan vỡ<br />Lan đau buồn quá khi hay Điệp đã xây mộng gia đình<br />Ai nào biết cho ai, đời quá chua cay duyên đành lỡ vì ai<br />Bao nhiêu niềm vui cũng vùi chôn từ đây, vùi chôn từ đây</p><p>Lỡ một cung đàn, phải chi tình đời là vòng giây oan trái<br />Nếu vì tình yêu Lan có tội gì đâu sao vướng vào sầu đau<br />Nàng sống mà tim như đã chết<br />Duyên bóng cô đơn đôi môi xin phai tàn<br />Thương thay cho nàng<br />Buồn xa nhân thế náu thân cửa Từ Bi<br /> </p>"]},{"key":"K1YW7YXK","artists":["Lâm Chấn Khang"],"lyrics":["Ghét Chính Anh<p>òng nhói đau, khi nhìn thấy em lệ rơi<br />Cũng chỉ vì, ngàn lời nói chia tay của anh<br />Anh không biết giờ phải làm sao bây giờ đây<br />Để cỏi lòng của em không còn đớn đau<br />Vì chính anh, đã đánh mất đi tình em<br />Những lỗi lầm ngày nào cũng do anh mà ra<br />Nhưng khi bên em trong anh giờ không còn cảm giác<br />Thôi chia tay hỡi nhau cho lòng bớt đau...</p><p>\"Ghét chính anh vô tâm đã làm em tổn thương,<br />ghét chính anh ngày qua quá vô tình<br />chẳng thấy em hi sinh vì người bao tháng năm<br />chẳng thấy em tuổi xuân qua rồi...\"</p><p>Nguyên nhân là do con tim anh<br />Không còn yêu như lúc trước<br />Và giờ đây anh mong em hãy chấp nhận điều đó<br />Giải thoát cho nhau đi em<br />Đừng bận lòng thêm chi hỡi người<br />Em hãy nhìn về đoạn đường phía trước...<br />Mai sau dù anh có bước tiếp<br />Yêu một người khác nữa<br />Và hình bóng một nữa ấy<br />Có nét gì như em khiến cho anh suy.. tư<br />Và cào xé trong hối hận<br />Nước mắt anh rơi anh biết anh đã sai rồi...</p>"]},{"key":"SQUPSY34","artists":["Lâm Chấn Khang"],"lyrics":["Cô Hàng Xóm (Remix)<p>Vùng ngoại ô, tôi có căn nhà tranh<br />Tuy bé nhưng thật xinh<br />Tháng ngày sống riêng một mình<br />Nhà gần bên, em sống trong giàu sang<br />Quen gấm nhung đài trang<br />Đi về xe đón đưa</p><p>Đêm đêm dưới ánh trăng vàng<br />Tôi với cây đàn âm thầm thở than<br />Và cô nàng bên xóm<br />Mỗi lúc lên đèn, sang nhà làm quen</p><p>ĐK:<br />Tôi ca không hay tôi đàn nghe cũng dở<br />Nhưng nàng khen nhiều và thật nhiều<br />Làm tôi thấy trong tâm tư xôn sao<br />Như lời âu yếm mặn nồng<br />Của đôi lứa yêu nhau</p><p>Hai năm trôi qua, nhưng tình không dám ngỏ<br />Tôi sợ thân mình là bọt bèo<br />Làm sao ước mơ duyên tơ mai sau<br />Tôi sợ ngang trái làm mộng đời<br />Chua xót thương đau</p><p>Rồi một hôm tôi quyết đi thật xa<br />Tôi cố quên người ta<br />Những hình bóng trong xa mờ<br />Nhờ thời gian, phương thuốc hay thần tiên<br />Chia cách đôi tình duyên<br />Nên người xưa đã quên</p><p>Hôm nay đón cánh thiệp hồng<br />Em báo tin mừng lấy chồng giàu sang<br />Đời em nhiều may mắn<br />Có nhớ anh ca sĩ nghèo này không?</p>"]},{"key":"8F67DF7F","artists":["Lâm Chấn Khang"],"lyrics":[""]},{"key":"9A3D8VPV","artists":["Lâm Chấn Khang"],"lyrics":[""]},{"key":"C82J0OQG","artists":["Lâm Chấn Khang"],"lyrics":["Ai Hay Chữ Ngờ<br />---<br />Tình này anh trao em đông đầy<br />Gọi ngàn giấc mơ quay về đầy<br />Cười đùa bên nhau vui tháng ngày<br />Yêu thương ngỡ như không vụt bay<br />Nào ngờ hôm nay anh trong thấy<br />Em bước bên ai qua chốn này<br />Tình yêu tôi em phai phôi như trang giấy<br />Ở đời ai hay đâu chữ ngờ<br />Chỉ mới hôm qua anh làm thơ<br />Gửi tặng cho em như mong chờ ,<br />Những mối ưu tư, mối tình thơ<br />Phải chăn anh đây như kẻ khờ<br />Hay vì tình em không bến bờ<br />Để hôm nay anh bỡ ngỡ em thờ ơ<br /><br />[ĐK]:<br />Tình này anh trao người mãi mãi<br />Dấu thời gian trôi không úa phai<br />Đường dài em đi nhìn người ra đi<br />Dù rằng anh không lỗi lầm chi<br />Còn lại đây bao câu hứa<br />Chẳng biết nói sao cho vừa<br />Ngồi trong mưa anh lặng lẽ mơ này xưa../"]},{"key":"DVA6WMZJ","artists":["Lâm Chấn Khang"],"lyrics":[""]},{"key":"SP2D22N2","artists":["Lâm Chấn Khang"],"lyrics":["LK Ngày Tận Thế - Nụ Hôn Và Giọt Nước Mắt<p>Đóng góp: Khoảng Lặng Ngày tận thế, phải chăng là ngày hôm nay?<br />Ngày mà em, lãng quên ân tình đôi ta!<br />Ngày em đến khiến anh, chợt bừng lên hạnh phúc mong manh.<br />Ngày em đi, đất trời như sụp đổ.</p><p>Ngày tận thế, với anh là ngày xa em,<br />Tinh yêu anh chỉ trao riêng về em thôi.<br />Người hạnh phúc bên ai, nào hay con tim anh khóc thầm.<br />Nhớ em nhiều, anh biết phải lằm sao......?</p><p>ĐK:<br />Ngày tận thế với anh người ơi,<br />Là ngày anh không còn em nữa.<br />Làm sao anh có thể quên vết thương chưa lành........vì mất em.</p><p>Ngày tận thế chỉ còn mỗi anh,<br />Bao người qua đâu nào hay biết?<br />Một con tim đã chết khi người đi...........</p>"]},{"key":"ISLXFEML","artists":["Lâm Chấn Khang"],"lyrics":["Mùa Xuân Ơi (Remix)<p>Xuân Xuân ơi ! Xuân đã về.Có nỗi vui nào vui hơn ngày Xuân đến.Xuân Xuân ơi ! Xuân đã về.Tiếng chúc giao thừa chào đón mùa Xuân.Xuân Xuân ơi ! Xuân đến rồi.Cánh én bay về cho tim mình nao nức.Xuân Xuân ơi ! Xuân đến rồi.Những đóa mây vàng chào mừng xuân sang.Nghe âm vang bao câu chúc yên lành.Đất nước gấm hoa yên ấm an vui.Bao em thơ khoe áo mới tươi cười.Chào một mùa Xuân mới!Xuân Xuân ơi ! Xuân đã về.Kính chúc muôn người với bao điều mong ước.Trong hương Xuân ta vẫy chào.Kính chúc muôn nhà gặp nhiều an vui.</p>"]}])
                        done()

