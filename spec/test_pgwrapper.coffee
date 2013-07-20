#!/usr/local/bin/mocha
chai = require "../node_modules/chai"
expect = chai.expect

# Goal:
# 	test with ignore syntax - SOLVED by ignoring error of duplicating info appears
# 	test with single quote escape - SOLVED by setting standard_conforming_strings = off
# 	test with auto_increment - NOT SOLVED

describe "Postgres wrapper",->
	PGWrapper = require '../lib/pgwrapper'
	wp = new PGWrapper()
	wp.getConnection()
	it "should escape quotes", (done)->
		# console.log wp.escape("song's name")
		expect(wp.escape("song's name")).to.equal("'song\\'s name'")
		done()
	it "should select 10 records from zisongs table", (done)->
		wp.getQueryMethod "select * from zisongs limit 10", (err, results)->
			expect(err).to.equal(null)
			expect(results.length).to.equal(10)
			done()
	
	it "should select  multiple values ", (done)->
		wp.getQueryMethod "select * from zisongs where sid=2000000042 or sid=2000000012 or sid=2000000022", (err, results2)->
			# console.log results2
			expect(err).to.equal(null)
			expect(results2.length).to.equal(3)
			done()

	it "should insert a song record into zisongs test table where id is genreated automaticallly", (done)->
		song = {"songid":"ZWZ9ZUD7","song_name":" Tháng 6 Trời Mưa ","song_artist":["Đàm Vĩnh Hưng"],"author":"","plays":"79819","topic":"[\"Nhạc Trẻ\",\"Việt Nam\"]","song_link":"http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjclMkYwJTJGOSUyRjA5MjUyMWZmYmZkY2U3YTcyNTA4M2VjNGFkZWI3NWE2Lm1wMyU3QzI=","path":"2010/09/27/0/9/092521ffbfdce7a725083ec4adeb75a6.mp3","lyric":"Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa anh cũng lạy trời mưa<br />anh lạy trời mưa phong kín đường về<br />và đêm ơi xin cứ dài vô tận<br /><br />Mình dựa vào nhau cho thuyền ghé bến<br />sưởi ấm đời nhau bằng những môi hôn<br />mình cầm tay nhau nghe tình dâng sóng nổi<br />hãy biến cuộc đời thành những tối tân hôn<br /><br />Da em trắng anh chẳng cần ánh sáng<br />tóc em mềm anh chẳng tiếc mùa xuân<br />trên cuộc đời sẽ chẳng có giai nhân<br />vì anh gọi tên em là nhan sắc<br /><br />Anh vuốt tóc em cho đêm khuya tròn giấc<br />anh sẽ nâng tay cho ngọc sát kề môi<br />anh sẽ nói thầm như gió thoảng trên vai<br />và bên em tiếng đời đi rất vội<br /><br />Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa em có lạy trời mưa<br />anh vẫn xin mưa phong kín đường về<br />anh nhớ suốt đời mưa tháng sáu","created":"2010-09-26 17:00:00"}
		wp.getQueryMethod "INSERT IGNORE INTO zisongs SET ? ", song, (err, results)->
			expect(err).to.equal(null)
			expect(results.length).to.equal(0)
			# wp.getQueryMethod "select * from zisongs where sid=2000000099", (err, results2)->
			# 	# console.log results2
			# 	expect(err).to.equal(null)
			# 	expect(results2.length).to.equal(1)
			done()

	it "should insert a song record into zisongs test table where sid=2000000099", (done)->
		song = {"sid":2000000099,"songid":"ZWZ9ZUD7","song_name":" Tháng 6 Trời Mưa ","song_artist":["Đàm Vĩnh Hưng"],"author":"","plays":"79819","topic":"[\"Nhạc Trẻ\",\"Việt Nam\"]","song_link":"http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjclMkYwJTJGOSUyRjA5MjUyMWZmYmZkY2U3YTcyNTA4M2VjNGFkZWI3NWE2Lm1wMyU3QzI=","path":"2010/09/27/0/9/092521ffbfdce7a725083ec4adeb75a6.mp3","lyric":"Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa anh cũng lạy trời mưa<br />anh lạy trời mưa phong kín đường về<br />và đêm ơi xin cứ dài vô tận<br /><br />Mình dựa vào nhau cho thuyền ghé bến<br />sưởi ấm đời nhau bằng những môi hôn<br />mình cầm tay nhau nghe tình dâng sóng nổi<br />hãy biến cuộc đời thành những tối tân hôn<br /><br />Da em trắng anh chẳng cần ánh sáng<br />tóc em mềm anh chẳng tiếc mùa xuân<br />trên cuộc đời sẽ chẳng có giai nhân<br />vì anh gọi tên em là nhan sắc<br /><br />Anh vuốt tóc em cho đêm khuya tròn giấc<br />anh sẽ nâng tay cho ngọc sát kề môi<br />anh sẽ nói thầm như gió thoảng trên vai<br />và bên em tiếng đời đi rất vội<br /><br />Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa em có lạy trời mưa<br />anh vẫn xin mưa phong kín đường về<br />anh nhớ suốt đời mưa tháng sáu","created":"2010-09-26 17:00:00"}
		wp.getQueryMethod "INSERT IGNORE INTO zisongs SET ? ", song, (err, results)->
			expect(err).to.equal(null)
			expect(results.length).to.equal(0)
			wp.getQueryMethod "select * from zisongs where sid=2000000099", (err, results2)->
				# console.log results2
				expect(err).to.equal(null)
				expect(results2.length).to.equal(1)
				done()
	it "should ignore the sid=2000000099 of zisongs because it is available in the table", (done)->
		song = {"sid":2000000099,"songid":"ZWZ9ZUD7","song_name":" Tháng 6 Trời Mưa ","song_artist":["Đàm Vĩnh Hưng"],"author":"","plays":"79819","topic":"[\"Nhạc Trẻ\",\"Việt Nam\"]","song_link":"http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjclMkYwJTJGOSUyRjA5MjUyMWZmYmZkY2U3YTcyNTA4M2VjNGFkZWI3NWE2Lm1wMyU3QzI=","path":"2010/09/27/0/9/092521ffbfdce7a725083ec4adeb75a6.mp3","lyric":"Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa anh cũng lạy trời mưa<br />anh lạy trời mưa phong kín đường về<br />và đêm ơi xin cứ dài vô tận<br /><br />Mình dựa vào nhau cho thuyền ghé bến<br />sưởi ấm đời nhau bằng những môi hôn<br />mình cầm tay nhau nghe tình dâng sóng nổi<br />hãy biến cuộc đời thành những tối tân hôn<br /><br />Da em trắng anh chẳng cần ánh sáng<br />tóc em mềm anh chẳng tiếc mùa xuân<br />trên cuộc đời sẽ chẳng có giai nhân<br />vì anh gọi tên em là nhan sắc<br /><br />Anh vuốt tóc em cho đêm khuya tròn giấc<br />anh sẽ nâng tay cho ngọc sát kề môi<br />anh sẽ nói thầm như gió thoảng trên vai<br />và bên em tiếng đời đi rất vội<br /><br />Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa em có lạy trời mưa<br />anh vẫn xin mưa phong kín đường về<br />anh nhớ suốt đời mưa tháng sáu","created":"2010-09-26 17:00:00"}
		wp.getQueryMethod "insert ignore into zisongs SET ? ", song, (err, results)->
			expect(err).to.equal(null)
			expect(results.length).to.equal(0)
			wp.getQueryMethod "select * from zisongs where sid=2000000099", (err, results2)->
				# console.log results2
				expect(err).to.equal(null)
				expect(results2.length).to.equal(1)
				done()
	it "should delete a song record into zisongs test table where sid=2000000099", (done)->
		song = {"sid":2000000099,"songid":"ZWZ9ZUD7","song_name":" Tháng 6 Trời Mưa ","song_artist":["Đàm Vĩnh Hưng"],"author":"","plays":"79819","topic":"[\"Nhạc Trẻ\",\"Việt Nam\"]","song_link":"http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjclMkYwJTJGOSUyRjA5MjUyMWZmYmZkY2U3YTcyNTA4M2VjNGFkZWI3NWE2Lm1wMyU3QzI=","path":"2010/09/27/0/9/092521ffbfdce7a725083ec4adeb75a6.mp3","lyric":"Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa anh cũng lạy trời mưa<br />anh lạy trời mưa phong kín đường về<br />và đêm ơi xin cứ dài vô tận<br /><br />Mình dựa vào nhau cho thuyền ghé bến<br />sưởi ấm đời nhau bằng những môi hôn<br />mình cầm tay nhau nghe tình dâng sóng nổi<br />hãy biến cuộc đời thành những tối tân hôn<br /><br />Da em trắng anh chẳng cần ánh sáng<br />tóc em mềm anh chẳng tiếc mùa xuân<br />trên cuộc đời sẽ chẳng có giai nhân<br />vì anh gọi tên em là nhan sắc<br /><br />Anh vuốt tóc em cho đêm khuya tròn giấc<br />anh sẽ nâng tay cho ngọc sát kề môi<br />anh sẽ nói thầm như gió thoảng trên vai<br />và bên em tiếng đời đi rất vội<br /><br />Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa em có lạy trời mưa<br />anh vẫn xin mưa phong kín đường về<br />anh nhớ suốt đời mưa tháng sáu","created":"2010-09-26 17:00:00"}
		# console.log "asdasd"
		wp.getQueryMethod "delete * from zisongs where sid=2000000099 ", (err, results)->
			# console.log results
			expect(err).to.equal(null)
			expect(results.length).to.equal(0)
			wp.getQueryMethod "select * from zisongs where sid=2000000099", (err, results2)->
				# console.log results2
				expect(err).to.equal(null)
				expect(results2.length).to.equal(0)
				done()

	it "should update song_artist field whose type is ARRAY", (done)->
		artists = ["test14","test2"]
		wp.getQueryMethod "update zisongs set song_artist=#{wp.escape JSON.stringify artists} where sid=2000000000 ", (err, results)->
			expect(err).to.equal(null) 
			expect(results.length).to.equal(0)
			wp.getQueryMethod "select * from zisongs where sid=2000000000", (err, results2)->
				expect(err).to.equal(null)
				expect(results2.length).to.equal(1)
				# console.log results2
				expect(results2[0].song_artist).to.eql(artists)
				done()

	it "should update song_name field whose type is STRING", (done)->
		name = "singile quote '-'  double quotes \"\" [][]{}{}{)()/////\\\\?=.-:;M;.#€%&hương là nắng mai"
		wp.getQueryMethod "update zisongs set song_name=#{wp.escape name} where sid=2000000000 ", (err, results)->
			expect(err).to.equal(null) 
			expect(results.length).to.equal(0)
			wp.getQueryMethod "select * from zisongs where sid=2000000000", (err, results2)->
				expect(err).to.equal(null)
				expect(results2.length).to.equal(1)
				# console.log results2
				expect(results2[0].song_name).to.equal(name)
				wp.endConnection()
				done()



