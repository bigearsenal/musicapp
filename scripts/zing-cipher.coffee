_encodeIdToInteger_ZING = (id)->
		a = "0IWOUZ6789ABCDEF".split('')
		b = "0123456789ABCDEF"
		parseInt Array::map.call(id, (v)-> b[a.indexOf(v)]).join(''), 16
_decodeIntegerToId_ZING = (i)->
		a = "0IWOUZ6789ABCDEF".split('')
		b = "0123456789abcdef"
		i.toString(16).split('').map((v)-> a[b.indexOf(v)]).join('')
encryptId = (id) ->
	a = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty".split("|") 
	[1,0,8,0,10].concat((id-307843200+'').split(''),[10,1,2,8,10,2,0,1,0]).map((i)-> 
		a[i][Math.random()*a[i].length|0]).join('')
# encryptId = (id) ->
# 	a = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty".split("|") 
# 	Array::map.call("1080|" + (id-307843200) + "|128|2010",(i)->
# 		if i isnt "|" then a[i][Math.random()*a[i].length|0] 
# 		else  "Tty"[Math.random()*3|0]).join('')	

encryptZingID = (id)->
	a = "0IWOUZ6789ABCDEF".split('')
	b = "0123456789ABCDEF"
	c = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty".split("|")
	[1,0,8,0,10].concat((parseInt(id.split('').map((v)->b[a.indexOf(v)]).join(''),16)-307843200+'').split(''),[10,1,2,8,10,2,0,1,0]).map((i)-> 
		c[i][Math.random()*c[i].length|0]).join('')
encryptZingID320Kbps = (id)->
	a = "0IWOUZ6789ABCDEF".split('')
	b = "0123456789ABCDEF"
	c = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty".split("|")
	[1,0,8,0,10].concat((parseInt(id.split('').map((v)->b[a.indexOf(v)]).join(''),16)-307843200+'').split(''),[10,3,2,0,10,2,0,1,0]).map((i)-> 
		c[i][Math.random()*c[i].length|0]).join('')
encryptZingTVID720 = (id)->
	a = "0IWOUZ6789ABCDEF".split('')
	b = "0123456789ABCDEF"
	c = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty".split("|")
	[1,0,8,0,10].concat((parseInt(id.split('').map((v)->b[a.indexOf(v)]).join(''),16)-307843200+'').split(''),[10,2,0,1,0]).map((i)-> 
		c[i][Math.random()*c[i].length|0]).join('')
	# [1,0,8,0,10].concat((parseInt(id.split('').map((v)->b[a.indexOf(v)]).join(''),16)-307843200+'').split(''),[10,1,4,0,8,10,2,0,1,0]).map((i)-> 
	# 	c[i][Math.random()*c[i].length|0]).join('')
encryptZingTVXMLID720 = (id)->
	a = "0IWOUZ6789ABCDEF".split('')
	b = "0123456789ABCDEF"
	c = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty".split("|")
	[1,0,8,0,10].concat((parseInt(id.split('').map((v)->b[a.indexOf(v)]).join(''),16)-307843200+'').split(''),[10,1,3,4,8,10,2,0,1,0]).map((i)-> 
		c[i][Math.random()*c[i].length|0]).join('')
# TV
# "ZHJmydDZJdyFGkH" 307875629-307843200
# "ZnJmy...t 	LAmJ 	tyvGkm" 	1,4,0,8,10,10,2,0,1,0
# "LHJmy...t 	LzGx 	yyDnLH" 	1,4,0,8
# "LnJmy...T 	LVlJ   	ytbnLn"	 	1,3,4,8
# "kncHt...y 	Ldlx 	yTFnLG" 	1,3,4,8 -> 32183
# "LmJmt...y 	kVSc 	yybnLH"	1,3,4,8 -> 32183
# "ZnJHy...T 	Lldd 	yTFmLG" 	1,4,3,3 -> 32267
# "LmJHt...T 	Lznx 	ytDnkn" 	1,4,0,8 -> 32429
# "LnJHy...y 	kCvN 	ytDmkH" 	1,6,2,8 -> 32139
# "LmJnt...y 	LpXW 	TyvGLn" 	1,5,6,5 -> 30330
# "ZGxGT...y 	kkHG 	TyvGkn" 	1,1,0,0 ->	22574
# ""
encryptZingIDLossless = (id)->
	a = "0IWOUZ6789ABCDEF".split('')
	b = "0123456789ABCDEF"
	c = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty|rIU|POwq|efK|Mjo".split("|")
	[1,0,8,0,10].concat((parseInt(id.split('').map((v)->b[a.indexOf(v)]).join(''),16)-307843200+'').split(''),[10,11,12,13,13,11,14,13,13,10,2,0,1,0]).map((i)-> 
		c[i][Math.random()*c[i].length|0]).join('')

getEncryptedID = (id,bitrate='128')->
	a = "0IWOUZ6789ABCDEF".split('')
	b = "0123456789ABCDEF"
	c = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty|rIU|POwq|efK|Mjo".split("|")
	if bitrate is '128' then A = [10,1,2,8,10,2,0,1,0]
	else if bitrate is '320' then A = [10,3,2,0,10,2,0,1,0]
	else if bitrate is 'lossless' then A = [10,11,12,13,13,11,14,13,13,10,2,0,1,0] 
	else A = []
	[1,0,8,0,10].concat((parseInt(id.split('').map((v)->b[a.indexOf(v)]).join(''),16)-307843200+'').split(''),A).map((i)-> 
		c[i][Math.random()*c[i].length|0]).join('')


# 320kbps
# "ZmcGy.....TBFGyvGkm" - 10,3,2,0,10,2,0,1,0
# LOSSLESS
# 10 encoded id:	L	O	S	S	L	E	S	S
# "LnJGT	y		r	P	e	f	I	M	f	f	TFmLn -  10,	r,P,e,f,I,M,f,f,10,2,0,1,0
# "ZGxGT	T		I	O	f	f	r	j	f	e	ybnLm -  10,	I,O,f,f,r,j,f,e
# "kGxny	t		r	O	e	e	r	j	K	f	tDHkm
# "ZGcHy	T		r	w	e	f	r	o	K	f	TDnLm
# "LHJnT	y		r	q	e	e	I	o	K	f	TvHLG
# "LnxGy	T		U	q	K	K	r	j	f	f	yFHLG
# "kmxmt	T		r	O	f	e	r	M	f	f	yFHLH
# "LnJGy	T		I	O	e	K	r	M	e	e	TFGLG
# "knxHy	T		r	O	f	f	I	M	f	K	TDHkm
# "kGxnT	y		r	w	e	f	I	j	f	f	yvGkm
#  We have: 'rIU' => 'L' , 'POwq' =>'O' , 'efK' => 'S', 'Mjo' => 'E'
#  We index the letters L, O, S ,E.  'L' => 11, 'O'=>12 , 'S' => 13 , 'E' => 14
#  Therefore: L O S S L E S S means 11,12,13,13,11,14,13,13
console.log "http://mp3.zing.vn/html5/video/" + encryptId 1382441101
console.log _decodeIntegerToId_ZING 1381685165
console.log _encodeIdToInteger_ZING("ZW67UDD8")-307843200+307843200
console.log "Video: 				http://mp3.zing.vn/html5/video/" + encryptZingID "ZW6OII9O"
console.log "Song 320kbps: 	http://mp3.zing.vn/download/song/joke-link/" + getEncryptedID "ZW6UAFD0",'320'
console.log "Song Lossless: 		http://mp3.zing.vn/download/song/joke-link/" + getEncryptedID "ZW6UAFD0",'lossless'

console.log "TV: 				http://tv.zing.vn/html5/video/" + encryptZingTVID720 "IWZ9CEO7"
console.log "TV - XML : 			http://tv.zing.vn/tv/xml/media/" + encryptZingTVXMLID720  "IWZ99AUU"

