

# API FOR LYRICS SITES

**Table of Contents**  

- [LYRICWIKI](#lyricwiki)
	- [GetSong](#getsong)
- [SONGFREAKS](#songfreaks)
	- [Getting a song without LRC](#getting-a-song-without-lrc)
	- [Getting LRC](#getting-lrc)
	- [Getting an album](#getting-an-album)
	- [Getting an artist](#getting-an-artist)
	- [Getting artists albums](#getting-artists-albums)
	- [Getting top artists](#getting-top-artists)
	- [Getting artists lyrics](#getting-artists-lyrics)
	- [Search](#search)
- [METROLYRICS](#metrolyrics)
	- [Getting lyric](#getting-lyric)
- [AUDIOSCROBBLER](#audioscrobbler)
	- [Get artists info](#get-artists-info)
- [LYRICFIND](#lyricfind)
	- [API KEYS:](#api-keys)
	- [Getting lyric](#getting-lyric-1)
	- [New Api](#new-api)
- [SOUNDHOUND](#soundhound)
	- [Getting song info](#getting-song-info)
	- [Getting videos](#getting-videos)
- [TUNEWIKI](#tunewiki)
	- [Getting lyric](#getting-lyric-2)

## LYRICWIKI

### GetSong

http://lyrics.wikia.com/api.php?action=lyrics&func=getSong&fmt=realjson&artist=Katy Perry&song=I Kissed A Girl&fallbackSearch=1&fullApiAuth=2d73c74507eaaf2190146733b905db27

	GET /api.php?action=lyrics&func=getSong&fmt=realjson&artist=Katy Perry&song=I Kissed A Girl&fallbackSearch=1&fullApiAuth=2d73c74507eaaf2190146733b905db27 HTTP/1.1
	Host: lyrics.wikia.com
	X-Requested-With: XMLHttpRequest
	Accept-Encoding: gzip
	Cookie: Geo={"city":"FIXME","country":"VN","continent":"AS"}; wikia_beacon_id=52JFlLe4Pg
	Connection: keep-alive
	User-Agent: Appcelerator Titanium/1.7.2 (iPhone/7.0.4; iPhone OS; en_US;)

Response:

	{
	"artist": "Katy Perry",
	"song": "I Kissed A Girl",
	"lyrics": "This was never the way I planned, not my intention\nI got so brave, drink in hand, lost my discretion\nIt's not what I'm used to, just wanna try you on\nI'm curious for you caught my attention\n\nI kissed a girl and I liked it, the taste of her cherry ChapStick\nI kissed a girl just to try it, I hope my boyfriend don't mind it\nIt felt so wrong, it felt so right, don't mean I'm in love tonight\nI kissed a girl and I liked it, I liked it\n\nNo, I don't even know your name, it doesn't matter\nYou're my experimental game, just human nature\nIt's not what good girls do, not how they should behave\nMy head gets so confused, hard to obey\n\nI kissed a girl and I liked it, the taste of her cherry ChapStick\nI kissed a girl just to try it, I hope my boyfriend don't mind it\nIt felt so wrong, it felt so right, don't mean I'm in love tonight\nI kissed a girl and I liked it, I liked it\n\nUs girls we are so magical, soft skin, red lips, so kissable\nHard to resist, so touchable, too good to deny it\nIt ain't no big deal, it's innocent\n\nI kissed a girl and I liked it, the taste of her cherry ChapStick\nI kissed a girl just to try it, I hope my boyfriend don't mind it\nIt felt so wrong, it felt so right, don't mean I'm in love tonight\nI kissed a girl and I liked it, I liked it<!-- Begin comScore Tag --><script type=\"text\/javascript\">var _comscore = _comscore || [];_comscore.push({ c1: \"2\", c2: \"6177433\",\toptions: {\t\turl_append: \"comscorekw=wikiacsid_entertainment\"\t}});(function() {\tvar s = document.createElement(\"script\"), el = document.getElementsByTagName(\"script\")[0]; s.async = true;\ts.src = (document.location.protocol == \"https:\" ? \"https:\/\/sb\" : \"http:\/\/b\") + \".scorecardresearch.com\/beacon.js\";\tel.parentNode.insertBefore(s, el);})();<\/script><noscript><img src=\"http:\/\/b.scorecardresearch.com\/p?c1=2&amp;c2=6177433&amp;c3=&amp;c4=&amp;c5=&amp;c6=&amp;c7=http%3A%2F%2Flyrics.wikia.com%2Fapi.php%3Faction%3Dlyrics%26func%3DgetSong%26fmt%3Drealjson%26artist%3DKaty%2520Perry%26song%3DI%2520Kissed%2520A%2520Girl%26fallbackSearch%3D1%26fullApiAuth%3D2d73c74507eaaf2190146733b905db27%26comscorekw%3Dwikiacsid_entertainment&amp;c15=&amp;cv=2.0&amp;cj=1\" \/><\/noscript><!-- End comScore Tag -->",
	"url": "http:\/\/lyrics.wikia.com\/Katy_Perry:I_Kissed_A_Girl",
	"page_namespace": 0,
	"page_id": 791514,
	"isOnTakedownList": "0"
	}

## SONGFREAKS

### Getting a song without LRC

http://apiv2.songfreaks.com//lyric.do?

	POST //lyric.do? HTTP/1.1
	Host: apiv2.songfreaks.com
	Accept-Encoding: gzip
	Content-Type: application/x-www-form-urlencoded; charset=utf-8
	Content-Length: 111
	Connection: close
	Cookie: JSESSIONID=093B708B086F592183AD67C2CBFF590A
	User-Agent: SongFreaks 2.1.1 (iPad; iPhone OS 7.0.4; en_US)
	
	apikey=6c7a95aa8238f3b437b1db24e644c2ee&comments=true&appname=sf_iphone&sfid=4694677&version=2.1.1&territory=US

Response: 

	<songfreaks> 
	<response code="101" renderTime="0.0280">SUCCESS: LICENSE, LYRICS</response> 
	<track id="7139678" track_group_id="4694677" urlslug="blurred-lines-lyrics-pharrell-williams-3" amg="29616279" instrumental="false" viewable="true" duration="4:23" lyric="3905268" has_lrc="false" tracknumber="1" discnumber="1"> 
		<title>Blurred Lines</title> 
		<rating averagerating="0.0" userrating="0" totalratings="0" /> 
		<album id="427392" amg="2796235" urlslug="blurred-lines-album-robin-thicke-1" year="2013" image="http://www.lyricfind.com/images/amg/cov75/dru700/u725/u72557nsksm.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/dru700/u725/u72557nsksm.jpg"> 
			<title>Blurred Lines [Clean]</title> 
			<artist amg="556625" id="26855" image="http://www.lyricfind.com/images/amg/pic200/drq100/q101/q10180e2pwg.jpg" genre="Rhythm &amp; Blues" urlslug="robin-thicke"> 
				<name>Robin Thicke</name> 
				<link>http://www.songfreaks.com/robin-thicke</link> 
			</artist> 
			<link>http://www.songfreaks.com/blurred-lines-album-robin-thicke-1</link> 
		</album> 
		<artists> 
			<artist amg="281403" id="32622" image="http://www.lyricfind.com/images/amg/pic200/drq000/q084/q08457inu2g.jpg" genre="Rap" urlslug="pharrell-williams"> 
				<name>Pharrell Williams</name> 
				<link>http://www.songfreaks.com/pharrell-williams</link> 
			</artist> 
			<artist amg="483720" id="581" image="http://www.lyricfind.com/images/amg/pic200/drq000/q036/q03691ht2fv.jpg" genre="Rap" urlslug="t-i"> 
				<name>T.I.</name> 
				<link>http://www.songfreaks.com/t-i</link> 
			</artist> 
			<artist amg="556625" id="26855" image="http://www.lyricfind.com/images/amg/pic200/drq100/q101/q10180e2pwg.jpg" genre="Rhythm &amp; Blues" urlslug="robin-thicke"> 
				<name>Robin Thicke</name> 
				<link>http://www.songfreaks.com/robin-thicke</link> 
			</artist> 
		</artists> 
		<link>http://www.songfreaks.com/blurred-lines-lyrics-pharrell-williams-3</link> 
		<lyrics>Hey, hey, hey
			Hey, hey, hey Hey, hey, hey
			If you can't hear, what I'm tryna say If you can't read, from the same page
			Maybe I'm going deaf Maybe I'm going blind
			Maybe I'm out of my mind OK, now he was close
			Tried to domesticate you But you're an animal
			Baby, it's in your nature Just let me liberate you
			You don't need no papers That man is not your mate
			And that's why I'm gon' take you Good girl!
			I know you want it I know you want it
			I know you want it You're a good girl!
			Can't let it get past me Me fall from plastic
			Talk about getting blasted I hate these blurred lines!
			I know you want it I know you want it
			I know you want it But you're a good girl!
			The way you grab me Must wanna get nasty
			Go ahead, get at me What do they make dreams for
			When you got them jeans on What do we need steam for
			You the hottest b**** in this place! I feel so lucky
			You wanna hug me What rhymes with hug me?
			Hey! OK, now he was close
			Tried to domesticate you But you're an animal
			Baby, it's in your nature Just let me liberate you
			You don't need no papers That man is not your mate
			And that's why I'm gon' take you Good girl!
			I know you want it I know you want it
			I know you want it You're a good girl!
			Can't let it get past me Me fall from plastic
			Talk about getting blasted I hate these blurred lines!
			I know you want it I know you want it
			I know you want it But you're a good girl!
			The way you grab me Must wanna get nasty
			Go ahead, get at me (Hustle Gang Homie)
			One thing I ask of you Lemme be the one you bring that a** up to
			From Malibu to Paris, boo Had a b****, but she ain't bad as you
			So, hit me up when you pa**in' through I'll give you something big enough to tear your a** in two
			Swag on 'em even when you dress casual I mean, it's almost unbearable
			Honey you not there when I'm At the bar side let you have me by
			Nothin' like your last guy, he too square for you He don't smack that a** and pull your hair for you
			So I'm just watchin' and waitin' For you to salute the truly pimpin'
			Not many women can refuse this pimpin' I'm a nice guy, but don't get confused, you git'n it!
			Shake your rump Get down
			Get up Do it like it hurt, like it hurt
			What, you don't like work? Hey!
			Baby, can you breathe? I got this from Jamaica
			It always works for me Dakota to Decatur
			No more pretending Cause now your winning
			Here's our beginning I always wanted a
			Good girl! I know you want it
			I know you want it I know you want it
			You're a good girl! Can't let it get past me
			Me fall from plastic Talk about getting blasted
			I hate these blurred lines! I know you want it
			I know you want it I know you want it
			But you're a good girl! The way you grab me
			Must wanna get nasty Go ahead, get at me
			Everybody get up Everybody get up
			Hey, hey, hey Hey, hey, hey
			Hey, hey, hey</lyrics> 
		<copyright>Lyrics © EMI Music Publishing, Universal Music Publishing Group</copyright> 
		<writer>Williams, Pharrell L / Harris, Clifford / Thicke, Robin</writer> 
		<submittedlyric>false</submittedlyric> 
		<foxmobile available="false" /> 
	</track> 
	<comments totalresults="0" totalpages="0" /> 
	</songfreaks>

### Getting LRC

	POST //lyric.do? HTTP/1.1
	Host: apiv2.songfreaks.com
	Accept-Encoding: gzip
	Content-Type: application/x-www-form-urlencoded; charset=utf-8
	Content-Length: 131
	Connection: close
	Cookie: JSESSIONID=352FFB19E8C5EBA662C490C8401D42B3
	User-Agent: SongFreaks 2.1.1 (iPad; iPhone OS 7.0.4; en_US)
	
	sfid=3921858&appname=sf_iphone&comments=true&territory=US&lrc=lrc&videos=true&version=2.1.1&apikey=6c7a95aa8238f3b437b1db24e644c2ee

Response:

	<songfreaks> 
	<response code="111" renderTime="0.2300">SUCCESS: LICENSE, LRC</response> 
	<track id="101578" track_group_id="3921858" urlslug="all-i-want-for-christmas-is-you-lyrics-mariah-carey" amg="857456" instrumental="false" viewable="true" duration="4:01" lyric="3781291" has_lrc="false" tracknumber="2" discnumber="1"> 
		<title>All I Want for Christmas Is You</title> 
		<rating averagerating="0.0" userrating="0" totalratings="0" /> 
		<album id="16328" amg="206142" urlslug="merry-christmas-album-mariah-carey" year="1994" image="http://www.lyricfind.com/images/amg/cov75/dre900/e962/e96280ddswo.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/dre900/e962/e96280ddswo.jpg"> 
			<title>Merry Christmas</title> 
			<artist amg="62404" id="1269" image="http://www.lyricfind.com/images/amg/pic200/drq100/q124/q12485fnbdj.jpg" genre="Rhythm &amp; Blues" urlslug="mariah-carey"> 
				<name>Mariah Carey</name> 
				<link>http://www.songfreaks.com/mariah-carey</link> 
			</artist> 
			<link>http://www.songfreaks.com/merry-christmas-album-mariah-carey</link> 
		</album> 
		<artists> 
			<artist amg="62404" id="1269" image="http://www.lyricfind.com/images/amg/pic200/drq100/q124/q12485fnbdj.jpg" genre="Rhythm &amp; Blues" urlslug="mariah-carey"> 
				<name>Mariah Carey</name> 
				<link>http://www.songfreaks.com/mariah-carey</link> 
			</artist> 
		</artists> 
		<lrc> 
			<line lrc_timestamp="[00:07.50]" milliseconds="7500">I don't want a lot for Christmas</line> 
			<line lrc_timestamp="[00:13.53]" milliseconds="13530">There is just one thing I need</line> 
			<line lrc_timestamp="[00:17.68]" milliseconds="17680">I don't care about the presents</line> 
			<line lrc_timestamp="[00:21.32]" milliseconds="21320">Underneath the Christmas tree</line> 
			<line lrc_timestamp="[00:24.83]" milliseconds="24830">I just want you for my own</line> 
			<line lrc_timestamp="[00:29.13]" milliseconds="29130">More than you could ever know</line> 
			<line lrc_timestamp="[00:33.13]" milliseconds="33130">Make my wish come true oh</line> 
			<line lrc_timestamp="[00:39.71]" milliseconds="39710">All I want for Christmas is you</line> 
			<line /> 
			<line lrc_timestamp="[00:57.53]" milliseconds="57530">I don't want a lot for Christmas</line> 
			<line lrc_timestamp="[01:00.68]" milliseconds="60680">There is just one thing I need, and I</line> 
			<line lrc_timestamp="[01:04.32]" milliseconds="64320">Don't care about the presents</line> 
			<line lrc_timestamp="[01:07.04]" milliseconds="67040">Underneath the Christmas tree</line> 
			<line lrc_timestamp="[01:10.32]" milliseconds="70320">I don't need to hang my stocking</line> 
			<line lrc_timestamp="[01:13.53]" milliseconds="73530">There upon the fireplace</line> 
			<line lrc_timestamp="[01:16.71]" milliseconds="76710">Santa Claus won't make me happy</line> 
			<line lrc_timestamp="[01:20.10]" milliseconds="80100">With a toy on Christmas day</line> 
			<line /> 
			<line lrc_timestamp="[01:23.13]" milliseconds="83130">I just want you for my own</line> 
			<line lrc_timestamp="[01:26.23]" milliseconds="86230">More than you could ever know</line> 
			<line lrc_timestamp="[01:29.41]" milliseconds="89410">Make my wish come true</line> 
			<line lrc_timestamp="[01:32.62]" milliseconds="92620">All I want for Christmas is you</line> 
			<line /> 
			<line lrc_timestamp="[01:42.44]" milliseconds="102440">I won't ask for much this Christmas</line> 
			<line lrc_timestamp="[01:45.44]" milliseconds="105440">I won't even wish for snow, and I</line> 
			<line lrc_timestamp="[01:49.07]" milliseconds="109070">I just wanna keep on waiting</line> 
			<line lrc_timestamp="[01:51.83]" milliseconds="111830">Underneath the mistletoe</line> 
			<line /> 
			<line lrc_timestamp="[01:55.04]" milliseconds="115040">I won't make a list and send it</line> 
			<line lrc_timestamp="[01:58.23]" milliseconds="118230">To the North Pole for Saint Nick</line> 
			<line lrc_timestamp="[02:01.44]" milliseconds="121440">I won't even stay awake</line> 
			<line lrc_timestamp="[02:04.38]" milliseconds="124380">To hear those magic reindeer click</line> 
			<line /> 
			<line lrc_timestamp="[02:07.74]" milliseconds="127740">'cause I just want you here tonight</line> 
			<line lrc_timestamp="[02:11.01]" milliseconds="131010">Holding on to me so tight</line> 
			<line lrc_timestamp="[02:14.23]" milliseconds="134230">What more can I do</line> 
			<line lrc_timestamp="[02:17.07]" milliseconds="137070">Oh, Baby all I want for Christmas is you</line> 
			<line /> 
			<line lrc_timestamp="[02:27.13]" milliseconds="147130">All the lights are shining</line> 
			<line lrc_timestamp="[02:30.10]" milliseconds="150100">So brightly everywhere</line> 
			<line lrc_timestamp="[02:33.80]" milliseconds="153800">And the sound of children's</line> 
			<line lrc_timestamp="[02:36.56]" milliseconds="156560">Laughter fills the air</line> 
			<line /> 
			<line lrc_timestamp="[02:40.56]" milliseconds="160560">And everyone is singing</line> 
			<line lrc_timestamp="[02:43.44]" milliseconds="163440">I hear those sleigh bells ringing</line> 
			<line lrc_timestamp="[02:46.17]" milliseconds="166170">Santa won't you bring me</line> 
			<line lrc_timestamp="[02:47.74]" milliseconds="167740">The one I really need</line> 
			<line lrc_timestamp="[02:49.20]" milliseconds="169200">Won't you please bring my baby to me quickly</line> 
			<line /> 
			<line lrc_timestamp="[02:52.68]" milliseconds="172680">I don't want a lot for Christmas</line> 
			<line lrc_timestamp="[02:55.80]" milliseconds="175800">This is all I'm asking for</line> 
			<line lrc_timestamp="[02:58.92]" milliseconds="178920">I just wanna see my baby</line> 
			<line lrc_timestamp="[03:02.13]" milliseconds="182130">Standing right outside my door</line> 
			<line /> 
			<line lrc_timestamp="[03:05.32]" milliseconds="185320">I just want you for my own</line> 
			<line lrc_timestamp="[03:08.50]" milliseconds="188500">More than you could ever know</line> 
			<line lrc_timestamp="[03:11.71]" milliseconds="191710">Make my wish come true</line> 
			<line lrc_timestamp="[03:14.53]" milliseconds="194530">Baby all I want for Christmas is you</line> 
			<line /> 
			<line lrc_timestamp="[03:28.01]" milliseconds="208010">All I want for Christmas is you, baby</line> 
		</lrc> 
		<link>http://www.songfreaks.com/all-i-want-for-christmas-is-you-lyrics-mariah-carey</link> 
		<lyrics>I don't want a lot for Christmas
			There is just one thing I need I don't care about the presents
			Underneath the Christmas tree I just want you for my own
			More than you could ever know Make my wish come true oh
			All I want for Christmas is you I don't want a lot for Christmas
			There is just one thing I need, and I Don't care about the presents
			Underneath the Christmas tree I don't need to hang my stocking
			There upon the fireplace Santa Claus won't make me happy
			With a toy on Christmas day I just want you for my own
			More than you could ever know Make my wish come true
			All I want for Christmas is you I won't ask for much this Christmas
			I won't even wish for snow, and I I just wanna keep on waiting
			Underneath the mistletoe I won't make a list and send it
			To the North Pole for Saint Nick I won't even stay awake
			To hear those magic reindeer click 'cause I just want you here tonight
			Holding on to me so tight What more can I do
			Oh, Baby all I want for Christmas is you All the lights are shining
			So brightly everywhere And the sound of children's
			Laughter fills the air And everyone is singing
			I hear those sleigh bells ringing Santa won't you bring me
			The one I really need Won't you please bring my baby to me quickly
			I don't want a lot for Christmas This is all I'm asking for
			I just wanna see my baby Standing right outside my door
			I just want you for my own More than you could ever know
			Make my wish come true Baby all I want for Christmas is you
			All I want for Christmas is you, baby</lyrics> 
		<copyright>Lyrics © Universal Music Publishing Group</copyright> 
		<writer>CAREY, MARIAH / AFANASIEFF, WALTER N.</writer> 
		<submittedlyric>false</submittedlyric> 
		<foxmobile available="false" /> 
	</track> 
	<videos> 
		<video youtubeid="yXQViqx6GMY" duration="236" thumbnail="http://i.ytimg.com/vi/yXQViqx6GMY/mqdefault.jpg"> 
			<title>Mariah Carey - All I Want For Christmas Is You</title> 
			<description>Music video by Mariah Carey performing All I Want For Christmas Is You. YouTube view counts pre-VEVO: 61153 (C) 1994 SONY BMG MUSIC ENTERTAINMENT.</description> 
		</video> 
		<video youtubeid="1wYUxyX4Ifc" duration="249" thumbnail="http://i.ytimg.com/vi/1wYUxyX4Ifc/mqdefault.jpg"> 
			<title>Mariah Carey - All I Want For Christmas Is You at Rockfeller Center 2013</title> 
			<description /> 
		</video> 
		<video youtubeid="fGFNmEOntFA" duration="254" thumbnail="http://i.ytimg.com/vi/fGFNmEOntFA/mqdefault.jpg"> 
			<title>All I Want For Christmas Is You (SuperFestive!) (Shazam V...</title> 
			<description>Justin Bieber Duet with Mariah Carey - All I Want For Christmas Is You (SuperFestive!) (Shazam Version) © 2011 The Island Def Jam Music Group.</description> 
		</video> 
		<video youtubeid="Bd0aFaU7zO8" duration="267" thumbnail="http://i.ytimg.com/vi/Bd0aFaU7zO8/mqdefault.jpg"> 
			<title>Mariah Carey &amp; Michael Bublé - All I Want For Christmas Is You (Christmas Special 2013)</title> 
			<description>Mariah Carey &amp; Michael Bublé perform All I Want For Christmas Is You on 'Michael Buble's 3rd Annual Christmas Special' - December 18th, 2013.</description> 
		</video> 
		<video youtubeid="YWXPX3rKFHI" duration="208" thumbnail="http://i.ytimg.com/vi/YWXPX3rKFHI/mqdefault.jpg"> 
			<title>"All I Want For Christmas Is You"-Mariah Carey/"Last Christmas"Mashup By Amber And Yoanna</title> 
			<description>Yoanna孫尤安Fan Page ♥: https://www.facebook.com/Yoanna.Sun1 ♥ Amber安柏兒Fan Page ♥: https://www.facebook.com/HsinHuiYoAmber ♥ CANNA Fan Page ♥ : https://www....</description> 
		</video> 
		<video youtubeid="AFvRf8PfpKw" duration="287" thumbnail="http://i.ytimg.com/vi/AFvRf8PfpKw/mqdefault.jpg"> 
			<title>Mariah Carey: All I Want For Christmas Is You (Duet with Michael Bublé)</title> 
			<description>Watch videos of Mariah performing "All I Want For Christmas Is You" (duet with Michael Bublé) and "Christmas Time Is In The Air Again" on the Michael Bublé's...</description> 
		</video> 
		<video youtubeid="gZCX4sNya3o" duration="296" thumbnail="http://i.ytimg.com/vi/gZCX4sNya3o/mqdefault.jpg"> 
			<title>Mariah Carey (All I Want for Christmas Is You)  NCT Lighting 2013 UNDUBBED</title> 
			<description>Mariah performing her Christmas Classic Live in DC!</description> 
		</video> 
		<video youtubeid="InYvRyX2Fu4" duration="182" thumbnail="http://i.ytimg.com/vi/InYvRyX2Fu4/mqdefault.jpg"> 
			<title>Mariah Carey - All I Want For Christmas Is You (Chatroulette Version)</title> 
			<description>Music by Mariah Carey Video created by Steve Kardynal http://www.facebook.com/SteveKardynalfans.</description> 
		</video> 
		<video youtubeid="ckbV7H2Gn4s" duration="303" thumbnail="http://i.ytimg.com/vi/ckbV7H2Gn4s/mqdefault.jpg"> 
			<title>Mariah Carey - 'All I Want For Christmas Is You' [Christmas in Rockefeller Center 2012]</title> 
			<description>Mariah Carey performing 'All I Want For Christmas Is You' live at Christmas in Rockefeller Center 2012.</description> 
		</video> 
	</videos> 
	<comments totalresults="2" totalpages="1"> 
		<comment id="2523" date="2013-12-24 08:32:36.000-0500" deleted="false" likes="0" dislikes="0"> 
			<user id="20153" displayname="lillyelly" avatar="https://s3.amazonaws.com/Songfreaks/profile_images/SFBieberAvatar.jpg" badgescore="60" /> 
			<userrating value="0" /> 
			<content contenttype="TRACK" contentid="3921858" /> 
			<message>haha great !</message> 
			<replies /> 
		</comment> 
		<comment id="369" date="2012-12-15 17:12:12.000-0500" deleted="false" likes="0" dislikes="0"> 
			<user id="4215" displayname="iysh2003@hotmail.co.uk" avatar="https://s3.amazonaws.com/Songfreaks/profile_images/SFBurnsAvatar.jpg" badgescore="60" /> 
			<userrating value="0" /> 
			<content contenttype="TRACK" contentid="3921858" /> 
			<message>brilliant spectacular oh my god just get in the christmas spirit</message> 
			<replies /> 
		</comment> 
	</comments> 
	</songfreaks>

### Getting an album

http://apiv2.songfreaks.com//album.do?

	POST //album.do? HTTP/1.1
	Host: apiv2.songfreaks.com
	Accept-Encoding: gzip
	Content-Type: application/x-www-form-urlencoded; charset=utf-8
	Content-Length: 110
	Connection: close
	Cookie: JSESSIONID=9918536DEDFB4EA2ECF56A1E4D5277EF
	User-Agent: SongFreaks 2.1.1 (iPad; iPhone OS 7.0.4; en_US)
	
	apikey=6c7a95aa8238f3b437b1db24e644c2ee&comments=true&appname=sf_iphone&sfid=210957&version=2.1.1&territory=US

Response:

	<songfreaks> 
	<response code="100" renderTime="0.0080">SUCCESS</response> 
	<album id="210957" amg="817740" urlslug="six-demon-bag-album-man-man" year="2006" image="http://www.lyricfind.com/images/amg/cov75/drh200/h222/h22212m6var.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/drh200/h222/h22212m6var.jpg"> 
		<title>Six Demon Bag</title> 
		<rating averagerating="0.0" userrating="0" totalratings="0" /> 
		<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" genre="Rock" urlslug="man-man"> 
			<name>Man Man</name> 
			<link>http://www.songfreaks.com/man-man</link> 
		</artist> 
		<link>http://www.songfreaks.com/six-demon-bag-album-man-man</link> 
		<tracks> 
			<track id="1445993" track_group_id="4382523" urlslug="feathers-lyrics-man-man" amg="8686311" instrumental="false" viewable="true" duration="2:08" lyric="228525" has_lrc="false" tracknumber="1" discnumber="1"> 
				<title>Feathers</title> 
				<link>http://www.songfreaks.com/feathers-lyrics-man-man</link> 
			</track> 
			<track id="1445994" track_group_id="4382524" urlslug="engrish-bwudd-lyrics-man-man" amg="8686312" instrumental="false" viewable="true" duration="3:33" lyric="228526" has_lrc="false" tracknumber="2" discnumber="1"> 
				<title>Engrish Bwudd</title> 
				<link>http://www.songfreaks.com/engrish-bwudd-lyrics-man-man</link> 
			</track> 
			<track id="1445995" track_group_id="4382525" urlslug="banana-ghost-lyrics-man-man" amg="8686313" instrumental="false" viewable="true" duration="2:54" lyric="228527" has_lrc="false" tracknumber="3" discnumber="1"> 
				<title>Banana Ghost</title> 
				<link>http://www.songfreaks.com/banana-ghost-lyrics-man-man</link> 
			</track> 
			<track id="5029419" track_group_id="1957466" urlslug="young-einsetin-on-the-beach-lyrics-man-man" amg="8686314" instrumental="false" viewable="false" duration=":58" lyric="0" has_lrc="false" tracknumber="4" discnumber="1"> 
				<title>Young Einsetin on the Beach</title> 
				<link>http://www.songfreaks.com/young-einsetin-on-the-beach-lyrics-man-man</link> 
			</track> 
			<track id="1445996" track_group_id="4382526" urlslug="skin-tension-lyrics-man-man" amg="8686315" instrumental="false" viewable="true" duration="3:46" lyric="228528" has_lrc="false" tracknumber="5" discnumber="1"> 
				<title>Skin Tension</title> 
				<link>http://www.songfreaks.com/skin-tension-lyrics-man-man</link> 
			</track> 
			<track id="5029420" track_group_id="1957467" urlslug="black-mission-goggles-lyrics-man-man" amg="8686316" instrumental="false" viewable="false" duration="4:59" lyric="0" has_lrc="false" tracknumber="6" discnumber="1"> 
				<title>Black Mission Goggles</title> 
				<link>http://www.songfreaks.com/black-mission-goggles-lyrics-man-man</link> 
			</track> 
			<track id="5029421" track_group_id="1957468" urlslug="hot-bat-lyrics-man-man" amg="8686317" instrumental="false" viewable="false" duration="1:26" lyric="0" has_lrc="false" tracknumber="7" discnumber="1"> 
				<title>Hot Bat</title> 
				<link>http://www.songfreaks.com/hot-bat-lyrics-man-man</link> 
			</track> 
			<track id="1445997" track_group_id="4382527" urlslug="push-the-eagles-stomach-lyrics-man-man" amg="8686318" instrumental="false" viewable="true" duration="3:39" lyric="228529" has_lrc="false" tracknumber="8" discnumber="1"> 
				<title>Push the Eagles Stomach</title> 
				<link>http://www.songfreaks.com/push-the-eagles-stomach-lyrics-man-man</link> 
			</track> 
			<track id="5029422" track_group_id="1957469" urlslug="spider-cider-lyrics-man-man" amg="8686319" instrumental="false" viewable="false" duration="3:05" lyric="0" has_lrc="false" tracknumber="9" discnumber="1"> 
				<title>Spider  Cider</title> 
				<link>http://www.songfreaks.com/spider-cider-lyrics-man-man</link> 
			</track> 
			<track id="5029423" track_group_id="1957470" urlslug="van-helsing-boom-box-lyrics-man-man" amg="8686320" instrumental="false" viewable="false" duration="3:44" lyric="0" has_lrc="false" tracknumber="10" discnumber="1"> 
				<title>Van Helsing Boom Box</title> 
				<link>http://www.songfreaks.com/van-helsing-boom-box-lyrics-man-man</link> 
			</track> 
			<track id="5029424" track_group_id="1957471" urlslug="tunneling-through-the-guy-lyrics-man-man" amg="8686321" instrumental="false" viewable="false" duration="5:25" lyric="0" has_lrc="false" tracknumber="11" discnumber="1"> 
				<title>Tunneling Through the Guy</title> 
				<link>http://www.songfreaks.com/tunneling-through-the-guy-lyrics-man-man</link> 
			</track> 
			<track id="5029425" track_group_id="1957472" urlslug="fishstick-gumbo-lyrics-man-man" amg="8686322" instrumental="false" viewable="false" duration=":04" lyric="0" has_lrc="false" tracknumber="12" discnumber="1"> 
				<title>Fishstick Gumbo</title> 
				<link>http://www.songfreaks.com/fishstick-gumbo-lyrics-man-man</link> 
			</track> 
			<track id="1445998" track_group_id="4382528" urlslug="ice-dogs-lyrics-man-man" amg="8686323" instrumental="false" viewable="true" duration="4:45" lyric="228530" has_lrc="false" tracknumber="13" discnumber="1"> 
				<title>Ice Dogs</title> 
				<link>http://www.songfreaks.com/ice-dogs-lyrics-man-man</link> 
			</track> 
		</tracks> 
		<review author="Bret Love">Subjects of huge buzz at South by Southwest 2005 for their circus-of-insanity live show, Philly's &lt;b&gt;Man Man&lt;/b&gt; comes across like &lt;b&gt;Tom Waits&lt;/b&gt; and &lt;b&gt;Captain Beefheart&lt;/b&gt; collaborating on a klezmer-influenced soundtrack to your scariest nightmare about killer clowns. The stripped-down opening track on their sophomore LP, &lt;b&gt;"Feathers,"&lt;/b&gt; almost borders on accessible, with a simple waltz-time saloon piano and multi-tracked vocals that sound about one whiskey shy of a drunken sea shanty. But by the time you get to track two, &lt;b&gt;"Engrish Bwudd,"&lt;/b&gt; the band has clearly given in to the temptation of overindulgence, with the whoops, wails, hollers, and growls of a musical madman singing "fee, fi, fo, fum" complemented by falsetto counterparts squealing "I smell the blood of an Englishman." It only gets weirder from there, with all manner of unusual instruments, discordant cacophony, and outlandish shrieking that'd make &lt;b&gt;the Boredoms&lt;/b&gt; sit up and take notice, and please-quiet-the-voices-in-my-head psychotic freak-outs all finding their place in &lt;b&gt;Man Man&lt;/b&gt;'s alternate universe musical reality. Most of this stuff is just too damn weird for all but the most experimental music listener, but when the band reigns in its more outlandish tendencies on tunes like the almost poetic &lt;b&gt;"Skin Tension"&lt;/b&gt; and the chugging &lt;b&gt;"Black Mission Goggles,"&lt;/b&gt; you get the sense there are some fine songwriters lurking beneath all the kitchen-sink craziness.</review> 
	</album> 
	<comments totalresults="0" totalpages="0" /> 
	</songfreaks>

### Getting an artist

	POST //artist.do? HTTP/1.1
	Host: apiv2.songfreaks.com
	Accept-Encoding: gzip
	Content-Type: application/x-www-form-urlencoded; charset=utf-8
	Content-Length: 109
	Connection: close
	Cookie: JSESSIONID=DB0AB3B481585EBC2C6BB953B6BC5B9E
	User-Agent: SongFreaks 2.1.1 (iPad; iPhone OS 7.0.4; en_US)
	
	apikey=6c7a95aa8238f3b437b1db24e644c2ee&comments=true&appname=sf_iphone&sfid=32622&version=2.1.1&territory=US

Response: 

	<songfreaks> 
	<response code="100" renderTime="0.0090">SUCCESS</response> 
	<artist amg="281403" id="32622" image="http://www.lyricfind.com/images/amg/pic200/drq000/q084/q08457inu2g.jpg" genre="Rap" urlslug="pharrell-williams"> 
		<name>Pharrell Williams</name> 
		<rating averagerating="3.6" userrating="0" totalratings="5" /> 
		<link>http://www.songfreaks.com/pharrell-williams</link> 
		<bio author="Andy Kellman">&lt;b&gt;Pharrell Williams&lt;/b&gt; didn't only help change the face of pop music during the late '90s and early 2000s. He also &lt;I&gt;was&lt;/I&gt; one of the faces of pop music -- as a charismatic star who often stole the show when producing and/or guesting on other artists' hit singles. His presence was unfading, whether he was in front of a music video or behind a beat. To trace the beginning of his ascent, you have to go back to 1992, when &lt;b&gt;Teddy Riley&lt;/b&gt; tapped him to write a verse for &lt;b&gt;Wreckx-n-Effect&lt;/b&gt;'s &lt;b&gt;"Rump Shaker."&lt;/b&gt; Since the late '90s, &lt;b&gt;Williams&lt;/b&gt; and longtime friend &lt;b&gt;Chad Hugo&lt;/b&gt; -- known together as &lt;b&gt;the Neptunes&lt;/b&gt; -- began scoring songwriting and production assignments that slowly but steadily infiltrated mainstream music, whether it was via dance-pop (&lt;b&gt;Britney Spears&lt;/b&gt;' &lt;b&gt;"I'm a Slave 4 U"&lt;/b&gt;), hardcore rap (&lt;b&gt;Clipse&lt;/b&gt;'s &lt;b&gt;"Grindin'"&lt;/b&gt;), or contemporary R&amp;B (&lt;b&gt;Babyface&lt;/b&gt;'s &lt;b&gt;"There She Goes"&lt;/b&gt;). &lt;b&gt;Williams&lt;/b&gt; and &lt;b&gt;Hugo&lt;/b&gt; were relatively obscure during the mid-'90s, doing spare work for the likes of &lt;b&gt;SWV&lt;/b&gt;, &lt;b&gt;Total&lt;/b&gt;, and &lt;b&gt;Mase&lt;/b&gt;, but they would eventually develop a style that would become as recognized and as mimicked as that of fellow Virginia Beach native &lt;b&gt;Timbaland&lt;/b&gt;. (Prior to stardom, all three producers were in a band together called &lt;b&gt;Surrounded by Idiots&lt;/b&gt;.) &#xD;
			As the duo took on more work, &lt;b&gt;Williams&lt;/b&gt;' voice became increasingly familiar. He was now more likely to provide the chorus and the background vocals of the same song, in addition to appearing in the video. (Hear/see &lt;b&gt;Jay-Z&lt;/b&gt;'s &lt;b&gt;"Excuse Me Miss"&lt;/b&gt; and &lt;b&gt;Snoop Dogg&lt;/b&gt;'s &lt;b&gt;"Beautiful"&lt;/b&gt; for two examples.) It wasn't until the summer of 2003 that he truly stepped out on his own. He released his first solo single, &lt;b&gt;"Frontin'."&lt;/b&gt; Produced with &lt;b&gt;Hugo&lt;/b&gt; and featuring a guest verse from &lt;b&gt;Jay-Z&lt;/b&gt;, the song built anticipation for The Neptunes Present... Clones, a compilation of all-new tracks from artists produced by the duo. &lt;b&gt;"Frontin'"&lt;/b&gt; was a ubiquitous summer hit and kept &lt;b&gt;Williams&lt;/b&gt;' momentum running up to the release of &lt;b&gt;Hugo&lt;/b&gt; and &lt;b&gt;Williams&lt;/b&gt;' second funk/rock-oriented &lt;b&gt;N.E.R.D.&lt;/b&gt; album, released in March 2004. &lt;b&gt;Williams&lt;/b&gt;' first solo album, In My Mind, survived a number of delays and was finally issued in July 2006.</bio> 
	</artist> 
	<comments totalresults="2" totalpages="1"> 
		<comment id="1530" date="2013-08-17 09:01:09.000-0400" deleted="false" likes="0" dislikes="0"> 
			<user id="25332" displayname="huny ®" avatar="https://s3.amazonaws.com/Songfreaks/profile_images/SFMadonnaAvatar.jpg" badgescore="60" /> 
			<userrating value="0" /> 
			<content contenttype="ARTIST" contentid="32622" /> 
			<message>So cute! look similiar like my love ð</message> 
			<replies /> 
		</comment> 
		<comment id="1088" date="2013-06-29 03:33:53.000-0400" deleted="false" likes="0" dislikes="0"> 
			<user id="18290" displayname="SkylarRenee17" avatar="https://s3.amazonaws.com/Songfreaks/profile_images/SFGagaAvatar.jpg" badgescore="60" /> 
			<userrating value="0" /> 
			<content contenttype="ARTIST" contentid="32622" /> 
			<message>Cute as hell:)&lt;3</message> 
			<replies /> 
		</comment> 
	</comments> 
	<artistblogs> 
		<artistblog id="22382" author="muzikat" url="http://muzikat.org/2013/05/24/happy-pharrell-williams/" trackback="http://muzikat.org/2013/05/24/happy-pharrell-williams/trackback/" title="Happy  &lt;b&gt;Pharrell Williams&lt;/b&gt; | Muzikat Electro Sounds" description="After a wonderful feat with the French Daft Punk, &lt;em&gt;Pharrell Williams&lt;/em&gt; will once again work with some frenchy studio for the original soundtrack of Despicable Me or Moi, Moche et Mchant. Enjoy this hip hop and swigging song full of sun ! Share this: Share. Facebook &amp;middot; Twitter &amp;middot; Google +1. Like this: Like Loading... Categories Hip hop, Lounge, Pop. No comments Post your own or leave a &lt;em&gt;trackback&lt;/em&gt;: &lt;em&gt;Trackback&lt;/em&gt; URL &lt;b&gt;...&lt;/b&gt;" date="2013-05-24 04:20:11.000-0400" activestatus="1" /> 
		<artistblog id="22379" author="premiere" url="http://www.lyricspremiere.com/pharrell-williams-happy-lyrics.html" trackback="http://www.lyricspremiere.com/pharrell-williams-happy-lyrics.html/trackback" title="&lt;b&gt;Pharrell Williams&lt;/b&gt;  Happy Lyrics" description="I&amp;#39;m a hot air balloon that could go to space / With the air, like I don&amp;#39;t care baby by the way / Chorus: / Because I&amp;#39;m happy / Clap along if you feel like a room without a roof / Because I&amp;#39;m happy / Clap along if you feel like happiness is the truth &lt;b&gt;...&lt;/b&gt;" date="2013-05-21 19:21:24.000-0400" activestatus="1" /> 
		<artistblog id="22380" author="Clutronica" url="http://www.csnowheaties.com/2013/05/21/pharrell-williams-happy/" trackback="http://www.csnowheaties.com/2013/05/21/pharrell-williams-happy/trackback/" title="&lt;b&gt;Pharrell Williams&lt;/b&gt;  Happy | CSNW" description="&lt;em&gt;Pharrell Williams&lt;/em&gt;  Happy. May 21st, 2013 | Posted by Clutronica in Singles &amp;middot; 20130520-me2-x600-1369082810. Not to be confused with N*E*R*D&amp;#39;s song of the same name, Pharrell sets the scene for second time for the kids film, Despicable Me 2. This time only focusing on the movie&amp;#39;s soundtrack instead of the score and the OST. &lt;b&gt;...&lt;/b&gt; Print &amp;middot; Pin It &amp;middot; Email &amp;middot; &lt;em&gt;Pharrell Williams&lt;/em&gt;. You can follow any responses to this entry through the RSS 2.0 You can leave a response, or &lt;em&gt;trackback&lt;/em&gt;." date="2013-05-21 15:55:17.000-0400" activestatus="1" /> 
		<artistblog id="22381" author="INPAQ" url="http://x-inpaq-x.com/inpaq/2013/5/21/pharrell-williams-happy-track.html" trackback="http://x-inpaq-x.com/inpaq/trackback/33738592" title="&lt;b&gt;PHARRELL WILLIAMS&lt;/b&gt;: Happy (Track) - INPAQ - Official Site &lt;b&gt;...&lt;/b&gt;" description="&lt;em&gt;PHARRELL WILLIAMS&lt;/em&gt;: Happy (Track). Date Tuesday, May 21, 2013 at 2:00PM &lt;b&gt;...&lt;/b&gt; You can either use the [&lt;em&gt;Trackback&lt;/em&gt; URL] for this entry, or link to your response directly. I want to leave a comment directly on this site . Article Title: Article URL: &lt;b&gt;...&lt;/b&gt;" date="2013-05-21 14:00:00.000-0400" activestatus="1" /> 
		<artistblog id="20586" author="l3gaci" url="http://l3gaci.com/2013/05/16/pharrell-williams-is-joining-rihanna-produced-reality-tv-show/" trackback="http://l3gaci.com/xmlrpc.php" title="&lt;b&gt;Pharrell Williams&lt;/b&gt; Is Joining Rihanna-Produced Reality TV Show &lt;b&gt;...&lt;/b&gt;" description="Reblogged from AllHipHop.com: (AllHipHop News) Fashion conscious producer-performer &lt;em&gt;Pharrell Williams&lt;/em&gt; is joining the team at the new Styled To Rock competition show on Style Network. According to the Hollywood Reporter, the &lt;b&gt;...&lt;/b&gt;" date="2013-05-16 11:15:31.000-0400" activestatus="1" /> 
		<artistblog id="22383" author="Mark" url="http://themenagerieofthings.wordpress.com/2013/05/16/daft-punk-random-access-memories-review/" trackback="http://themenagerieofthings.wordpress.com/xmlrpc.php" title="Daft Punk  Random Access Memories Review | The Menagerie Of &lt;b&gt;...&lt;/b&gt;" description="&lt;em&gt;Pharrell Williams&lt;/em&gt; kicks off with some sub-woofer shaking bass and a funky Chic-esq guitar over the top before Pharrell begins to sing. The song itself is a slow, &lt;b&gt;...&lt;/b&gt; &lt;em&gt;Pingback&lt;/em&gt;: Daft Punk  Random Access Memories  I FOUND MUSIC. &lt;em&gt;Pingback&lt;/em&gt;: &lt;b&gt;...&lt;/b&gt;" date="2013-05-16 09:54:48.000-0400" activestatus="1" /> 
		<artistblog id="20583" author="OdECk" url="http://www.ipauta.com/daft-punk-ft-pharrell-williams-pitbull-get-lucky/" trackback="http://www.ipauta.com/daft-punk-ft-pharrell-williams-pitbull-get-lucky/trackback/" title="Daft Punk Ft. &lt;b&gt;Pharrell Williams&lt;/b&gt; &amp;amp; Pitbull - Get Lucky | IPAUTA.COM &lt;b&gt;...&lt;/b&gt;" description="Daft Punk Ft. &lt;em&gt;Pharrell Williams&lt;/em&gt; &amp;amp; Pitbull  Get Lucky &amp;middot; OdECk | May 16, 2013 | Comments 0. Descargar/Bajar: Daft Punk Ft. &lt;em&gt;Pharrell Williams&lt;/em&gt; &amp;amp; Pitbull  Get Lucky. descargaripauta &amp;middot; Tweet &lt;b&gt;...&lt;/b&gt;" date="2013-05-16 00:22:47.000-0400" activestatus="1" /> 
		<artistblog id="20582" author="Todd 'ToddStar' Jolicoeur" url="http://magazine.100percentrock.com/news/articles/201305/15738" trackback="http://magazine.100percentrock.com/news/articles/201305/15738/trackback" title="&lt;b&gt;Pharrell Williams&lt;/b&gt; Joins Rihanna&amp;#39;s STYLED TO ROCK | 100% ROCK &lt;b&gt;...&lt;/b&gt;" description="LOS ANGELESMay 15, 2013Style Media announced today that multi-Grammy Award winner and fashion designer &lt;em&gt;Pharrell Williams&lt;/em&gt; will serve as one of the mentors on Styled to Rock, the new reality competition series from executive &lt;b&gt;...&lt;/b&gt;" date="2013-05-15 14:35:46.000-0400" activestatus="1" /> 
		<artistblog id="20584" author="Zell" url="http://www.onethrone.us/video-robin-thicke-pharrell-williams-t-i-perform-blurred-lines-on-the-voice/" trackback="http://www.onethrone.us/xmlrpc.php" title="[Video] Robin Thicke, &lt;b&gt;Pharrell Williams&lt;/b&gt;, &amp;amp; T.I. Perform - One Throne" description="[Video] Robin Thicke, &lt;em&gt;Pharrell Williams&lt;/em&gt;, &amp;amp; T.I. Perform Blurred Lines on The Voice &lt;b&gt;...&lt;/b&gt; Robin-Thicke-Blurred-Lines-Ft-TI-Pharrell &lt;b&gt;...&lt;/b&gt; 2 comments on [Music Video] Tyler, The Creator  IFHY. &lt;em&gt;Pingback&lt;/em&gt;: One Throne. &lt;em&gt;Pingback&lt;/em&gt;: One Throne &lt;b&gt;...&lt;/b&gt;" date="2013-05-15 12:40:54.000-0400" activestatus="1" /> 
		<artistblog id="20587" author="LJ" url="http://www.remix-nation.com/daft-punk-random-access-memories-live-stream-now-available/" trackback="http://www.remix-nation.com/xmlrpc.php" title="Daft Punk  Random Access Memories Live Stream Now Available &lt;b&gt;...&lt;/b&gt;" description="And rightfully so, as the French duo has teamed up with talent from all genres, including Nile Rogers, &lt;em&gt;Pharrell Williams&lt;/em&gt;, Todd Edwards, Julian Casablancas, Giorgio Moroder, and Animal Collective&amp;#39;s Panda Bear, to create an innovative 13 track dance music experience. The new album adopted a more classic and fundamental &lt;b&gt;...&lt;/b&gt; Daft Punk  Random Access Memories Live Stream Now Available. &lt;em&gt;Pingback&lt;/em&gt;: An Initial Thought on Daft Punk&amp;#39;s Random Access Memories | Remix Nation &lt;b&gt;...&lt;/b&gt;" date="2013-05-13 19:12:42.000-0400" activestatus="1" /> 
		<artistblog id="18619" author="WeMbZ" url="http://ratedtunes.wordpress.com/2013/05/09/daft-punk-get-lucky-ft-pharrell-williams/" trackback="http://ratedtunes.wordpress.com/2013/05/09/daft-punk-get-lucky-ft-pharrell-williams/trackback/" title="Daft Punk  Get Lucky ft. &lt;b&gt;Pharrell Williams&lt;/b&gt; | Rate The Tune" description="Looks like the legends just wont go away, here is Daft Punks number one hit single Get lucky featuring &lt;em&gt;Pharrell Williams&lt;/em&gt;. The song is the ultimate chill out song &lt;b&gt;...&lt;/b&gt; Comments (0) &lt;em&gt;Trackbacks&lt;/em&gt; (0) Leave a comment &lt;em&gt;Trackback&lt;/em&gt;. No comments yet." date="2013-05-09 18:49:44.000-0400" activestatus="1" /> 
		<artistblog id="22384" author="Kayjosh" url="http://kayjosh.com/2013/05/photos-pharrell-williams-fiancee-exposes-a-breast-as-she-trips/" trackback="http://kayjosh.com/2013/05/photos-pharrell-williams-fiancee-exposes-a-breast-as-she-trips/trackback/" title="PHOTOS: &lt;b&gt;Pharrell Williams&lt;/b&gt;&amp;#39; Fiance Exposes A Breast As She Trips &lt;b&gt;...&lt;/b&gt;" description="But &lt;em&gt;Pharrell Williams&lt;/em&gt;&amp;#39; fiancee would have no doubt been left feeling more than a little red-faced on account of her somewhat ungraceful exit from the 2013 Met Ball on Monday night. Accompanying her rapper beau to the star-studded event at New York City&amp;#39;s Metropolitan Museum of Art, the model and &lt;b&gt;...&lt;/b&gt; 1 Reply; 1 Comment; 0 Tweets; 0 Facebook; 0 &lt;em&gt;Pingbacks&lt;/em&gt;. Last reply was 6 days ago. Fake Oakleys. View 6 days ago. I am sure this piece of writing has touched all the internet users, &lt;b&gt;...&lt;/b&gt;" date="2013-05-08 07:07:06.000-0400" activestatus="1" /> 
		<artistblog id="18620" author="Cee L R" url="http://theoriginalgreenwichdiva.com/met-gala-2013-pharrell-williams-fiancee-helen-lasichanh-exposes-a-breast-as-she-trips-over-on-her-stiletto/44605/" trackback="http://Theoriginalgreenwichdiva.com/met-gala-2013-pharrell-williams-fiancee-helen-lasichanh-exposes-a-breast-as-she-trips-over-on-her-stiletto/44605/trackback/" title="Met Gala 2013: &lt;b&gt;Pharrell Williams&lt;/b&gt;&amp;#39; fiance Helen Lasichanh exposes &lt;b&gt;...&lt;/b&gt;" description="&lt;em&gt;Pharrell Williams&lt;/em&gt;&amp;#39; fiance, Helen Lasichanh, suffered a major wardrobe malfunction at the Metropolitan Museum of Art Ball Monday night while leaving the very formal event. The model was &lt;b&gt;...&lt;/b&gt; Follow-up comment rss or Leave a &lt;em&gt;Trackback&lt;/em&gt; &lt;b&gt;...&lt;/b&gt;" date="2013-05-07 12:32:30.000-0400" activestatus="1" /> 
		<artistblog id="17804" author="MC Winkel" url="http://www.whudat.de/daft-punk-ft-pharrell-williams-get-lucky-original-george-barnett-cover-shredder-version-metal-hardcore-version/" trackback="http://www.whudat.de/daft-punk-ft-pharrell-williams-get-lucky-original-george-barnett-cover-shredder-version-metal-hardcore-version/trackback/" title="Daft Punk ft. &lt;b&gt;Pharrell Williams&lt;/b&gt;  Get Lucky  Original + George &lt;b&gt;...&lt;/b&gt;" description="Daft Punk ft. &lt;em&gt;Pharrell Williams&lt;/em&gt;  Get Lucky  Original + George Barnett Cover + Shredder Version + Metal Version &lt;b&gt;...&lt;/b&gt; Skateboarding: ICECREAM in Chi-Town and Miami w/ &lt;em&gt;Pharrell Williams&lt;/em&gt; (Clip) &lt;b&gt;...&lt;/b&gt; Sag was oder setz einen &lt;em&gt;Trackback&lt;/em&gt;." date="2013-05-06 06:32:24.000-0400" activestatus="1" /> 
		<artistblog id="20585" author="irek" url="http://beatkingdom.org/twerkit-busta-rhymes-prod-pharrell-williams" trackback="http://beatkingdom.org/xmlrpc.php" title="TwerkIt Busta Rhymes Prod -&lt;b&gt;Pharrell Williams&lt;/b&gt; - Hip Hop Producers &lt;b&gt;...&lt;/b&gt;" description="YMCMB/Cash Money/The Conglomerate alongside Producer &lt;em&gt;Pharrell Williams&lt;/em&gt; lace up twerkit for Busta Rhymes with this fresh released single. &lt;b&gt;...&lt;/b&gt; Prod -&lt;em&gt;Pharrell Williams&lt;/em&gt; dlytens christian louboutin men. &lt;em&gt;Pingback&lt;/em&gt;: cheap Oakley Sunglasses &lt;b&gt;...&lt;/b&gt;" date="2013-05-03 14:21:08.000-0400" activestatus="1" /> 
		<artistblog id="17044" author="Dev Gillespie (DG)" url="http://djsdoingwork.com/2013/05/03/new-music-twerk-it-busta-rhymes-x-produced-by-pharrell-williams-audio-inside/" trackback="http://djsdoingwork.com/2013/05/03/new-music-twerk-it-busta-rhymes-x-produced-by-pharrell-williams-audio-inside/trackback/" title="New Music: Twerk It  Busta Rhymes x Produced by &lt;b&gt;Pharrell&lt;/b&gt; &lt;b&gt;...&lt;/b&gt;" description="New Music: Twerk It  Busta Rhymes x Produced by &lt;em&gt;Pharrell Williams&lt;/em&gt; (Audio Inside) &lt;b&gt;...&lt;/b&gt; Of course, Busta rhymes over the sick Pharrell beat with ease. Check out the new &lt;b&gt;...&lt;/b&gt; No comments Post your own or leave a &lt;em&gt;trackback&lt;/em&gt;: &lt;em&gt;Trackback&lt;/em&gt; URL &lt;b&gt;...&lt;/b&gt;" date="2013-05-03 13:54:14.000-0400" activestatus="1" /> 
		<artistblog id="18198" author="whycauseican" url="http://whycauseican.com/2013/05/03/listen-busta-rhymes-twerk-it-prod-by-pharrell-twerkit/" trackback="http://whycauseican.com/xmlrpc.php" title="Listen: Busta Rhymes Twerk It (Prod. By &lt;b&gt;Pharrell&lt;/b&gt;) #Twerkit &lt;b&gt;...&lt;/b&gt;" description="By Pharrell) #Twerkit. by whycauseican on May 3, 2013. busta-rhymes-twerk-it-whycauseican. Busta Rhymes drops a new song titled, #Twerkit, which is produced by &lt;em&gt;Pharrell Williams&lt;/em&gt;. Seems like Busta is going for a new style and I&amp;#39;m not sure if it&amp;#39;s &lt;b&gt;...&lt;/b&gt; Trackbacks &amp;amp; &lt;em&gt;Pingbacks&lt;/em&gt;. Hot97 Summer Jam 2013 Line-Up Includes Kendrick Lamar, 2 Chainz, Miguel and MORE! | WhyCauseICan.com, music blog within the music industry that post current news, events and music &amp;middot; Listen: 2 Chainz &lt;b&gt;...&lt;/b&gt;" date="2013-05-03 01:53:11.000-0400" activestatus="1" /> 
		<artistblog id="17048" author="AK" url="http://hiphop-n-more.com/2013/05/busta-rhymes-twerk-it/" trackback="http://hiphop-n-more.com/xmlrpc.php" title="Busta Rhymes  &amp;#39;Twerk It&amp;#39; (CDQ) | HipHop-N-More" description="Busta Rhymes gives Flex the green light to drop his latest single which is produced by &lt;em&gt;Pharrell Williams&lt;/em&gt;. The sound is &lt;b&gt;...&lt;/b&gt; Busta Rhymes gives Flex the green light to drop his latest single which is produced by &lt;em&gt;Pharrell Williams&lt;/em&gt;. The sound is &lt;b&gt;...&lt;/b&gt;" date="2013-05-02 20:03:23.000-0400" activestatus="1" /> 
		<artistblog id="17045" author="mondoitalianews" url="http://www.mondoitalianews.com/miley-cyrus-talks-to-pharrell-williams-and-strips-off-for-mario-testino/" trackback="http://www.mondoitalianews.com/miley-cyrus-talks-to-pharrell-williams-and-strips-off-for-mario-testino/trackback/" title="miley cyrus talks to &lt;b&gt;pharrell williams&lt;/b&gt; and strips off for mario testino" description="Miley Cyrus has spent the past few years acting out and growing up, in the latest issue of V Magazine, she reveals all to &lt;em&gt;Pharrell&lt;/em&gt; Wiliams, the producer behind her new hip-hop sound and she strips off and looks amazing in the magazine&amp;#39;s photoshoot by Mario Testino. MILEY CYRUS V MAG4a. Where did you start? &lt;em&gt;Pharrell&lt;/em&gt; was the first person I wanted to &lt;b&gt;....&lt;/b&gt; Post a comment or leave a &lt;em&gt;trackback&lt;/em&gt;: &lt;em&gt;Trackback&lt;/em&gt; URL.  THE CYBORGS &amp;#39;ELECTRIC CHAIR&amp;#39;: Il NUOVO MANIFESTO DEL DUO &lt;b&gt;...&lt;/b&gt;" date="2013-05-01 17:43:32.000-0400" activestatus="1" /> 
		<artistblog id="17046" author="izquierdacasual" url="http://izquierdacasual.com/2013/05/01/daft-punk-get-lucky-feat-pharrell-williams/" trackback="http://izquierdacasual.com/2013/05/01/daft-punk-get-lucky-feat-pharrell-williams/trackback/" title="Daft Punk &lt;b&gt;Pharrell Williams&lt;/b&gt; SNL Ad | Izquierdacasual" description="Daft Punk &lt;em&gt;Pharrell Williams&lt;/em&gt; SNL Ad &amp;middot; 1 de mayo de 2013 //. 0. Tu voto: Share this: Twitter &amp;middot; Facebook. Me gusta: Me gusta Cargando... Categoras Msica, Videos. Sin comentarios Publicar tu entrada o dejar un &lt;em&gt;trackback&lt;/em&gt;: URL de &lt;em&gt;trackback&lt;/em&gt; &lt;b&gt;...&lt;/b&gt;" date="2013-05-01 05:28:49.000-0400" activestatus="1" /> 
	</artistblogs> 
	</songfreaks>

### Getting artists albums

	POST //artistalbums.do? HTTP/1.1
	Host: apiv2.songfreaks.com
	Accept-Encoding: gzip
	Content-Type: application/x-www-form-urlencoded; charset=utf-8
	Content-Length: 142
	Connection: close
	Cookie: JSESSIONID=DB0AB3B481585EBC2C6BB953B6BC5B9E
	User-Agent: SongFreaks 2.1.1 (iPad; iPhone OS 7.0.4; en_US)

	albumslimit=10&sfid=32622&appname=sf_iphone&listingtype=main&albumsoffset=0&territory=US&version=2.1.1&apikey=6c7a95aa8238f3b437b1db24e644c2ee

Response:

	<songfreaks> 
	<response code="100" renderTime="0.0040">SUCCESS</response> 
	<artistalbums totalresults="8" totalpages="1"> 
		<album id="362740" amg="2446159" urlslug="angel-album-pharrell-williams-1" year="2005" image="http://www.lyricfind.com/images/not_available_cov75.jpg" largeimage="http://www.lyricfind.com/images/not_available_cov200.jpg"> 
			<title>Angel</title> 
			<artist amg="281403" id="32622" image="http://www.lyricfind.com/images/amg/pic200/drq000/q084/q08457inu2g.jpg" urlslug="pharrell-williams"> 
				<name>Pharrell Williams</name> 
				<link>http://www.songfreaks.com/pharrell-williams</link> 
			</artist> 
			<link>http://www.songfreaks.com/angel-album-pharrell-williams-1</link> 
		</album> 
		<album id="217773" amg="807073" urlslug="in-my-mind-album-pharrell-williams" year="2006" image="http://www.lyricfind.com/images/amg/cov75/drh300/h387/h38796r9k0d.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/drh300/h387/h38796r9k0d.jpg"> 
			<title>In My Mind</title> 
			<artist amg="281403" id="32622" image="http://www.lyricfind.com/images/amg/pic200/drq000/q084/q08457inu2g.jpg" urlslug="pharrell-williams"> 
				<name>Pharrell Williams</name> 
				<link>http://www.songfreaks.com/pharrell-williams</link> 
			</artist> 
			<link>http://www.songfreaks.com/in-my-mind-album-pharrell-williams</link> 
		</album> 
		<album id="362924" amg="2446626" urlslug="number-one-album-pharrell-williams-1" year="2006" image="http://www.lyricfind.com/images/not_available_cov75.jpg" largeimage="http://www.lyricfind.com/images/not_available_cov200.jpg"> 
			<title>Number One</title> 
			<artist amg="281403" id="32622" image="http://www.lyricfind.com/images/amg/pic200/drq000/q084/q08457inu2g.jpg" urlslug="pharrell-williams"> 
				<name>Pharrell Williams</name> 
				<link>http://www.songfreaks.com/pharrell-williams</link> 
			</artist> 
			<link>http://www.songfreaks.com/number-one-album-pharrell-williams-1</link> 
		</album> 
		<album id="327712" amg="2054253" urlslug="the-billionaire-boys-club-tape-album-pharrell-williams" year="2010" image="http://www.lyricfind.com/images/amg/cov75/dro900/o955/o95580d0lim.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/dro900/o955/o95580d0lim.jpg"> 
			<title>The Billionaire Boys Club Tape</title> 
			<artist amg="281403" id="32622" image="http://www.lyricfind.com/images/amg/pic200/drq000/q084/q08457inu2g.jpg" urlslug="pharrell-williams"> 
				<name>Pharrell Williams</name> 
				<link>http://www.songfreaks.com/pharrell-williams</link> 
			</artist> 
			<link>http://www.songfreaks.com/the-billionaire-boys-club-tape-album-pharrell-williams</link> 
		</album> 
		<album id="208598" amg="817231" urlslug="can-i-have-it-like-that-album-pharrell-williams" year="2005" image="http://www.lyricfind.com/images/amg/cov75/drh100/h148/h14876ig97o.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/drh100/h148/h14876ig97o.jpg"> 
			<title>Can I Have It Like That</title> 
			<artist amg="281403" id="32622" image="http://www.lyricfind.com/images/amg/pic200/drq000/q084/q08457inu2g.jpg" urlslug="pharrell-williams"> 
				<name>Pharrell Williams</name> 
				<link>http://www.songfreaks.com/pharrell-williams</link> 
			</artist> 
			<link>http://www.songfreaks.com/can-i-have-it-like-that-album-pharrell-williams</link> 
		</album> 
		<album id="186089" amg="645627" urlslug="frontin-album-pharrell-williams" year="2003" image="http://www.lyricfind.com/images/amg/cov75/drg500/g593/g59357abwgi.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/drg500/g593/g59357abwgi.jpg"> 
			<title>Frontin' [US 12"/CD]</title> 
			<artist amg="281403" id="32622" image="http://www.lyricfind.com/images/amg/pic200/drq000/q084/q08457inu2g.jpg" urlslug="pharrell-williams"> 
				<name>Pharrell Williams</name> 
				<link>http://www.songfreaks.com/pharrell-williams</link> 
			</artist> 
			<link>http://www.songfreaks.com/frontin-album-pharrell-williams</link> 
		</album> 
		<album id="207556" amg="813455" urlslug="angel-album-pharrell-williams" year="2005" image="http://www.lyricfind.com/images/amg/cov75/drh100/h114/h11487ra4ma.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/drh100/h114/h11487ra4ma.jpg"> 
			<title>Angel [US CD]</title> 
			<artist amg="281403" id="32622" image="http://www.lyricfind.com/images/amg/pic200/drq000/q084/q08457inu2g.jpg" urlslug="pharrell-williams"> 
				<name>Pharrell Williams</name> 
				<link>http://www.songfreaks.com/pharrell-williams</link> 
			</artist> 
			<link>http://www.songfreaks.com/angel-album-pharrell-williams</link> 
		</album> 
		<album id="229921" amg="1020327" urlslug="the-remix-instrumentals-vol-2-album-pharrell-williams" year="" image="http://www.lyricfind.com/images/amg/cov75/dri300/i362/i36280intu6.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/dri300/i362/i36280intu6.jpg"> 
			<title>The Remix Instrumentals, Vol. 2 [EP]</title> 
			<artist amg="281403" id="32622" image="http://www.lyricfind.com/images/amg/pic200/drq000/q084/q08457inu2g.jpg" urlslug="pharrell-williams"> 
				<name>Pharrell Williams</name> 
				<link>http://www.songfreaks.com/pharrell-williams</link> 
			</artist> 
			<link>http://www.songfreaks.com/the-remix-instrumentals-vol-2-album-pharrell-williams</link> 
		</album> 
	</artistalbums> 
	</songfreaks>

### Getting top artists

	POST //topartists.do? HTTP/1.1
	Host: apiv2.songfreaks.com
	Accept-Encoding: gzip
	Content-Type: application/x-www-form-urlencoded; charset=utf-8
	Content-Length: 84
	Connection: close
	Cookie: JSESSIONID=7C3978872B5D686C559B92315497E1CE
	User-Agent: SongFreaks 2.1.1 (iPhone; iPhone OS 7.0.4; en_US)
	
	apikey=6c7a95aa8238f3b437b1db24e644c2ee&appname=sf_iphone&version=2.1.1&territory=US


### Getting artists lyrics

	POST //artistlyrics.do? HTTP/1.1
	Host: apiv2.songfreaks.com
	Accept-Encoding: gzip
	Content-Type: application/x-www-form-urlencoded; charset=utf-8
	Content-Length: 141
	Connection: close
	Cookie: JSESSIONID=2F17FB9E08C94BBADBBD196B3B2EE0BC
	User-Agent: SongFreaks 2.1.1 (iPad; iPhone OS 7.0.4; en_US)

	sfid=37077&appname=sf_iphone&lyricslimit=10&listingtype=all&territory=US&version=2.1.1&lyricsoffset=0&apikey=6c7a95aa8238f3b437b1db24e644c2ee

Response:

	<songfreaks> 
	<response code="100" renderTime="0.0220">SUCCESS</response> 
	<artistlyrics totalresults="52" totalpages="6"> 
		<track id="1445995" track_group_id="4382525" urlslug="banana-ghost-lyrics-man-man" amg="8686313" instrumental="false" viewable="true" duration="2:54" lyric="228527" has_lrc="false" tracknumber="3" discnumber="1"> 
			<title>Banana Ghost</title> 
			<album id="210957" amg="817740" urlslug="six-demon-bag-album-man-man" year="2006" image="http://www.lyricfind.com/images/amg/cov75/drh200/h222/h22212m6var.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/drh200/h222/h22212m6var.jpg"> 
				<title>Six Demon Bag</title> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
				<link>http://www.songfreaks.com/six-demon-bag-album-man-man</link> 
			</album> 
			<artists> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" genre="Rock" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
			</artists> 
			<link>http://www.songfreaks.com/banana-ghost-lyrics-man-man</link> 
			<snippet>Please don't go and build a fence around your heart 
				Like you've done before When you're losing ground 
				I know I can't wait I don't even have the st</snippet> 
		</track> 
		<track id="6336098" track_group_id="3264093" urlslug="bangkok-necktie-lyrics-man-man" amg="23219219" instrumental="false" viewable="false" duration="2:51" has_lrc="false" tracknumber="9" discnumber="1"> 
			<title>Bangkok Necktie</title> 
			<album id="334647" amg="2162360" urlslug="life-fantastic-album-man-man-1" year="2011" image="http://www.lyricfind.com/images/amg/cov75/drq000/q006/q00605w76gq.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/drq000/q006/q00605w76gq.jpg"> 
				<title>Life Fantastic</title> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
				<link>http://www.songfreaks.com/life-fantastic-album-man-man-1</link> 
			</album> 
			<artists> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" genre="Rock" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
			</artists> 
			<link>http://www.songfreaks.com/bangkok-necktie-lyrics-man-man</link> 
		</track> 
		<track id="5029420" track_group_id="1957467" urlslug="black-mission-goggles-lyrics-man-man" amg="8686316" instrumental="false" viewable="false" duration="4:59" has_lrc="false" tracknumber="6" discnumber="1"> 
			<title>Black Mission Goggles</title> 
			<album id="210957" amg="817740" urlslug="six-demon-bag-album-man-man" year="2006" image="http://www.lyricfind.com/images/amg/cov75/drh200/h222/h22212m6var.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/drh200/h222/h22212m6var.jpg"> 
				<title>Six Demon Bag</title> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
				<link>http://www.songfreaks.com/six-demon-bag-album-man-man</link> 
			</album> 
			<artists> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" genre="Rock" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
			</artists> 
			<link>http://www.songfreaks.com/black-mission-goggles-lyrics-man-man</link> 
		</track> 
		<track id="7062436" track_group_id="4658001" urlslug="born-tight-lyrics-man-man" amg="29724233" instrumental="false" viewable="false" duration="" has_lrc="false" tracknumber="13" discnumber="2"> 
			<title>Born Tight</title> 
			<album id="422454" amg="2806333" urlslug="on-oni-pond-album-man-man" year="2013" image="http://www.lyricfind.com/images/amg/cov75/dru900/u965/u96513bgil4.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/dru900/u965/u96513bgil4.jpg"> 
				<title>On Oni Pond [2LP+CD]</title> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
				<link>http://www.songfreaks.com/on-oni-pond-album-man-man</link> 
			</album> 
			<artists> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" genre="Rock" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
			</artists> 
			<link>http://www.songfreaks.com/born-tight-lyrics-man-man</link> 
		</track> 
		<track id="7062464" track_group_id="4658022" urlslug="born-tight-lyrics-man-man-1" amg="29778318" instrumental="false" viewable="false" duration="3:43" has_lrc="false" tracknumber="13" discnumber="1"> 
			<title>Born Tight</title> 
			<album id="422459" amg="2818097" urlslug="on-oni-pond-album-man-man-1" year="2013" image="http://www.lyricfind.com/images/amg/cov75/drv000/v097/v09747usekz.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/drv000/v097/v09747usekz.jpg"> 
				<title>On Oni Pond</title> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
				<link>http://www.songfreaks.com/on-oni-pond-album-man-man-1</link> 
			</album> 
			<artists> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" genre="Rock" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
			</artists> 
			<link>http://www.songfreaks.com/born-tight-lyrics-man-man-1</link> 
		</track> 
		<track id="7062437" track_group_id="4658002" urlslug="curtains-lyrics-man-man" amg="29724234" instrumental="false" viewable="false" duration="" has_lrc="false" tracknumber="12" discnumber="2"> 
			<title>Curtains</title> 
			<album id="422454" amg="2806333" urlslug="on-oni-pond-album-man-man" year="2013" image="http://www.lyricfind.com/images/amg/cov75/dru900/u965/u96513bgil4.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/dru900/u965/u96513bgil4.jpg"> 
				<title>On Oni Pond [2LP+CD]</title> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
				<link>http://www.songfreaks.com/on-oni-pond-album-man-man</link> 
			</album> 
			<artists> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" genre="Rock" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
			</artists> 
			<link>http://www.songfreaks.com/curtains-lyrics-man-man</link> 
		</track> 
		<track id="7062465" track_group_id="4658023" urlslug="curtains-lyrics-man-man-1" amg="29778319" instrumental="false" viewable="false" duration="1:03" has_lrc="false" tracknumber="12" discnumber="1"> 
			<title>Curtains</title> 
			<album id="422459" amg="2818097" urlslug="on-oni-pond-album-man-man-1" year="2013" image="http://www.lyricfind.com/images/amg/cov75/drv000/v097/v09747usekz.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/drv000/v097/v09747usekz.jpg"> 
				<title>On Oni Pond</title> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
				<link>http://www.songfreaks.com/on-oni-pond-album-man-man-1</link> 
			</album> 
			<artists> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" genre="Rock" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
			</artists> 
			<link>http://www.songfreaks.com/curtains-lyrics-man-man-1</link> 
		</track> 
		<track id="6336102" track_group_id="3264097" urlslug="dark-arts-lyrics-man-man" amg="23219229" instrumental="false" viewable="false" duration="3:49" has_lrc="false" tracknumber="4" discnumber="1"> 
			<title>Dark Arts</title> 
			<album id="334647" amg="2162360" urlslug="life-fantastic-album-man-man-1" year="2011" image="http://www.lyricfind.com/images/amg/cov75/drq000/q006/q00605w76gq.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/drq000/q006/q00605w76gq.jpg"> 
				<title>Life Fantastic</title> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
				<link>http://www.songfreaks.com/life-fantastic-album-man-man-1</link> 
			</album> 
			<artists> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" genre="Rock" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
			</artists> 
			<link>http://www.songfreaks.com/dark-arts-lyrics-man-man</link> 
		</track> 
		<track id="7062442" track_group_id="4658007" urlslug="deep-cover-lyrics-man-man" amg="29724239" instrumental="false" viewable="true" duration="" lyric="3897144" has_lrc="false" tracknumber="7" discnumber="1"> 
			<title>Deep Cover</title> 
			<album id="422454" amg="2806333" urlslug="on-oni-pond-album-man-man" year="2013" image="http://www.lyricfind.com/images/amg/cov75/dru900/u965/u96513bgil4.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/dru900/u965/u96513bgil4.jpg"> 
				<title>On Oni Pond [2LP+CD]</title> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
				<link>http://www.songfreaks.com/on-oni-pond-album-man-man</link> 
			</album> 
			<artists> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" genre="Rock" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
			</artists> 
			<link>http://www.songfreaks.com/deep-cover-lyrics-man-man</link> 
			<snippet>Deep Cover
				Is not a place It's a state of mind
				To have your heart go incognito And hide away for awhile
				Deep Cover It's a holiday
				From the landslides</snippet> 
		</track> 
		<track id="7062470" track_group_id="4658028" urlslug="deep-cover-lyrics-man-man-1" amg="29778324" instrumental="false" viewable="true" duration="3:03" lyric="3897144" has_lrc="false" tracknumber="7" discnumber="1"> 
			<title>Deep Cover</title> 
			<album id="422459" amg="2818097" urlslug="on-oni-pond-album-man-man-1" year="2013" image="http://www.lyricfind.com/images/amg/cov75/drv000/v097/v09747usekz.jpg" largeimage="http://www.lyricfind.com/images/amg/cov200/drv000/v097/v09747usekz.jpg"> 
				<title>On Oni Pond</title> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
				<link>http://www.songfreaks.com/on-oni-pond-album-man-man-1</link> 
			</album> 
			<artists> 
				<artist amg="645123" id="37077" image="http://www.lyricfind.com/images/amg/pic200/drq100/q100/q10019qu4mb.jpg" genre="Rock" urlslug="man-man"> 
					<name>Man Man</name> 
					<link>http://www.songfreaks.com/man-man</link> 
				</artist> 
			</artists> 
			<link>http://www.songfreaks.com/deep-cover-lyrics-man-man-1</link> 
			<snippet>Deep Cover
				Is not a place It's a state of mind
				To have your heart go incognito And hide away for awhile
				Deep Cover It's a holiday
				From the landslides</snippet> 
		</track> 
	</artistlyrics> 
	</songfreaks>

### Search

	POST //search.do? HTTP/1.1
	Host: apiv2.songfreaks.com
	Accept-Encoding: gzip
	Content-Type: application/x-www-form-urlencoded; charset=utf-8
	Content-Length: 136
	Connection: close
	Cookie: JSESSIONID=4C1AC461A77F739AEECE0DC19B788FCA
	User-Agent: SongFreaks 2.1.1 (iPhone; iPhone OS 7.0.4; en_US)
	
	apikey=6c7a95aa8238f3b437b1db24e644c2ee&appname=sf_iphone&type=TRACK&limit=10&alltracks=true&version=2.1.1&all=Man&offset=0&territory=US


## METROLYRICS

### Getting lyric

http://api.metrolyrics.com/v1/get/fullbody/?title=Who Says&artist=Selena Gomez&X-API-KEY=b84a4db3a6f9fb34523c25e43b387f1f56f987a5&format=json

	GET /2.0/?api_key=d1b0b71880806ca19d6c8891ced0a0ac&artist=Selena Gomez&method=track.getInfo&track=Who Says&api_sig=a711f27c8c1b5285d687d66a0aa236da HTTP/1.1
	Host: ws.audioscrobbler.com
	Accept-Encoding: gzip, deflate
	Accept: */*
	Accept-Language: en-us
	Connection: keep-alive
	User-Agent: metrolyrics/102 CFNetwork/672.0.8 Darwin/14.0.0

Response:

	{
	"song": "I wouldn't wanna be anybody else, hey\nYou made me insecure, told me I wasn't good enough\nBut who are you to judge.\nWhen you're a diamond in the rough\n\nI'm sure you got some things\nYou'd like to change about yourself\nBut when it comes to me\nI wouldn't want to be anybody else\n\nNa na na na na na na na na na na na na\nNa na na na na na na na na na na na na\nI'm no beauty queen, I'm just beautiful me\n\nNa na na na na na na na na na na na na\nNa na na na na na na na na na na na na\nYou've got every right to a beautiful life, come on\n\nWho says, who says you're not perfect\nWho says you're not worth it\nWho says you're the only one that's hurting\nTrust me that's the price of beauty\nWho says you're not pretty\nWho says you're not beautiful, who says?\n\nIt's such a funny thing\nHow nothing's funny when it's you\nYou tell 'em what you mean\nBut they can't whiten out the truth\n\nIt's like the work of art\nThat never gets to see the light\nKeep you beneath the stars\nWon't let you touch the sky\n\nNa na na na na na na na na na\nNa na na na na na na na na na\nI'm no beauty queen, I'm just beautiful me\n\nNa na na na na na na na na na\nNa na na na na na na na na na\nYou've got every right to a beautiful life, come on\n\nWho says, who says you're not perfect\nWho says you're not worth it\nWho says you're the only one that's hurting\nTrust me that's the price of beauty\nWho says you're not pretty\nWho says you're not beautiful, who says?\n\nWho says you're not star potential\nWho says you're not presidential\nWho says you can't be in movies\nListen to me, listen to me\n\nWho says you don't pass the test\nWho says you can't be the best\nWho said, who said?\nWould you tell me who said that, yeah\nWho said\n\nWho says, who says you're not perfect\nWho says you're not worth it\nWho says you're the only one that's hurting\nTrust me that's the price of beauty\nWho says you're not pretty\nWho says you're not beautiful, who says?\n\nWho says you're not perfect\nWho says you're not worth it\nWho says you're the only one that's hurting\nTrust me that's the price of beauty\nWho says you're not pretty\nWho says you're not beautiful, who says?",
	"lyricid": 896778736,
	"title": "Who Says",
	"artist": "Selena Gomez",
	"url": "http:\/\/www.metrolyrics.com\/who-says-lyrics-selena-gomez.html",
	"content_status": 1,
	"gracenote": 1,
	"publishers": "Lyrics \u00a9 Warner\/Chappell Music, Inc.",
	"songwriters": "RENEA, PRISCILLA \/ KIRIAKOU, EMANUEL",
	"line_count": 73,
	"songmeaning_lines": [],
	"songmeanings": [],
	"songLinetimestamps": [{
		"line": 1,
		"timestamp": 0
	}, {
		"line": 2,
		"timestamp": 10
	}, {
		"line": 3,
		"timestamp": 14
	}, {
		"line": 4,
		"timestamp": 16
	}, {
		"line": 5,
		"timestamp": 19
	}, {
		"line": 6,
		"timestamp": 21
	}, {
		"line": 7,
		"timestamp": 24
	}, {
		"line": 8,
		"timestamp": 26
	}, {
		"line": 9,
		"timestamp": 33
	}, {
		"line": 10,
		"timestamp": 42
	}, {
		"line": 11,
		"timestamp": 47
	}, {
		"line": 12,
		"timestamp": 50
	}, {
		"line": 13,
		"timestamp": 53
	}, {
		"line": 14,
		"timestamp": 57
	}, {
		"line": 15,
		"timestamp": 60
	}, {
		"line": 16,
		"timestamp": 62
	}, {
		"line": 17,
		"timestamp": 71
	}, {
		"line": 18,
		"timestamp": 73
	}, {
		"line": 19,
		"timestamp": 76
	}, {
		"line": 20,
		"timestamp": 78
	}, {
		"line": 21,
		"timestamp": 81
	}, {
		"line": 22,
		"timestamp": 83
	}, {
		"line": 23,
		"timestamp": 86
	}, {
		"line": 24,
		"timestamp": 88
	}, {
		"line": 25,
		"timestamp": 95
	}, {
		"line": 26,
		"timestamp": 104
	}, {
		"line": 27,
		"timestamp": 109
	}, {
		"line": 28,
		"timestamp": 112
	}, {
		"line": 29,
		"timestamp": 115
	}, {
		"line": 30,
		"timestamp": 118
	}, {
		"line": 31,
		"timestamp": 122
	}, {
		"line": 32,
		"timestamp": 124
	}, {
		"line": 33,
		"timestamp": 128
	}, {
		"line": 34,
		"timestamp": 130
	}, {
		"line": 35,
		"timestamp": 133
	}, {
		"line": 36,
		"timestamp": 135
	}, {
		"line": 37,
		"timestamp": 138
	}, {
		"line": 38,
		"timestamp": 140
	}, {
		"line": 39,
		"timestamp": 142
	}, {
		"line": 40,
		"timestamp": 144
	}, {
		"line": 41,
		"timestamp": 148
	}, {
		"line": 42,
		"timestamp": 149
	}, {
		"line": 43,
		"timestamp": 153
	}, {
		"line": 44,
		"timestamp": 155
	}, {
		"line": 45,
		"timestamp": 159
	}, {
		"line": 46,
		"timestamp": 162
	}, {
		"line": 47,
		"timestamp": 165
	}, {
		"line": 48,
		"timestamp": 169
	}, {
		"line": 49,
		"timestamp": 171
	}, {
		"line": 50,
		"timestamp": 174
	}, {
		"line": 51,
		"timestamp": 178
	}, {
		"line": 52,
		"timestamp": 181
	}, {
		"line": 53,
		"timestamp": 184
	}]
	}


## AUDIOSCROBBLER 

### Get artists info

http://ws.audioscrobbler.com/2.0/?api_key=d1b0b71880806ca19d6c8891ced0a0ac&artist=Ellie%20Goulding&limit=500&method=artist.getSimilar&api_sig=4d1318fd6830b87ebc84e531391e2cd5

	GET /2.0/?api_key=d1b0b71880806ca19d6c8891ced0a0ac&artist=Ellie%20Goulding&	limit=500&method=artist.getSimilar&api_sig=4d1318fd6830b87ebc84e531391e2cd5 	HTTP/1.1
	Host: ws.audioscrobbler.com
	Accept-Encoding: gzip, deflate
	Accept: */*
	Accept-Language: en-us
	Connection: keep-alive
	User-Agent: metrolyrics/102 CFNetwork/672.0.8 Darwin/14.0.0


## LYRICFIND

### API KEYS:

3a5cc89e3aefd37e94c013f20b3b4636 (GSound)
31c9f10b8c2d83e38e80e15f41e810f7 (GSound)
19d8ec1b68d34a12a086abbe06fcd5c6 (Hear Lyrics)

### Getting lyric

https://api.lyricfind.com/lyric.do?apikey=31c9f10b8c2d83e38e80e15f41e810f7&reqtype=default&trackid=amg:29799008&output=json

	GET /lyric.do?apikey=31c9f10b8c2d83e38e80e15f41e810f7&reqtype=default&trackid=amg:10220629&output=json HTTP/1.1
	Host: api.lyricfind.com
	Proxy-Connection: keep-alive
	Accept-Encoding: gzip, deflate
	Accept: */*
	Cookie: JSESSIONID=9268BFD5FDB46DA58EA13369F92A088F
	Connection: keep-alive
	Accept-Language: en-us
	User-Agent: gsound/963 CFNetwork/672.0.8 Darwin/14.0.0


### New Api

http://api.lyricfind.com/lyric.do?reqtype=default&useragent=hear-lyrics&output=json&apikey=19d8ec1b68d34a12a086abbe06fcd5c6&trackid=amg%3A25506802

	GET /lyric.do?reqtype=default&useragent=hear-lyrics&output=json&apikey=19d8ec1b68d34a12a086abbe06fcd5c6&trackid=amg%3A29599248 HTTP/1.1
	Host: api.lyricfind.com
	Accept-Encoding: gzip
	Accept: application/json
	Cookie: JSESSIONID=A3F2329842658DB0D0674175A95050A4
	Connection: keep-alive
	Accept-Language: fr, en, de, zh-Hans, zh-Hant, ja, nl, it, es, es-MX, ko, pt, pt-PT, da, fi, nb, sv, ru, pl, tr, uk, ar, hr, cs, el, he, ro, sk, th, id, ms, en-GB, en-AU, ca, hu, vi, en-us;q=0.8
	User-Agent: com.drop.hearlyrics/1.2.0 (unknown, iPhone OS 7.0.4, iPad, Scale/2.000000)

Response:

	{
	"response": {
		"code": 101,
		"description": "SUCCESS: LICENSE, LYRICS"
	},
	"track": {
		"amg": 29599248,
		"instrumental": false,
		"viewable": true,
		"has_lrc": true,
		"lrc_verified": true,
		"title": "Birthday",
		"artist": {
			"name": "Selena Gomez"
		},
		"last_update": "2013-11-27 11:29:28",
		"lyrics": "Tell \u0027em that is my birthday\r\nTell \u0027em that is my birthday\r\nTell \u0027em that is my birthday\r\nWhen I party like that\r\nEvery night\u0027s my birthday\r\nThey don\u0027t know, so it\u0027s okay\r\nTell \u0027em that is my birthday\r\nWhen I party like that\r\n\r\nJazz it up, jazz it up\r\n\r\nHappy as can be, falling into you, falling into me\r\nHow do you do, calling me the queen, baking cream\r\nBlow your dreams, blow your dreams, blow your dreams away with me\r\nBlow your dreams, blow your dreams, blow your dreams away with me\r\nSo yummy\r\n\r\nTell \u0027em that is my birthday\r\nTell \u0027em that is my birthday\r\nTell \u0027em that is my birthday\r\nWhen I party like that\r\nEvery night\u0027s my birthday\r\nThey don\u0027t know, so it\u0027s okay\r\nTell em that is my birthday\r\nWhen I party like that\r\n\r\nJazz it up, jazz it up\r\n\r\nFeeling fine and free\r\nCrashing into you, crashing into me, so yummy\r\nIt\u0027s all I wanna do, come and dance with me, pretty please\r\nBlow your dreams, blow your dreams, blow your dreams away with me\r\nBlow your dreams, blow your dreams, blow your dreams away with me\r\n\r\nTell \u0027em that is my birthday\r\nTell \u0027em that is my birthday\r\nTell \u0027em that is my birthday\r\nWhen I party like that\r\nEvery night\u0027s my birthday\r\nThey don\u0027t know, so it\u0027s okay\r\nTell \u0027em that is my birthday\r\nWhen I party like that\r\n\r\nTell \u0027em that is my birthday\r\nTell \u0027em that is my birthday\r\nTell \u0027em that is my birthday\r\nWhen I party like that\r\nEvery night\u0027s my birthday\r\nThey don\u0027t know, so it\u0027s okay\r\nTell \u0027em that is my birthday\r\nWhen I party like that\r\n\r\nBlow your dreams, blow your dreams, blow your dreams away with me\r\nBlow your dreams, blow your dreams, blow your dreams away with me\r\nBlow your dreams, blow your dreams, blow your dreams away with me\r\nBlow your dreams, blow your dreams, blow your dreams away with me\r\n\r\nTell \u0027em that is my birthday\r\nTell \u0027em that is my birthday\r\nTell \u0027em that is my birthday\r\nWhen I party like that\r\nEvery night\u0027s my birthday\r\nThey don\u0027t know, so it\u0027s okay\r\nTell \u0027em that is my birthday\r\nWhen I party like that\r\n\r\nTell \u0027em that is my birthday\r\nTell \u0027em that is my birthday\r\nTell \u0027em that is my birthday\r\nWhen I party like that\r\nEvery night\u0027s my birthday\r\nThey don\u0027t know, so it\u0027s okay\r\nTell \u0027em that is my birthday\r\nWhen I party like that",
		"copyright": "Lyrics ¬© Universal Music Publishing Group, Sony/ATV Music Publishing LLC",
		"writer": "GONZALEZ, MICHAEL FRANCIS / KASHER, JACOB / RUSSO, CRISTA ROSE"
	}
}


## SOUNDHOUND 


### Getting song info

Valid with User-Agent

https://secureapi.midomi.com/v2/?method=getTrackInformation&track_id=100673773554619402&format=lyrics&from=chart_hottest

https://secureapi.midomi.com/v2/?method=getVideos&artist_name=Eminem&track_name=The+Monster

	GET /v2/?method=getTrackInformation&track_id=100470214617438614&format=lyrics&from=chart_hottest&log_only=1 HTTP/1.1
	Host: secureapi.midomi.com
	Proxy-Connection: keep-alive
	Accept-Encoding: gzip, deflate
	Accept: */*
	Cookie: PHPSESSID=7ea861174e420c260fba4ebb9c9ece84; freemium_num_searches=-1; freemium_state=XRDYDVwfa45lu4Rt3SZCNsBGQxRxCFZa0iXRWrQa+r7oG9RthoCqsdk1b6XDdvvJQ+F/yEIm6/j/qQvC+oE4xZCBki8wgET8VyBx9a8jKM0HuUMJ9Hsb84JWs/DhINEpzgxbhX1fNlp8Hq9KBRR795iWgMDCmzVECqQFgCerL3g4oPWLvAZGerd7wTPDXNu25wpxQch66wEQnjVL4tQZmg8U4JM1JSrXfMAYlgYIHa0oZ1EhuOBYjCWAwIDzo/OO8FT6AJiVnkdDhYlyUQ5pTGuR4qR/5FBFkG+Zv54B5C3ylcNP+fqp2tJy3FWW2ZW+uSjEqrbJEVFcdK3VvHlwmQJiFtg1G+WaXqRmNn8qP+PPkmL6LszZGHNOVLWjLbLQEL6w5Phf6hsQZWUJqDfQZkGnM4BBc4cxXCn/hu/UIbQRFwCtFvLtGI/+qxPDEuDaEJZD1Mvbk0akFkchm4MQc6jnC6yfhnWbNG7eFreaPZOpov8teB//z8JI2soCwaF2jOZSzmnlKXYzTPNtPP41Tjfj/daT8XEylZ0JdP6RdWNFqkQgseUDnoJIPUFwdyebINqFAfAy1kq+9fUxSmH86Dc7oqaenDLE/2tFwZWw7xONoad7cfNDBAkz8vFPvW0Bifj9il7RYNvwwbEcAOas8NFHn7o+icH/FAEFnzBTdoh/cv4HlXiNhjWGL6jnqt14+XLyENc4HK7UHmZovnx/9/IBgB1aReJQPTlzIQCyHjyZXuX9/er7Q5r8iHCzyVhC; num_searches_cookie={"omr_pos":4,"omr_neg":1,"hasSeenListenOnStart":false}; partners_cookie={"installed":["shf","shi"]}; recent_searches_cookie_1=["100514407746028155"]
	Connection: keep-alive
	Accept-Language: en-us
	User-Agent: AppNumber=2 AppVersion=5.6.0a APIVersion=2.0.0.0 VID=9ef17d05ceac4d2580d18f5d0f0691a7 VUID=454692A6-AE40-4131-9EFC-9DEBB42BE9F1 IFA=AD1306BB-E587-48D9-BB61-F4E001F98B3E COUNTRY=US ITUNES=US LANG=en DEV=iPhone_4.1 FIRMWARE=7.0.4 MAPS=1

Response:

	<melodis> 
	<track album_id="300372800525743514" track_id="100470214617438614" artist_id="200510557329747826" artist_name="Passenger" album_name="All the Little Lights" album_date="2012 02 24" track_name="Let Her Go" album_primary_image="http://static.midomi.com/a/pop/cov200/dru500/u552/u55271s8psa.jpg" audio_preview_url="http://a561.phobos.apple.com/us/r2000/006/Music/v4/39/0c/22/390c220f-81ed-fd14-8ca8-66f6360b2f46/mzaf_7701353043128361046.aac.m4a" video_url="https://secureapi.midomi.com:443/v2/?method=getVideos&amp;artist_name=Passenger&amp;track_name=Let+Her+Go" lyrics_provider="lyricfind" lyrics_url="http://www.google.com/search?q=lyrics+Let+Her+Go+Passenger" has_recommended_tracks="0" purchase_url="https://secureapi.midomi.com:443/v2/?method=getTrackBuyLinks&amp;track_id=100470214617438614&amp;store=itunes" spotify_id="spotify:track:6GmUVqe73u5YRfUUynZK6I"> 
		<artists> 
			<artist artist_primary_image="http://static.midomi.com/a/pic200/drq000/q019/200_q01954eiswk.jpg" artist_id="200510557329747826" artist_name="Passenger" similar_artist_count="19" has_social_channels="0" has_twitter_social="0" has_facebook_social="0" purchase_url="https://secureapi.midomi.com:443/v2/?method=getArtistBuyLinks&amp;artist_id=200510557329747826"> 
				<external_links> 
					<external_link title="Listen on iTunes Radio" image="http://static.midomi.com/images/mobile/iphone/iTunes_Radio_icon_120x120.png" url="https://itunes.apple.com/us/station/idra.396255033?uo=4&amp;at=10lIs&amp;ct=3-pr-itunesra-passenger" url_browser="external_itunes" section="2" /> 
					<external_link title="Follow @SoundHound" subtitle="News, updates, and more ..." image="http://static.midomi.com/images/external-link-twitter-60x60.png" url="http://www.soundhound.com/index.php?action=s.twitterRowIos5" url_browser="twitter_api" alt_title="Follow @SoundHound" alt_subtitle="News, updates, and more ..." alt_url="http://mobile.twitter.com/SoundHound" alt_url_browser="internal" section="3" /> 
					<external_link title="Explore SoundHound Charts" image="http://static.midomi.com/images/mobile/row-charts-icon-120x120.png" url="soundhound://soundhound.com/?shch=1" section="3" /> 
					<external_link title="Wikipedia Artist Page" image="http://static.midomi.com/images/mobile/iphone/wk60.png" url="http://en.m.wikipedia.org/wiki/Special:Search?search=Passenger" url_browser="internal" section="4" /> 
					<external_link title="Similar Artists" image="http://static.midomi.com/images/mobile/iphone/icon-similarartist.png" url="https://secureapi.midomi.com:443/v2/?method=getArtistSimilarArtists&amp;artist_id=200510557329747826" url_browser="api" item_count="19" section="5" /> 
				</external_links> 
			</artist> 
		</artists> 
		<external_links> 
			<external_link title="Listen Free" subtitle="Download Spotify Now" image="http://static.midomi.com/corpus/92/22/922275a01daa6692fd7b17fb286506e3premium-row-(120x120).png" url="spotify:track:6GmUVqe73u5YRfUUynZK6I" alt_title="Listen Free" alt_subtitle="Download Spotify Now" alt_image="http://static.midomi.com/corpus/92/22/922275a01daa6692fd7b17fb286506e3premium-row-(120x120).png" alt_url="http://hastrk1.com/serve?action=click&amp;publisher_id=19418&amp;site_id=6022&amp;offer_id=255078&amp;ios_ifa=iOSifa&amp;sub_campaign=integratedrow_US&amp;sub_ad=copy101.14" alt_url_browser="external" section="2" /> 
			<external_link title="Listen on iTunes Radio" image="http://static.midomi.com/images/mobile/iphone/iTunes_Radio_icon_120x120.png" url="https://itunes.apple.com/us/station/idra.396255033?uo=4&amp;at=10lIs&amp;ct=3-pr-itunesra-passenger" url_browser="external_itunes" section="2" /> 
			<external_link title="Explore the DNA of Music" subtitle="Tap for Samples, Covers, Remixes" image="http://static.midomi.com/corpus/53/5a/535a363300a5a6595ee5f3fb036dde8fDNA-PremiumRow-icon.png" url="http://static.midomi.com/corpus/whosampled/ios/who-sampled-ios.html" url_browser="internal" section="2" /> 
			<external_link title="Explore SoundHound Charts" image="http://static.midomi.com/images/mobile/row-charts-icon-120x120.png" url="soundhound://soundhound.com/?shch=1" section="2" /> 
			<external_link title="Follow @SoundHound" subtitle="News, updates, and more ..." image="http://static.midomi.com/images/external-link-twitter-60x60.png" url="http://www.soundhound.com/index.php?action=s.twitterRowIos5" url_browser="twitter_api" alt_title="Follow @SoundHound" alt_subtitle="News, updates, and more ..." alt_url="http://mobile.twitter.com/SoundHound" alt_url_browser="internal" section="4" /> 
			<external_link title="Loving SoundHound ∞?" subtitle="Rate it in the App Store" image="http://static.midomi.com/images/fivestars_60px.png" url="http://itunes.apple.com/app/soundhound/id284972998?uo=5&amp;at=10lIs&amp;ct=_2USpra-t" url_browser="external_itunes" section="4" /> 
			<external_link title="Album Appearances" image="http://static.midomi.com/images/mobile/iphone/icon-songalbumappear.png" url="http://api.midomi.com:443/v2/?method=getTrackAlbumsById&amp;track_id=100470214617438614&amp;from=track" url_browser="api" section="5" /> 
		</external_links> 
		<lyrics>Well you only need the light when it's burning low
			Only miss the sun when it starts to snow Only know you love her when you let her go
			Only know you've been high when you're feeling low Only hate the road when you're missing home
			Only know you love her when you let her go And you let her go
			Staring at the bottom of your glass Hoping one day you'll make a dream last
			But dreams come slow and they go so fast You see her when you close your eyes
			Maybe one day you'll understand why Everything you touch, oh it dies
			But you only need the light when it's burning low Only miss the sun when it starts to snow
			Only know you love her when you let her go Only know you've been high when you're feeling low
			Only hate the road when you're missing home Only know you love her when you let her go
			Staring at the ceiling in the dark Same old empty feeling in your heart
			'Cause love comes slow and it goes so fast Well you see her when you fall asleep
			But never to touch and never to keep 'Cause you loved her too much and you dive too deep
			Well you only need the light when it's burning low Only miss the sun when it starts to snow
			Only know you love her when you let her go Only know you've been high when you're feeling low
			Only hate the road when you're missing home Only know you love her when you let her go
			And you let her go Oh oh oh no
			And you let her go Oh oh oh no
			Well you let her go 'Cause you only need the light when it's burning low
			Only miss the sun when it starts to snow Only know you love her when you let her go
			Only know you've been high when you're feeling low Only hate the road when you're missing home
			Only know you love her when you let her go 'Cause you only need the light when it's burning low
			Only miss the sun when it starts to snow Only know you love her when you let her go
			Only know you've been high when you're feeling low Only hate the road when you're missing home
			Only know you love her when you let her go Copyright: Sony/ATV Music Publishing LLC
			Writers: ROSENBERG, MICHAEL DAVID</lyrics> 
	</track> 
	</melodis>

### Getting videos

https://secureapi.midomi.com/v2/?method=getVideos&artist_name=Passenger&track_name=Let+Her+Go

	GET /v2/?method=getVideos&artist_name=Passenger&track_name=Let+Her+Go HTTP/1.1

Response:

	<melodis> 
	<videos> 
		<video video="http://www.youtube.com/embed/RBumgq5yVrA?showinfo=0" title="Passenger - Let Her Go [Official Video]" description="The official video for new single 'Let Her Go.' Directed and Produced by Dave Jansen. Amazing work Dave. http://www.theloop.com.au/DaveJansen/ Taken from Top..." created="2012-07-25T22:28:26.000Z" views_count="161778969" rating_average="4.9071255" duration="255" provider="youtube"> 
			<thumbnails>
				<thumbnail url="http://i.ytimg.com/vi/RBumgq5yVrA/0.jpg" time="00:02:07.500" />
			</thumbnails>
		</video> 
		<video video="http://www.youtube.com/embed/PrGq-pSvZg8?showinfo=0" title="Passenger Let her go lyrics" description="My third video so I hope you like it. Subscribe if you want. Thanks for watching. I put in a link with the acoustic version of Let Her Go - Made by Jordan Jansen. http://www.youtube.com/watch?v..." created="2012-10-27T16:02:17.000Z" views_count="7621658" rating_average="4.850792" duration="255" provider="youtube"> 
			<thumbnails>
				<thumbnail url="http://i.ytimg.com/vi/PrGq-pSvZg8/0.jpg" time="00:02:07.500" />
			</thumbnails>
		</video> 
		<video video="http://www.youtube.com/embed/ufEejvMEP64?showinfo=0" title="Passenger - Let her go *lyrics*" description="twitter: www.twitter.com/ivobeijen other account: www.youtube.com/mrbeijen1997mobiel Kik:ivopsv0313 lyrics video passenger - let her go ((DISCLAIMER)) I DON'..." created="2012-11-05T20:45:00.000Z" views_count="18715082" rating_average="4.873146" duration="260" provider="youtube"> 
			<thumbnails>
				<thumbnail url="http://i.ytimg.com/vi/ufEejvMEP64/0.jpg" time="00:02:10" />
			</thumbnails>
		</video> 
		<video video="http://www.youtube.com/embed/BIHrkqBFUL4?showinfo=0" title="Let Her Go - Passenger (Official Video Cover by Jasmine Thompson)" description="EP 'Under The Willow Tree' iTunes: http://smarturl.it/UnderTheWillowTree Limited edition CDs: http://tantrumjas.bandcamp.com/. My cover of 'Let Her Go' by Pa..." created="2013-05-12T13:46:43.000Z" views_count="5801917" rating_average="4.943113" duration="188" provider="youtube"> 
			<thumbnails>
				<thumbnail url="http://i.ytimg.com/vi/BIHrkqBFUL4/0.jpg" time="00:01:34" />
			</thumbnails>
		</video> 
		<video video="http://www.youtube.com/embed/8tjixLbTlio?showinfo=0" title="&quot;Let Her Go&quot; - Passenger (Tyler Ward &amp; Kurt Schneider)" description="Get our version of &quot;Let Her Go&quot; on iTunes here! https://itunes.apple.com/us/album/let-her-go-single/id693324327 And go subscribe to Tyler Ward!! He is the ma..." created="2013-08-25T06:08:52.000Z" views_count="3477931" rating_average="4.9530263" duration="245" provider="youtube"> 
			<thumbnails>
				<thumbnail url="http://i.ytimg.com/vi/8tjixLbTlio/0.jpg" time="00:02:02.500" />
			</thumbnails>
		</video> 
		<video video="http://www.youtube.com/embed/Ginx7WKq5GE?showinfo=0" title="Passenger - Let Her Go (Lyrics)" description="Passenger - Let Her Go, from the album All the Little Lights. My first lyrics video. Hope you enjoy it! Made entirely in Adobe Premiere Pro CS6. ------------..." created="2012-12-16T03:18:49.000Z" views_count="4029144" rating_average="4.9329634" duration="253" provider="youtube"> 
			<thumbnails>
				<thumbnail url="http://i.ytimg.com/vi/Ginx7WKq5GE/0.jpg" time="00:02:06.500" />
			</thumbnails>
		</video> 
		<video video="http://www.youtube.com/embed/26SDD60m_kY?showinfo=0" title="Passenger - Let Her Go" description="Passenger - Let Her Go From the album &quot;All The Little Lights&quot; available on: http://itunes.apple.com/gb/album/all-the-little-lights/id490717938 Lyrics: Well y..." created="2012-03-12T20:43:49.000Z" views_count="9580657" rating_average="4.824384" duration="253" provider="youtube"> 
			<thumbnails>
				<thumbnail url="http://i.ytimg.com/vi/26SDD60m_kY/0.jpg" time="00:02:06.500" />
			</thumbnails>
		</video> 
		<video video="http://www.youtube.com/embed/meq0zmOb8EA?showinfo=0" title="Let Her Go - Passenger (Boyce Avenue feat. Hannah Trigwell acoustic cover) on iTunes &amp; Spotify" description="Tickets + VIP Meet &amp; Greets: http://smarturl.it/BATour iTunes: http://smarturl.it/BoyceCCV3b Spotify: http://smarturl.it/BoyceCCV3bSpotify Alejandro Manzano ..." created="2013-09-08T15:59:19.000Z" views_count="4401488" rating_average="4.9540796" duration="245" provider="youtube"> 
			<thumbnails>
				<thumbnail url="http://i.ytimg.com/vi/meq0zmOb8EA/0.jpg" time="00:02:02.500" />
			</thumbnails>
		</video> 
		<video video="http://www.youtube.com/embed/vAP5kakbcQg?showinfo=0" title="Passenger - Let Her Go (Nicole Cross Official Cover Video)" description="Cover of Passenger's Let Her Go :) add me on facebook: http://www.facebook.com/nicolecrossmusic guitar: https://www.facebook.com/manuelweimannmusic love, Nic..." created="2013-03-15T15:23:21.000Z" views_count="4215579" rating_average="4.8981104" duration="229" provider="youtube"> 
			<thumbnails>
				<thumbnail url="http://i.ytimg.com/vi/vAP5kakbcQg/0.jpg" time="00:01:54.500" />
			</thumbnails>
		</video> 
		<video video="http://www.youtube.com/embed/zgY6lB4X3U0?showinfo=0" title="&quot;Let Her Go&quot; by Passenger, cover by CIMORELLI" description="Hope you like our cover of &quot;Let Her Go&quot; by Passenger! We had so much fun arranging this one and really love the lyrics and meaning behind it. SACRAMENTO: we ..." created="2013-11-22T18:57:58.000Z" views_count="844344" rating_average="4.900993" duration="591" provider="youtube"> 
			<thumbnails>
				<thumbnail url="http://i.ytimg.com/vi/zgY6lB4X3U0/0.jpg" time="00:04:55.500" />
			</thumbnails>
		</video> 
	</videos> 
	</melodis>


## TUNEWIKI

### Getting lyric

http://api.tunewiki.com/smp/v2/getLyric?apiKey=f2ee8c4f138ce7505e329a2ed7f39277&title=This Man&appver=4.3.1&tu=twtemp~661b8d72c38f5c350c16c762deafe174&json=true&artist=Jeremy Camp&apiPass=1b2e8964c4c7d0dac5382239d90b4bbe

	POST /smp/v2/getLyric?apiKey=f2ee8c4f138ce7505e329a2ed7f39277&title=This Man&appver=4.3.1&tu=twtemp~661b8d72c38f5c350c16c762deafe174&json=true&artist=Jeremy Camp&apiPass=1b2e8964c4c7d0dac5382239d90b4bbe HTTP/1.1
	Host: api.tunewiki.com
	Accept-Encoding: gzip, deflate
	Content-Type: application/x-www-form-urlencoded
	Accept-Language: en-us
	Accept: */*
	Pragma: no-cache
	Content-Length: 0
	Connection: keep-alive
	User-Agent: MediaPlayer/4001/3.0 (iPhone 4.3.2; iPhone; iPhone; Apple; AT&T; 410214; en_US)

Response:

	{
	"response": {
		"@expires": "never",
		"@source": "MemCache",
		"lyric": {
			"line": [{
				"@timing": "0",
				"value": "In only a moment truth"
			}, {
				"@timing": "4006930655",
				"value": "Was seen revealed this mystery"
			}, {
				"@timing": "4077714617",
				"value": "The crown that showed no dignity he wore"
			}, {
				"@timing": "506746904911",
				"value": "And the king was placed for all the world"
			}, {
				"@timing": "40019456511",
				"value": "To show disgrace but only beauty flowed from this place"
			}, {
				"@timing": "508857505971",
				"value": "Would you take the place of this man"
			}, {
				"@timing": "44041886171",
				"value": "Would you take the nails from his hands"
			}, {
				"@timing": "44021926991",
				"value": "Would you take the place of this man"
			}, {
				"@timing": "502823105972",
				"value": "Would you take the nails from his hands"
			}, {
				"@timing": "509404305423",
				"value": "He held the weight of impurity"
			}, {
				"@timing": "506127355443",
				"value": "The father would not see"
			}, {
				"@timing": "502543605953",
				"value": "The reasons had finally come to be to"
			}, {
				"@timing": "505882904973",
				"value": "Show the depth of his grace flowed with"
			}, {
				"@timing": "506652105414",
				"value": "Every sin erased he knew that this was"
			}, {
				"@timing": "507167405434",
				"value": "Why he came"
			}, {
				"@timing": "1090079",
				"value": "Would you take the place of this man"
			}, {
				"@timing": "48080674193",
				"value": "Would you take the nails from his hands"
			}, {
				"@timing": "10392011",
				"value": "Would you take the place of this man"
			}, {
				"@timing": "507303906945",
				"value": "Would you take the nails from his hands"
			}, {
				"@timing": "508899256485",
				"value": "And we just don't know the blood and"
			}, {
				"@timing": "42025987705",
				"value": "Water flowed and in it all"
			}, {
				"@timing": "509291856956",
				"value": "He showes just how much he cares"
			}, {
				"@timing": "506498156996",
				"value": "And the veil was torn so we could have"
			}, {
				"@timing": "14595061",
				"value": "This open door and all these things have"
			}, {
				"@timing": "279001792",
				"value": "Finally been complete"
			}, {
				"@timing": "505669757967",
				"value": "Would you take the place of this man"
			}, {
				"@timing": "507471507408",
				"value": "Would you take the nails from his hands"
			}, {
				"@timing": "44026948766",
				"value": "Would you take the place of this man"
			}, {
				"@timing": "48000028196",
				"value": "Would you take the nails from his hands"
			}, {
				"@timing": "508369257498",
				"value": "From his hands"
			}, {
				"@timing": "504709508429",
				"value": "From his hands"
			}, {
				"@timing": "60787769675411",
				"value": "From his hands"
			}, {
				"@timing": "3910761095",
				"value": "From his hands"
			}, {
				"@timing": "60781091493221",
				"value": "From his hands"
			}]
		},
		"no_cache": "false",
		"country_code": "VN",
		"group_identifier": "",
		"group_id": "2388850",
		"language": "",
		"last_update": "2013-09-19 20:58:54",
		"lyrics_blocked": "0",
		"lyrics_locked": "1",
		"version": "1379638734",
		"user_id": "",
		"year": "",
		"comment": "",
		"genre": "",
		"art_block": "0",
		"artist": {
			"@id": "34330",
			"value": "Jeremy Camp"
		},
		"album": {
			"@id": "18034",
			"value": "Restored"
		},
		"title": {
			"@id": "1858060",
			"value": "This Man"
		},
		"namespace": "1",
		"mbkey": "tw:smp:lyrics:205:1858060"
	}
	}



