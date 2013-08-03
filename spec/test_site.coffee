Site = require "../lib/Site"


class TestSuite extends Site
	constructor: ->
		super "test"
		
	escape : ->
		a = [{"link":"http://data.chiasenhac.com/downloads/1115/6/1114856-71d35567/32/file-name.m4a","type":"m4a","file_size":3328,"bitrate":"32kbps"},{"link":"http://data.chiasenhac.com/downloads/1115/6/1114856-71d35567/128/file-name.mp3","type":"mp3","file_size":11786,"bitrate":"128kbps"},{"link":"http://data.chiasenhac.com/downloads/1115/6/1114856-71d35567/320/file-name.mp3","type":"mp3","file_size":29409,"bitrate":"320kbps"}]
		a = ["21323","2132"]
		console.log @connection.escape(JSON.stringify a).replace(/^'\[/g,"{").replace(/\]'$/g,"}")
	queryTest : ->
		@connect()
		song = {"sid":2000000010,"songid":"asdfd","song_name":" asdf asdf as ","song_artist":["sdfsdfasdfg"],"author":"","plays":"79819","topic":"[\"Nhạc Trẻ\",\"Việt Nam\"]","song_link":"http://mp3.zing.vn/xml/load-song/MjAxMCUyRjA5JTJGMjclMkYwJTJGOSUyRjA5MjUyMWZmYmZkY2U3YTcyNTA4M2VjNGFkZWI3NWE2Lm1wMyU3QzI=","path":"2010/09/27/0/9/092521ffbfdce7a725083ec4adeb75a6.mp3","lyric":"Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa anh cũng lạy trời mưa<br />anh lạy trời mưa phong kín đường về<br />và đêm ơi xin cứ dài vô tận<br /><br />Mình dựa vào nhau cho thuyền ghé bến<br />sưởi ấm đời nhau bằng những môi hôn<br />mình cầm tay nhau nghe tình dâng sóng nổi<br />hãy biến cuộc đời thành những tối tân hôn<br /><br />Da em trắng anh chẳng cần ánh sáng<br />tóc em mềm anh chẳng tiếc mùa xuân<br />trên cuộc đời sẽ chẳng có giai nhân<br />vì anh gọi tên em là nhan sắc<br /><br />Anh vuốt tóc em cho đêm khuya tròn giấc<br />anh sẽ nâng tay cho ngọc sát kề môi<br />anh sẽ nói thầm như gió thoảng trên vai<br />và bên em tiếng đời đi rất vội<br /><br />Tháng sáu trời mưa trời mưa không dứt<br />trời không mưa em có lạy trời mưa<br />anh vẫn xin mưa phong kín đường về<br />anh nhớ suốt đời mưa tháng sáu","created":"2010-09-26 17:00:00"}
		
		@connection.query "insert into nssongs (songid,name,artist,artistid,author,authorid,totaltime,plays,topic,bitrate,official,islyric,mp3link,lyric,created,updated) VALUES(1297642,'No Suprises','Radiohead',5741,'',0,227,40,'Nhạc Âu Mỹ',320,1,0,'http://st02.freesocialmusic.com/mp3/2013/07/25/1486073233/13747712991_4075.mp3','','2013-7-25 23:54:59','2013-7-27 19:6:19')", (err, results)=>
			console.log "callled"
			if err then console.log err
			else 
				# console.log results
				for result in results
					console.log  result.formats
					console.log "-------------"

			@connection.end()

		# @connection.query "INSERT IGNORE INTO test SET ? ", song, (err, results)=>
		# 	console.log "callled"
		# 	if err then console.log err
		# 	else 
		# 		console.log results
		# 		console.log "-------"

		# 	@connection.end()



test = new TestSuite()
test.escape()
# test.queryTest()

# Array::splitBySeperator = (seperator) ->
# 	result = []
# 	for val in @
# 		_a = val.split(seperator)
# 		for item in _a
# 			result.push item.trim()
# 	return result
# Array::unique = -> @filter (a, b) => (@.indexOf(a, b + 1) < 0)
# Array::replaceElement = (source,value)->
# 	for val,index in @
# 		if val is source
# 			@[index] = value
# 	return @
# a = [ 'Hàn Quốc', 'Rap / Hip Hop' ]
# b = "Hàn Quốc, Rap / Hip Hop"
# console.log  b.split().splitBySeperator(' / ').replaceElement('Rap',"anbinh").unique()

# groupBy = (obj, value, context) ->
	
# 	# This function is ported from underscore library
# 	ArrayProto = Array.prototype
# 	ObjProto = Object.prototype
# 	nativeForEach  = ArrayProto.forEach
# 	hasOwnProperty   = ObjProto.hasOwnProperty
# 	has = (obj, key) -> hasOwnProperty.call obj, key
# 	each = (obj, iterator, context) ->
# 		return  unless obj?
# 		if nativeForEach and obj.forEach is nativeForEach
# 			obj.forEach iterator, context
# 		else if obj.length is +obj.length
# 			i = 0
# 			l = obj.length
# 			while i < l
# 				return  if iterator.call(context, obj[i], i, obj) is breaker
# 				i++
# 		else
# 			for key of obj
# 				return  if iterator.call(context, obj[key], key, obj) is breaker  if has(obj, key)
# 	isFunction = (obj) -> typeof obj is "function"
# 	identity = (value) -> value
# 	lookupIterator = (value) ->
# 		(if isFunction(value) then value else (obj) ->
# 			obj[value]
# 		)
# 	group = (obj, value, context, behavior) ->
# 		result = {}
# 		iterator = lookupIterator((if not value? then identity else value))
# 		each obj, (value, index) ->
# 			key = iterator.call(context, value, index, obj)
# 			behavior result, key, value
# 		result
# 	group obj, value, context, (result, key, value) ->
# 		((if has(result, key) then result[key] else (result[key] = []))).push value

# a = ["Ái Vân","Ái Vân","Ái Vân","Ái Vân","Ái Vân","Ái Vân","Ái Vân","Ái Vân","Ái Vân","Ái Vân","Nguyễn Hưng"]
# # a = ["Bảo Hân","Lynda Trang Đài","Phi Phi","Henry Chúc","BẢo Hân","Jenny Loan","Phi Phi","Bảo Hân","Bảo Hân","Don Hồ","BẢo Hân","Thế Sơn"]
# a = ["Frank Ocean","Frank Ocean","Frank Ocean","Frank Ocean","Frank Ocean","Frank Ocean","Frank Ocean","Earl Sweatshirt","Frank Ocean","Frank Ocean","Frank Ocean","Frank Ocean","Frank Ocean","John Mayer","Frank Ocean","Frank Ocean","Frank Ocean","André 3000","Frank Ocean","Frank Ocean"]
# a = ["Thanh Hà","Duy Quang","Hương Lan","Ái Vân","Dalena","Don Hồ","BẢo Hân","Jenny Loan","Phi Phi","Nguyễn Hưng","Đức Huy","Henry Chúc","Don Hồ","Hợp Ca"]
# a  = ["Dalena","Thanh Lan","Thái Châu","Thanh Lan","Thái Châu","Nguyễn Hưng","Kỳ Duyên","Bảo Hân","Phi Phi","Phượng Thúy","Thanh Hà","Thế Sơn","Duy Quang","Ái Vân","Elvis Phương","Thanh Hà","Thế Sơn","Mỹ Huyền","Nguyễn Hưng"]
# a = ["Hương Lan","Thế Sơn","Hương Lan","Thế Sơn","Hương Lan","Thế Sơn","Hương Lan","Thế Sơn"]
# a = ["Kim Tae Woo","Nancy","Seo In Trouble","Big Bang","Shin Seung Hun","D sembeo","Lee Jung Hyun","Ji","Youth","D sembeo"]
# arr  = ["Lý Hải","Lý Hải","Lý Hải","Lý Hải","Lý Hải","Lý Hải","Lý Hải","Lý Hải","Lý Hải","Lý Hải","Lý Hải","Lý Hải","Lý Hải","Lý Hải","Lý Hải"]
# # b = groupBy a, (value)-> value



# artists = []
# albumArtists = []
# if arr .length > 0 
# 	arr = split_array_apart(arr,',')
# 	Array::unique = -> @filter (a, b) => (@.indexOf(a, b + 1) < 0)
# 	b = {}
# 	b[artist] = [] for artist in arr .unique()
# 	b[artist].push artist for artist in arr 
# 	# console.log b


# 	for artistName,values of b
# 		artists.push {name : artistName, count : values.length}

# 	# sort artist by DESC order
# 	artists = artists.sort (a,b)-> return  b.count - a.count
# 	# total apprearance in list
# 	total = artists.reduce ((a,b)->  return a + b.count), 0

# 	if artists[0].count/total > 0.5
# 		albumArtists.push artists[0].name
# 	else
# 		if (artists[0].count + artists[1].count)/total > 0.5
# 			albumArtists.push artists[0].name
# 			albumArtists.push artists[1].name
# 		else 
# 			albumArtists.push "Various Artists"
# return albumArtists

# console.log albumArtists



