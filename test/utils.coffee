http = require 'http'
zlib = require 'zlib'
url = require 'url'
getFileByHTTP = (link, callback) ->
      http.get link, (res) =>
          res.setEncoding 'utf8'
          data = ''
          # callback res.headers.location
          if res.statusCode isnt 302
            res.on 'data', (chunk) =>
              data += chunk;
            res.on 'end', () =>

              callback data
          else callback(null)
        .on 'error', (e) =>
          console.log  "Cannot get file. ERROR: " + e.message
getGzipped = (link, callback, options) ->
      headers =
        'Accept-Encoding': 'gzip'
      params = 
        'host' : url.parse(link).host
        'path' : url.parse(link).path
        'method' : "GET"
        'headers': headers
      # console.log params
      buffer = []
      http.get(params, (res) ->
        gunzip = zlib.createGunzip()
        res.pipe gunzip
        gunzip.on("data", (data) ->
          buffer.push data.toString()
        ).on("end", ->
          # console.log buffer.join("")
          callback buffer.join("")
        ).on "error", (e) ->
          console.log  e
      ).on "error", (e) ->
       console.log  e
getRedirectFileByHTTP = (link, onSucess, onFail, options) ->
    http.get link, (res) =>
        res.setEncoding 'utf8'
        data = ''
        # onSucess res.headers.location
        # console.log res.statusCode
        if res.statusCode isnt 302 and res.statusCode isnt 301
          res.on 'data', (chunk) =>
            data += chunk;
          res.on 'end', () =>
            onSucess data, options
        else 
          if res.statusCode is 301
            getRedirectFileByHTTP res.headers.location,onSucess,onFail,options
          else 
            onFail("The link: #{link} is temporary moved",options)
      .on 'error', (e) =>
        onFail  "Cannot get file: #{link} from server. ERROR: " + e.message, options
        @stats.totalItemCount +=1
        @stats.failedItemCount +=1

module.exports.getFileByHTTP = getFileByHTTP
module.exports.getRedirectFileByHTTP = getRedirectFileByHTTP
module.exports.getGzipped = getGzipped