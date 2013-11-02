# This class is an abtraction of item (song,album,video) that can be created into tables
# It will provide the basic concurrent jobs, type
# The real class whose function customJob will be overidden
class ItemConstruction extends require('events').EventEmitter
	constructor : (@sourceTable, @destinationTable, @connection)->
		@maxConcurrentJobs = 10
		@currentCursor = -1
		@_checkCursorCount = 0
		@totalRecords = 0
		@records = 0
		@limit = 20
		@offset = -1 # -1 means the option is disable
		@debug = true
		@destinationTable.fullName = @destinationTable.prefix + @destinationTable.type
		require('../helpers/array')
		Encoder = require('../../node_modules/node-html-encoder').Encoder
		@encoder = new Encoder('entity')
		@artistsSeparationPatterns = [" f(ea)?t\\.? "," duet ", " featuring "," [-_+] "," vs ","[,;] "," fs "]
		super()


	setMaxConcurrentJobs : (max)->
		@maxConcurrentJobs = max
	setLimit : (limit)->
		@limit = limit
	getLimit : ->
		@limit
	setOffset : (offset)->
		@offset = offset
	getTotalItemCount : ->
		return @totalItemCount
	getTotalRecords : ->
		return @totalRecords
	setTotalRecords : (num)->
		@totalRecords = num
	logInfo : ->
		#
	logResult : (pathToDisk)->
		#
	removeDiacritics : (str) ->
		diacritics = {"\u24B6":"A","\uFF21":"A","\u00C0":"A","\u00C1":"A","\u00C2":"A","\u1EA6":"A","\u1EA4":"A","\u1EAA":"A","\u1EA8":"A","\u00C3":"A","\u0100":"A","\u0102":"A","\u1EB0":"A","\u1EAE":"A","\u1EB4":"A","\u1EB2":"A","\u0226":"A","\u01E0":"A","\u00C4":"A","\u01DE":"A","\u1EA2":"A","\u00C5":"A","\u01FA":"A","\u01CD":"A","\u0200":"A","\u0202":"A","\u1EA0":"A","\u1EAC":"A","\u1EB6":"A","\u1E00":"A","\u0104":"A","\u023A":"A","\u2C6F":"A","\uA732":"AA","\u00C6":"AE","\u01FC":"AE","\u01E2":"AE","\uA734":"AO","\uA736":"AU","\uA738":"AV","\uA73A":"AV","\uA73C":"AY","\u24B7":"B","\uFF22":"B","\u1E02":"B","\u1E04":"B","\u1E06":"B","\u0243":"B","\u0182":"B","\u0181":"B","\u24B8":"C","\uFF23":"C","\u0106":"C","\u0108":"C","\u010A":"C","\u010C":"C","\u00C7":"C","\u1E08":"C","\u0187":"C","\u023B":"C","\uA73E":"C","\u24B9":"D","\uFF24":"D","\u1E0A":"D","\u010E":"D","\u1E0C":"D","\u1E10":"D","\u1E12":"D","\u1E0E":"D","\u0110":"D","\u018B":"D","\u018A":"D","\u0189":"D","\uA779":"D","\u01F1":"DZ","\u01C4":"DZ","\u01F2":"Dz","\u01C5":"Dz","\u24BA":"E","\uFF25":"E","\u00C8":"E","\u00C9":"E","\u00CA":"E","\u1EC0":"E","\u1EBE":"E","\u1EC4":"E","\u1EC2":"E","\u1EBC":"E","\u0112":"E","\u1E14":"E","\u1E16":"E","\u0114":"E","\u0116":"E","\u00CB":"E","\u1EBA":"E","\u011A":"E","\u0204":"E","\u0206":"E","\u1EB8":"E","\u1EC6":"E","\u0228":"E","\u1E1C":"E","\u0118":"E","\u1E18":"E","\u1E1A":"E","\u0190":"E","\u018E":"E","\u24BB":"F","\uFF26":"F","\u1E1E":"F","\u0191":"F","\uA77B":"F","\u24BC":"G","\uFF27":"G","\u01F4":"G","\u011C":"G","\u1E20":"G","\u011E":"G","\u0120":"G","\u01E6":"G","\u0122":"G","\u01E4":"G","\u0193":"G","\uA7A0":"G","\uA77D":"G","\uA77E":"G","\u24BD":"H","\uFF28":"H","\u0124":"H","\u1E22":"H","\u1E26":"H","\u021E":"H","\u1E24":"H","\u1E28":"H","\u1E2A":"H","\u0126":"H","\u2C67":"H","\u2C75":"H","\uA78D":"H","\u24BE":"I","\uFF29":"I","\u00CC":"I","\u00CD":"I","\u00CE":"I","\u0128":"I","\u012A":"I","\u012C":"I","\u0130":"I","\u00CF":"I","\u1E2E":"I","\u1EC8":"I","\u01CF":"I","\u0208":"I","\u020A":"I","\u1ECA":"I","\u012E":"I","\u1E2C":"I","\u0197":"I","\u24BF":"J","\uFF2A":"J","\u0134":"J","\u0248":"J","\u24C0":"K","\uFF2B":"K","\u1E30":"K","\u01E8":"K","\u1E32":"K","\u0136":"K","\u1E34":"K","\u0198":"K","\u2C69":"K","\uA740":"K","\uA742":"K","\uA744":"K","\uA7A2":"K","\u24C1":"L","\uFF2C":"L","\u013F":"L","\u0139":"L","\u013D":"L","\u1E36":"L","\u1E38":"L","\u013B":"L","\u1E3C":"L","\u1E3A":"L","\u0141":"L","\u023D":"L","\u2C62":"L","\u2C60":"L","\uA748":"L","\uA746":"L","\uA780":"L","\u01C7":"LJ","\u01C8":"Lj","\u24C2":"M","\uFF2D":"M","\u1E3E":"M","\u1E40":"M","\u1E42":"M","\u2C6E":"M","\u019C":"M","\u24C3":"N","\uFF2E":"N","\u01F8":"N","\u0143":"N","\u00D1":"N","\u1E44":"N","\u0147":"N","\u1E46":"N","\u0145":"N","\u1E4A":"N","\u1E48":"N","\u0220":"N","\u019D":"N","\uA790":"N","\uA7A4":"N","\u01CA":"NJ","\u01CB":"Nj","\u24C4":"O","\uFF2F":"O","\u00D2":"O","\u00D3":"O","\u00D4":"O","\u1ED2":"O","\u1ED0":"O","\u1ED6":"O","\u1ED4":"O","\u00D5":"O","\u1E4C":"O","\u022C":"O","\u1E4E":"O","\u014C":"O","\u1E50":"O","\u1E52":"O","\u014E":"O","\u022E":"O","\u0230":"O","\u00D6":"O","\u022A":"O","\u1ECE":"O","\u0150":"O","\u01D1":"O","\u020C":"O","\u020E":"O","\u01A0":"O","\u1EDC":"O","\u1EDA":"O","\u1EE0":"O","\u1EDE":"O","\u1EE2":"O","\u1ECC":"O","\u1ED8":"O","\u01EA":"O","\u01EC":"O","\u00D8":"O","\u01FE":"O","\u0186":"O","\u019F":"O","\uA74A":"O","\uA74C":"O","\u0152":"OE","\u01A2":"OI","\uA74E":"OO","\u0222":"OU","\u24C5":"P","\uFF30":"P","\u1E54":"P","\u1E56":"P","\u01A4":"P","\u2C63":"P","\uA750":"P","\uA752":"P","\uA754":"P","\u24C6":"Q","\uFF31":"Q","\uA756":"Q","\uA758":"Q","\u024A":"Q","\u24C7":"R","\uFF32":"R","\u0154":"R","\u1E58":"R","\u0158":"R","\u0210":"R","\u0212":"R","\u1E5A":"R","\u1E5C":"R","\u0156":"R","\u1E5E":"R","\u024C":"R","\u2C64":"R","\uA75A":"R","\uA7A6":"R","\uA782":"R","\u24C8":"S","\uFF33":"S","\u015A":"S","\u1E64":"S","\u015C":"S","\u1E60":"S","\u0160":"S","\u1E66":"S","\u1E62":"S","\u1E68":"S","\u0218":"S","\u015E":"S","\u2C7E":"S","\uA7A8":"S","\uA784":"S","\u1E9E":"SS","\u24C9":"T","\uFF34":"T","\u1E6A":"T","\u0164":"T","\u1E6C":"T","\u021A":"T","\u0162":"T","\u1E70":"T","\u1E6E":"T","\u0166":"T","\u01AC":"T","\u01AE":"T","\u023E":"T","\uA786":"T","\uA728":"TZ","\u24CA":"U","\uFF35":"U","\u00D9":"U","\u00DA":"U","\u00DB":"U","\u0168":"U","\u1E78":"U","\u016A":"U","\u1E7A":"U","\u016C":"U","\u00DC":"U","\u01DB":"U","\u01D7":"U","\u01D5":"U","\u01D9":"U","\u1EE6":"U","\u016E":"U","\u0170":"U","\u01D3":"U","\u0214":"U","\u0216":"U","\u01AF":"U","\u1EEA":"U","\u1EE8":"U","\u1EEE":"U","\u1EEC":"U","\u1EF0":"U","\u1EE4":"U","\u1E72":"U","\u0172":"U","\u1E76":"U","\u1E74":"U","\u0244":"U","\u24CB":"V","\uFF36":"V","\u1E7C":"V","\u1E7E":"V","\u01B2":"V","\uA75E":"V","\u0245":"V","\uA760":"VY","\u24CC":"W","\uFF37":"W","\u1E80":"W","\u1E82":"W","\u0174":"W","\u1E86":"W","\u1E84":"W","\u1E88":"W","\u2C72":"W","\u24CD":"X","\uFF38":"X","\u1E8A":"X","\u1E8C":"X","\u24CE":"Y","\uFF39":"Y","\u1EF2":"Y","\u00DD":"Y","\u0176":"Y","\u1EF8":"Y","\u0232":"Y","\u1E8E":"Y","\u0178":"Y","\u1EF6":"Y","\u1EF4":"Y","\u01B3":"Y","\u024E":"Y","\u1EFE":"Y","\u24CF":"Z","\uFF3A":"Z","\u0179":"Z","\u1E90":"Z","\u017B":"Z","\u017D":"Z","\u1E92":"Z","\u1E94":"Z","\u01B5":"Z","\u0224":"Z","\u2C7F":"Z","\u2C6B":"Z","\uA762":"Z","\u24D0":"a","\uFF41":"a","\u1E9A":"a","\u00E0":"a","\u00E1":"a","\u00E2":"a","\u1EA7":"a","\u1EA5":"a","\u1EAB":"a","\u1EA9":"a","\u00E3":"a","\u0101":"a","\u0103":"a","\u1EB1":"a","\u1EAF":"a","\u1EB5":"a","\u1EB3":"a","\u0227":"a","\u01E1":"a","\u00E4":"a","\u01DF":"a","\u1EA3":"a","\u00E5":"a","\u01FB":"a","\u01CE":"a","\u0201":"a","\u0203":"a","\u1EA1":"a","\u1EAD":"a","\u1EB7":"a","\u1E01":"a","\u0105":"a","\u2C65":"a","\u0250":"a","\uA733":"aa","\u00E6":"ae","\u01FD":"ae","\u01E3":"ae","\uA735":"ao","\uA737":"au","\uA739":"av","\uA73B":"av","\uA73D":"ay","\u24D1":"b","\uFF42":"b","\u1E03":"b","\u1E05":"b","\u1E07":"b","\u0180":"b","\u0183":"b","\u0253":"b","\u24D2":"c","\uFF43":"c","\u0107":"c","\u0109":"c","\u010B":"c","\u010D":"c","\u00E7":"c","\u1E09":"c","\u0188":"c","\u023C":"c","\uA73F":"c","\u2184":"c","\u24D3":"d","\uFF44":"d","\u1E0B":"d","\u010F":"d","\u1E0D":"d","\u1E11":"d","\u1E13":"d","\u1E0F":"d","\u0111":"d","\u018C":"d","\u0256":"d","\u0257":"d","\uA77A":"d","\u01F3":"dz","\u01C6":"dz","\u24D4":"e","\uFF45":"e","\u00E8":"e","\u00E9":"e","\u00EA":"e","\u1EC1":"e","\u1EBF":"e","\u1EC5":"e","\u1EC3":"e","\u1EBD":"e","\u0113":"e","\u1E15":"e","\u1E17":"e","\u0115":"e","\u0117":"e","\u00EB":"e","\u1EBB":"e","\u011B":"e","\u0205":"e","\u0207":"e","\u1EB9":"e","\u1EC7":"e","\u0229":"e","\u1E1D":"e","\u0119":"e","\u1E19":"e","\u1E1B":"e","\u0247":"e","\u025B":"e","\u01DD":"e","\u24D5":"f","\uFF46":"f","\u1E1F":"f","\u0192":"f","\uA77C":"f","\u24D6":"g","\uFF47":"g","\u01F5":"g","\u011D":"g","\u1E21":"g","\u011F":"g","\u0121":"g","\u01E7":"g","\u0123":"g","\u01E5":"g","\u0260":"g","\uA7A1":"g","\u1D79":"g","\uA77F":"g","\u24D7":"h","\uFF48":"h","\u0125":"h","\u1E23":"h","\u1E27":"h","\u021F":"h","\u1E25":"h","\u1E29":"h","\u1E2B":"h","\u1E96":"h","\u0127":"h","\u2C68":"h","\u2C76":"h","\u0265":"h","\u0195":"hv","\u24D8":"i","\uFF49":"i","\u00EC":"i","\u00ED":"i","\u00EE":"i","\u0129":"i","\u012B":"i","\u012D":"i","\u00EF":"i","\u1E2F":"i","\u1EC9":"i","\u01D0":"i","\u0209":"i","\u020B":"i","\u1ECB":"i","\u012F":"i","\u1E2D":"i","\u0268":"i","\u0131":"i","\u24D9":"j","\uFF4A":"j","\u0135":"j","\u01F0":"j","\u0249":"j","\u24DA":"k","\uFF4B":"k","\u1E31":"k","\u01E9":"k","\u1E33":"k","\u0137":"k","\u1E35":"k","\u0199":"k","\u2C6A":"k","\uA741":"k","\uA743":"k","\uA745":"k","\uA7A3":"k","\u24DB":"l","\uFF4C":"l","\u0140":"l","\u013A":"l","\u013E":"l","\u1E37":"l","\u1E39":"l","\u013C":"l","\u1E3D":"l","\u1E3B":"l","\u0142":"l","\u019A":"l","\u026B":"l","\u2C61":"l","\uA749":"l","\uA781":"l","\uA747":"l","\u01C9":"lj","\u24DC":"m","\uFF4D":"m","\u1E3F":"m","\u1E41":"m","\u1E43":"m","\u0271":"m","\u026F":"m","\u24DD":"n","\uFF4E":"n","\u01F9":"n","\u0144":"n","\u00F1":"n","\u1E45":"n","\u0148":"n","\u1E47":"n","\u0146":"n","\u1E4B":"n","\u1E49":"n","\u019E":"n","\u0272":"n","\u0149":"n","\uA791":"n","\uA7A5":"n","\u01CC":"nj","\u24DE":"o","\uFF4F":"o","\u00F2":"o","\u00F3":"o","\u00F4":"o","\u1ED3":"o","\u1ED1":"o","\u1ED7":"o","\u1ED5":"o","\u00F5":"o","\u1E4D":"o","\u022D":"o","\u1E4F":"o","\u014D":"o","\u1E51":"o","\u1E53":"o","\u014F":"o","\u022F":"o","\u0231":"o","\u00F6":"o","\u022B":"o","\u1ECF":"o","\u0151":"o","\u01D2":"o","\u020D":"o","\u020F":"o","\u01A1":"o","\u1EDD":"o","\u1EDB":"o","\u1EE1":"o","\u1EDF":"o","\u1EE3":"o","\u1ECD":"o","\u1ED9":"o","\u01EB":"o","\u01ED":"o","\u00F8":"o","\u01FF":"o","\u0254":"o","\uA74B":"o","\uA74D":"o","\u0275":"o","\u0153":"oe","\u0276":"oe","\u01A3":"oi","\u0223":"ou","\uA74F":"oo","\u24DF":"p","\uFF50":"p","\u1E55":"p","\u1E57":"p","\u01A5":"p","\u1D7D":"p","\uA751":"p","\uA753":"p","\uA755":"p","\u24E0":"q","\uFF51":"q","\u024B":"q","\uA757":"q","\uA759":"q","\u24E1":"r","\uFF52":"r","\u0155":"r","\u1E59":"r","\u0159":"r","\u0211":"r","\u0213":"r","\u1E5B":"r","\u1E5D":"r","\u0157":"r","\u1E5F":"r","\u024D":"r","\u027D":"r","\uA75B":"r","\uA7A7":"r","\uA783":"r","\u24E2":"s","\uFF53":"s","\u015B":"s","\u1E65":"s","\u015D":"s","\u1E61":"s","\u0161":"s","\u1E67":"s","\u1E63":"s","\u1E69":"s","\u0219":"s","\u015F":"s","\u023F":"s","\uA7A9":"s","\uA785":"s","\u017F":"s","\u1E9B":"s","\u00DF":"ss","\u24E3":"t","\uFF54":"t","\u1E6B":"t","\u1E97":"t","\u0165":"t","\u1E6D":"t","\u021B":"t","\u0163":"t","\u1E71":"t","\u1E6F":"t","\u0167":"t","\u01AD":"t","\u0288":"t","\u2C66":"t","\uA787":"t","\uA729":"tz","\u24E4":"u","\uFF55":"u","\u00F9":"u","\u00FA":"u","\u00FB":"u","\u0169":"u","\u1E79":"u","\u016B":"u","\u1E7B":"u","\u016D":"u","\u00FC":"u","\u01DC":"u","\u01D8":"u","\u01D6":"u","\u01DA":"u","\u1EE7":"u","\u016F":"u","\u0171":"u","\u01D4":"u","\u0215":"u","\u0217":"u","\u01B0":"u","\u1EEB":"u","\u1EE9":"u","\u1EEF":"u","\u1EED":"u","\u1EF1":"u","\u1EE5":"u","\u1E73":"u","\u0173":"u","\u1E77":"u","\u1E75":"u","\u0289":"u","\u24E5":"v","\uFF56":"v","\u1E7D":"v","\u1E7F":"v","\u028B":"v","\uA75F":"v","\u028C":"v","\uA761":"vy","\u24E6":"w","\uFF57":"w","\u1E81":"w","\u1E83":"w","\u0175":"w","\u1E87":"w","\u1E85":"w","\u1E98":"w","\u1E89":"w","\u2C73":"w","\u24E7":"x","\uFF58":"x","\u1E8B":"x","\u1E8D":"x","\u24E8":"y","\uFF59":"y","\u1EF3":"y","\u00FD":"y","\u0177":"y","\u1EF9":"y","\u0233":"y","\u1E8F":"y","\u00FF":"y","\u1EF7":"y","\u1E99":"y","\u1EF5":"y","\u01B4":"y","\u024F":"y","\u1EFF":"y","\u24E9":"z","\uFF5A":"z","\u017A":"z","\u1E91":"z","\u017C":"z","\u017E":"z","\u1E93":"z","\u1E95":"z","\u01B6":"z","\u0225":"z","\u0240":"z","\u2C6C":"z","\uA763":"z","\uFF10":"0","\u2080":"0","\u24EA":"0","\u2070":"0", "\u00B9":"1","\u2474":"1","\u2081":"1","\u2776":"1","\u24F5":"1","\u2488":"1","\u2460":"1","\uFF11":"1", "\u00B2":"2","\u2777":"2","\u2475":"2","\uFF12":"2","\u2082":"2","\u24F6":"2","\u2461":"2","\u2489":"2", "\u00B3":"3","\uFF13":"3","\u248A":"3","\u2476":"3","\u2083":"3","\u2778":"3","\u24F7":"3","\u2462":"3", "\u24F8":"4","\u2463":"4","\u248B":"4","\uFF14":"4","\u2074":"4","\u2084":"4","\u2779":"4","\u2477":"4", "\u248C":"5","\u2085":"5","\u24F9":"5","\u2478":"5","\u277A":"5","\u2464":"5","\uFF15":"5","\u2075":"5", "\u2479":"6","\u2076":"6","\uFF16":"6","\u277B":"6","\u2086":"6","\u2465":"6","\u24FA":"6","\u248D":"6", "\uFF17":"7","\u2077":"7","\u277C":"7","\u24FB":"7","\u248E":"7","\u2087":"7","\u247A":"7","\u2466":"7", "\u2467":"8","\u248F":"8","\u24FC":"8","\u247B":"8","\u2078":"8","\uFF18":"8","\u277D":"8","\u2088":"8", "\u24FD":"9","\uFF19":"9","\u2490":"9","\u277E":"9","\u247C":"9","\u2089":"9","\u2468":"9","\u2079":"9"};
		chars = str.split("")
		i = chars.length - 1
		alter = false
		ch = undefined
		while i >= 0
			ch = chars[i]
			if diacritics.hasOwnProperty(ch)
			  chars[i] = diacritics[ch]
			  alter = true
			i--
		str = chars.join("")  if alter
		str
	compareTwoArtists : (art1,art2)->
		if art1 isnt null
			temp1 = art1.sort((a,b)-> return a.localeCompare(b)).map (v)-> v.toLowerCase().trim()
		else temp1 = null
		if art2 isnt null
			temp2 = art2.sort((a,b)-> return a.localeCompare(b)).map (v)-> v.toLowerCase().trim()
		else temp2 = null
		if temp1 isnt null
			return temp1.compare(temp2)
		else 
			if temp2 isnt null
				return temp2.compare(temp1)
			else 
				return true
	transformArtists : (artists)->
		# replace default values and remove some
		artists = artists.map (v)=>@encoder.htmlDecode v
		artists = artists.map (v)=>
			if @removeDiacritics(v).search(/Dang cap nhat.*/gi) > -1 or @removeDiacritics(v).search(/Chua xac dinh.*/gi) > -1
				return ""
			else return  v
		
		artists = artists.filter (v) -> v isnt ""

		artists = artists.map (v)->
			return v.replace(/^V\.A.*/,'Various Artists').replace(/^N\/A$/,'')
				.replace(/Nhiều ca sĩ.*/,'Various Artists').replace(/&amp/gi,'').trim()

		# separate artistss by pattern
		patterns = @artistsSeparationPatterns
		artists = artists.splitByPatterns(patterns)
		# add combine pattern like "selena gomez & the scene"
		# join again if the `Selena Gomez & The Scene` is accidentally separated by `ampersand(&)`
		artists = artists.joinTwoElementByPattern("selena gomez","the scene","&")
		artists = artists.joinTwoElementByPattern("T","ARA","-")
		artists = artists.unique()
		# set null if  array is empty
		if artists.length is 0 then artists = null
		return artists
	transformItem : (item)->
		_item = item
		_item.title = @encoder.htmlDecode(_item.title)
		if _item.title then _item.title = _item.title.trim()
		_item.artists = @transformArtists(_item.artists) if _item.artists isnt null
		return _item
	saveNewItem : (item,callback)->
		@connection.query "INSERT INTO #{@sourceTable} SET ?", item, (err)->
			if err then errMes =  "Cannot insert new item. #{err}"
			callback(errMes)
	saveUpdatedItem : (item,callback)->
		# on 01-11-2013, update checktime, set it to current time
		updateSongQuery = "update #{@sourceTable} SET sources = '#{JSON.stringify item.sources}', checktime=now() WHERE id = #{item.id}"
		@connection.query updateSongQuery,(err)->
			if err then errMes =  "Cannot update found item. #{err}"
			callback(errMes)
	saveItem : (data,callback) ->
		switch data.type
			when "insert" then @saveNewItem data.item, (err)-> callback(err,data.type)
			when "update" then  @saveUpdatedItem data.item, (err)-> callback(err,data.type)
			else 
				console.log "Critical error: type is invalid".inverse.red
				console.log data
	processNewIem : (item,callback) ->
		newItem = 
			title : item.title
			artists : item.artists
			sources : []
		if newItem.title then newItem.title = newItem.title.trim()
		if item.id.toString().match(/^[0-9]+$/)
			siteid = parseInt(item.id,10)
		else throw Error("Id has to be an integer number")
		newSource = {site : @destinationTable.prefix, id : siteid}
		newItem.sources.push(newSource)
		newItem.sources = JSON.stringify newItem.sources
		# @saveNewItem(newItem,callback)
		callback(newItem)
	processExistingItems : (existingItems,item,callback)->
		
		foundIndex = -1
		for existingItem,index in existingItems
			if @compareTwoArtists(existingItem.artists,item.artists)
				foundIndex = index
		# console.log "FOUND INDEX #{foundIndex}"
		if foundIndex > -1
			existingItem = existingItems[foundIndex]
			if item.id.toString().match(/^[0-9]+$/)
				siteid = parseInt(item.id,10)
			else throw Error("Id has to be an integer number")
			existingItem.sources.push {site : @destinationTable.prefix, id : siteid}
			existingItem.sources = existingItem.sources.uniqueObject()
			# @saveUpdatedItem(existingItem,callback)
			data = 
				item : existingItem
				type : "update"
			callback(data)
		else 
			@processNewIem item, (item)->
				data = 
					item : item
					type : "insert"
				callback(data)
	customProcessingJob : (cursor)->
		# main func to process record at specific cursor
		findRecordQuery = "select id,title,artists from #{@destinationTable.fullName} where id=#{cursor}"
		@connection.query findRecordQuery, (err1, result)=>
			if err1 
				errMessage = "#{err1} while finding record!!!"
				@emit("item",errMessage,null,cursor)
			else 
				item = @transformItem result[0]
				findTitleQuery = "select id, title, artists,sources from #{@sourceTable} where lower(trim(title))=lower(trim(#{@connection.escape item.title}))"
				@connection.query findTitleQuery, (err2,existingItems)=>
					if err2  
						errMessage = "#{err2} Cannot find title"						
						@emit("item",errMessage,null,cursor)
					else 
						if existingItems.length >= 0
							@processExistingItems existingItems, item, (data)=>
								@emit("item",null,data,cursor)
								@runNext()
						else 
							err = "CRITICAL ERROR : Length of the existingItems is not zero or greater than 1"
							@emit("item",err,null,cursor)
	runNext :  ->
		# console.log "#{@currentCursor}"
		if @currentCursor < @records.length-1
			# console.log "called"
			@currentCursor +=1
			@customProcessingJob @records[@currentCursor]
			return true
		else
			@_checkCursorCount +=1
			if @_checkCursorCount is @maxConcurrentJobs
				# callback null, null,null
				# @emit("end") #this option is disable. Enable later if necessary
				return false
			return false

	# Callback(err,data,cusor)
	# data = {
	# 	item : Object,
	# 	type : "update" or "insert"
	# }
	runJob : (condition) ->
		if condition
			_query = "select id from #{@destinationTable.fullName} WHERE #{condition} ORDER BY id ASC "
		else 
			_query = "select id from #{@destinationTable.fullName} ORDER BY id ASC "
		# console.log _query
		# process.exit 0
		if @limit > -1  
			_query += " LIMIT #{@limit}"
			if @offset > -1 then _query += " OFFSET #{@offset}"
		if @debug 
			if @limit > -1
				mes = "Querying #{@limit} records"

			else mes = "Querying all records"
			if condition 
				mes += " with condition: #{condition}"
			console.log mes
		@connection.query _query, (err,results)=>
			if err then console.log err
			else 
				@records = results.map (v) -> parseInt(v.id,10)
				@limit = @records.length
				# console.log @records
				if @records.length > 0
					console.log "# of records got: #{@records.length}"
					# if @destinationTable.fullName is "kealbums"
					# 	console.log "check if sohtn"
					# 	process.exit(0)
					# console.log ""
					# console.log ""
					for i in [0..@maxConcurrentJobs-1]
						@runNext()
				else
					# console.log "No items found!" 
					@emit("end")

module.exports =  ItemConstruction

