getFileByHTTP = require('./utils').getFileByHTTP
chai = require "chai"
expect = chai.expect
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
                              expect(song.link).to.match(/http:\/\/www[0-9]+\.nhac\.vui\.vn\/uploadmusic2\/[0-9a-f]{32}\/[0-9a-f]{8}\/uploadmusic\/id_chan\/2-2013\/huylun\/Rap\/NewTrack\/128\/Anh Se Quen - MT Phan\.mp3/)
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
                        expect(song.topics).to.eql(['Rap Việt'])
                        expect(song.authors).to.eql(['Rap Việt'])
                        expect(song.lyric).to.match(/Anh sẽ quên - MT Phan.+một mình ỡ nơi góc tối.. lòng lại buồn.+chĩ là do anh tưỡng tượng ra trong cơn mê.+ anh viết về em/)
                        done()
      describe "Album ID: 26989",->
            it 'should be called "April\'s Spring" by "Forty" and has certain properties ',(done)->
                  id = 26989
                  link = "http://hcm.nhac.vui.vn/-a#{id}p1.html"
                  getFileByHTTP link, (data)->
                        result = nv.processAlbumData id, data
                        # console.log result
                        expect(result.album.id).to.equal(26989)
                        expect(result.album.title).to.equal('April\'s Spring')
                        expect(result.album.artists).to.eql(['Forty'])
                        expect(result.album.topics).to.eql(['Nhạc Hàn Quốc'])
                        expect(parseInt(result.album.plays,10)).to.be.at.least(39)
                        expect(parseInt(result.album.nsongs,10)).to.equal(2)
                        expect(result.album.coverart).to.equal('http://nv-ad-hcm.24hstatic.com/upload/album/2-2013/1366001419_Aprils-Spring-Album-40-(Forty).jpg')
                        expect(result.album.date_created).to.equal('2013-4-15 11:50:19')
                        expect(result.album.songids).to.eql([314212,314211])
                        done()