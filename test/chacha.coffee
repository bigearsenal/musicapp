getFileByHTTP = require('./utils').getFileByHTTP
chai = require "chai"
expect = chai.expect
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
                        expect(parseInt(song.id,10)).to.equal(614150)
                        expect(song.title).to.equal('Lòng mẹ')
                        expect(song.artistid).to.equal(206)
                        expect(song.artists).to.eql(['Khánh Ly'])
                        expect(song.duration).to.equal(335)
                        expect(song.bitrate).to.equal(128)
                        expect(song.coverart).to.equal('http://s2.chacha.vn/artists//s5/206/206.jpg?v=0')
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
                        # console.log album
                        expect(album.id).to.equal(9456)
                        expect(album.title).to.equal('Xin Còn Gọi Tên Nhau')
                        expect(album.artists).to.eql(['Tình Khúc Trường Sa'])
                        expect(album.nsongs).to.equal(11)
                        expect(album.coverart).to.equal('http://s2.chacha.vn/albums//s2/1/9456/9456.jpg')
                        expect(album.plays).to.be.at.least(93)
                        expect(album.description).to.equal("")
                        expect(album.songids).to.eql([ 535549, 611624, 611630, 611634, 443173, 611636, 611638, 611642, 611644, 611650, 611652 ])
                        done()