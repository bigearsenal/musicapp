getFileByHTTP = require('./utils').getFileByHTTP
getGzipped = require('./utils').getGzipped
chai = require "chai"
expect = chai.expect
describe 'THE WEBSITE MP3.ZING.VN', ->
      Zing = require '../lib/zing'
      zing = new Zing()
      song = {}
      describe 'Song ID: ZW67B7BD', ->
            it 'should be encoded into 1382528957, has plays, topic and authors',(done) ->
                  zing.connect()
                  songid = 1382528957
                  link = "http://mp3.zing.vn/bai-hat/joke-link/#{zing._convertToId songid}.html"
                  getGzipped link, (data)->
                        # console.log "anvubg"
                        # console.log data
                        zing._getFileByHTTP = ->
                        song = zing._processSong songid, data
                        expect(song.id).to.equal(1382528957)
                        expect(parseInt(song.plays,10)).to.match(/\d+/)
                        expect(song.authors).to.eql(["Hoàng Sông Hương"])
                        expect(song.topics).to.eql([ 'Việt Nam' ])
                        done()
            it 'should be called Meditation, composed by Olivia Ong, created on 2013-04-07, has link and path',(done)->
                  zing.connect()
                  link = "http://m.mp3.zing.vn/xml/song/LnJGtLnNAQQxJQQyLDcyDHLG"
                  getGzipped link, (data)->
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
                  zing.temp = 
                    albums : []
                  getGzipped link, (data)->
                        # console.log data
                        result = zing._processAlbum albumid, data
                        # console.log result
                        expect(result.key).to.equal("ZWZAAIW0")
                        expect(result.title).to.equal("Anh Muốn Quay Lại... Đến Khi Nào")
                        expect(result.artists).to.eql(["Khắc Việt"])
                        expect(result.topics).to.eql(["Việt Nam","Nhạc Trẻ"])
                        expect(parseInt(result.plays,10)).to.match(/\d+/)
                        expect(parseInt(result.year_released,10)).to.equal(2013)
                        expect(parseInt(result.nsongs,10)).to.equal(2)
                        # console.log result
                        # expect(result.songids.length).to.equal(2)
                        expect(result.coverart).to.equal('http://image.mp3.zdn.vn/thumb/240_240/covers/5/2/5284f196b781e762b443f762a612172f_1365388107.jpg')
                        expect(result.description).to.equal('“Đến khi nào”. “Anh muốn quay lại” là nỗi nhớ người yêu da diết được Khắc Việt chuyển tải qua giai điệu sâu lắng từ đầu đến cuối. Đúng như tựa đề, “Anh muốn quay lại” như một đề nghị muộn màng khi tình cảm đã chia ly. Trong khi đó “Đến khi nào” lại là một tình yêu rộng lượng của người con trai sẵn sàng hy sinh để đem lại hạnh phúc cho người mình yêu. Việc sử dụng điệp từ “Đến khi nào” nhiều lần trong ca khúc cùng tên khiến cho người nghe đồng cảm nhiều hơn với tình yêu chung thủy của chàng trai trong ca khúc này. ')
                        expect(result.date_created).to.equal("2013-4-8 9:28:27")
                        done()
      describe "Video ID: ZWZ9ZO0U",->
            it 'should be called "Kiếp Phong Trần" by "Lâm Hùng" and has certain properties ', (done)->
                  zing.connect()
                  vid = 1381585668
                  link = "http://mp3.zing.vn/video-clip/joke-link/#{zing._convertToId vid}.html"
                  getGzipped link, (data)->
                        video = zing._processVideo vid, data
                        # console.log video
                        expect(video.id).to.equal(1381585668)
                        expect(video.title).to.equal('Kiếp Phong Trần')
                        expect(video.artists).to.eql(["Lâm Hùng"])
                        expect(video.topics).to.eql(["Việt Nam","Nhạc Trẻ"])
                        expect(parseInt(video.plays,10)).to.be.at.least(1014646)
                        expect(video.thumbnail).to.equal('http://image.mp3.zdn.vn/thumb_video/1/e/1ebf84dd6270b3978273b47f980c854a_1340685814.jpg')
                        expect(video.link).to.match(/http:\/\/mp3.zing.vn\/html5\/video\/[a-zA-Z0-9]{24}/)
                        expect(video.lyric).to.equal('Kiếp phong trần bạn đường sương gió, giang hồ phiêu lãng vũ trụ là nhà. Ánh trăng vàng làm đèn đêm thâu, tựa mình trên cát sương giăng làm màn. 2. Nắng chan hoà miền trời thanh câm tú, ngỡ ngàng tựa như bước trên bồng lai. Mong quên đời phàm trần còn nhiều trên vai, tranh giành như thế tốt hơn làm người. ĐK1: Đời nam nhi chí trai dọc ngang núi sông, dù gian khó quyết không nao núng lòng. Đường ta đi chông gai không làm nhụt chí hiên ngang, đường thênh thang bước chân vui miệt mài. ĐK2: Đàn réo rắt chất ngất bầu không gian sẽ xoa dịu ta quên nỗi đau thương trầm luân. Đàn hỡi có nói giúp cho lòng ta xin nhân gian thôi hận thù cho nét môi tươi rạng ngời. Ta vui cùng non bồng lãng du, ta vui cùng bạn đường gió sương. Trọn niềm vui xóa tan đau thương sầu kiếp.\t\t"')
                        expect(video.date_created).to.equal('2012-6-26')
                        done()