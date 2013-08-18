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
	it "should drop table if exists and created new test table", (done)->
		query = """
		DROP TABLE IF EXISTS "public"."test";
		CREATE TABLE "public"."test" (
			"id" int4 NOT NULL,
			"key" varchar(30) COLLATE "default",
			"title" varchar(255) COLLATE "default",
			"artists" varchar(50)[] COLLATE "default",
			"authors" varchar(50)[] COLLATE "default",
			"plays" int8,
			"topics" varchar(50)[] COLLATE "default",
			"link" varchar(255) COLLATE "default",
			"path" varchar(255) COLLATE "default",
			"lyric" text COLLATE "default",
			"date_created" timestamp(6) NULL,
			"checktime" timestamp(6) NULL
		)
		WITH (OIDS=FALSE);
		ALTER TABLE "public"."test" OWNER TO "daonguyenanbinh";
		ALTER TABLE "public"."test" ADD CONSTRAINT "test_pkey" PRIMARY KEY ("id") NOT DEFERRABLE INITIALLY IMMEDIATE;
		"""
		# console.log query
		wp.getQueryMethod query, (err)->
			if err then console.log err
			done()
	it "should insert 10 records", (done)->
		query = """
		BEGIN;
		INSERT INTO "public"."test" VALUES ('1381585039', 'ZWZ9Z08F', ' Tình Yêu Trở Lại ', '{"Cao Thái Sơn"}', '{"Nguyễn Văn Chung"}', '4179762', '{"Việt Nam","Nhạc Trẻ"}', 'http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjMlMkY0JTJGNSUyRjQ1MjRmMWQ1ZGNkM2FiYzFiNGVhYTc5ZWY0ZDY0MjBlLm1wMyU3QzI=', '2010/09/23/4/5/4524f1d5dcd3abc1b4eaa79ef4d6420e.mp3', 'Ngày em đi anh buồn biết mấy <br />Mình chia tay sau bao ngày yêu nhau <br />Vì sao ta cứ giận hờn vu vơ <br />Cứ hững hờ vô tâm rồi xa nhau<br /> Ngày hôm qua anh vô tình trông thấy<br /> Nụ cười ấy như ban đầu gặp nhau <br />Những kí ức ngỡ ngủ vùi quên lãng <br />Bỗng âm thầm thổn thức lại trong tim<br /> <br />Đk:<br />Chợt nhận ra anh yêu em như đã yêu <br />Đi gần em sao anh hạnh phúc bao nhiêu<br /> Vẫn nụ cười nồng ấm, vẫn đây đôi mắt hiền<br /> Vẫn bàn tay nhẹ vuốt tóc em ngày xưa<br /> Chợt nhận ra anh yêu em yêu quá nhiều <br />Đủ để anh quên đi đau đớn bao nhiêu<br /> Anh cầm bàn tay ấy và anh xiết thật chặt (vào lòng)<br /> Để tình yêu sớm quay trở về...', '2010-09-23 00:00:00', '2013-03-26 18:32:58');
		INSERT INTO "public"."test" VALUES ('1381585040', 'ZWZ9Z090', ' Con Đường Mưa ', '{"Cao Thái Sơn"}', '{"Nguyễn Văn Chung"}', '3863611', '{"Việt Nam","Nhạc Trẻ"}', 'http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjMlMkYwJTJGNSUyRjA1NTBlMTQ4MGI2Mzk2OTRlOTdjYmRiZGFkMWNkMWQzLm1wMyU3QzI=', '2010/09/23/0/5/0550e1480b639694e97cbdbdad1cd1d3.mp3', 'Nếu ngày xưa bước đi nhanh qua con đường mưa<br />Thì anh đã không gặp người <br />Nếu ngày xưa em nhìn anh nhưng không mỉm cười <br />Thì anh đã không mộng mơ <br />Nếu tình ta chẳng phải xa khi đang đậm sâu <br />Thì anh đã không đau buồn <br />Nếu lòng anh không còn yêu em hơn chính mình <br />Thì anh đã quên được em…<br /> [ĐK]: Làm sao để đường xưa đừng in dấu chân anh mỗi ngày <br />Làm sao cho lòng anh thôi gọi tên em trong mỗi giấc mơ <br />Làm sao để mưa mùa thu đừng rơi khi anh đang nhớ em. <br />Làm sao khi thấy mưa anh không buồn<br /> Làm sao để quên niềm vui niềm hạnh phúc khi anh có người <br />Làm sao quên ngày chia tay lệ em rơi trên đôi mắt cay <br />Làm sao để thôi chờ mong <br />Làm sao tim anh thôi đừng mơ… <br />***Rằng ngày mai thấy em quay trở về *** <br />Nếu ngày xưa bước đi nhanh qua con đường mưa <br />Thì anh đã không gặp người Nếu ngày xưa em nhìn anh nhưng không mỉm cười <br />Thì anh đã không mộng mơ <br />Nếu thời gian có quay về trước khi gặp em<br /> Thì anh vẫn xin đi cùng <br />Nếu ngày xưa mưa mùa thu rơi trên lối về <br />Thì anh vẫn không vội qua… (Back to [ĐK])', '2010-09-23 00:00:00', '2013-03-26 18:27:33');
		INSERT INTO "public"."test" VALUES ('1381585041', 'ZWZ9Z09I', ' Ánh Trăng Buồn ', '{"Cao Thái Sơn"}', '{"Thanh Thuận"}', '1723961', '{"Việt Nam","Nhạc Trẻ"}', 'http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjMlMkY4JTJGNSUyRjg1MzBiZGM4ZWNkZTBhYTNkNjc0YjgwY2ZjM2M5YzFlLm1wMyU3QzI=', '2010/09/23/8/5/8530bdc8ecde0aa3d674b80cfc3c9c1e.mp3', 'Ngồi nơi đây nhớ một ngừơi nhìn mưa rơi nhớ thương em <br />Ngồi trong đêm hỏi ánh trăng sao trăng buồn lẽ loi <br />Nhìn sao đêm tôi mong chờ tình khao khát tiếng yêu thương <br />Lòng thầm mong sẽ có em bên em người hỡi <br />Ánh trăng ơi sao buồn lẻ loi Trăng nhớ ai trăng vẫn đợi chờ <br />Hãy mang em đi vào cơn mơ Để tim tôi mãi mãi có em <br />Ánh trăng ơi khi nào khi nào có đôi <br />Tay nắm tay đi suốt cuộc đời <br />Ánh trăng khuya chờ ai mong ai <br />Mà sao trăng thao thức suốt đêm <br />Ánh trăng buồn', '2010-09-23 00:00:00', '2013-03-26 18:27:34');
		INSERT INTO "public"."test" VALUES ('1381585042', 'ZWZ9Z09W', ' Pha Lê Tím ', '{"Cao Thái Sơn"}', '{"Nguyễn Văn Chung"}', '3340459', '{"Việt Nam","Nhạc Trẻ"}', 'http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjMlMkZkJTJGNSUyRmQ1YjFhZGUzOTZmODI1MmI4ZDU1MjM0MDM2ZmNhYzcyLm1wMyU3QzI=', '2010/09/23/d/5/d5b1ade396f8252b8d55234036fcac72.mp3', 'Một ngày nào tình cờ, em thấy cô đơn.<br />Một ngày nào tình cờ, em nhớ đến anh.<br />Tìm nụ cười nhẹ nhàng lau khô mắt buồn.<br />Rồi chầm chậm nhìn vào không gian,<br />Nhìn vào bầu trời người sẽ thấy.<br /><br />Nắng chứa những nụ hôn nồng nàn, ấm thêm đôi môi mềm.<br />Gió giấu những cánh tay êm đềm, dịu dàng anh ôm lấy<br />Hãy hỏi những vì sao trên trời, ánh mắt anh đâu rồi<br />Nụ cười anh, gửi nơi khuyết vầng trăng.<br /><br />Những khúc hát ngày ta hẹn hò, có trong cơn mưa chiều.<br />Những nỗi nhớ đến em đong đầy, bình hoa Pha Lê Tím<br />Những tiếng sóng ngày đêm xô bờ, giống như anh thì thầm<br />Lời yêu thương, thường hay nói cùng em..', '2010-09-23 00:00:00', '2013-03-26 18:27:17');
		INSERT INTO "public"."test" VALUES ('1381585043', 'ZWZ9Z09O', ' Đắng Cay ', '{"Cao Thái Sơn"}', '{"Lương Bằng Vinh"}', '1400308', '{"Việt Nam","Nhạc Trẻ"}', 'http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjMlMkY5JTJGYSUyRjlhYmUwYzg4NGVlN2M4ZmNlOGRjNThhY2YzZjhjZjQzLm1wMyU3QzI=', '2010/09/23/9/a/9abe0c884ee7c8fce8dc58acf3f8cf43.mp3', 'Người yêu dấu ơi...Tình anh đã trao em rồi Nỗi nhớ ngàn khơi không cuồng phong gió mưa nào ngăn lối Người yêu dấu ơi...dù năm tháng thêm xa vời Bóng đêm tối trong lẻ loi đơn côi cuộc đời Giọt lệ đắng cay,gạt trên gối bao u hoài Dĩ vãng còn đây, nghe tình đau vết thương tình xưa ấy Thời gian đã qua, lưu luyến mãi không phai nhòa Mãi cho đến kiếp sau tình còn nghe xót xa.... Biết thế khi xưa đừng chung lối đường Sợi nắng giọt mưa nào ai có lường Ánh mắt đôi môi càng bẻ bàng Tình đắm tình say tình đã lỡ làng Vẫn mãi mãi yêu em yêu vô vàn Vẫn mãi mãi yêu em khi duyên tình trái ngang', '2010-09-23 00:00:00', '2013-03-26 18:27:17');
		INSERT INTO "public"."test" VALUES ('1381585044', 'ZWZ9Z09U', ' Tự Khúc Mùa Đông ', '{"Cao Thái Sơn"}', '{"Tường Văn"}', '1125386', '{"Việt Nam","Nhạc Trẻ"}', 'http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjMlMkY3JTJGOSUyRjc5NTdlMTlmYjQwZTkxOGRkM2M2YTQ4OWFkYWRlYmJmLm1wMyU3QzI=', '2010/09/23/7/9/7957e19fb40e918dd3c6a489adadebbf.mp3', 'Ngỡ như đêm mùa đông thoáng nghe gió lạnh.<br />Ngỡ như trong vòng tay mãi không cách xa.<br />Có hay chăng tình ai với ai trễ hẹn. <br />Đám lá khô theo gió xa xăm mùa đông. <br />Đã như chim trời bay với bao ước vọng. <br />Đã như như quên lời ru tháng năm dấu yêụ .<br />Những đêm sao lặng im với tôi khóc thầm. <br />Nếu như em còn đây thấu chăng tình tôị .<br /><br />ĐK: <br /><br />Mong manh bao nhớ nhung. <br />Tình yêu héo mòn liêu xiêu con phố quen còn đó. <br />Ai trông ai ngóng ai dường như xác xợ <br />Vang trong tim nỗi đau ngút ngàn. <br /><br />Đêm đêm luôn có tôi ngồi đây với trờị <br />Đang trông theo gót xưa mòn lốị <br />Đêm chim bay có nhau nhìn tôi rất buồn. <br />Thương thân tôi lẽ loi rã rờị', '2010-09-23 00:00:00', '2013-03-26 18:27:17');
		INSERT INTO "public"."test" VALUES ('1381585397', 'ZWZ9ZIFZ', ' 半島鐵盒 (Ban Dao Tie He) / Hộp Sắt Bán Đảo ', '{"Châu Kiệt Luân"}', '{}', '2911', '{"Hoa Ngữ","Đài Loan"}', 'http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjQlMkY4JTJGNCUyRjg0NTFlNmY4MzNkOGM5YzIzNmVkOTdiOGFmNGZkZWIyLm1wMyU3QzI=', '2010/09/24/8/4/8451e6f833d8c9c236ed97b8af4fdeb2.mp3', '', '2010-09-24 00:00:00', '2013-03-26 18:27:18');
		INSERT INTO "public"."test" VALUES ('1381585398', 'ZWZ9ZIF6', ' Careful ', '{Paramore}', '{}', '4827', '{"Âu Mỹ",Rock}', 'http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjQlMkYzJTJGOSUyRjM5YzA5ODY4ZmM4YmZhODhmMDllMGFhNzI4NDkzNjMzLm1wMyU3QzI=', '2010/09/24/3/9/39c09868fc8bfa88f09e0aa728493633.mp3', '', '2010-09-24 00:00:00', '2013-03-26 18:27:18');
		INSERT INTO "public"."test" VALUES ('1381585045', 'ZWZ9Z09Z', ' Trăng Úa Sao Mờ ', '{"Cao Thái Sơn"}', '{"Vũ Tuấn Đức"}', '537331', '{"Việt Nam","Nhạc Trẻ"}', 'http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjMlMkZkJTJGMiUyRmQyMTNlODIzYTkwOTkyNGIxMWQwMTVkMjY0MjI4M2E4Lm1wMyU3QzI=', '2010/09/23/d/2/d213e823a909924b11d015d2642283a8.mp3', 'Đêm hôm nao bầu trời muôn trăng sao <br />Trên bãi vắng từng cơn sóng ru êm đềm <br />Và gío quấn quýt những vòng tay <br />Và trăng ôm ấp đôi vai gầy <br />Có ai ngờ đâu yêu đương là tan vỡ <br />Em ra đi còn thương nhớ <br />Này em yêu hỡi trăng sao mờ khuất đêm nay <br />Anh giờ đây lang thang tìm dấu chân kỷ niệm <br />Bao ước mơ êm đềm Vội tan theo sóng đưa <br />Người yêu hỡi trăng sao vụt tắt đêm nay <br />Anh còn đây không gian sầu vắng hao gầy <br />Và không có em nơi này <br />Chỉ còn trăng úa sao mờ đêm nay<br /> Nghe sao rơi lòng buồn dâng chơi vơi <br />Trên bãi vắng từng cơn sóng xô âm thầm <br />Và gió rét mướt thấm hồn đau <br />Bờ hoang nghe sóng xô nghẹn ngào <br />Có ai ngờ đâu yêu đường là tan vỡ <br />Em ra đi còn thương nhớ', '2010-09-23 00:00:00', '2013-03-26 18:27:17');
		INSERT INTO "public"."test" VALUES ('1381585046', 'ZWZ9Z096', ' Giấc Mơ ', '{"Cao Thái Sơn"}', '{"Nguyễn Văn Chung"}', '752167', '{"Việt Nam","Nhạc Trẻ"}', 'http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjMlMkY1JTJGOCUyRjU4ZjdmZDNjNDkyYTkzYzFlNTAwMGI1MmNlZWNmMDAyLm1wMyU3QzI=', '2010/09/23/5/8/58f7fd3c492a93c1e5000b52ceecf002.mp3', 'Trước thềm vẫn xanh vườn hoa<br /> Vỗ về giấc mơ dịu êm<br /> Tiếc rằng đã không còn em <br />Vườn hoa kia như không màu <br />Nắng hồng trước sân nhà ai <br />Ấm nồng giấc mơ ngày xưa <br />Tiếc rằng đã không còn em <br />Đêm mưa rơi nhạt nắng phai<br /> Lá vàng thắp đôi hàng cây<br /> Hững hờ mùa thu lá bay<br /> Nhớ người bước qua anh vô tình<br /> Thức dậy thấy em vô hình<br /> Gió về cuối Đông buồn tênh <br />Buốt lạnh lòng anh lẻ loi<br /> Có người cách xa anh muôn trùng<br /> Có người nhớ em vô cùng', '2010-09-23 00:00:00', '2013-03-26 18:27:17');
		INSERT INTO "public"."test" VALUES ('2000000010', 'asdfd', 'asdf asdf as', '{"{sdfsdfasdfg}"}', '{}', '79819', '{"Việt Nam","Nhạc Trẻ"}', 'http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjclMkYwJTJGOSUyRjA5MjUyMWZmYmZkY2U3YTcyNTA4M2VjNGFkZWI3NWE2Lm1wMyU3QzI=', '2010/09/27/0/9/092521ffbfdce7a725083ec4adeb75a6.mp3', 'Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa anh cũng lạy trời mưa<br />anh lạy trời mưa phong kín đường về<br />và đêm ơi xin cứ dài vô tận<br /><br />Mình dựa vào nhau cho thuyền ghé bến<br />sưởi ấm đời nhau bằng những môi hôn<br />mình cầm tay nhau nghe tình dâng sóng nổi<br />hãy biến cuộc đời thành những tối tân hôn<br /><br />Da em trắng anh chẳng cần ánh sáng<br />tóc em mềm anh chẳng tiếc mùa xuân<br />trên cuộc đời sẽ chẳng có giai nhân<br />vì anh gọi tên em là nhan sắc<br /><br />Anh vuốt tóc em cho đêm khuya tròn giấc<br />anh sẽ nâng tay cho ngọc sát kề môi<br />anh sẽ nói thầm như gió thoảng trên vai<br />và bên em tiếng đời đi rất vội<br /><br />Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa em có lạy trời mưa<br />anh vẫn xin mưa phong kín đường về<br />anh nhớ suốt đời mưa tháng sáu', '2010-09-26 17:00:00', null);
		INSERT INTO "public"."test" VALUES ('2000000000', 'ZWZ9ZUD7', 'singile quote ''-''  double quotes "" [][]{}{}{)()/////\\\\?=.-:;M;.#€%&hương là nắng mai', '{"test14","test2"}', '{}', '79819', '{"Việt Nam","Nhạc Trẻ"}', 'http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjclMkYwJTJGOSUyRjA5MjUyMWZmYmZkY2U3YTcyNTA4M2VjNGFkZWI3NWE2Lm1wMyU3QzI=', '2010/09/27/0/9/092521ffbfdce7a725083ec4adeb75a6.mp3', 'Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa anh cũng lạy trời mưa<br />anh lạy trời mưa phong kín đường về<br />và đêm ơi xin cứ dài vô tận<br /><br />Mình dựa vào nhau cho thuyền ghé bến<br />sưởi ấm đời nhau bằng những môi hôn<br />mình cầm tay nhau nghe tình dâng sóng nổi<br />hãy biến cuộc đời thành những tối tân hôn<br /><br />Da em trắng anh chẳng cần ánh sáng<br />tóc em mềm anh chẳng tiếc mùa xuân<br />trên cuộc đời sẽ chẳng có giai nhân<br />vì anh gọi tên em là nhan sắc<br /><br />Anh vuốt tóc em cho đêm khuya tròn giấc<br />anh sẽ nâng tay cho ngọc sát kề môi<br />anh sẽ nói thầm như gió thoảng trên vai<br />và bên em tiếng đời đi rất vội<br /><br />Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa em có lạy trời mưa<br />anh vẫn xin mưa phong kín đường về<br />anh nhớ suốt đời mưa tháng sáu', '2010-09-26 17:00:00', null);
		COMMIT;
		"""
		wp.getQueryMethod query, (err)->
			if err then console.log err
			done()
	it "should select 10 records from test table", (done)->
		wp.getQueryMethod "select * from test limit 10", (err, results)->
			expect(err).to.equal(null)
			expect(results.length).to.equal(10)
			done()	
	it "should select  multiple values ", (done)->
		wp.getQueryMethod "select * from test where id=1381585041 or id=1381585042 or id=1381585043", (err, results2)->
			# console.log results2
			expect(err).to.equal(null)
			expect(results2.length).to.equal(3)
			done()
	it "should insert a song record into test test table where id=2000000099", (done)->
		song = {"id":2000000099,"key":"ZWZ9ZUD7","title":" Tháng 6 Trời Mưa ","artists":["Đàm Vĩnh Hưng"],"authors":[],"plays":"79819","topics":["Nhạc Trẻ","Việt Nam"],"link":"http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjclMkYwJTJGOSUyRjA5MjUyMWZmYmZkY2U3YTcyNTA4M2VjNGFkZWI3NWE2Lm1wMyU3QzI=","path":"2010/09/27/0/9/092521ffbfdce7a725083ec4adeb75a6.mp3","lyric":"Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa anh cũng lạy trời mưa<br />anh lạy trời mưa phong kín đường về<br />và đêm ơi xin cứ dài vô tận<br /><br />Mình dựa vào nhau cho thuyền ghé bến<br />sưởi ấm đời nhau bằng những môi hôn<br />mình cầm tay nhau nghe tình dâng sóng nổi<br />hãy biến cuộc đời thành những tối tân hôn<br /><br />Da em trắng anh chẳng cần ánh sáng<br />tóc em mềm anh chẳng tiếc mùa xuân<br />trên cuộc đời sẽ chẳng có giai nhân<br />vì anh gọi tên em là nhan sắc<br /><br />Anh vuốt tóc em cho đêm khuya tròn giấc<br />anh sẽ nâng tay cho ngọc sát kề môi<br />anh sẽ nói thầm như gió thoảng trên vai<br />và bên em tiếng đời đi rất vội<br /><br />Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa em có lạy trời mưa<br />anh vẫn xin mưa phong kín đường về<br />anh nhớ suốt đời mưa tháng sáu","date_created":"2010-09-26 17:00:00"}
		wp.getQueryMethod "INSERT IGNORE INTO test SET ? ", song, (err, results)->
			expect(err).to.equal(null)
			expect(results.length).to.equal(0)
			wp.getQueryMethod "select * from test where id=2000000099", (err, results2)->
				# console.log results2
				expect(err).to.equal(null)
				expect(results2.length).to.equal(1)
				done()
	it "should ignore the id=2000000099 of test because it is available in the table", (done)->
		song = {"id":2000000099,"key":"ZWZ9ZUD7","title":" Tháng 6 Trời Mưa ","artists":["Đàm Vĩnh Hưng"],"authors":[],"plays":"79819","topics":["Nhạc Trẻ","Việt Nam"],"link":"http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjclMkYwJTJGOSUyRjA5MjUyMWZmYmZkY2U3YTcyNTA4M2VjNGFkZWI3NWE2Lm1wMyU3QzI=","path":"2010/09/27/0/9/092521ffbfdce7a725083ec4adeb75a6.mp3","lyric":"Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa anh cũng lạy trời mưa<br />anh lạy trời mưa phong kín đường về<br />và đêm ơi xin cứ dài vô tận<br /><br />Mình dựa vào nhau cho thuyền ghé bến<br />sưởi ấm đời nhau bằng những môi hôn<br />mình cầm tay nhau nghe tình dâng sóng nổi<br />hãy biến cuộc đời thành những tối tân hôn<br /><br />Da em trắng anh chẳng cần ánh sáng<br />tóc em mềm anh chẳng tiếc mùa xuân<br />trên cuộc đời sẽ chẳng có giai nhân<br />vì anh gọi tên em là nhan sắc<br /><br />Anh vuốt tóc em cho đêm khuya tròn giấc<br />anh sẽ nâng tay cho ngọc sát kề môi<br />anh sẽ nói thầm như gió thoảng trên vai<br />và bên em tiếng đời đi rất vội<br /><br />Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa em có lạy trời mưa<br />anh vẫn xin mưa phong kín đường về<br />anh nhớ suốt đời mưa tháng sáu","date_created":"2010-09-26 17:00:00"}
		wp.getQueryMethod "insert ignore into test SET ? ", song, (err, results)->
			expect(err).to.equal(null)
			expect(results.length).to.equal(0)
			wp.getQueryMethod "select * from test where id=2000000099", (err, results2)->
				# console.log results2
				expect(err).to.equal(null)
				expect(results2.length).to.equal(1)
				done()
	it "should delete a song record into test test table where id=2000000099", (done)->
		# console.log "asdasd"
		wp.getQueryMethod "delete * from test where id=2000000099 ", (err, results)->
			# console.log results
			expect(err).to.equal(null)
			expect(results.length).to.equal(0)
			wp.getQueryMethod "select * from test where id=2000000099", (err, results2)->
				# console.log results2
				expect(err).to.equal(null)
				expect(results2.length).to.equal(0)
				done()

	it "should update song_artist field whose type is ARRAY", (done)->
		artists = ["test14","test2"]
		query = "update test set artists=#{wp.escape JSON.stringify(artists).replace('[','{').replace(']','}')} where id=2000000000 "
		# console.log query
		wp.getQueryMethod query, (err, results)->
			expect(err).to.equal(null) 
			expect(results.length).to.equal(0)
			wp.getQueryMethod "select * from test where id=2000000000", (err, results2)->
				expect(err).to.equal(null)
				expect(results2.length).to.equal(1)
				# console.log results2
				expect(results2[0].artists).to.eql(artists)
				done()

	it "should update title field whose type is STRING", (done)->
		name = "singile quote '-'  double quotes \"\" [][]{}{}{)()/////\\\\?=.-:;M;.#€%&hương là nắng mai"
		wp.getQueryMethod "update test set title=#{wp.escape name} where id=2000000000 ", (err, results)->
			expect(err).to.equal(null) 
			expect(results.length).to.equal(0)
			wp.getQueryMethod "select * from test where id=2000000000", (err, results2)->
				expect(err).to.equal(null)
				expect(results2.length).to.equal(1)
				# console.log results2
				expect(results2[0].title).to.equal(name)
				done()

	it "should drop table test", (done)->
		query  = """
		DROP TABLE IF EXISTS "public"."test";
		"""
		wp.getQueryMethod query, (err, results)->
			expect(err).to.equal(null) 
			expect(results.length).to.equal(0)
			wp.getQueryMethod "select * from test where id=2000000000", (err, results2)->
				expect(err).to.match(/relation .+does not exist/)
				wp.endConnection()
				done()



