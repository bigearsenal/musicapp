class NS
	@_a : ['bw bg bQ bA aw ag aQ aA Zw Zg'.split(' '),
			'fedcbaZYXW'.split(''),
			'NJFBdZVRtp'.split(''),
			'U0 Uk UU UE V0 Vk VU VE W0 Wk'.split(' '),
			'RQTSVUXWZY'.split(''),
			'hlptx159BF'.split(''),
			' X1 XF XV Wl W1 WF WV Vl V1'.split(' ')]
	@_b : ['bw bg bQ bA aw ag aQ aA Zw Zg'.split(' '),
			'fedcbaZYXW'.split(''),
			'MIEAcYUQso'.split(''),
			'Uw Uj UQ UD Vw Vj VQ VD Ww Wj'.split(' '),
			'RQTSVUXWZY'.split(''),
			'hlptx159BF'.split(''),
			' X1 XF XV Wl W1 WF WV Vl V1'.split(' ')]
	@_c : ['bw bg bQ bA aw ag aQ aA Zw Zg'.split(' '),
			'fedcbaZYXW'.split(''),
			'MIEAcYUQso'.split(''),
			'U0 Uk UU UE V0 Vk VU VE W0 Wk'.split(' '),
			'RQTSVUXWZY'.split(''),
			'hlptx159BF'.split(''),
			' X1 XF XV Wl W1 WF WV Vl V1'.split(' ')]
	@encrypt : (id) ->
		(id+'').split('').map((v,i)-> NS._a[6-i][v]).join('')
	@decrypt : (id) ->
		arr = [id.slice(0,2),id.slice(2,3),id.slice(3,4),id.slice(4,6),id.slice(6,7),id.slice(7,8),id.slice(8,10)].filter (e) -> e if e isnt ''
		parseInt(arr.map((v,i) -> NS._a[6-i].indexOf(v)).join(''), 10)
	@getKey : (id)->
		if id.toString().match(/^[0-9]+$/) then return NS.encrypt(parseInt(id,10))
		else return null
	@getID : (key)->
		return NS.decrypt(key)
	@checkKey : (key)->
		arr = [key.slice(0,2),key.slice(2,3),key.slice(3,4),key.slice(4,6),key.slice(6,7),key.slice(7,8),key.slice(8,10)].filter (e) -> e if e isnt ''
		t = arr.map((v,i) -> NS._a[6-i].indexOf(v)).join('')
		p = arr.map((v,i) -> NS._b[6-i].indexOf(v)).join('')
		q = p = arr.map((v,i) -> NS._c[6-i].indexOf(v)).join('')
		if t.match(/^[0-9]+$/) or p.match(/^[0-9]+$/) or q.match(/^[0-9]+$/) then return true
		else return false

# console.log NS.getID "X1pYW0pebQ"
# console.log NS.getKey 17444
# # WVFSVg 7935
# console.log NS.checkKey "X1pYW0pebQ"

module.exports = NS

