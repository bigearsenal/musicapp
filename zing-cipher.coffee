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

console.log "http://mp3.zing.vn/html5/video/" + encryptId 1381585458
console.log "http://mp3.zing.vn/html5/video/" + encryptZingID "ZW6Z7DE0"
console.log _decodeIntegerToId_ZING 1382352024
console.log _encodeIdToInteger_ZING "ZWZA9D6F"

