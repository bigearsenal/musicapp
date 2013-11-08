
# Element represents the basic type of song, album or video
# It transforms them from different sources into a singular source
# It takes data from songs,albums and videos table
# Put them back to GRAND TABLES
# Item is an object having some basic fields
# {
# 	id
# 	title
# 	artists
# 	authors (optional)
# 	country
# 	styles
# 	genres
# 	plays
# 	duration (optional)
# 	size (optional)
# 	links
# 	lyric (optional)
# 	date_created 
# 	date_updated (optional)
# 	checktime
# }
require "../string"
require "../array"
topics = ["Nhạc Trẻ","Nhạc Trữ Tình","Nhạc Cách Mạng",
"Nhạc Trịnh ","Nhạc Tiền Chiến","Nhạc Dân Tộc","Nhạc Thiếu Nhi","Nhạc Không Lời",
"Rock Việt","Nhạc Hải Ngoại","Nhạc Quê Hương","Nhạc Việt Nam","Nhạc Quốc Tế",
"Rap Việt - Hiphop","Nhạc Hoa","Nhạc Hàn","Nhạc Pháp","Nhạc Các Nước Khác",
"Classical","Nhạc Phim","Nhạc Âu Mỹ","Pop","Rock","Hiphop/Rap","Country","Jazz","Hiphop",
"Latin","Thể Loại","Dance/Electronic","Nhạc Nhật","Chưa phân loại","Style",
"Acoustic/Audiophile","Soul","Reggae","Metal","New Age","R&B","Folk","Opera","TV Shows",
"VMVC 2011","Cặp Đôi Hoàn Hảo","Bài Hát Yêu Thích","Vietnam\'s Got Talent","Nhạc Chủ Đề",
"Nhạc 8/3","Nhạc chủ đề","Nhạc 8/3","Mừng QT phụ nữ 8/3","Nhạc Sàn","Nhạc Bà Bầu & Baby",
"Nhạc Spa | Thư Giãn","Nhạc Đám Cưới Hay","Sách Nói","Radio - Cảm Xúc","The Voice - Giọng Hát Việt",
"Vietnam Idol 2012","Nhạc Tuyển Tập","Shining Show","Gương Mặt Thân Quen","Ngâm Thơ","Fanmade / Radio"]

Vietnam = ["Nhạc Trẻ","Nhạc Trữ Tình","Nhạc Cách Mạng",
"Nhạc Trịnh","Nhạc Tiền Chiến","Nhạc Dân Tộc","Nhạc Thiếu Nhi",
"Rock Việt","Nhạc Hải Ngoại","Nhạc Quê Hương","Nhạc Việt Nam"]


# Turning elements of an array to lowercase
Array::toLowerCase = ()->
	return @.map (val)-> return val.toLowerCase()

class Element
	# items is an array whose elements are from the following source: cc,csn,nct,ns....
	constructor: (items) ->
		@item = {}
		@item.title = items[0].title
		@item.artists = items[0].artists
		@item.authors = @getAuthors(items)
		@item.country = @getCountry(items)
		@item.styles = @getStyles(items)
		@item.genres = @getGenres(items)
		@item.plays = @getPlays(items)
		@item.duration = @getDuration(items)
		@item.size = @getSize(items)
		@item.links = @getLinks(items)
		@item.lyric = @getLyric(items)
		@item.date_created = @getDateCreated(items)
	getAuthors : (items)->
		authors = []
		items.forEach (itm)-> if itm.authors then authors.push author for author in itm.authors
		return authors.unique()

	getCountry : (items)->
		countries = []
		items.forEach (itm)->
			if itm.topics
				for topic in itm.topics
					if Vietnam.toLowerCase().contains(topic.toLowerCase()) then countries.push("Vietnam")
					



	
