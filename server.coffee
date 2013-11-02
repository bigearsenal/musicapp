http = require("http")
url = require("url")
SearchUtils = require "./lib/misc/assisstantFuncs"
search = new SearchUtils()
http.createServer((req, res) ->
	uri = url.parse(req.url)
	pathname = uri.pathname
	query = uri.query
	
	if pathname is "/search" and query.match(/^q=(.+)/)
			terms = query.match(/^q=(.+)/)[1]
			console.log "Searching for term: \"#{decodeURIComponent terms}\""
			search.searchES terms, (xml)->
				res.writeHead 200,"Content-Type": "text/xml"
				res.end xml
				console.log "Complete request for term: \"#{decodeURIComponent terms}\""

	else 
		res.writeHead 200,"Content-Type": "text/plain"
		res.end "Invalid - Request denied\n"

	
	
).listen 1337, "192.168.0.169"
console.log "Server running at http://192.168.0.169:1337/"