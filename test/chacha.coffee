getFileByHTTP = require('./utils').getFileByHTTP
chai = require "chai"
expect = chai.expect
describe "THE WEBSITE CHACHA.VN",->
      Chacha = require '../lib/chacha'
      chacha = new Chacha()
      describe "Song ID: 614150",->
            it 'should be called "Lòng mẹ" by "Khánh Ly" and has certain properties',(done)->
                  id = 614150
                  url = "http://beta.chacha.vn/song/joke,#{id}.html"
                  options = 
                        id : id
                  chacha.HTTPGet url, options, (err,data)->
                        if err then console.log err + " at CHACHA SONG TEST"
                        else 
                              chacha.processSong data,options,(song)->
                                    # console.log song
                                    expect(song.id).to.equal(614150)
                                    expect(song.title).to.equal('Lòng mẹ')
                                    expect(song.artistid).to.equal(206)
                                    expect(song.artists).to.eql(['Khánh Ly'])
                                    expect(song.duration).to.equal(0)
                                    expect(song.bitrate).to.equal(128)
                                    expect(song.coverart).to.match(/http:\/\/s2\.chacha\.vn\/artists\/\/s[0-9]\/206\/206.jpg.*/)
                                    expect(song.link).to.match(/http:\/\/audio\.chacha\.vn\/songs\/output\/74\/614150\/2\/s\/long-me - Khanh Ly\.mp3\?s=1/)
                                    done()

      describe "Album ID: 9456",->
            it 'should be called "Xin Còn Gọi Tên Nhau - Tình Khúc Trường Sa" by "Nhiều Ca Sĩ" and has certain properties ',(done)->
                  id = 9456
                  link = "http://beta.chacha.vn/album/joke,#{id}.html"
                  options = 
                        id : id
                  chacha.HTTPGet link, options, (err,data)->
                        if err then console.log err + " at CHACHA ALBUM TEST"
                        else 
                              album = chacha.processAlbum data, options
                              # console.log album
                              expect(album.id).to.equal(9456)
                              expect(album.title).to.equal('Xin Còn Gọi Tên Nhau - Tình Khúc Trường Sa')
                              expect(album.artists).to.eql(['Various Artists'])
                              expect(album.nsongs).to.equal(11)
                              expect(album.coverart).to.match(/http:\/\/s2\.chacha\.vn\/albums\/\/s2\/1\/9456\/9456\.jpg/)
                              expect(album.plays).to.be.at.least(79)
                              expect(album.description).to.equal("")
                              expect(album.songids).to.eql([535549, 611624, 611630, 611634, 443173, 611636, 611638, 611642, 611644, 611650, 611652 ])
                              done()