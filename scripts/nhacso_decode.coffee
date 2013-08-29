
decode  = (id) ->
	a = ['bw bg bQ bA aw ag aQ aA Zw Zg'.split(' '),
	 	 'fedcbaZYXW'.split(''),
	 	 'NJFBdZVRtp'.split(''),
	 	 'U0 Uk UU UE V0 Vk VU VE W0 Wk'.split(' '),
	 	 'RQTSVUXWZY'.split(''),
	 	 'hlptx159BF'.split(''),
	 	 ' X1 XF XV Wl W1 WF WV Vl V1'.split(' ')]
	(id+'').split('').map((v,i)-> a[6-i][v]).join('')

# REMEMER: THE DECODE with Videos is different "NJFBdZVRtp" will be turned into  "MIE..."
encode = (id) ->
	arr = [id.slice(0,2),id.slice(2,3),id.slice(3,4),id.slice(4,6),id.slice(6,7),id.slice(7,8),id.slice(8,10)].filter (e) -> e if e isnt ''
	a = ['bw bg bQ bA aw ag aQ aA Zw Zg'.split(' '),
	 	 'fedcbaZYXW'.split(''),
	 	 'NJFBdZVRtp'.split(''),
	 	 'U0 Uk UU UE V0 Vk VU VE W0 Wk'.split(' '),
	 	 'RQTSVUXWZY'.split(''),
	 	 'hlptx159BF'.split(''),
	 	 ' X1 XF XV Wl W1 WF WV Vl V1'.split(' ')]
	parseInt(arr.map((v,i) -> a[6-i].indexOf(v)).join(''), 10)

# console.log songIdEncode(1273487)
console.log encode "WVtZVUBc"
console.log decode(1301930)
# console.log decode(1274109)
# console.log encode decode(1273674)

# THIS PART is for ZING
_encodeIdToInteger_ZING = (id)->
		a = "0IWOUZ6789ABCDEF".split('')
		b = "0123456789ABCDEF"
		parseInt id.split('').map((v)-> b[a.indexOf(v)]).join(''), 16

_decodeIntegerToId_ZING = (i)->
		a = "0IWOUZ6789ABCDEF".split('')
		b = "0123456789abcdef"
		i.toString(16).split('').map((v)-> a[b.indexOf(v)]).join('')

encryptId = (id) ->
		# 307843200 is a constant between the new id and the original
		arr = "GHmn<LZk<DFbv<BVd<ASlz<QWp<ghXC<Nas<Jcx<ERui".split("<")
		a = "nkbdzphacu".split('')
		"ZGJGT" + (id-307843200).toString().split('').map((v)-> a[v]).join('') + "TZDJTDGLG"

decodeString = (str)->
		s=["IJKLMNOPQRSTUVWXYZabcdef",
		"CDEFGHSTUVWXijklmnyz0123"]
		base24 = "0123456789abcdefghijklmn"
		s1 = "AEIMQUYcgkosw048".split('')
		category = ""

		charCode = (x)->x.charCodeAt(0)

		x1x2 = str.substr(0,2).split('').map((v, i)-> base24[s[i].indexOf(v)] ).join('')
		n = parseInt(x1x2,24)

		x3 = str[2]
		x4 = str[3]
		c_x3 = charCode(x3)
		c_x4 = charCode(x4)  

		for i in [0..s1.length-2]
			if 56<=c_x3<=57
				if c_x3 is 56 then category = "typeA"
				else category = "typeB"
				additionalFactor =  s1.indexOf "8"
				break
			else if charCode(s1[i])<=c_x3<charCode(s1[i+1])
					# console.log "#{s1[i]}"
					additionalFactor = s1.indexOf s1[i]
					if c_x3 is charCode(s1[i])
						category = "typeA"
					else 
						if c_x3 is charCode(s1[i])+1
							category = "typeB"
						else category = "typeC"

		# console.log "the input is #{str}"
		# console.log "Additional Factor is #{additionalFactor}"
		# console.log "Value of x3 is #{x3}: Category: #{category}"

		#additionalFactor is the remainder in hex value from (0..15)
		c_y2 = (n%6 + 2)*16 + additionalFactor
		c_y1 = Math.floor(n/6)+32

		c_y3 = ""
		if category is "typeA"
		
			if 103<=c_x4<=122
				c_y3 = c_x4 - 103 + 32
			if 48<=c_x4<=57
				c_y3 = c_x4 + 4
		else 
			if category is "typeB"
				
				if 65<=c_x4<=90
					c_y3 = c_x4 - 1
				else if 97<=c_x4<=122
					c_y3 = c_x4 - 7
				else if 48<=c_x4<=57
					c_y3 = c_x4 + 68
			else 
				# doing thing with C D
				c_y3 = 63
		[String.fromCharCode(c_y1), String.fromCharCode(c_y2), String.fromCharCode(c_y3)].join('')
		# [result,remainder]

encodeString = (str)->

		s=["IJKLMNOPQRSTUVWXYZabcdef",
			"CDEFGHSTUVWXijklmnyz0123"]
		base24 = "0123456789abcdefghijklmn"
		s1 = "AEIMQUYcgkosw048".split('')

		charCode = (x)-> x.charCodeAt(0)
		
		# find char codes of the characters in the source string
		c_y1 = charCode str[0]
		c_y2 = charCode str[1]
		c_y3 = charCode str[2]
		
		# find the category of the string source
		category = "typeC"
		if 32<=c_y3<=51
			c_x4 = c_y3 + 103 - 32
			category = "typeA"
		else
			if 52<=c_y3<=61
				c_x4 = c_y3 - 4
				category = "typeA"
			else 
				if 64<=c_y3<=89
					c_x4 = c_y3 + 1
					category = "typeB"
				else 
					if 90<=c_y3<=115
						c_x4 = c_y3 + 7
						category = "typeB"
					else
						if 116<=c_y3<=125
							c_x4 =  c_y3 - 68
							category = "typeB"
							
		# find the additional factor
		additionalFactor = c_y2%16
		index = additionalFactor
		
		# find char code of x3
		if category is "typeA"
			c_x3 = charCode s1[index]
		else if category is "typeB"
				c_x3 = charCode(s1[index]) + 1
			else if category is "typeC"
				c_x3 = charCode(s1[index]) + 2
		
		# find the number in base 10
		remainder = (c_y2 - additionalFactor)/16 - 2
		result = (c_y1 - 32)*6
		n = result + remainder
		
		# convert number to base 24 and map to a new string
		s_base24 = n.toString(24)
		x1x2 = s_base24.split('').map((v,i)-> s[i][base24.indexOf(v)]).join('')
		
		# return the final encoded string
		x1x2 + String.fromCharCode(c_x3) + String.fromCharCode(c_x4)

# Used for ZINGZGJGTknazpbzuukTZDJTDGLG
# console.log decodeString("MyU3")
# testStr = "MjAxMy8wMi8xMS84L2EvInagaMEOGFlMDY4MjdhNmQwMzExNDk1YmNjZTIyOTU5ODViOGUdUngWeBXAzfEZvInagaMEmUsICmV2ZXIgQWxvInagaMEWeBmV8SnVzdGFUZWV8MXwy"
# testStr = "eyJhY3RpWeB24iOiJsaXN0ZW4iLCJkYXRhIjp7ImFjY0lkIjowLCJhY2NvInagaMEdW50IjoiIiwiaG9zdCI6IjEwLjMwLjEyLjE1MCIsInJlWeBmRlmUsICl90aW1lIjowLjAzNzY2MzkzNjYxNDk5LCJwYXJhWeBSI6eyJsaXN0ZW5fdHlwZSI6InZpZGVvInagaMEIiwiaWQiOjEwNzQ0MDMxMTEsInRpdGxlIjoiRmVlWeBCBUaGlzIE1vInagaMEWeBWVdUngdCIsImFydGlzdF9pZCI6IjM0ODmUsICsODQzIiwiZ2VdUngmUsICmVfaWQiOiIzIiwia2V5IjoiMjgxMzRhODE0NjIwNDM1MTY1OGI4ZGZhYjhiODQ5Y2EifX1"
# testArr = []

# testArr.push decodeString testStr.slice(i, i+4) for i in [0..testStr.length-1] by 4
# console.log decodeURIComponent testArr.join('')
# console.log encodeString "4%7"
# console.log encryptId 1382365302
# console.log encryptId _encodeIdToInteger_ZING 'ZW6Z7CU7'
# console.log _encodeIdToInteger_ZING 'IWZ99FIF'
# console.log _decodeIntegerToId_ZING 1382382663

# convert mp3 path to string
# str = encodeURIComponent "2010/09/24/f/0/f036e127edb6847ae93f666c789fdee6.mp3"
# str = str.slice(0,60) # remove 3 in mp3 string
# testArr = []
# testArr.push encodeString str.slice(i, i+3) for i in [0..str.length-1] by 3
# console.log "http://mp3.zing.vn/xml/load-song/"+
# 			testArr.join('') + "MyU3QzI=" #using with mp3

# # using with video
# str = encodeURIComponent "2013/03/08/f/f/ff6a3d42057b7b47d89363884840dbd0.mp4"
# console.log str
# str = str.slice(0,60) # remove 3 in mp3 string
# testArr = []
# testArr.push encodeString str.slice(i, i+3) for i in [0..str.length-1] by 3
# console.log "http://mp3.zing.vn/xml/load-video/"+
# 			testArr.join('') + "NCU3QzI=" #using with mp4
# console.log [32..127].map((v)-> String.fromCharCode(v)).join('')

