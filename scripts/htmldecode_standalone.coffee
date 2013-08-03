
htmlDecode = (s) ->
  arr1 = new Array("&nbsp;", "&iexcl;", "&cent;", "&pound;", "&curren;", "&yen;", "&brvbar;", "&sect;", "&uml;", "&copy;", "&ordf;", "&laquo;", "&not;", "&shy;", "&reg;", "&macr;", "&deg;", "&plusmn;", "&sup2;", "&sup3;", "&acute;", "&micro;", "&para;", "&middot;", "&cedil;", "&sup1;", "&ordm;", "&raquo;", "&frac14;", "&frac12;", "&frac34;", "&iquest;", "&Agrave;", "&Aacute;", "&Acirc;", "&Atilde;", "&Auml;", "&Aring;", "&Aelig;", "&Ccedil;", "&Egrave;", "&Eacute;", "&Ecirc;", "&Euml;", "&Igrave;", "&Iacute;", "&Icirc;", "&Iuml;", "&ETH;", "&Ntilde;", "&Ograve;", "&Oacute;", "&Ocirc;", "&Otilde;", "&Ouml;", "&times;", "&Oslash;", "&Ugrave;", "&Uacute;", "&Ucirc;", "&Uuml;", "&Yacute;", "&THORN;", "&szlig;", "&agrave;", "&aacute;", "&acirc;", "&atilde;", "&auml;", "&aring;", "&aelig;", "&ccedil;", "&egrave;", "&eacute;", "&ecirc;", "&euml;", "&igrave;", "&iacute;", "&icirc;", "&iuml;", "&eth;", "&ntilde;", "&ograve;", "&oacute;", "&ocirc;", "&otilde;", "&ouml;", "&divide;", "&Oslash;", "&ugrave;", "&uacute;", "&ucirc;", "&uuml;", "&yacute;", "&thorn;", "&yuml;", "&quot;", "&amp;", "&lt;", "&gt;", "&oelig;", "&oelig;", "&scaron;", "&scaron;", "&yuml;", "&circ;", "&tilde;", "&ensp;", "&emsp;", "&thinsp;", "&zwnj;", "&zwj;", "&lrm;", "&rlm;", "&ndash;", "&mdash;", "&lsquo;", "&rsquo;", "&sbquo;", "&ldquo;", "&rdquo;", "&bdquo;", "&dagger;", "&dagger;", "&permil;", "&lsaquo;", "&rsaquo;", "&euro;", "&fnof;", "&alpha;", "&beta;", "&gamma;", "&delta;", "&epsilon;", "&zeta;", "&eta;", "&theta;", "&iota;", "&kappa;", "&lambda;", "&mu;", "&nu;", "&xi;", "&omicron;", "&pi;", "&rho;", "&sigma;", "&tau;", "&upsilon;", "&phi;", "&chi;", "&psi;", "&omega;", "&alpha;", "&beta;", "&gamma;", "&delta;", "&epsilon;", "&zeta;", "&eta;", "&theta;", "&iota;", "&kappa;", "&lambda;", "&mu;", "&nu;", "&xi;", "&omicron;", "&pi;", "&rho;", "&sigmaf;", "&sigma;", "&tau;", "&upsilon;", "&phi;", "&chi;", "&psi;", "&omega;", "&thetasym;", "&upsih;", "&piv;", "&bull;", "&hellip;", "&prime;", "&prime;", "&oline;", "&frasl;", "&weierp;", "&image;", "&real;", "&trade;", "&alefsym;", "&larr;", "&uarr;", "&rarr;", "&darr;", "&harr;", "&crarr;", "&larr;", "&uarr;", "&rarr;", "&darr;", "&harr;", "&forall;", "&part;", "&exist;", "&empty;", "&nabla;", "&isin;", "&notin;", "&ni;", "&prod;", "&sum;", "&minus;", "&lowast;", "&radic;", "&prop;", "&infin;", "&ang;", "&and;", "&or;", "&cap;", "&cup;", "&int;", "&there4;", "&sim;", "&cong;", "&asymp;", "&ne;", "&equiv;", "&le;", "&ge;", "&sub;", "&sup;", "&nsub;", "&sube;", "&supe;", "&oplus;", "&otimes;", "&perp;", "&sdot;", "&lceil;", "&rceil;", "&lfloor;", "&rfloor;", "&lang;", "&rang;", "&loz;", "&spades;", "&clubs;", "&hearts;", "&diams;")
  arr2 =  new Array("&#160;", "&#161;", "&#162;", "&#163;", "&#164;", "&#165;", "&#166;", "&#167;", "&#168;", "&#169;", "&#170;", "&#171;", "&#172;", "&#173;", "&#174;", "&#175;", "&#176;", "&#177;", "&#178;", "&#179;", "&#180;", "&#181;", "&#182;", "&#183;", "&#184;", "&#185;", "&#186;", "&#187;", "&#188;", "&#189;", "&#190;", "&#191;", "&#192;", "&#193;", "&#194;", "&#195;", "&#196;", "&#197;", "&#198;", "&#199;", "&#200;", "&#201;", "&#202;", "&#203;", "&#204;", "&#205;", "&#206;", "&#207;", "&#208;", "&#209;", "&#210;", "&#211;", "&#212;", "&#213;", "&#214;", "&#215;", "&#216;", "&#217;", "&#218;", "&#219;", "&#220;", "&#221;", "&#222;", "&#223;", "&#224;", "&#225;", "&#226;", "&#227;", "&#228;", "&#229;", "&#230;", "&#231;", "&#232;", "&#233;", "&#234;", "&#235;", "&#236;", "&#237;", "&#238;", "&#239;", "&#240;", "&#241;", "&#242;", "&#243;", "&#244;", "&#245;", "&#246;", "&#247;", "&#248;", "&#249;", "&#250;", "&#251;", "&#252;", "&#253;", "&#254;", "&#255;", "&#34;", "&#38;", "&#60;", "&#62;", "&#338;", "&#339;", "&#352;", "&#353;", "&#376;", "&#710;", "&#732;", "&#8194;", "&#8195;", "&#8201;", "&#8204;", "&#8205;", "&#8206;", "&#8207;", "&#8211;", "&#8212;", "&#8216;", "&#8217;", "&#8218;", "&#8220;", "&#8221;", "&#8222;", "&#8224;", "&#8225;", "&#8240;", "&#8249;", "&#8250;", "&#8364;", "&#402;", "&#913;", "&#914;", "&#915;", "&#916;", "&#917;", "&#918;", "&#919;", "&#920;", "&#921;", "&#922;", "&#923;", "&#924;", "&#925;", "&#926;", "&#927;", "&#928;", "&#929;", "&#931;", "&#932;", "&#933;", "&#934;", "&#935;", "&#936;", "&#937;", "&#945;", "&#946;", "&#947;", "&#948;", "&#949;", "&#950;", "&#951;", "&#952;", "&#953;", "&#954;", "&#955;", "&#956;", "&#957;", "&#958;", "&#959;", "&#960;", "&#961;", "&#962;", "&#963;", "&#964;", "&#965;", "&#966;", "&#967;", "&#968;", "&#969;", "&#977;", "&#978;", "&#982;", "&#8226;", "&#8230;", "&#8242;", "&#8243;", "&#8254;", "&#8260;", "&#8472;", "&#8465;", "&#8476;", "&#8482;", "&#8501;", "&#8592;", "&#8593;", "&#8594;", "&#8595;", "&#8596;", "&#8629;", "&#8656;", "&#8657;", "&#8658;", "&#8659;", "&#8660;", "&#8704;", "&#8706;", "&#8707;", "&#8709;", "&#8711;", "&#8712;", "&#8713;", "&#8715;", "&#8719;", "&#8721;", "&#8722;", "&#8727;", "&#8730;", "&#8733;", "&#8734;", "&#8736;", "&#8743;", "&#8744;", "&#8745;", "&#8746;", "&#8747;", "&#8756;", "&#8764;", "&#8773;", "&#8776;", "&#8800;", "&#8801;", "&#8804;", "&#8805;", "&#8834;", "&#8835;", "&#8836;", "&#8838;", "&#8839;", "&#8853;", "&#8855;", "&#8869;", "&#8901;", "&#8968;", "&#8969;", "&#8970;", "&#8971;", "&#9001;", "&#9002;", "&#9674;", "&#9824;", "&#9827;", "&#9829;", "&#9830;")

  isEmpty =  (val) ->
      if val
        (val is null) or val.length is 0 or /^\s+$/.test(val)
      else
        true
  swapArrayVals = (s, arr1, arr2) ->
      return s  if isEmpty(s)
      re = undefined
      if arr1 and arr2
        
        #ShowDebug("in swapArrayVals arr1.length = " + arr1.length + " arr2.length = " + arr2.length)
        # array lengths must match
        if arr1.length is arr2.length
          x = 0
          i = arr1.length

          while x < i
            re = new RegExp(arr1[x], "g")
            s = s.replace(re, arr2[x]) #swap arr1 item with matching item from arr2
            x++
      s

  HTML2Numerical = (s) -> swapArrayVals s, arr1, arr2

  #----------------------------#    
  arr = undefined
  c = undefined
  m = undefined
  d = s
  return d  if isEmpty(d)
  
  d = HTML2Numerical(d)
  
  arr = d.match(/&#[0-9]{1,5};/g)
  
  if arr?
    x = 0

    while x < arr.length
      m = arr[x]
      c = m.substring(2, m.length - 1) #get numeric part which is refernce to unicode character
      # if its a valid number we can decode
      if c >= -32768 and c <= 65535
        
        # decode every single match within string
        d = d.replace(m, String.fromCharCode(c))
      else
        d = d.replace(m, "") #invalid so replace with nada
      x++
  d

console.log  htmlDecode('<p>Đ&acirc;y l&agrave; đĩa đơn tiếng Nhật thứ 34 được BoA ph&aacute;t h&agrave;nh. Ca kh&uacute;c chủ đề c&ugrave;ng t&ecirc;n với phần vũ đạo bouncy được sử dụng l&agrave;m nhạc nền cho bộ phim &lsquo;Hakui no Namida&rsquo;. Phần h&igrave;nh ảnh b&igrave;a album, BoA v&ocirc; c&ugrave;ng xinh tươi v&agrave; trẻ trung với nụ cười rạng ngời.</p>')

multiArgs = (args, fn) ->
  result = []
  i = undefined
  i = 0
  while i < args.length
    result.push args[i]
    fn.call args, args[i], i  if fn
    i++
  result
stripTags = (s,tag) ->
  args = arguments.length > 0 ? arguments : ['']
  multiArgs args, (tag) ->
    s = s.replace(RegExp("</?" + tag + "[^<>]*>", "gi"), "")

  return s
tag = ''
str = '<div class="clear-fix"></div><div class="content-item ">
<a title="Tập 4 - Vòng Đối Đầu" href="http://tv.zing.vn/video/Giong-Hat-Viet-Tap-4-Vong-Doi-Dau/IWZ9FOIU.html?from=mp3zing" target="_blank" class="video-img"><img src="http://image.mp3.zdn.vn/home_channel_hot/d/8/d8bb936bc561ece8e37bb0f83367a211_1375029551.jpg" width="128" height="72" alt="Tập 4 - Vòng Đối Đầu" /></a>
<h3><a title="Tập 4 - Vòng Đối Đầu" href="http://tv.zing.vn/video/Giong-Hat-Viet-Tap-4-Vong-Doi-Dau/IWZ9FOIU.html?from=mp3zing" target="_blank">Tập 4 - Vòng Đối Đầu</a></h3>
<span><a href="http://tv.zing.vn/giong-hat-viet?from=mp3zing" title="Giọng Hát Việt 2013" target="_blank" class="_strCut" strlength="24">Giọng Hát Việt 2013</a></span>
</div>'


console.log str.replace(RegExp("</?" + tag + "[^<>]*>", "gi"), "")

class RegexString 


str = "
<a href=test.html class=4444> a=adf asd  </a>1
<a href=\"test.html\" class=\"7777\"> adf asdf </a>
<a href='test.html' class=\"4555\">  asdf d </a>
"
console.log str.match /(\S+)=["']?((?:.(?!["']?\s+(?:\S+)=|[>"']))+.)["']?/gi
tag = "href"
re = "(#{tag})=[\"\']\?((\?\:\.(\?\![\"\']\?\\s+(\?\:\\S+)=|[>\"\']))\+\.)[\"\']?"
console.log re
reg = new RegExp(re,"gi")
console.log str.match(reg)
console.log str.match /<a href.+?(<\/a>)/gi
console.log 'dfaljdf "afsdkf" sadfjsk "adl"'.match /".+?"/gi

