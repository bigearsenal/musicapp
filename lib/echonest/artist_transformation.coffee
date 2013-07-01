ObjectTransformation = require './object_transformation'

class ArtistTransformation extends ObjectTransformation
	constructor : (@table,@connection)->
		super @table,@connection
	getTransformedArtist  : (artist)->
		_artist = 
			id 				:	artist.id
			name 			: 	artist.name
			familiarity 		:	artist.familiarity 						
			hotttnesss 		:	artist.hotttnesss 					
					

		location = artist.artist_location 
		if location
			_artist.country = location.country or ""
			_artist.city = location.city or ""
			_artist.location = location.location or ""
			_artist.region = location.region or ""
		else
			_artist.country = ""
			_artist.city = ""
			_artist.location =  ""
			_artist.region = ""

		
		docCounts = artist.doc_counts
		if docCounts
			_artist.nbiographies 	= docCounts.biographies
			_artist.nblogs			= docCounts.blogs
			_artist.nnews			= docCounts.news
			_artist.nreviews		= docCounts.reviews
			_artist.nimages			= docCounts.images
			_artist.naudios			= docCounts.audio
			_artist.nsongs			= docCounts.songs
			_artist.nvideos			= docCounts.video
		else 
			_artist.nbiographies 	= 0
			_artist.nblogs			= 0
			_artist.nnews			= 0
			_artist.nreviews		= 0
			_artist.nimages			= 0
			_artist.naudios			= 0
			_artist.nsongs			= 0
			_artist.nvideos			= 0

		genres = artist.genres
		_artist.genres = ""
		if genres
			_genres = []
			for genre in genres
				_genres.push genre.name
			if _genres.length > 0
				_artist.genres = JSON.stringify _genres

		yearsActive = artist.years_active 
		_artist.years_active = ""
		if yearsActive
			if yearsActive.length > 0
				_artist.years_active = JSON.stringify yearsActive
		return _artist
	getBlogs : (artist)->
		blogs = artist.blogs
		if blogs
			_blogs = []
			for blog in blogs
				_blog = 
					blog_id : ""
					artist_id : artist.id
					name : ""
					summary : ""
					url : ""
					date_found : ""
					date_posted : ""
				if blog.id then _blog.blog_id = blog.id
				if blog.name then _blog.name = blog.name
				if blog.summary then _blog.summary = blog.summary
				if blog.url then _blog.url = blog.url
				if blog.date_posted then _blog.date_posted = blog.date_posted
				if blog.date_found then _blog.date_found = blog.date_found
				_blogs.push _blog
			return _blogs
		else return []
	getNewss : (artist)->
		newss = artist.news
		_newss = []
		if newss
			for news in newss
				_news = 
					news_id : ""
					artist_id : artist.id
					name : ""
					summary : ""
					url : ""
					date_found : ""
				if news.id then _news.news_id = news.id
				if news.name then _news.name = news.name
				if news.summary then _news.summary = news.summary
				if news.url then _news.url = news.url
				if news.date_found then _news.date_found = news.date_found
				_newss.push _news
			return _newss
		else return []
	getReviews : (artist)->
		reviews = artist.reviews
		_reviews = []
		if reviews
			for review in reviews
				_review = 
					artist_id : artist.id
					name : ""
					release : ""
					summary : ""
					image_url : ""
					url : ""
					date_found : ""
				if review.name then _review.name = review.name
				if review.summary then _review.summary = review.summary
				if review.url then _review.url = review.url
				if review.release then _review.release = review.release
				if review.image_url then _review.image_url = review.image_url
				if review.date_found then _review.date_found = review.date_found
				_reviews.push _review
			return _reviews
		else return []
	getAudios : (artist)->
		audios = artist.audio
		_audios = []
		if audios
			for audio in audios
				_audio = 
					audio_id : ""
					artist_id : artist.id
					title : ""
					length : 0
					url : ""
					date : ""
				if audio.id then _audio.audio_id = audio.id
				if audio.title then _audio.title = audio.title
				if audio.length then _audio.length = audio.length
				if audio.url then _audio.url = audio.url
				if audio.date then _audio.date = audio.date
				_audios.push _audio
			return _audios
		else return []
	getBiographies : (artist)->
		biographies = artist.biographies
		_biographies = []
		if biographies
			for bio in biographies
				_bio = 
					site : ""
					artist_id : artist.id
					desc : ""
					truncated : 0
					url : ""
					licence_attribution : ""
					licence_attribution_url : ""
					licence_type : ""
					licence_url : ""
					licence_version : ""
				if bio.site then _bio.site = bio.site
				if bio.text then _bio.desc = bio.text
				if bio.truncated then _bio.truncated = bio.truncated
				if bio.url then _bio.url = bio.url
				if bio.licence
					if bio.licence.attribution then _bio.licence_attribution = bio.licence.attribution
					if bio.licence["attribution-url"] then _bio.licence_attribution_url = bio.licence["attribution-url"]
					if bio.licence.type then _bio.licence_type = bio.licence.type
					if bio.licence.url then _bio.licence_url = bio.licence.url
					if bio.licence.version then _bio.licence_version = bio.licence.version
				_biographies.push _bio
			return _biographies
		else return []
	getTerms : (artist)->
		terms = artist.terms
		_terms = []
		if terms
			for term in terms
				_term = 
					name : ""
					artist_id : artist.id
					frequency : ""
					weight : ""
				if term.name then _term.name = term.name
				if term.frequency then _term.frequency = term.frequency
				if term.weight then _term.weight = term.weight
				_terms.push _term
			return _terms
		return []
	getUrls : (artist)->
		urls = artist.urls
		_urls = []
		if urls
			for key, value of urls
				_url = 
					site : key.replace(/_url/,'')
					artist_id : artist.id
					url : value
				_urls.push _url
			return _urls
		else return []
	getForeignIds : (artist)->
		foreignIds = artist.foreign_ids
		_foreignIds = []


		if foreignIds
			_foreignIds = @groupBy foreignIds, (value) -> value.foreign_id.replace(/^.+artist:/,'')
			_result = []
			for key, values of _foreignIds
				_id = 
					foreign_id : key
					artist_id : artist.id
				countries = @groupBy values, (value) -> value.catalog.replace(/^.+-/,'')
				catalog = @groupBy values, (value) -> value.catalog.replace(/-.+$/,'')
				_id.countries = [] 
				_id.catalog = []
				for k1, v1 of countries
					_id.countries.push k1
				_id.countries = _id.countries.join()
				if _id.countries is "facebook" or _id.countries is "WW" or _id.countries is "seatgeek" or _id.countries is "twitter"
					_id.countries = "World Wide"
				for k2,v2 of catalog
					_id.catalog.push k2
				_id.catalog = _id.catalog.join()
				if _id.catalog is "rdio"
					if _id.foreign_id.match(/r[0-9]+/)
						_id.foreign_id = _id.foreign_id.replace("r","")
				_result.push _id
			return  _result

		else return []
	getAllStatements : (artist)->
		_artist 			= @getTransformedArtist(artist)
		_blogs 			= @getBlogs(artist)
		_newss 		= @getNewss(artist)
		_reviews 		= @getReviews(artist)
		_audios 		= @getAudios(artist)
		_bios 			= @getBiographies(artist)
		_terms 			= @getTerms(artist)
		_urls 			= @getUrls(artist)
		_foreignIds 	= @getForeignIds(artist)
		_statement = "" 
		_statement +=  @getInsertStatement _artist,		 @table.artist
		_statement += "\n"
		_statement +=  @getInsertStatement _blogs,		 @table.blogs
		_statement += "\n"
		_statement +=  @getInsertStatement _newss,		 @table.news
		_statement += "\n"
		_statement +=  @getInsertStatement _reviews,	 @table.reviews
		_statement += "\n"
		_statement +=  @getInsertStatement _audios,		 @table.audios
		_statement += "\n"
		_statement +=  @getInsertStatement _bios,		 @table.biographies
		_statement += "\n"
		_statement +=  @getInsertStatement _terms,		 @table.terms
		_statement += "\n"
		_statement +=  @getInsertStatement _urls,		 @table.urls
		_statement += "\n"
		_statement +=  @getInsertStatement _foreignIds,	 @table.foreign_ids
		_statement += "\n"
		return _statement
	resetAllTables :  ->
		_statement = ""
		_specialStatment  = ""
		for key,value of @table
			if value.match /Artists/
				_specialStatment = "delete from #{value};"
			else _statement += "truncate table #{value};"
		_statement += _specialStatment
		@connection.query _statement, (err,result)->
			if err then console.log "Cannt reset all of the tables!!!. #{err}".red
			else console.log  "RESET TABLES DONE!".inverse.blueq
	appendArtistToFile : (artist, callbackOnDone) ->
		_select = "Select id from #{@table.artist} where id=#{@connection.escape artist.id}"
		# console.log _select
		@connection.query _select, (err,result)=>
			if err then callbackOnDone "We have an error in statement. ERROR: #{err}"
			else 
				if result.length is 0
					# console.log "THERE is no artist in TABLE. We will append new one to file,insert  it in table and callback when its done"
					@fs.appendFileSync @filePath, @getAllStatements(artist)+"\n"
					_statement = @getInsertStatement @getTransformedArtist(artist), @table.artist
					@connection.query _statement, (err, result)=>
						if err then callbackOnDone "Cannot insert new artist into table! ERROR:#{err}"
						else 
							# console.log result
							callbackOnDone null
				else 
					# console.log "Artist #{artist.id} exists. WE will discard"
					callbackOnDone "Artist #{artist.id} exists. Artist will be discard"

		# @fs.appendFileSync @filePath, @getAllStatements()
		# console.log "File: #{@fileName} saved succeed to #{@filePath}"
module.exports = ArtistTransformation