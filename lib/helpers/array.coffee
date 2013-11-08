objectEquals = (x,y) ->
	return true  if x is y
	return false  if (x not instanceof Object) or (y not instanceof Object)
	return false  if x.constructor isnt y.constructor
	for p of x
		continue  unless x.hasOwnProperty(p)
		return false  unless y.hasOwnProperty(p)
		continue  if x[p] is y[p]
		return false  if typeof (x[p]) isnt "object"
		return false  unless Object.equals(x[p], y[p])
	for p of y
		return false  if y.hasOwnProperty(p) and not x.hasOwnProperty(p)
	true
Array::uniqueObject = (property)->
	indexOfObjectInArray  = (arr, searchObj)->
		for obj,index in arr
			if objectEquals(obj,searchObj)
				return index
		return -1
	@.filter (element, index, array)->
   		indexOfObjectInArray(array, element) is index
Array::compare = (array) ->
	return false  unless array
	return false  unless @length is array.length
	i = 0
	while i < @length
		if this[i] instanceof Array and array[i] instanceof Array
			return false  unless this[i].compare(array[i])
		else return false  unless this[i] is array[i]
		i++
	true
Array::splitBySeperatorPattern = (seperatorPattern) ->
	result = []
	reg = new RegExp(seperatorPattern,"gi")
	for val in @
		seperator = val.match(reg)?[0]
		if seperator
			_a = val.split(seperator)
		else _a = val.split()
		for item in _a
			result.push item.trim()
	return result
Array::findPatternIndex = (pattern)->
	reg = new RegExp(pattern,"gi")
	for val,idx in @
		if val.match(reg)
			return idx
	return -1
Array::joinTwoElementByPattern = (firstPattern,secondPattern,bindingString)->
	idx1 = @findPatternIndex(firstPattern)
	idx2 = @findPatternIndex(secondPattern)
	if idx1 isnt -1 and idx2 isnt -1 and idx1 isnt idx2
		newArray = []
		newArray.push @[idx1]+" "+bindingString+" "+@[idx2]
		for val,index in @
			if index isnt idx1 and index isnt idx2
				newArray.push val
		return newArray
	return @
Array::splitByPatterns = (patterns)->
	newArtists = []
	for artist in @
		check = false #check if a seperator found or not
		tempArr = artist.split()
		for pattern in patterns
			tempArr = tempArr.splitBySeperatorPattern(pattern)
		for temp in tempArr
			newArtists.push temp
	return newArtists
Array::uniqueObjectByKey = (property)->
	indexOfObjectInArray  = (arr, searchTerm, property)->
		for i in [0..arr.length-1]
			if arr[i][property] is searchTerm
				return i
		return -1
	@.filter (element, index, array)->
		indexOfObjectInArray(array, element[property], property) is index
Array::unique = ()->
	@.filter (element, index, array)->
		array.indexOf(element) is index
Array::contains = (el)->
	@.forEach (val)->
		if val is el then return true


module.exports = null