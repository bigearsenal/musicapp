Site = require "./Site"
fs = require 'fs'

class Stats extends Site
  constructor: ->
    super "XX"
    @connect()
  recordCount : (tables, message)->
    tableCount = 0
    totalTables = tables.length
    itemCount = 0
    items = []
    for table in tables
      _qs = "select count(*) as count from #{table}"
      @connection.query _qs, (err,results)->
        if err then console.log "cannt not get total songs from table"
        else 
          tableCount += 1
          for result in results
            itemCount += result.count
            items.push result.count
            # console.log result.count
          if tableCount is totalTables
            # print final result
            console.log JSON.stringify tables
            console.log JSON.stringify items
            console.log message + itemCount
  fetchTable : ->
    
    _q = "show tables"
    @connection.query _q, (err, results)=>
      if err then console.log "eroore babay"
      else 
        songTables = []
        albumTables = []
        videosTables = []
        for item in results
          table = item.Tables_in_anbinh
          if table.match(/Songs$/)
            songTables.push table
          if table.match(/[a-zA-Z]+Albums$/)
            albumTables.push table
          if table.match(/Videos$/)
            videosTables.push table

        @recordCount albumTables, "total albums is "

        @recordCount songTables, "total songs is "

        @recordCount videosTables, "total videos is "

        


    

module.exports = Stats