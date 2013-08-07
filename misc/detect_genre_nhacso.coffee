desc = "Genres: Pop, Dance, Teen Pop, Rock\n
Released: 16 July 2013\n
℗ 2013 Atlantic Recording Corporation for the United States and WEA International Inc. for the world outside of the United States"
desc2 = "Label: Carter Enterprises\n
Genres: Hip-Hop/Rap, Music"
desc = "Genre : 팝 (Pop), 댄스 (Dance)"
desc = "Genre: Pop\n
Released: Jul 24, 2013/ ℗ 2013 UNIVERSAL SIGMA, a division of UNIVERSAL MUSIC LLC"
desc = "GENRE (K-Pop) :	 댄스 (Dance)\n
LABEL/PUBLISHER :	 Top Media | LOEN Entertainment"
desc = "GENRE (K-Pop) :	 일렉트로니카 (Electronica)\n
LABEL/PUBLISHER :	 Paris Baguette, New Moon On Monday Inc., MoonWalk AB | Loen Entertainment"
desc = "Genre: OST\n
Company | Publisher : CJ E&M | CJ E&M"
desc = "GENRE (K-Pop) :	 OST > TV Drama\n
LABEL/PUBLISHER :	 (주)까사벨르 | Neowiz Internet"
getGenre = (str)->
	genres = str.match(/genres?(\s+)?\:?.+/gi)?[0]
	if genres 
		genres = genres.replace(/genres?(\s+)?\:?/gi,'').trim().split(',').map (v)-> v.replace(/\:/g,'').trim()
		if genres.length is 1
			_arr = []
			if genres[0].match(/K-Pop/gi)?[0]
				_arr.push "Korean Pop"
				_arr.push genres[0].replace(/\(?K-Pop\)?/gi,'').trim()
				genres = _arr
	else 
		genres = null
	return genres
getLabel = (str)->
	label = str.match(/label\:?.+/gi)?[0]
	if label    
		label = label.replace(/label\:?/gi,'').trim()
		if label.match(/([^])?Publisher(\s)+\:?.+/gi)
			label = label.replace(/([^])?Publisher(\s)+\:?/gi,'').trim()
		return label
	if str.match(/℗.+/)?[0]
		return str.match(/℗.+/)?[0].replace(/℗/,'').replace(/[0-9]{4}/,'').trim()
	if label then return label.replace(/\/?PUBLISHER(\s+)?\:?/gi,'').trim()

	label = str.match(/([^])?Publisher(\s)+\:?.+/gi)?[0]
	if label then return str.match(/(.+)?Publisher(\s)+\:?.+/gi)?[0].replace(/(.+)?Publisher(\s)+\:?/gi,'').trim()

console.log getGenre desc
console.log getLabel desc