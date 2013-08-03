String::stripHtmlTags = (tag)->
	if not tag then tag = ""
	@.replace(RegExp("</?" + tag + "[^<>]*>", "gi"), "")

String::getTagAttributes = (att)->
	if not att then att = "\\S+" 
	re = "(#{att})=[\"\']\?((\?\:\.(\?\![\"\']\?\\s+(\?\:\\S+)=|[>\"\']))\+\.)[\"\']?"
	reg = new RegExp(re,"gi")
	@.match(reg)


String::getTag = (tag)->
	# NOTE: this func does not resolve the nested tags
	if not tag then tag = "\\S+"
	re = "<#{tag}[^>]*>?(.*?)(<\/#{tag}>|\/>)"
	# re = "<(#{tag})([^<]+)*(?:>(.*)<\/\\1>|\\s+\/>)"
	reg = new RegExp(re,"gi")
	@.match(reg)
	
test = "
<br href=test.html class=4444 />
<a href=test.html class=4444> aa=df asd  </a>1
<a href=\"test.html\" class=\"7777\"> adf asdf </a>
<a href='test.html' class=\"4555\">  asdf d </a>
"
test2 = '<div class="clear-fix"></div><div class="content-item ">
<a title="Tập 4 - Vòng Đối Đầu" href="http://tv.zing.vn/video/Giong-Hat-Viet-Tap-4-Vong-Doi-Dau/IWZ9FOIU.html?from=mp3zing" target="_blank" class="video-img"><img src="http://image.mp3.zdn.vn/home_channel_hot/d/8/d8bb936bc561ece8e37bb0f83367a211_1375029551.jpg" width="128" height="72" alt="Tập 4 - Vòng Đối Đầu" /></a>
<h3><a title="Tập 4 - Vòng Đối Đầu" href="http://tv.zing.vn/video/Giong-Hat-Viet-Tap-4-Vong-Doi-Dau/IWZ9FOIU.html?from=mp3zing" target="_blank">Tập 4 - Vòng Đối Đầu</a></h3>
<span><a href="http://tv.zing.vn/giong-hat-viet?from=mp3zing" title="Giọng Hát Việt 2013" target="_blank" class="_strCut" strlength="24">Giọng Hát Việt 2013</a></span>
</div>'

test3 = '<h1 class="name"><a target="_blank" href="http://www.nhaccuatui.com/tim-kiem?q=Mars" title="Mars">Mars</a> - <a href="http://www.nhaccuatui.com/tim-kiem?q=Jay+Sean&b=singer" title="Tìm các bài hát, playlist, mv do ca sĩ Jay Sean trình bày" target="_blank">Jay Sean</a>, <a href="http://www.nhaccuatui.com/tim-kiem?q=Rick+Ross&b=singer" title="Tìm các bài hát, playlist, mv do ca sĩ Rick Ross trình bày" target="_blank">Rick Ross</a></h1>'
# console.log test.stripHtmlTags("")
# console.log test2.stripHtmlTags("div").stripHtmlTags("a").stripHtmlTags("h3").stripHtmlTags("img")
# console.log test.getTagAttributes("href")
# console.log test2.getTagAttributes("title")
# console.log test.getTag("a")
# console.log test.getTag("br")
# console.log test2.getTag("h3")

console.log test3.stripHtmlTags()
