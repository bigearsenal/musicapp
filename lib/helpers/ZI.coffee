class ZI
	@_a : "0IWOUZ6789ABCDEF".split('')
	@_b : "0123456789abcdef"
	@_c : "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty|rIU|POwq|efK|Mjo".split("|")
	@checkKey : (key)->
		for el in key.split("")
			if ZI._a.indexOf(el) is -1 then return false
		return true
	@encrypt : (i)->
		i.toString(16).split('').map((v)-> ZI._a[ZI._b.indexOf(v)]).join('')
	@decrypt : (key)->
		parseInt Array::map.call(key, (v)-> ZI._b[ZI._a.indexOf(v)]).join(''), 16
	@getKey : (id)->
		if id.toString().match(/^[0-9]+$/) then return ZI.encrypt(parseInt(id,10))
		else  return null
	@getID : (src)->
		if typeof src  is 'string' then return  ZI.decrypt(src)
		else if typeof src is 'number' then return src
		else return null
	@_getCipherText : (id,tailArray)->
		[1,0,8,0,10].concat((id-307843200+'').split(''),tailArray).map((i)-> 
				ZI._c[i][Math.random()*ZI._c[i].length|0]).join('')
	@getEncodedKey : (src)->
		return ZI._getCipherText ZI.getID(src),[10,1,2,8,10,2,0,1,0]
	@Video : {
		getEncodedKey : (src,type=360)->
			# type is 360,480,720,1080
			return ZI._getCipherText ZI.getID(src),[10].concat(type.toString().split('').map((v)->parseInt(v,10)),[10,2,0,1,0])
	}
	@Song : {
		getEncodedKey : (src,bitrate=128)->
			#bitrate 128,320
			A = if bitrate is 'lossless' then [11,12,13,13,11,14,13,13]  else bitrate.toString().split('').map((v)->parseInt(v,10))
			return ZI._getCipherText ZI.getID(src),[10].concat(A,[10,2,0,1,0])
	}
	@TV : {
		getEncodedKey : (src)->
			return ZI._getCipherText ZI.getID(src),[10,2,0,1,0]
	}



module.exports = ZI