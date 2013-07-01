class DatabaseInsertion
	constructor : (path,table, connection)->
		@path = path
		@fs = require 'fs'
		_files = @fs.readdirSync @path
		@files = _files.filter (v)-> if v.search('json') > -1 then return yes else return no
		@totalFiles = @files.length
		@totalItemCount = 0
		@table = table
		@connection = connection
		@query = 
			_insertIntoTable : "INSERT IGNORE INTO " + @table + " SET ? "
		@maxConcurrentJobs = 10
		@currentCursor = -1
		@errorFiles = []
		@artistHavingSongsGreaterThanZero = 0
		@_checkCursorCount = 0
		@currentFile = ""
		@currentFileCount = 0
	
	setMaxConcurrentJobs : (max)->
		@maxConcurrentJobs = max
	setPath : (path)->
		@path = path
	getPath : ->
		return @path
	getErrorFiles : ->
		return @errorFiles
	getTotalItemCount : ->
		return @totalItemCount
	getTotalFiles : ->
		return @totalFiles
	getArtistHavingSongsGreaterThanZero : ->
		return @artistHavingSongsGreaterThanZero
	getLastFile :->
		return @files[@files.length-1]
	logInfo : ->
		console.log "File Path: #{@path}"
		console.log "# of concurrent jobs : #{@maxConcurrentJobs}"
		console.log "totalFiles : #{@totalFiles}"
	logResult : (pathToDisk)->
		console.log ""
		console.log "# of items: #{@totalItemCount}"
		console.log "# of files: #{@totalFiles}"
		# console.log "# of items having songs greater than ZERO #{@artistHavingSongsGreaterThanZero}"
		if @errorFiles.length is 0
			console.log "NO FILES CORRUPTED!"
		else	
			console.log "# of failed files: #{@errorFiles.length}"
			@fs.writeFileSync pathToDisk, JSON.stringify @errorFiles
			console.log "ERRORS FILES have been written"
	
	insertIntoDatabaseFromDisk : ->

	downloadAll : ->
		for i in [0..@maxConcurrentJobs-1]
			@getNextIndex()

	runNext : (callback) ->
		# console.log "#{@currentCursor}"
		if @currentCursor < @files.length-1
			# console.log "called"
			@currentCursor +=1
			@insertIntoDatabaseFromDisk @files[@currentCursor],callback
			
			return true
		else
			@_checkCursorCount +=1
			if @_checkCursorCount is @maxConcurrentJobs
				callback null, @currentFile, true
			return false

	runJob : (callback) ->
		for i in [0..@maxConcurrentJobs-1]
			@runNext(callback)

module.exports = DatabaseInsertion