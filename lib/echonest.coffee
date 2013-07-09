
Site = require "./Site"



DownloadEchoNest = require './echonest/download_echonest'


class EchoNest extends Site
	constructor: ->
		super "EN"
		@logPath = "./log/ENLog.txt"
		@log = {}
		@_readLog()
		@table.Artists = "ENArtists"

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

	_getFieldFromTable : (params, callback)->
		_q = "Select #{params.sourceField} from #{params.table}"
		_q += " WHERE #{params.condition} LIMIT #{params.skip},#{params.limit}" if params.limit
		# console.log _q
		@connection.query _q, (err, results)=>
			# console.log callback + "------"
			callback results 
	onItemFail  : (error, options)=>

		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		@stats.currentId  = options.id
		_u = "UPDATE #{@table.Artists} SET download_done = 0 "
		_u += " WHERE artist_id=#{@connection.escape options.id}"
		# console.log _u
		@connection.query _u, (err)=>
			if err then console.log "hello #{err}"
			@_updateArtist()
		@utils.printUpdateRunning options.id,  @stats, "Fetching....."		
	processArtist : (data, options)=>
		result = JSON.parse data
		if result.response
			if result.response.artists
				artist = result.response.artists
				if artist.length is 0
					@onItemFail "no artist found", options
				else 
					_artist = artist[0]
					_artist.artist_id = options.id
					_artist.download_done = 1
					@eventEmitter.emit "result-artist", _artist, options
			else @onItemFail "no result", options
		else @onItemFail "noresult 2 ", options 	
	_updateArtist : ->
		params =
			sourceField : "artist_id, #{@table.Artists}.name"
			table : @table.Artists
			limit : @temp.nItems
			skip : @temp.nItemsSkipped
			condition : ' artist_id not like "AR%" and download_done is null  '
		@_getFieldFromTable params, (results)=>
			# console.log "HELLOO"
			@stats.totalItems = results.length
			for artist in results
				link = "http://developer.echonest.com/api/v4/artist/search?api_key=EGXKLPXBW3VLDDC6Y&format=json&results=1&name=#{encodeURIComponent  artist.name}"
				# console.log link
				options = 
					id : artist.artist_id
				@getFileByHTTP link, @processArtist, @onItemFail, options
	updateArtists : ->
		@connect()
		@showStartupMessage "Updating artist to table ", @table.Artists
		@temp = 
			nItems : 1
			nItemsSkipped : 0
		@stats.currentTable = @table.Artists

		@eventEmitter.on "result-artist", (artist,options)=>
			@stats.totalItemCount +=1
			@stats.passedItemCount +=1
			@stats.currentId = options.id

			_u = "UPDATE #{@table.Artists} SET artist_id=#{@connection.escape artist.id},  download_done = #{artist.download_done} "
			_u += " WHERE artist_id=#{@connection.escape artist.artist_id}"
			# console.log _u
			# console.log artist
			@connection.query _u, (err)=>
				if err  
					# console.log "Song: #{options.id} has an error #{err}"
					_u = "UPDATE #{@table.Artists} SET download_done = 0 "
					_u += " WHERE artist_id=#{@connection.escape options.id}"
					@connection.query _u, (err)=>
						if err then console.log "hello #{err}"
				@_updateArtist()
			@utils.printUpdateRunning options.id,  @stats, "Fetching....."
			# if @stats.totalItems is @stats.totalItemCount
			# 	@utils.printFinalResult @stats
			
		@_updateArtist()

	# THIS PART FOR GENERAL PURPOSES
	insertStatement : (query, options)->
		@connection.query query, (err)->
			if err then console.log "Cannot insert song #{options.id} . ERROR: #{err}"
	onItemFail : (err, options)=>
		# console.log "Link: #{options.link} has an error. ERROR:#{err}"
		@stats.totalItemCount +=1
		@stats.failedItemCount +=1
		@utils.printUpdateRunning @stats.currentId, @stats, "Fetching...."
		_u = """
		UPDATE #{@table.Artists} SET
		download_done=0
		WHERE artist_id=#{@connection.escape options.id}
		"""
		@connection.query _u, (err)->
			if err then console.log "We have an error at func fetchArtists #{err} ---- for URL: #{_u}"
		@callNextStep(options.id, options.name, options.link)
	processItem : (data,options)=>
		@eventEmitter.emit "item-processing", data, options
	_getItem : (id,name, link)->
		options = 
			link : link
			name : name
			id : id
		# console.log "#{link}".inverse.red
		@getFileByHTTP link, @processItem, @onItemFail, options  
	fetchItems: (id,name,link) ->
		@_getItem id, name, link
	updateStats : (options)->
		@stats.totalItemCount +=1
		@stats.passedItemCount +=1
		@utils.printUpdateRunning @stats.currentId, @stats, "Fetching...."
	
	insertItemIntoDB : (item,insertStatement)->
		@connection.query insertStatement, item, (err)->
			if err then console.log "We have an  error at item: #{JSON.stringify item} --> #{err}".red

	fetchItemFromDB :  (templateLink)->
		
		@connection.query "select artist_id, #{@table.Artists}.name from #{@table.Artists} where download_done is null and artist_id='AR015LY1187B98CCAF' LIMIT 1", (err,results)=>
			if err then console.log "#{err}"
			else 
				# console.log "#n results #{results.length}"
				name = results[0].name
				id = results[0].artist_id
				link = templateLink.replace("<<REPLACE_AREA>>",name)
				@fetchItems id, name ,link	

	callNextStep : ->
		@fetchItemFromDB @templateLink 
	
	fetchArtists :->
		@connect()
		@templateLink = "http://developer.echonest.com/api/v4/artist/search?api_key=EGXKLPXBW3VLDDC6Y&format=json&name=<<REPLACE_AREA_SECOND>>&results=100&start=<<REPLACE_AREA_FIRST>>&bucket=audio&bucket=biographies&bucket=blogs&bucket=doc_counts&bucket=familiarity&bucket=genre&bucket=hotttnesss&bucket=images&bucket=artist_location&bucket=news&bucket=reviews&bucket=songs&bucket=terms&bucket=urls&bucket=video&bucket=years_active&bucket=id:7digital-US&bucket=id:7digital-AU&bucket=id:7digital-UK&bucket=id:facebook&bucket=id:fma&bucket=id:emi_open_collection&bucket=id:emi_bluenote&bucket=id:emi_artists&bucket=id:twitter&bucket=id:spotify-WW&bucket=id:seatwave&bucket=id:lyricfind-US&bucket=id:jambase&bucket=id:musixmatch-WW&bucket=id:rdio-US&bucket=id:rdio-AT&bucket=id:rdio-AU&bucket=id:rdio-BR&bucket=id:rdio-CA&bucket=id:rdio-CH&bucket=id:rdio-DE&bucket=id:rdio-DK&bucket=id:rdio-ES&bucket=id:rdio-FI&bucket=id:rdio-FR&bucket=id:rdio-IE&bucket=id:rdio-IT&bucket=id:rdio-NL&bucket=id:rdio-NO&bucket=id:rdio-NZ&bucket=id:rdio-PT&bucket=id:rdio-SE&bucket=id:emi_electrospective&bucket=id:rdio-WW&bucket=id:rdio-EE&bucket=id:rdio-LT&bucket=id:rdio-LV&bucket=id:rdio-IS&bucket=id:rdio-BE&bucket=id:rdio-MX&bucket=id:seatgeek&bucket=id:rdio-GB&bucket=id:rdio-CZ&bucket=id:rdio-CO&bucket=id:rdio-PL&bucket=id:rdio-MY&bucket=id:rdio-HK&bucket=id:rdio-CL"
		@fetchItemFromDB @templateLink
		@eventEmitter.on "item-result", (items, options)=>
			@updateStats(options)
			# console.log "ANSDNSAD"
			# console.log options.id
			# console.log items
			for item in items
				if options.id is item.id
					_u = """
					UPDATE #{@table.Artists} SET 
					location = #{@connection.escape JSON.stringify item.location},
					audio = #{@connection.escape JSON.stringify item.audio},
					biographies = #{@connection.escape JSON.stringify item.biographies},
					doc_counts = #{@connection.escape JSON.stringify item.doc_counts},
					familiarity = #{item.familiarity},
					foreign_ids = #{@connection.escape JSON.stringify item.foreign_ids},
					genres = #{@connection.escape JSON.stringify item.genres},
					hotttnesss = #{item.hotttnesss},
					images = #{@connection.escape JSON.stringify item.images},
					songs = #{@connection.escape JSON.stringify item.songs},
					terms = #{@connection.escape JSON.stringify item.terms},
					urls = #{@connection.escape JSON.stringify item.urls},
					videos = #{@connection.escape JSON.stringify item.videos},
					years_active = #{@connection.escape JSON.stringify item.years_active},
					download_done=1
					WHERE artist_id=#{@connection.escape options.id}
					"""
					@stats.currentId = options.id
					console.log _u
					# @connection.query _u, (err)->
					# 	if err then console.log "We have an error at func fetchArtists #{err} ---- for URL: #{_u}"
				else
					_item = item
					_item.download_done = 1
					console.log item
			# @callNextStep()

		@eventEmitter.on "item-processing", (data,options)=>

			try
				data = JSON.parse(data)
				# console.log data
				if data.response 
					if data.response.artists
						items = data.response.artists
						if items isnt undefined
							@eventEmitter.emit "item-result", items, options
						else @onItemFail "undefined", options
					else @onItemFail "data.response.artists does not exit", options
				else @onItemFail "data.response does not exit", options
			catch e
				@onItemFail "data has error", options			
				
	# FETCH ALL SONGS FROM ARTISTS
	fetchSongsFromArtists : =>
		@connect()
		@table.Artists = "ENArtists_temp"
		@templateLink = "http://developer.echonest.com/api/v4/song/search?api_key=EGXKLPXBW3VLDDC6Y&format=json&results=100&start=0&artist_id=<<REPLACE_AREA>>&bucket=song_hotttnesss&bucket=artist_familiarity&bucket=artist_hotttnesss&bucket=audio_summary&bucket=artist_location&bucket=tracks&bucket=scores&bucket=song_type&bucket=song_discovery&bucket=song_currency&bucket=id:7digital-US&bucket=id:7digital-AU&bucket=id:7digital-UK&bucket=id:facebook&bucket=id:fma&bucket=id:emi_open_collection&bucket=id:emi_bluenote&bucket=id:emi_artists&bucket=id:twitter&bucket=id:spotify-WW&bucket=id:seatwave&bucket=id:lyricfind-US&bucket=id:jambase&bucket=id:musixmatch-WW&bucket=id:rdio-US&bucket=id:rdio-AT&bucket=id:rdio-AU&bucket=id:rdio-BR&bucket=id:rdio-CA&bucket=id:rdio-CH&bucket=id:rdio-DE&bucket=id:rdio-DK&bucket=id:rdio-ES&bucket=id:rdio-FI&bucket=id:rdio-FR&bucket=id:rdio-IE&bucket=id:rdio-IT&bucket=id:rdio-NL&bucket=id:rdio-NO&bucket=id:rdio-NZ&bucket=id:rdio-PT&bucket=id:rdio-SE&bucket=id:emi_electrospective&bucket=id:rdio-WW&bucket=id:rdio-EE&bucket=id:rdio-LT&bucket=id:rdio-LV&bucket=id:rdio-IS&bucket=id:rdio-BE&bucket=id:rdio-MX&bucket=id:seatgeek&bucket=id:rdio-GB&bucket=id:rdio-CZ&bucket=id:rdio-CO&bucket=id:rdio-PL&bucket=id:rdio-MY&bucket=id:rdio-HK&bucket=id:rdio-CL"
		
		
		@callNextStep = (id,name,link) =>
			if id isnt null
				start  = parseInt link.match(/start=([0-9]+)/)?[1],10
				start +=100
				link = link.replace(/start=[0-9]+/,"start="+start)
				@fetchItems id, name ,link
			else @fetchItemFromDB @templateLink
		@fetchItemFromDB = (templateLink)=>
			@connection.query "select artist_id, #{@table.Artists}.name from #{@table.Artists} where artist_id ='AR00MBZ1187B9B5DB1' LIMIT 1", (err,results)=>
				if err then console.log "#{err}"
				else 
					# console.log "#n results #{results.length}"
					name = results[0].name
					id = results[0].artist_id
					link = templateLink.replace("<<REPLACE_AREA>>",id)
					@stats.currentId = id
					# console.log link
					@fetchItems id, name ,link	
		@fetchItemFromDB @templateLink
		@eventEmitter.on "item-result", (items, options)=>
			
			# console.log "ANSDNSAD"
			# console.log options.id
			_u = """
			UPDATE #{@table.Artists} SET
			download_done=1
			WHERE artist_id=#{@connection.escape options.id}
			"""
			@stats.currentId = options.id + ":start=" + parseInt(options.link.match(/start=([0-9]+)/)?[1],10)
			@connection.query _u, (err)=>
				if err then console.log "We have an error at func fetchArtists #{err} ---- for URL: #{_u}"
				else 			
					for song in items
						do (song)=>
							_song = 
								id : song.id
								title : song.title
								artist_id : song.artist_id
								artist_name : song.artist_name
								artist_location : JSON.stringify song.artist_location
								artist_familiarity  : song.artist_familiarity
								artist_hotttnesss : song.artist_hotttnesss
								acousticness : song.audio_summary.acousticness
								analysis_url : JSON.stringify song.audio_summary.analysis_url
								danceability : song.audio_summary.danceability
								duration : song.audio_summary.duration
								energy : song.audio_summary.energy
								key : song.audio_summary.key
								liveness : song.audio_summary.liveness
								loudness : song.audio_summary.loudness
								mode : song.audio_summary.mode
								speechiness : song.audio_summary.speechiness
								tempo : song.audio_summary.tempo
								time_signature : song.audio_summary.time_signature
								valence : song.audio_summary.valence
								song_currency : song.song_currency
								song_discovery : song.song_discovery
								song_hotttnesss : song.song_hotttnesss
								song_type : JSON.stringify song.song_type
								foreign_ids :  JSON.stringify song.foreign_ids
								tracks :  JSON.stringify song.tracks
							# console.log _song
							@updateStats(options)
							@insertItemIntoDB _song, @query._insertIntoSongs
							# console.log "INSERT DONE"
					
			# @connection.query _u, (err)->
			# 	if err then console.log "We have an error at func fetchArtists #{err} ---- for URL: #{_u}"
			if items.length > 0
				@callNextStep(options.id, options.name, options.link)
			else @callNextStep(null)
		
		@eventEmitter.on "item-processing", (data,options)=>

			try
				data = JSON.parse(data)
				# console.log data
				if data.response 
					if data.response.songs
						items = data.response.songs
						if items isnt undefined
							@eventEmitter.emit "item-result", items, options
						else @onItemFail "undefined", options
					else @onItemFail "data.response.songs does not exit", options
				else @onItemFail "data.response does not exit", options
			catch e
				@onItemFail "data has error", options

	# Download links from ENArtists_ab where nsongs is not null and nsongs > 0
	# it means `is_processing=1`
	downloadArtists : ->
		
		@table.Artists = "ENArtists_download_zing"
						
		@eventEmitter.on "item-result", (items, options)=>
			for song in items
				do (song)=>
					_song = 
						id : song.id
						title : song.title
						artist_id : song.artist_id
						artist_name : song.artist_name
						artist_location : JSON.stringify song.artist_location
						artist_familiarity  : song.artist_familiarity
						artist_hotttnesss : song.artist_hotttnesss
						acousticness : song.audio_summary.acousticness
						analysis_url : JSON.stringify song.audio_summary.analysis_url
						danceability : song.audio_summary.danceability
						duration : song.audio_summary.duration
						energy : song.audio_summary.energy
						key : song.audio_summary.key
						liveness : song.audio_summary.liveness
						loudness : song.audio_summary.loudness
						mode : song.audio_summary.mode
						speechiness : song.audio_summary.speechiness
						tempo : song.audio_summary.tempo
						time_signature : song.audio_summary.time_signature
						valence : song.audio_summary.valence
						song_currency : song.song_currency
						song_discovery : song.song_discovery
						song_hotttnesss : song.song_hotttnesss
						song_type : JSON.stringify song.song_type
						foreign_ids :  JSON.stringify song.foreign_ids
						tracks :  JSON.stringify song.tracks
					# console.log _song
					@updateStats(options)
					@insertItemIntoDB _song, @query._insertIntoSongs
					# console.log "INSERT DONE"
		dlEchoNest = new DownloadEchoNest()
		dlEchoNest.setnArtists(20000)
		dlEchoNest.setnArtistsSkipped(0)
		dlEchoNest.setMaxConcurrentJobs(32)
		dlEchoNest.setTemplateLink("http://developer.echonest.com/api/v4/artist/search?api_key=<<REPLACE_AREA_APIKEY>>&format=json&name=<<REPLACE_AREA_FIRST>>&results=100&start=0&bucket=audio&bucket=biographies&bucket=blogs&bucket=doc_counts&bucket=familiarity&bucket=genre&bucket=hotttnesss&bucket=images&bucket=artist_location&bucket=news&bucket=reviews&bucket=songs&bucket=terms&bucket=urls&bucket=video&bucket=years_active&bucket=id:7digital-US&bucket=id:7digital-AU&bucket=id:7digital-UK&bucket=id:facebook&bucket=id:fma&bucket=id:emi_open_collection&bucket=id:emi_bluenote&bucket=id:emi_artists&bucket=id:twitter&bucket=id:spotify-WW&bucket=id:seatwave&bucket=id:lyricfind-US&bucket=id:jambase&bucket=id:musixmatch-WW&bucket=id:rdio-US&bucket=id:rdio-AT&bucket=id:rdio-AU&bucket=id:rdio-BR&bucket=id:rdio-CA&bucket=id:rdio-CH&bucket=id:rdio-DE&bucket=id:rdio-DK&bucket=id:rdio-ES&bucket=id:rdio-FI&bucket=id:rdio-FR&bucket=id:rdio-IE&bucket=id:rdio-IT&bucket=id:rdio-NL&bucket=id:rdio-NO&bucket=id:rdio-NZ&bucket=id:rdio-PT&bucket=id:rdio-SE&bucket=id:emi_electrospective&bucket=id:rdio-WW&bucket=id:rdio-EE&bucket=id:rdio-LT&bucket=id:rdio-LV&bucket=id:rdio-IS&bucket=id:rdio-BE&bucket=id:rdio-MX&bucket=id:seatgeek&bucket=id:rdio-GB&bucket=id:rdio-CZ&bucket=id:rdio-CO&bucket=id:rdio-PL&bucket=id:rdio-MY&bucket=id:rdio-HK&bucket=id:rdio-CL")
		dlEchoNest.appendNewIndicesFromArtist = (artist)->
			id = artist.artist_id
			name = artist.name
			index = "#{id}_#{name}"
			@count +=1
			@indices.push index
		dlEchoNest.downloadFileByWGET = (index,callback)->
			_t = index.split('_')
			id = _t[0]
			name = _t[1]
			fileName = "#{id}.json"
			path = @filePath + fileName
			url = @templateLink.replace("<<REPLACE_AREA_FIRST>>",encodeURIComponent(name))
			apikey = new ENApiKeys()
			url = @apikey.getUrlByReplacingApiKey url, "<<REPLACE_AREA_APIKEY>>"
			# mode: quiet -q, continue -c
			cmd = "wget -q -c \"#{url}\" -O #{path} "
			# console.log cmd
			@exec cmd, (err, stdout, stderr)=>
				if err 
					errInfo = "id:#{id},name:#{name} has an error: ERROR:#{err}"
					console.log "#{cmd}".red
					if callback then callback(errInfo,null)
				else 
					if callback  
						callback(null,fileName)
						@runNext(callback)
					else @runNext()
		
		@connect()
		@connection.query "Select artist_id, name from #{@table.Artists} where download_done is null  LIMIT \
		#{dlEchoNest.getnArtistsSkipped()},#{dlEchoNest.getnArtists()}", (err, results)=>
			if err then console.log "dsjfhskjdfh#{err}"
			else 
				totalSongs = 0
				for artist in results
					_artist = artist
					_artist.name = @removeDiacritics _artist.name
					dlEchoNest.appendNewIndicesFromArtist artist
				console.log "OPTIONS: nAritsts=#{dlEchoNest.getnArtists()}, nArtistsSkipped=#{dlEchoNest.getnArtistsSkipped()}"
				console.log "# artists : #{results.length}"
				console.log "# hrefs : #{dlEchoNest.getTotalItems()}"
				console.log "# Tables : #{@table.Artists}"
				fs = require 'fs'
				log = 
					nAritsts : dlEchoNest.getnArtists()
					nArtistsSkipped : dlEchoNest.getnArtistsSkipped()
					numberOfArtists : results.length
					nHrefs : dlEchoNest.getTotalItems()
					nsongs : totalSongs
				console.log  JSON.stringify dlEchoNest.saveIndices()
				console.log  JSON.stringify dlEchoNest.saveLog(JSON.stringify(log))
				# THE MAIN FUNC
				dlEchoNest.runJob (err, fileName)=>
					if err then console.log err
					else 
						@stats.currentId = fileName + ":noDB"
						@updateStats()
						_u = "update #{@table.Artists} SET download_done=1 where artist_id=#{@connection.escape fileName.replace(".json","")}"
						@connection.query _u, (err)=>
							if err then console.log "cannot set artists anbinh #{err}"
	downloadVideos : ->
		
		@table.Artists = "ENArtists_stats"
						
		dlEchoNest = new DownloadEchoNest()
		dlEchoNest.setFilePath("/Volumes/Data/website/database/echonest_video/")
		dlEchoNest.setnArtists(20000)
		dlEchoNest.setnArtistsSkipped(0)
		dlEchoNest.setMaxConcurrentJobs(32)

		dlEchoNest.setTemplateLink("http://developer.echonest.com/api/v4/artist/video?api_key=<<REPLACE_AREA_APIKEY>>&id=<<REPLACE_AREA_SECOND>>&format=json&results=100&start=<<REPLACE_AREA_FIRST>>")
		dlEchoNest.appendNewIndicesFromArtist = (artist)->
			nvideos = artist.nvideos
			id = artist.artist_id
			if nvideos%100 is 0
				nlinks = nvideos/100
			else nlinks = nvideos/100+1

			if nvideos is 0 then console.log "EROOR nvideos of artists is ZERO"

			nsteps = nlinks - 1
			# if nsteps > 9  then nsteps = 9
			for i in [0..nsteps]
				# link = templateLink.replace("<<REPLACE_AREA_FIRST>>",i*100).replace("<<REPLACE_AREA_SECOND>>",id)
				Index = "#{id}_#{(i*100)}"
				@count +=1
				@indices.push Index
		dlEchoNest.downloadFileByWGET = (index,callback)->
			_t = index.split('_')
			id = _t[0]
			start = _t[1]
			fileName = "#{id}_#{start}.json"
			path = @filePath + fileName
			url = @templateLink.replace("<<REPLACE_AREA_FIRST>>",start).replace("<<REPLACE_AREA_SECOND>>",id)
			
			url = @apikey.getUrlByReplacingApiKey url, "<<REPLACE_AREA_APIKEY>>"
			# mode: quiet -q, continue -c
			cmd = "wget -q -c '#{url}' -O #{path} "
			# console.log index
			@exec cmd, (err, stdout, stderr)=>
				if err 
					error = "#{err} : #{fileName} - URL: #{url}"
					if callback then callback(error,null)
				else 
					if callback  
						callback(null,fileName)
						@runNext(callback)
					else @runNext()
		
		@connect()
		@connection.query "Select artist_id, nvideos from #{@table.Artists} where is_video_being_processed=0 LIMIT \
		#{dlEchoNest.getnArtistsSkipped()},#{dlEchoNest.getnArtists()}", (err, results)=>
			if err then console.log "dsjfhskjdfh#{err}"
			else 
				totalVideos = 0
				for artist in results
					dlEchoNest.appendNewIndicesFromArtist artist
					totalVideos += artist.nvideos
				console.log "OPTIONS: nAritsts=#{dlEchoNest.getnArtists()}, nArtistsSkipped=#{dlEchoNest.getnArtistsSkipped()}"
				console.log "# artists : #{results.length}"
				console.log "# hrefs : #{dlEchoNest.getTotalItems()}"
				console.log "# Videos : #{totalVideos}"
				console.log "# Tables : #{@table.Artists}"
				console.log "# Concurrent: #{dlEchoNest.getMaxConccurentJobs()}"
				fs = require 'fs'
				log = 
					nAritsts : dlEchoNest.getnArtists()
					nArtistsSkipped : dlEchoNest.getnArtistsSkipped()
					numberOfArtists : results.length
					nHrefs : dlEchoNest.getTotalItems()
					nvideos : totalVideos
				console.log  JSON.stringify dlEchoNest.saveIndices()
				console.log  JSON.stringify dlEchoNest.saveLog(JSON.stringify(log))
				# THE MAIN FUNC
				dlEchoNest.runJob (err, fileName, isDone)=>
					if err then console.log err
					else 
						if fileName
							@stats.currentId = fileName + ":noDB"
							@updateStats()
							_u = "update #{@table.Artists} SET is_video_being_processed=is_video_being_processed + 1 where artist_id=#{@connection.escape fileName.replace(/_[0-9]+.json/,"")}"
							@connection.query _u, (err)=>
								if err then console.log "cannot set artists anbinh #{err}"

					if isDone
						@utils.printFinalResult @stats
						# CALLBACK FUNCTION WHEN DONE
						@downloadVideos()
	downloadImages : ->
		
		@table.Artists = "ENArtists_stats"
						
		dlEchoNest = new DownloadEchoNest()
		dlEchoNest.setFilePath("/Volumes/Data/website/database/echonest_images/")
		dlEchoNest.setnArtists(50000)
		dlEchoNest.setnArtistsSkipped(0)
		dlEchoNest.setMaxConcurrentJobs(32)

		dlEchoNest.setTemplateLink("http://developer.echonest.com/api/v4/artist/images?api_key=<<REPLACE_AREA_APIKEY>>&id=<<REPLACE_AREA_SECOND>>&format=json&results=100&start=<<REPLACE_AREA_FIRST>>")
		dlEchoNest.appendNewIndicesFromArtist = (artist)->
			nimages = artist.nimages
			id = artist.artist_id
			if nimages%100 is 0
				nlinks = nimages/100
			else nlinks = nimages/100+1

			if nimages is 0 then console.log "EROOR nimages of artists is ZERO"

			nsteps = nlinks - 1
			# if nsteps > 9  then nsteps = 9
			for i in [0..nsteps]
				# link = templateLink.replace("<<REPLACE_AREA_FIRST>>",i*100).replace("<<REPLACE_AREA_SECOND>>",id)
				Index = "#{id}_#{(i*100)}"
				@count +=1
				@indices.push Index
		dlEchoNest.downloadFileByWGET = (index,callback)->
			_t = index.split('_')
			id = _t[0]
			start = _t[1]
			fileName = "#{id}_#{start}.json"
			path = @filePath + fileName
			url = @templateLink.replace("<<REPLACE_AREA_FIRST>>",start).replace("<<REPLACE_AREA_SECOND>>",id)
			
			url = @apikey.getUrlByReplacingApiKey url, "<<REPLACE_AREA_APIKEY>>"
			# mode: quiet -q, continue -c
			cmd = "wget -q -c '#{url}' -O #{path} "
			# console.log index
			@exec cmd, (err, stdout, stderr)=>
				if err 
					error = "#{err} : #{fileName} - URL: #{url}"
					if callback then callback(error,null)
				else 
					if callback  
						callback(null,fileName)
						@runNext(callback)
					else @runNext()
		
		class ImageInsertion 
			constructor : (@table,path, @connection) ->
				@fs = require 'fs'
				@path = path
				@filePath = ""
			readFile : (fileName,callback)->
				@filePath = @path + fileName
				@fs.readFile @filePath, (err,data)->
					callback err, data
			getInsertStatement : (objects,table)->	
				getStatementFromObject = (object,table)=>
					columns = []
					values = []
					for key,value of object
						columns.push "#{table}.#{key}"
						values.push  @connection.escape value
					return "INSERT IGNORE INTO #{table} (#{columns.join(',')}) VALUES (#{values.join(",")})"

				if objects instanceof Array 
					statements = []
					for object in objects
						statements.push getStatementFromObject object, table
					if statements.length > 0
						return statements.join(";")+";"
					else return ""
				else  
					statement = getStatementFromObject objects, table
					statement += ";"
					return statement
			createTransactionStatment :(fileName,callback) ->
				@readFile fileName, (err,data)=>
					if err then console.log "An error appears while reading #{fileName}. ERROR: #{err}"
					else 
						images = JSON.parse data
						images = images.response.images
						_images = []
						for image in images
							_image = 
								artist_id : ""
								url : image.url
								license_url : image.license.url
								license_type : image.license.type
								license_attribution : image.license.attribution
							_image.artist_id = fileName.replace(/_[0-9]+\.json/g,'')
							_images.push _image
						callback "start transaction;#{@getInsertStatement _images,@table} commit; " 
			insertTransaction : ( fileName,callback)->
				@createTransactionStatment fileName, (statement)=>
					@connection.query statement, (err, result)->
						callback err,result
		@connect()
		imageInsertion = new ImageInsertion("ENImages",dlEchoNest.getFilePath(),@connection)


		
		@connection.query "Select artist_id, nimages from #{@table.Artists} where is_image_being_processed=0 LIMIT \
		#{dlEchoNest.getnArtistsSkipped()},#{dlEchoNest.getnArtists()}", (err, results)=>
			if err then console.log "dsjfhskjdfh#{err}"
			else 
				totalImages = 0
				for artist in results
					dlEchoNest.appendNewIndicesFromArtist artist
					totalImages += artist.nimages
				console.log "OPTIONS: nAritsts=#{dlEchoNest.getnArtists()}, nArtistsSkipped=#{dlEchoNest.getnArtistsSkipped()}"
				console.log "# artists : #{results.length}"
				console.log "# hrefs : #{dlEchoNest.getTotalItems()}"
				console.log "# Images : #{totalImages}"
				console.log "# Tables : #{@table.Artists}"
				console.log "# Concurrent: #{dlEchoNest.getMaxConccurentJobs()}"
				fs = require 'fs'
				log = 
					nAritsts : dlEchoNest.getnArtists()
					nArtistsSkipped : dlEchoNest.getnArtistsSkipped()
					numberOfArtists : results.length
					nHrefs : dlEchoNest.getTotalItems()
					nvideos : totalImages
				console.log  JSON.stringify dlEchoNest.saveIndices()
				console.log  JSON.stringify dlEchoNest.saveLog(JSON.stringify(log))
				# THE MAIN FUNC
				dlEchoNest.runJob (err, fileName, isDone)=>
					if err then console.log err
					else 
						if fileName
							@stats.currentId = fileName + ":noDB"
							imageInsertion.insertTransaction fileName, (err,result)->
								if err then console.log "Cannot insert imags: #{fileName} into table. ERROR: #{err} "
							@updateStats()
							_u = "update #{@table.Artists} SET is_image_being_processed=is_image_being_processed + 1 where artist_id=#{@connection.escape fileName.replace(/_[0-9]+.json/,"")}"
							@connection.query _u, (err)=>
								if err then console.log "cannot set artists anbinh #{err}"

					if isDone
						@utils.printFinalResult @stats
						# CALLBACK FUNCTION WHEN DONE
						@downloadImages()

	putArtistsFromDiskToDB : ->
		
		ArtistTransformation = require './echonest/artist_transformation'
		DatabaseInsertion = require './echonest/database_insertion'

		@connect()
		path = '/Volumes/Data/website/database/echonest_artists_patch/'
		@table.Artists = "ENArtists"

		table = {artist : "ENArtists",blogs : "ENBlogs",news : "ENNews",reviews : "ENReviews",audios : "ENAudios",biographies : "ENBiographies",terms : "ENTerms",urls : "ENUrls",foreign_ids : "ENForeign_ids"}				
		transformer = new ArtistTransformation table, @connection
		fileName = "anbinh" + @formatDate(new Date()).replace(/:/g,'-').replace(" ","-") + ".sql"
		transformer.setPath '/Volumes/Data/website/database/sql/'
		transformer.setFileName(fileName)
		# transformer.resetAllTables()

		dbInsertion = new DatabaseInsertion(path,@table.Artists,@connection)
		dbInsertion.setMaxConcurrentJobs(1000)
		dbInsertion.logInfo()

		dbInsertion.insertIntoDatabaseFromDisk = (file,callback)->
			@currentFileCount += 1
			@currentFile = file +			 ":" + @currentFileCount + ":#{@currentCursor}"
			try
				data = @fs.readFileSync(@path + file)
				data = JSON.parse data
				if data.response.artist
					data = data.response.artist
					_temp = []
					_temp.push data
					data = _temp
				else data = data.response.artists

				indexCount = 0
				totalItemInFile = data.length
				# console.log "asds"
				if totalItemInFile > 0
					for artist, index in data
						# console.log "#{artist.songs}--#{index}"
						if artist.songs
							if artist.songs.length > 0 then @artistHavingSongsGreaterThanZero +=1
						@totalItemCount +=1
						# console.log transformer.getInsertStatement transformer.getForeignIds(artist), "ENForeign_ids"
						# console.log artist
						# The method appendArtistToFile of class ArtistTransformation does 2 things
						# Firstly, it checks if  an artist is available in its table. If not, then save to file and insert new artist into DB. 
						# Otherwise, it  will discard the artist.
						# The callback will be triggered in the case of the new one is inserted into DB for checking later with null error
						transformer.appendArtistToFile artist, (err)=>
							callback err, @currentFile
							indexCount +=1
							if indexCount is totalItemInFile
								@runNext(callback)
							null
				else 
					# console.log "run this #{file} : #{totalItemInFile} --> #{@currentCursor} ------                   ----------------------"
					callback null, @currentFile
					# console.log "ANBINH"
					@runNext(callback)
				null
			catch e
				# console.log e
				err = "#{file} has an error. #{e}"
				callback err, @currentFile
				@runNext(callback)
				@errorFiles.push file
		
		check = false
		dbInsertion.runJob (err,currentFile, isDone)=>
			@stats.currentId = currentFile			
			if not isDone
				if err  
					if not err.match(/Artist will be discard/)
						console.log "ERROR: #{err}".red
					@stats.totalItemCount +=1
					@stats.failedItemCount +=1
					@utils.printUpdateRunning @stats.currentId, @stats, "Fetching...."
				else 				
					# console.log currentFile + "-----------"
					@updateStats()
			else
				@utils.printFinalResult @stats
				dbInsertion.logResult "/Volumes/Data/website/database/artists_files_errors.json"
	putSongsFromDiskToDB : ->

		DatabaseInsertion = require './echonest/database_insertion'
		SongTransformation = require './echonest/song_transformation'

		@connect()
		directory = "echonest_song_part2"
		path = "/Volumes/Data/website/database/#{directory}/"
		@table.Songs = "ENSongs"

		table = 
			song : "ENSongs"
			foreign_ids :  "ENSongs_foreign_ids"
			tracks : "ENSongs_tracks"			
		transformer = new SongTransformation table, @connection
		fileName = "songs-#{directory}-" + @formatDate(new Date()).replace(/-/g,'').replace(" ","-").replace(/:/g,'_') + ".sql"
		transformer.setPath '/Volumes/Data/website/database/sql/'
		transformer.setFileName(fileName)

		dbInsertion = new DatabaseInsertion(path,@table.Songs,@connection)
		dbInsertion.setMaxConcurrentJobs(50)

		dbInsertion.insertIntoDatabaseFromDisk = (file,callback)->
			@currentFileCount += 1
			@currentFile = file + ":" + @currentFileCount + ":#{@currentCursor}"
			try
				data = @fs.readFileSync(@path + file)
				data = JSON.parse data
				data = data.response.songs
				indexCount = 0
				if data.length > 0
					for song, index in data
						if song.songs
							if song.songs.length > 0 then @songHavingSongsGreaterThanZero +=1
						@totalItemCount +=1

						transformer.appendSongToFile song, (err)=>
							callback err, @currentFile
							indexCount +=1
							if indexCount is data.length
								@runNext(callback)
							null
				else 
					# console.log "run this #{file} : #{data.length} --> #{@currentCursor} ------                   ----------------------"
					callback null, @currentFile
					@runNext(callback)
				null
			catch e
				# console.log e
				err = "#{file} has an error. #{e}"
				callback err, @currentFile
				@runNext(callback)
				@errorFiles.push file
		dbInsertion.logInfo()
		check = false
		dbInsertion.runJob (err,currentFile, isDone)=>
			
			@stats.currentId = currentFile
			if isDone
				@utils.printFinalResult @stats
				dbInsertion.logResult "/Volumes/Data/website/database/songs_files_errors.json"
			else 
				if err  
					if not err.match(/Song will be discard/)
						console.log "NEW ERROR: #{err}"
					@stats.totalItemCount +=1
					@stats.failedItemCount +=1
					@utils.printUpdateRunning @stats.currentId, @stats, "Fetching...."
				else 
					@updateStats()

	putVideosFromDiskToDB : ->

		DatabaseInsertion = require './echonest/database_insertion'
		@connect()
		directory = "echonest_video"
		path = "/Volumes/Data/website/database/#{directory}/"
		@table.Videos = "ENVideos"
		_insertVideoStatement= @query._insertIntoVideos


		dbInsertion = new DatabaseInsertion(path,@table.Videos,@connection)
		dbInsertion.setMaxConcurrentJobs(50)

		dbInsertion.insertIntoDatabaseFromDisk = (file,callback)->
			@currentFileCount += 1
			@currentFile = file + ":" + @currentFileCount + ":#{@currentCursor}"
			try
				data = @fs.readFileSync(@path + file)
				data = JSON.parse data
				data = data.response.video
				indexCount = 0
				if data.length > 0
					for video, index in data
						@totalItemCount +=1
						_video = 
							video_id : video.id
							title : video.title
							artist_id : ""
							site : video.site
							url : video.url
							image_url : video.image_url
							date_found : video.date_found
						_video.artist_id = file.replace(/_[0-9]+.json/,"")

						@connection.query _insertVideoStatement,_video, (err)=>
							callback err, @currentFile
							indexCount +=1
							if indexCount is data.length
								@runNext(callback)
							null
				else 
					# console.log "run this #{file} : #{data.length} --> #{@currentCursor} ------                   ----------------------"
					callback null, @currentFile
					@runNext(callback)
				null
			catch e
				# console.log e
				err = "#{file} has an error. #{e}"
				callback err, @currentFile
				@runNext(callback)
				@errorFiles.push file
		dbInsertion.logInfo()
		check = false
		dbInsertion.runJob (err,currentFile, isDone)=>
			
			@stats.currentId = currentFile
			if isDone
				@utils.printFinalResult @stats
				dbInsertion.logResult "/Volumes/Data/website/database/videos_files_errors.json"
			else 
				if err  
					if not err.match(/Song will be discard/)
						console.log "NEW ERROR: #{err}"
					@stats.totalItemCount +=1
					@stats.failedItemCount +=1
					@utils.printUpdateRunning @stats.currentId, @stats, "Fetching...."
				else 
					@updateStats()

	fetchABunchOfArtistsInDB_first : ->
		
		@table.Artists = "ENArtists_stats"
		dlEchoNest = new DownloadEchoNest()
		dlEchoNest.setnArtists(10000)
		dlEchoNest.setnArtistsSkipped(0)
		dlEchoNest.setMaxConcurrentJobs(32)
		@connect()
		@connection.query "Select artist_id, nsongs from #{@table.Artists} where is_song_being_processed=0 LIMIT \
		#{dlEchoNest.getnArtistsSkipped()},#{dlEchoNest.getnArtists()}", (err, results)=>
			if err then console.log "dsjfhskjdfh#{err}"
			else 
				totalSongs = 0
				for artist in results
					dlEchoNest.appendNewIndicesFromArtist artist
					totalSongs += artist.nsongs
				console.log "OPTIONS: nAritsts=#{dlEchoNest.getnArtists()}, nArtistsSkipped=#{dlEchoNest.getnArtistsSkipped()}"
				console.log "# artists : #{results.length}"
				console.log "# hrefs : #{dlEchoNest.getTotalItems()}"
				console.log "# Songs : #{totalSongs}"
				console.log "# Tables : #{@table.Artists}"
				console.log "# Concurrent: #{dlEchoNest.getMaxConccurentJobs()}"
				fs = require 'fs'
				log = 
					nAritsts : dlEchoNest.getnArtists()
					nArtistsSkipped : dlEchoNest.getnArtistsSkipped()
					numberOfArtists : results.length
					nHrefs : dlEchoNest.getTotalItems()
					nsongs : totalSongs
				console.log  JSON.stringify dlEchoNest.saveIndices()
				console.log  JSON.stringify dlEchoNest.saveLog(JSON.stringify(log))
				# THE MAIN FUNC
				dlEchoNest.runJob (err, fileName, isDone)=>
					if err then console.log err
					else 
						if fileName
							@stats.currentId = fileName + ":noDB"
							@updateStats()
							_u = "update #{@table.Artists} SET is_song_being_processed=is_song_being_processed + 1 where artist_id=#{@connection.escape fileName.replace(/_[0-9]+.json/,"")}"
							@connection.query _u, (err)=>
								if err then console.log "cannot set artists anbinh #{err}"

					if isDone
						@utils.printFinalResult @stats
						@fetchABunchOfArtistsInDB_first()
					# @end()
					# @connect()
					# if err then console.log "can not download #{err}"
					# else 
					# 	file = dlEchoNest.getFilePath() + fileName
					# 	content = fs.readFileSync file
					# 	data = JSON.parse content
					# 	options =
					# 		id : fileName
					# 	@stats.currentId = fileName
					# 	if data.response 
					# 		if data.response.songs
					# 			items = data.response.songs
					# 			if items isnt undefined
					# 				@eventEmitter.emit "item-result", items, options
					# 			else @onItemFail "undefined", options
					# 		else @onItemFail "data.response.songs does not exit", options
					# 	else @onItemFail "data.response does not exit", options

	# Major update: update new songs based on some attributes
	updateSongs : ->
		@connect()
		@showStartupMessage "Update new songs on table", @table.Songs

		UpdateNewSongsAndArtists = require './echonest/update_song'
		us = new UpdateNewSongsAndArtists(@table,@connection,@getFileByHTTP)
		us.setDefaultTotalItems(1000)
		
		# sids = ['SODCHZN1311AFDE225','SOZTASP131343A05BA','SOPLRQU131343905EF','SOZVFBC1312A8AFE1B','SOLIBKD1311AFE84CC','SOIOPGD1313439B00E','SOKIOVV131343959D4','SOMRDXU1312FDFDE15','SORXXID1311AFD787B','SOMUOPA1311AFDB7AF','SOMAAXM1313439793D','SOUTAJC131343967AD','SOYDHKW13134392D56','SOKOHAQ13134387D8F','SOBWUHO1311AFE7029','SOOLHJI1311AFDF206','SOXVKCF1311AFE3C9A','SOQJMQH1313439D4A2','SOAOLCY1311AFDE1C8','SOYUFKA1311AFDCE59','SOUKBLY1311AFDE5D3','SOMXIYD1312FE00724','SOXHMPZ1311AFE5CE9','SONVPPB1312FE00ED4','SOEQQSR13134392E19','SOXSRRJ1311AFE0A6B','SOJFGZO1313438951E','SOVPUDN1311AFE0318','SOGRKNC1312A8A8B43','SOOISAO131343A6823','SOMOCPX131343A0052','SOULTCL131343A2681','SOEJHIN1311AFE4F0E','SOYCEFA136F1608EB4','SOUILFX136F1A1FD6B','SOPYZXX136C5A2FE88','SOQSQJQ136C5711F49','SODARDS136C73BA443','SOSAFFK136C74CE673']
		# us.requestNewSongsWithItsProperties sids, (songStatements)->
		# 	console.log "DONE"
		# 	console.log songStatements
		us.addAttribute("sort","song_hotttnesss-desc")
		us.getNewSongAndArtistIds "song_max_hotttnesss",1,(statements,songids)=>
			console.log "HELLO!"
			console.log "statmens length: #{statements.length}"
			console.log "# of new songs #{statements.match(/INSERT IGNORE INTO ENSongs /g)?.length}"
			fs = require 'fs'
			fs.appendFileSync "/Volumes/Data/website/database/anbinh_xxxx_new.sql",statements
			console.log "WRITTING NEW ARTISTS TO DISK DONE!"
			console.log "Getting #{songids.length} new songs"
			us.requestNewSongsWithItsProperties songids, (songsStatements)->
				fs.appendFileSync "/Volumes/Data/website/database/anbinh_xxxx_new.sql",songsStatements
				console.log "WRITTING NEW SONGS TO DISK DONE!" 
			# console.log "songs length #{songids.length}"
			# console.log songids
			# console.log "Getting new songs with their tracks and their foreign_ids..."
			# us.requestNewSongsWithItsProperties songids, (songStatements)->
			# 	console.log "DONE"
			# 	console.log songStatements

			# us.filterNewAlbumIds artistids



	showStats : ->
		@_printTableStats @table


module.exports = EchoNest