chai = require "chai"
expect = chai.expect

fs = require 'fs'
prefix = "CSN"
name = "Chiasenhac"
path = "./log/#{prefix}Log.txt"
table = 
	song : prefix.toLowerCase() + "songs"
	album : prefix.toLowerCase() + "albums"
	video : prefix.toLowerCase() + "videos"
describe "#{name}",->
	PGWrapper = require '../../lib/pgwrapper'
	wp = new PGWrapper()
	wp.getConnection()
	file = fs.readFileSync path, "utf8"
	content = JSON.parse file
	it "should have max songid indentical to max id in log file", (done)->
		# console.log wp.escape("song's name")
		query = "select max(id) as max from #{table.song}"
		wp.getQueryMethod query, (err,results)->
			expect(err).to.equal(null)
			max = parseInt(results[0].max,10)
			expect(max).to.equal(content.lastSongId)
			done()
