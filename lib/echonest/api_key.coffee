class ENApiKeys
	constructor : ->
		# {"id":"FHPFXUKUGHZWWUXPR","rateLimit":500} doesnt work with video request
		@apiKeys = [{"id":"SQSOWEREIRXGF03CJ","rateLimit":240},{"id":"V3WFT6DHG0RJX4UD2","rateLimit":120},{"id":"EHY4JJEGIOFA1RCJP","rateLimit":500},{"id":"027ER5TKTSQ81BANR","rateLimit":500},{"id":"EGXKLPXBW3VLDDC6Y","rateLimit":120},{"id":"LCSBHWUZA2IHUVLCF","rateLimit":480},{"id":"DIRRTDZGPELXNOKKF","rateLimit":120}]
		@templateLink = "http://developer.echonest.com/api/v4/song/search?api_key=<<REPLACE_AREA_APIKEY>>&format=json&results=1&artist=radiohead"

	addNewApiKey : (apiKey)->
		@apiKeys.push apiKey
		return true
	getApiKeys : ->
		return @apiKeys

	testDistrubutionOfRandomIndex : ->
		distribution = @apiKeys.map (v)-> return 0
		count = 0
		for i in [1..100000]
			url =  "http://developer.echonest.com/api/v4/song/search?api_key=<<REPLACE_AREA_APIKEY>>&format=json&results=1&artist=radiohead"
			id = @getRandomIndexOfApiKeys()
			distribution[id] += 1
			count +=1
		
		total = 0
		total += dis for dis in distribution
		
		console.log "#{count}"
		console.log total
		console.log distribution
		console.log @apiKeys.map((v)-> v.rateLimit).join()
	getRandomIndexOfApiKeys : ->
		# load balance : the more ratelimit, the higher the probability
		totalWeights = 0
		ranges = []
		for apiKey,idx in @apiKeys
			totalWeights += apiKey.rateLimit

			if ranges.length > 0
				ranges.push apiKey.rateLimit + ranges[ranges.length-1] 
			else 
				ranges.push  apiKey.rateLimit 
		index = 0
		randomWeight = Math.random()*totalWeights|0
		# console.log ranges
		# console.log totalWeights
		# console.log randomWeight
		for range,idx in ranges
			if randomWeight > range
				index = idx + 1
		# console.log index
		return index

	initRateLimit : (callback)->
		http = require 'http'
		count = 0
		for apiKey, index in @apiKeys
			do (apiKey, index)=>
				link = @templateLink.replace("<<REPLACE_AREA_APIKEY>>",apiKey.id)
				http.get link, (res) =>
						res.setEncoding 'utf8'
						@apiKeys[index].rateLimit = parseInt res.headers["x-ratelimit-limit"], 10
						count += 1
						if count is @apiKeys.length
							callback null, @apiKeys
					.on 'error', (e) =>
						callback   "Cannot get headers of APIKEYS from server. ERROR:#{e} " , null
	getUrlByReplacingApiKey : (url,replaceString)->
		return url.replace(replaceString,@apiKeys[@getRandomIndexOfApiKeys()].id)

module.exports = ENApiKeys