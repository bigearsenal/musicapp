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

# decode video of ZW67D7I0
#  http://mp3.zing.vn/html5/video/LHcHTZHNSgRBNahtybmkH 480p
#  LGJHtLGNzXEdasCtLbJtDHLG 3gp
#  kmJHyZGNSCEBNNhtzxmTDnZG #mobile site
#  LHcHT Z 	H 	N 	S 	g 	R 	B 	N 	a 	h 	t 	ybmkH (10,2,0,1,0) #480p
#  LGJHt   L 	G 	N 	z 	X 	E 	d 	a 	s 	C 	t 	LbJtDHLG #3gp
#  kmJHy  Z 	G 	N 	S 	C 	E 	B 	N 	N 	h 	t 	zxmTDnZG (4,8,0,10,2,0,1,0) # mobile site
#  LHcHT 	ZHNSgRBNah 	t 	ybmkH
#  ZmJnt 	ZmszgEdsaC 	t 	vGZG
#  
encryptZingVideoID = (id)->
	a = "0IWOUZ6789ABCDEF".split('')
	b = "0123456789ABCDEF"
	c = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty".split("|")
	[1,0,8,0,10].concat((parseInt(id.split('').map((v)->b[a.indexOf(v)]).join(''),16)-307843200+'').split(''),[10,10,2,0,1,0]).map((i)-> 
		c[i][Math.random()*c[i].length|0]).join('')

encryptZingIDVideoWithType= (id,type)->
	a = "0IWOUZ6789ABCDEF".split('')
	b = "0123456789ABCDEF"
	c = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty".split("|")
	# type is 360,480,720,1080
	tail = [10].concat(type.toString().split('').map((v)->parseInt(v,10)),[10,2,0,1,0])
	[1,0,8,0,10].concat((parseInt(id.split('').map((v)->b[a.indexOf(v)]).join(''),16)-307843200+'').split(''),tail).map((i)-> 
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

encryptZingTVID720Test = (id)->
	a = "0IWOUZ6789ABCDEF".split('')
	b = "0123456789ABCDEF"
	c = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty".split("|")
	[1,0,8,0,10].concat((parseInt(id.split('').map((v)->b[a.indexOf(v)]).join(''),16)-307843200+'').split(''),[10,7,2,0,10,2,0,1,0]).map((i)-> 
		c[i][Math.random()*c[i].length|0]).join('')

console.log "http://mp3.zing.vn/html5/video/" + encryptId 1382441101
console.log _decodeIntegerToId_ZING 308934409
console.log _encodeIdToInteger_ZING("ZW67F76U")-307843200+307843200

console.log "VIDEO --------------------------------------"
console.log "Video (lowest): 		http://mp3.zing.vn/html5/video/" + encryptZingID "ZW67BW9E"
console.log "Video high(480): 	http://mp3.zing.vn/html5/video/" + encryptZingVideoID "ZW67BW9E"
console.log "Video with 240: 	http://mp3.zing.vn/html5/video/" + encryptZingIDVideoWithType "ZW67BW9E",240
console.log "Video with 360: 	http://mp3.zing.vn/html5/video/" + encryptZingIDVideoWithType "ZW67BW9E",360
console.log "Video with 480: 	http://mp3.zing.vn/html5/video/" + encryptZingIDVideoWithType "ZW67BW9E",480
console.log "Video with 720: 	http://mp3.zing.vn/html5/video/" + encryptZingIDVideoWithType "ZW67BW9E",720
console.log "Video with 1080: 	http://mp3.zing.vn/html5/video/" + encryptZingIDVideoWithType "ZW67BW9E",1080
console.log "END OF VIDEO --------------------------------------"

console.log "Song 128kbps: 	http://mp3.zing.vn/download/song/joke-link/" + getEncryptedID "ZW66WEOF",'128'
console.log "Song 320kbps: 	http://mp3.zing.vn/download/song/joke-link/" + getEncryptedID "ZW66WEOF",'320'
console.log "Song Lossless: 		http://mp3.zing.vn/download/song/joke-link/" + getEncryptedID "ZW66WEOF",'lossless'

console.log "TV: 				http://tv.zing.vn/html5/video/" + encryptZingTVID720 "IWZ9FCW9"
console.log "TV test: 			http://tv.zing.vn/html5/video/" + encryptZingTVID720Test "IWZ9FCW9"
console.log "TV - XML : 			http://tv.zing.vn/tv/xml/media/" + encryptZingTVXMLID720  "IWZ99AUU"



