String::stripHtmlTags = (tag)->
	if not tag then tag = ""
	@.replace(RegExp("</?" + tag + "[^<>]*>", "gi"), "")

String::getTagAttributes = (att)->
	if not att then att = "\\S+" 
	re = "(#{att})=[\"\']\?((\?\:\.(\?\![\"\']\?\\s+(\?\:\\S+)=|[>\"\']))\+\.)[\"\']?"
	reg = new RegExp(re,"gi")
	@.match(reg)


String::getTag = (tag)->
	# NOTE: this func does not resolve the nested tags
	if not tag then tag = "\\S+"
	re = "<#{tag}[^>]*>?(.*?)(<\/#{tag}>|\/>)"
	# re = "<(#{tag})([^<]+)*(?:>(.*)<\/\\1>|\\s+\/>)"
	reg = new RegExp(re,"gi")
	@.match(reg)

module.exports = null
