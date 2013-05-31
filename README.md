#DOCUMENTATION#


# CLI Installation #

None

# Usage #

Using nodejs

# Introduction #

## 1.Nhacso.net ##

Their link's ids are encrypted in simple ways. They can be cracked by utilizing this func

```coffeescript
decode  = (id) ->
	a = ['bw bg bQ bA aw ag aQ aA Zw Zg'.split(' '),
	 	 'fedcbaZYXW'.split(''),
	 	 'NJFBdZVRtp'.split(''),
	 	 'U0 Uk UU UE V0 Vk VU VE W0 Wk'.split(' '),
	 	 'RQTSVUXWZY'.split(''),
	 	 'hlptx159BF'.split(''),
	 	 ' X1 XF XV Wl W1 WF WV Vl V1'.split(' ')]
	(id+'').split('').map((v,i)-> a[6-i][v]).join('')
```

EX: `song_id` : **345678** will become **XVxUVURX**


### a.Get links automatically###

We can grasp data with these links  

**Using CLI**  
<http://nhacso.net/download-nhac/link-tu-tao/=.1250000.html>  
`1250000` is `songid`. 

**Get cookie** `FPTID` and **Hash** `hash`
```bash
curl  https://id.fpt.net/\?display\=iframe -v
```
*USING `grep` and `sed`*  
```
curl -s https://id.fpt.net/\?display\=iframe -i | grep -i -E "FPTID\=[0-9a-zA-Z]+|id\=\"hash\" value\=\"" | sed -e 's/Set\-Cookie\: //' -e 's/\; path=\///' -e 's/\                    <input type\=\"hidden\" name\=\"hash\" id\=\"hash\" value\=\"//' -e 's/\" \/\>//'
```
**Get cookie** `Auth`  
```bash
curl  https://id.fpt.net/?display=iframe -d "hash=a9785186138d519050ea35a178b749ff&username=goofyfpt%40outlook.com&password=goofyfpt" -b "FPTID=j96g6to8r0qvcvgsmlnn04he43" -v
```
`bash` and `FPTID` have to be consitent  


```
curl -s https://id.fpt.net/\?display\=iframe -d "hash=a9785186138d519050ea35a178b749ff&username=goofyfpt%40outlook.com&password=goofyfpt" -b "FPTID=j96g6to8r0qvcvgsmlnn04he43" -i| grep -i 'Auth\=[0-9a-zA-Z\%]\+'| sed -e 's/Set\-Cookie\: //' -e 's/\; path\=\/\; domain\=\.fpt\.net\; httponly//'
```
**Get song** 
```bash
curl "http://nhacso.net/download-nhac/link-tu-tao/=.1250000.html" -o sample.mp3 -b Auth=V0JAaVlcZkNEXlwAECkcCzVFAgNVAhwuXgtnBwdbAkkEPF1UbQ
```
Remember the cookie `Auth=V0JAaVlcZkNEXlwAECkcCzVFAgNVAhwuXgtnBwdbAkkEPF1UbQ` is valid in 24h

**BONUS**  
Auto login  
```bash
http://nhacso.net/sso.php?id=1240090058&value=2&action=login&sid=V0JAb1ldb0NGV1wWQzIZUDtEQFoAAh81Bg1oRRBbFhwfLAMQag%3D%3D
```
Insert user-generated valid `Auth` .`id=1240090058` in the link above is not necessary. ONLY use session ID `Auth` to log into your acccount! BAM! Security LEAK!

###b.Song###
<http://nhacso.net/flash/song/xnl/1/id/XVxUVURX>  
  
<http://nhacso.net/song/parse?listIds=1250000>  

Direct link :  <http://nhacso.net/html5/song/id/X1pZUEVaaA==>

> `listIds`means you can pass parameters with the following pattern : `para1,para2,para3`  

<http://nhacso.net/artist/parse?listIds=5092,186,131,47,2088,2130,80,2407,17,55>  
> Get similar songs w.r.t. `song_id` X1pUUkFdaA , `5092,186,131,47,2088,2130,80,2407,17,55`are `artistId`

<http://nhacso.net/statistic/songlike?listIds=1251227>  
> Get `songlike`  

<http://nhacso.net/statistic/songtotallisten?listIds=1260796,1260795>  

> Get `songtotallisten` ; `1260796,1260795`are songIds  

<http://nhacso.net/statistic/songstatistic?listIds=1260796,1260795>  

> Get `songstatistic`; `1260796,1260795` are songIds  

> View page source to get the structure. XML Format  

###c.Video###
<http://nhacso.net/flash/video/xnl/1/id/X1xSV0Y>  
> `/id/X1xSV0Y` can be replaced by `id/14345`  

<http://nhacso.net/video/parse?listIds=14345>  

<http://nhacso.net/video/numbersub?listIds=14502%2C14506>  

> Get Subtitles 

<http://nhacso.net/statistic/videostatistic?listIds=14449>  

> Get `videostatistic`  

MISC:  
<http://nhacso.net/video/statisticview>  
> Request Method: `POST` , form data: `id:14449` <= increase song plays. Use cURL command `curl -XPOST http://nhacso.net/video/statisticview -d  "id=14449"`  

<http://nhacso.net/producer/getproducer>  
> Request Method: `POST` , form data: `listIds:10` <= get procedure. Use cURL command `curl -XPOST http://nhacso.net/producer/getproducer  -d "listIds=10"`  


###d.Album###
<http://nhacso.net/flash/album/xnl/1/uid/X1lWW0NabwIBAw==,W1pZWkVe>  
Use HTML5 <http://nhacso.net//html5/album/id/WF1VVEZf>  ªß
> Use on the last parameter only  

<http://nhacso.net/album/parse?listIds=17000>  

<http://nhacso.net/album/getstatistic?listIds=543996,543700,543565,542242>  

> Get album list stats  `543996,543700,543565,542242` are albumIds

<http://nhacso.net/statistic/albumtotallisten?listIds=543700>  

> Get `albumtotallisten`  

<http://nhacso.net/album/getstatistic?listIds=6884>  

> `getstatistic` of an album  

<http://nhacso.net/statistic/albumtotallisten?listIds=543700>  

> Get `albumtotallisten` <= aggregation of included songs

<http://nhacso.net/album/gettotalsong?listIds=533138%2C535960>  

> `gettotalsong` of an album  

<http://nhacso.net/album/getdescandissuetime?listIds=543996,543700,543565,542242>  

> `getdescandissuetime`: get description and issued moment  

<http://nhacso.net/album/getissuetime?listIds=447529,321676,310104,310102>  

> `getissuetime`

*DEFAULT ALBUMS*:   
<http://st.nhacso.net/images/album/thumb_album_120x120.jpg>  

###e.Misc###
**Get Category**
	
<http://nhacso.net/category/getcategory?listIds=1,2,4,5>  
> `getcategory` <= get list

**Get Lyric**
<http://nhacso.net/song/lyric?song_id=1100539>  

**Lastest Songs:**
<http://nhacso.net/top/latestsong?xnl=1>  

**Get Parse Amount Album:**
<http://nhacso.net/artist/parseamountalbum?listIds=54 >  

**Get Parse Amount Song of Artist**
<http://nhacso.net/artist/parseamountsong?listIds=54>  

**Get Artist**  
<http://nhacso.net/artist/parseamountsong?listIds=54>  
<http://nhacso.net/artist/desc?listIds=54>  
<http://nhacso.net/artist/parse?listIds=311>  
**Get Suggestion**
<http://nhacso.net/artist/parsesuggest?listIds=54>  
**Get issued time** 
<http://nhacso.net/album/getdescandissuetime?listIds=347553>  

*STATS:* Get song_id from 1 to 1.261.000 on Jan 11, 2012.   
On Jan 08, scan 541148 albums, filter and insert 165465 albums into database  
On Jan 11, scan 977721 songs; ~14016 videos ~500000 abums

**NOTE** they use `||` as a delimiter `Lê Minh Trung ||Như Ý`  

*MICS :* Check these links again

<http://nhacso.net/song/getobjectsong?id=945455>  
<http://nhacso.net/video/getobjectvideo?id=14300>  
> `type=POST` <= check in server script. Functions `getObjectVideo()`and `getObjectSong()`  

<http://nhacso.net/song/listen>  

> Request Method: `POST` , form data: `id:1142573` <= increase song plays. Use cURL command `curl -XPOST http://nhacso.net/song/listen -d  "id=1260645"`

---

## 2.Music.go.vn##

<http://music.go.vn/Ajax/RenderXmlHandler.ashx?sid=47278>  

* Get Song Data  
	<http://music.go.vn/Ajax/SongHandler.ashx?type=getsonginfo&sid=12343>  
	`type=getsonginfo`  
* Get Album Data  
	<http://music.go.vn/Ajax/AlbumHandler.ashx?type=getinfo&album=12999>  
	`type=getinfo`  
	<http://music.go.vn/Ajax/AlbumHandler.ashx?type=getsongbyalbum&album=17556>  
	`type=getsongbyalbum` - `album=[1..17556]` on 12-12-12
* Get Artist  
	<http://music.go.vn/Ajax/ArtistHandler.ashx?type=getsongartist&artist=23641>  
	`type=getsongartist`   
	<http://music.go.vn/Ajax/ArtistHandler.ashx?type=getalbumartist&artist=23641>  
	`type=getalbumartist`  
* Get Suggestion    
	<http://music.go.vn/Ajax/Suggestion.ashx?jsoncallback=&keyword=em%20ve%20dau&top=1&per=8&blacklist=Artist>  
	`keyword=em ve dau` -- `top=[1..100]` -- `per =`  
	<http://music.go.vn/Ajax/Suggestion.ashx?jsoncallback=&keyword=toi&top=100&per=4&blacklist=Artist>  

* Base URL: <http://farm11.gox.vn:8080/streams/>  

*STATS:* Total songs: 173733. Total albums: 17556 .  
Updated on December 12, 2012

---

## 3.Hcm.nhac.vui.vn ##

* Get Song  
	<http://hcm.nhac.vui.vn/asx2.php?type=1&id=299321>  
	`type=1` => song  

	<http://hcm.nhac.vui.vn/asx2.php?type=5&id=297053>  
	`type=5` => secret 320 kbps links  
* Get Album  
	<http://hcm.nhac.vui.vn/asx2.php?type=3&id=24000>  
	`type=3` => album  

* Access to different servers:  
	<http://music-hn.24hstatic.com/uploadmusic2/4312057e459982206e6d6e257c2c3bf3/5164734e/uploadmusic/id_le/2-2013/ngaln/Music/128/Hukkeunhukkeun%20Ttakkeunttakkeun%20-%20Tokyo%20Girl.mp3>
	`music-hn` - `music-hcm` - `m-nv-music`  - `nv-img-hcm` - `nv-ad-hcm` - `nv-ad-hn`  
	<http://hn.nhac.vui.vn/asx2.php?type=3&id=26873>  
	`hn.nhac.vui.vn` <=> `hcm.nhac.vui.vn`

*STATS:* ~279772 songs, ~24100 albums on Feb 02

---

## 4.Chacha.vn##
* Get Song  
	<http://www.chacha.vn/song/play/420343>  
	`song/play` <= insert `song_id`  

* Get Album  
	<http://www.chacha.vn/album/play/7333>  
	`play/id` <= insert `album_id`  
	NOTE: `http://s2.chacha.vn/artists//s5/309/309.jpg?v=0` <= look at property `thumb` to get  artist id  
* Get Thumbnail  
	<http://s2.chacha.vn/albums//s3/7223/7223.jpg?v=0>  
	<http://s2.chacha.vn/artists/s2/15/130088/130088.jpg>  
	*Note:* get thumbnail from albums or artists  
	`s0`,`s1`,`s2`,`s3`,`s4`,`s5` are sizes.   
	`0 => original`, `1 => 640x640px`, `2 => 320x320`, `3 => 150x150`, `4 => 100x100`, `5 => 50x50`

<http://audio.chacha.vn/songs/output/71/586908/2/s/duc-vong%20-%20Thanh%20Dai%20Sieu.mp3>
<http://audio.chacha.vn/songs/output/71/586908/4/s/duc-vong%20-%20Thanh%20Dai%20Sieu.mp3>

Notice `2` and `4` 

The rule of finding the link of mp3 file:  

```coffeescript
http://audio.chacha.vn/songs/output/71/586908/2/s/ - .mp3?s=1
http://audio.chacha.vn/songs/output/71/586908/4/s/duc-vong - Thanh Dai Sieu.mp3
http://audio.chacha.vn/songs/output/71/586906/2/s/ - .mp3?s=1
http://audio.chacha.vn/songs/output/71/586906/2/s/doi-mat-nguoi-xua - Dan Nguyen.mp3?s=1
http://audio.chacha.vn/songs/output/71/586736/2/s/ - .mp3?s=1
http://audio.chacha.vn/songs/output/71/586736/2/s/bien-noi-nho-va-em - My-Linh.mp3?s=1
http://audio.chacha.vn/songs/output/53/2/s/ - .mp3
http://audio.chacha.vn/songs/output/53/2/s/va-em-da-biet-minh-yeu - Ho-Ngoc-Ha.mp3
```

 

<http://audio.chacha.vn/songs/output/71/586908/2/s/ - .mp3?s=1>  

*STATS:* ~313875 songs, ~ 4396 albums on Jan 31

--- 

## 5.Nghenhac.info ##
* Get Album  
<http://nghenhac.info/Album/joke-link/20697/.html>  
<http://nghenhac.info/Farm/PlayAlbumJson.ashx?p=7BB61600815BA707>  

XML-Format : <http://nghenhac.info/Farm/PlayAlbum.aspx?p=0DD9A357E02601E1>  
not complete

*STATS:* ~193285 songs, ~16084 albums on Feb 04

---

##6.Vietgiaitri.com - JUNK##
* Get Album  
<http://nhac.vietgiaitri.com/album-nhac/-4471.vgt>  
<http://img.vietgiaitri.com/music.php?act=xml&sm=a593b5ed00bd1442bc6741cab4bdda2b&time=1357584049&uid=0&gid=2&aid=6899&repeat=always>  
	`aid=` <= insert number, temporary link

*STATUS:* circa 8000 songs. This site will be ignored.

---

## 7.Nhac.hay365.com - JUNK##
* Get Song  
	<http://static.hay365.com/song_43151.xml>  

* Get Album
	<http://static.hay365.com/album_3369.xml>  
	`album_3369` <= change number  --- ~3300 albums

*STATUS:* circa 50000 songs. This site will be ignored.

---

## 8.Music.vnn.vn - JUNK##
* Get Album  
<http://music.vnn.vn/vdco/albums/p/48.htm>  
<http://music.vnn.vn/album/5380/.htm>  
<http://music.vnn.vn//XML/Album/2013/1/album-huong-lan-mo-lai-vang-trang20130108020942.xml>  
	not complete  

*STATUS:* greater than 10^3 albums and about 800 songs. This site will be ignored.

---

## 9.Nghenhacmoi.net - JUNK ##
* Get Album  
	<http://nghenhacmoi.net/music/xml/3/701.xml>  
	Note: just thousands of songs, ~700 albums 

*STATUS:* greater than 700 albums. This site will be ignored.

---

## 10.Nhacvang.net - JUNK ##
* Get Album  
	<http://nghenhacvang.net/playplaylist/5725.xml>  
	~5000 albums  

	<http://nghenhacvang.net/play/3111.mp3>  
	<http://sv.nghenhacvang.net/data/1euuluxqhtfyitrv/2013/03/PH047%20-%20Chon%20Xua%20Em%20Ve/04.%20Moi%20Em%20Ve%20-%20Ngoc%20Lan.mp3>

---

## 11.Chiasenhac.com##
**Get song**
<http://playlist.chiasenhac.com/nghe-album/your-link~1061516.html>  
Crawl .html to get the value "decodeURIComponent"
```bash
http://data.chiasenhac.com/downloads/1026/3/1025225-5bdcd546/320/Noi%20Tinh%20Yeu%20Bat%20Dau%20-%20Bang%20Kieu_%20Lam%20An.mp3
```
Get quality `320kps`,`128kps` or `32kps` `quality.php?q=320&redirect=mp3/vietnam/v-pop/your-link~1025225.html`

## 12.Music.yeucahat.com ##
**Get album**
<http://music.yeucahat.com/mp3/vietnamese/91432-your-link.html>  
Crawl .html to get the value "decodeURIComponent" 
```bash
http://data.yeucahat.com/downloads/92/3/06fea2c2b85d7c0e57eea7efe46d608e/Ng…n%20Long%20Phung%20Xum%20Vay%20-%20Khoi%20My_%20%28www.YeuCaHat.com%29.mp3
```
<http://download.chiasenhac.com/download.php?m=93404>  
<http://download.chiasenhac.com/download.php?m=1094220>   

```bash
curl 'http://download.chiasenhac.com/download.php?m=1067123' --silent -H 'Cookie:  csn_sid=ca404dfca9556f5830b5fb96add51691;' | grep Download | grep '<a href="http:'  
``` 

NOTE: THE LINK  
`http://data.chiasenhac.com/downloads/1031/#{days of week}/1030109-056c7572/320/joke-link.mp3` 

`0` => `Sunday`,`1` => `Monday` ..... `5` => `Friday`, `6` => `Saturday`  

---

## 13.Keeng.vn ##
* Get album
	<http://www.keeng.vn/album/album-moi.html?page=160>  
	> crawl page. CURRENT max page is 792 to get AlbumId  
	<http://www.keeng.vn/album/get-album-xml?album_identify=2673C7B2>  
	Notice: crawl from page 1..792 ordered by album-moi, started with album `Hit K-Pop Tháng 1/2013` on Jan 31  
* Get Video
	about 20k videos

*STATS:* get ~17721 albums, ~132052 songs on Feb 7


---

## 14.Mp3.zing.vn ##

### Decode id ###

Turn `ZW6W7IUO` into `1382183235`  

```coffeescript
convertToInt = (id)->
	a = "0IWOUZ6789ABCDEF".split('')
	b = "0123456789ABCDEF"
	parseInt id.split('').map((v)-> b[a.indexOf(v)]).join(''), 16
```

### Analyzing encrypted id ####

The format is `ZGJGTknazzupuzaTZDJTDGLG`  

1.Create matrix Mx24 : M album items & 24-character string  

```coffeescript
1381585029 => "LHJnyknNBNALJbuTLbxTDmkH"
1381585030 => "LGxGTLHadNALJVHykFcTFnLn"
........................................
1381585043 => "knJHyLGNdNAkJSdtLDJtFnZG"
1381585044 => "ZncGyLnsBaSkJAltZbctFGkm"
```
2.Invert the matrix and find the repeated characters in each row. The more M rows are fetched, the more precise they are. Tested with ~70000 albums EX: a inversed matrix of 50x24 gonna be  

```coffeescript
LLkZZZkLLLLLkZLZLkZLkLLZZkLLLkkkLZLLLkZLZZkZLZLZZL:0 => "LZk"
HGHnnHmmHGnHnnnHGmHGmmnnmGHnHHmHmmHGmHnGHmmmGmGGmG:1 => "GHmn"
JxxJxcJccJcJJcccJJJJxJJxccJcJJJJJcxxcccxJJxJJxxcJx:2 => "Jcx"
nGGnnmnmmGGnHGnGmmGmmmHHmGmHHnHHHmHmmmnnnGGGHmHmHG:3 => "GHmn"
yTyyttTtttyyyyyyytyytTyyTtyttyytytTyytyTTyytTyyTtT:4 => "Tty"
kLkLLZkLLkZLLLkLLkLkkLLkLZLLkLZZkLLLLkLZkZLkkZLLLL:5 => "LZk"
nHHHnnnGHmmmGnGGHGnHHHnnGnmGmmHnmHGGHHnnmHnmmHHmnG:6 => "GHmn"
NaNsaNsaNNaNNsNNNNNsNaNNNsNNsaaaNNNaNNNsNsNaaNasaN:7 => "Nas"
BdVdVddVVdBddBdVVBBBVBdBBddVdVVddBdddVddBdBVdddVdd:8 => "BVd"
NNssNNsNsNNNNaNaNaNsNsNNNNsasNaNNsaaNasNsaNNasaNaN:9 => "Nas"
AAzzAzSzlSSSASAllSSSAAASzlSSASzzlSzlAASSSAAlSzSzlz:10 => "ASlz"
LLkZLLZLLLkkkkZZZLLLkZkkZLLkkkLLLLLLLLLZZLkZkZLkZk:11 => "LZk"
JJcxccJxJxxxJJxJxJJccxcxxJcJxcxcxJcxxxJcJJcJJcJcJx:12 => "Jcx"
bVBVdVddBVdzSAASllzWQpQWWWppghXhhXgCasNaaNaNscxxJc:13 => "ABCJNQSVWXabcdghlpsxz"
uHZbBlQXNJuLdlpXaJiGZDdSpgsxHkvdSQNinLDdQgNJRGLDdp:14 => "BDGHJLNQRSXZabdgiklnpsuvx"
TyTyyyyytyTyttytytyyyyyttTTytyTtTyyTTtyTtyyytTyyyT:15 => "Tty"
LkZLkLZkLLLLLZLkkLLZLLZLLZLLLLLLLLLkkkLLZkkLZZLkLk:16 => "LZk"
bFFFDFbDFFbvDbFFbDbbFDvbvDvFvDvbDFDDDDDvbDbDFDvFFb:17 => "DFbv"
xccJcJxJJcxxJcJcJJJcxJJxJJJJJcJJccJcJccccxJJxcxJJx:18 => "Jcx"
TTytyytyTyyyttTTttttyyyTTyyyyyTyyyytTyTyTytyTTTtyy:19 => "Tty"
DFDFFDbDDFDFFFvDDDDbDDDvbFbbbDvbDDFbDbvvFvFFDFbbDD:20 => "DFbv"
mnmHmnnmGnGGnGnnGmHmGmnnHnnHmGmGGnmnmHHGmnGGmHmHnG:21 => "GHmn"
kLLLLkkLLZLLZkkZLLkLLLLLZZLkZZLZZLZLLLLZZkkLZZLZLZ:22 => "LZk"
HnnGnHnnnHnHGmmHmnnHGHmmnnmmmmmHHnHmnHGHmGmGmHHHmm:23 => "GHmn"
```  

3.It's showed that each single character in the group `LZk` represents a same symbol (number or character or whatever). There are 11 groups : `GHmn`, `LZk`, `DFbv`, `BVd`, `ASlz`, `QWp`, `ghXC`, `Nas`, `Jcx`, `ERui` and `Tty`. Try with different number of albums. We will see the patterns at position 15,14,13... tend to vary in size as we increase the number of albums in ascendant order. EX: result of 50000x24 matrix  

```coffeescript
0 => "LZk"
1 => "GHmn"
2 => "Jcx"
3 => "GHmn"
4 => "Tty"
5 => "LZk"
6 => "GHmn"
7 => "Nas"
8 => "BVd"
9 => "Nas"
10 => "ACEJNQRSWXacghilpsuxz"
11 => "ABCDEFGHJLNQRSVWXZabcdghiklmnpsuvxz"
12 => "ABCDEFGHJLNQRSVWXZabcdghiklmnpsuvxz"
13 => "ABCDEFGHJLNQRSVWXZabcdghiklmnpsuvxz"
14 => "ABCDEFGHJLNQRSVWXZabcdghiklmnpsuvxz"
15 => "Tty"
16 => "LZk"
17 => "DFbv"
18 => "Jcx"
19 => "Tty"
20 => "DFbv"
21 => "GHmn"
22 => "LZk"
23 => "GHmn"
```

4.We see that if the 14th pattern reaches to 35-character length, it gonna stay the same, the the 13th continue to vary until it reached its limit. The same thing applies to 13th pattern. So the question is which position it gonna stop. We find out 10 groups from `GHmn` to `ERui` has total characters of 35. They equal the limit of 14th pattern.Moreover, the group `Tty` does not exist in the 14th pattern. Therefore we can assume it can be served as a delimiter or something else. 10 groups maybe represent base ten, so the boundary can be assumed from 4th to 15th. Next step, we observe the length from 5th to 14th is equal to 10. It is coincident to the length of aid (album_id showed in number) (EX: 1381585030). So our assumption is perhaps correct. The problem now is to find a  mapping of each group to single digit in base 10. Find two consecutive albums and look at the change in the 14th position of aid in the albums, hence we have the example hash table:  
```coffeescript
1381585330 => "LnJmyknNdNSvZBHTkDJTvHkn" : 14th position is "H"
1381585331 => "kmJmTLHsdalFLVLyLDJTbGZG" : 14th position is "L"
........................................
1381585339 => "kncmTkHsdsAvkduyLFJyDnLG" : 14th position is "u"
```

5.We come to an order of 10 groups as `GHmn`<`LZk`<`DFbv`<`BVd`<`ASlz`<`QWp`<`ghXC`<`Nas`<`Jcx`<`ERui`. They are equivalent to the digits from 0,1,2 to 9. EX: we test with the string `LnJmyknNdNSvZBHTkDJTvHkn`(1381585330). At firstly remove the trivial positions from 0 to 4, 15 to 23 as the group `Tty` is the delimiter to get `knNdNSvZBH` and convert it into nummerical system. We have `1073742130`. The difference between the result and the original number is `307843200`.   

6.It is almost complete. Now given a real album_id, ex: `1382365302` . We subtract by `307843200` and generate from the calculated result to get string which each digit is equivalent to each group. Finally it is end up with `ZGJGTknazpbbknbTZDJTDGLG` <http://m.mp3.zing.vn/xml/song/ZGJGTknazpbbknbTZDJTDGLG>  

```coffeescript  
encryptId = (id) ->
	a = "GHmn|LZk|DFbv|BVd|ASlz|QWp|ghXC|Nas|Jcx|ERui|Tty".split("|") 
	[1,0,8,0,10].concat((id-307843200+'').split(''),[10,1,2,8,10,2,0,1,0]).map((i)-> 
		a[i][Math.random()*a[i].length|0]).join('')
```

EX: Run `encryptId(1381585458)` -> `ZGJGykHsVNSDvQJtkDcTbHkH`  

### Brutal Search ###

* Using search (not recommended)
<http://mp3.zing.vn/suggest/search?term=toi>  
> `term` is artist or song in database

* Scan whole albums in artist profile
> <http://mp3.zing.vn/nghe-si/Dam-Vinh-Hung/album>  

### Album encrypted links###

*Step 1:* Get album-xml: 
```bash
http://mp3.zing.vn/xml/album-xml/LHxnyLGNVJkxubJTLvctbmLG
```
*Step 2:* Get static, constant links. For instance:
```bash
http://mp3.zing.vn/xml/load-song/MjAxMyUyRjAxJTJGMDQlMkY2JTJGOSUyRjY5OWMxNDFjODgyZTBmMWVjODNkMmE2Yjk1MmUyMjQwLm1wMyU3QzI=
```  
> It'll redirect to a new temporary location

*Step 3:* Get temp link (being expired in 6h)
```bash
http://stream2.hot2.cache11.vcdn.vn/fsfsdfdsfdserwrwq3/3b9e3d4f06d2df09cc8da402c00ae49e/5108fcdc/2013/01/04/6/9/699c141c882e0f1ec83d2a6b952e2240.mp3
```
Notice link like this
```bash
http://stream2.hot2.cache11.vcdn.vn/fsfsdfdsfdserwrwq3/4ce95480fb0b141aba6d059d0591fa3c/5108a15e/2013/01/04/6/9/699c141c882e0f1ec83d2a6b952e2240.mp3
```
only available in 6hours due to the consistency between the hash `4ce95480fb0b141aba6d059d0591fa3c` and the timestamp `5108a15e` => `timestamping`

### Get resources ###

* Get album  
<http://mp3.zing.vn/xml/album-xml/LGxnyLnsVcbZDdbtLvJyvGLG>  
<http://m.mp3.zing.vn/xml/album/LGxnyLnsVcbZDdbtLvJyvGLG>  
<http://mp3.zing.vn/html5/album/LHJHykHsdaJLxnsyyFmZm>  

* Get song  
<http://m.mp3.zing.vn/xml/song/ZGJGTknazzupuzaTZDJTDGLG>  
<http://mp3.zing.vn/download/song/Chi-Con-Lai-Tinh-Yeu-Bui-Anh-Tuan/ZGJGyLGNldSnHdptLDcyvmLn>  
**the encrypted links**  
<http://mp3.zing.vn/xml/load-song/MjAxMSUyRjAyJTJGMjIlMkZlJTJGYSUyRmVhMWI5OTU4YWY5MTM5YjA2ODE5MTU2NzFlMjVhN2JiLm1wMyU3QzI=>  
<http://m.mp3.zing.vn/xml/song-load/MjAxMSUyRjAyJTJGMjIlMkZlJTJGYSUyRmVhMWI5OTU4YWY5MTM5YjA2ODE5MTU2NzFlMjVhN2JiLm1wMyU3QzI=>    
<http://mp3.zing.vn/html5/song/ZnJHyLHadixLdbDyTbHLH>  
* Get video  
<http://mp3.zing.vn/xml/video-xml/kGJmykGaBaavclGykbcybmLn>  
<http://mp3.zing.vn/html5/video/ZGJmykHslWmJsmZySJmybGZm>  
```bash
http://channelz.mp3.zdn.vn/zv/0da2d1cd79cb1ed7e303c032c86fd20b/5111e350/file_uploads/video/2010/9/23/3/8/38a4b0133afa3796f3f4d443d6f88c72.mp4
```
This link will be regenerated in every 6h.  
At first, the webserver will rewrite the URL to new location `http://channelz.org.mp3.zdn.vn/....` .   
Secondly, it actually loads balancing among the hosts: `http://channelz1.org.mp3.zdn.vn/...` where subdomain `channelz1` is in `[1,2,7,8,9]`

* Get full thumbnail  
<http://image.mp3.zdn.vn/thumb/165_165/covers/6/e/6e47d27c9f2f2caecedae2c64b934cda_1289472556.jpg>  
=> remove the `thumb/165_165` to get the full URL

* Get lyrics  
<http://mp3.zing.vn/ajax/lyrics/lyrics?from=0&id=ZW6OFZ70&callback=zmCore.js270375>  
=> JSONP. Remove callback func to get JSON `http://mp3.zing.vn/ajax/lyrics/lyrics?from=0&id=ZW6OFZ70&callback=`  
=> param `from=0` means lyric version  
Get lyrics for videos  
<http://mp3.zing.vn/ajax/lyric-v2/lyrics?id=ZW6UF98O>  
Get all lyrics for videos by inserting parameter `from=0`  
<http://mp3.zing.vn/ajax/lyric-v2/lyrics?id=ZW6UF98O&from=0>   

### Notice ###

Lyric has supported many verions  

### Statistics ###

~421984 songs, ~42677 albums, ~10695 artists, ~29366 videos on Feb 7

## 15.Store.zing.vn ##

```coffeescript
ONES = ['A','E','I','M','Q','U','Y','c','g','k']
TENS = ['MD','MT','Mj','Mz','ND','NT','Nj','Nz','OD','OT']
HUNDREDS = ['w','x','y','z','0','1','2','3','4','5']
THOUSANDS = ['A','E','I','M','Q','U','Y','c','g','k']
TENSOFTHOUSANDS = ['MD','MT','Mj','Mz','ND','NT','Nj','Nz','OD','OT']
HUNDREDSOFTHOUSANDS = ['','MC0x','MC0y','MC0z','MC00','MC01','MC02','MC03','MC04']
```
* Get Song  
	<http://store.zing.vn/mediaxml?mediaId=MC02MzU2MDc=>  
	`mediaId=MC02MzU2MDc=` <=> `mediaId=735607=` . Notice the equal sign  

---

## 16.Nhaccuatui.com ##
* Scan artist profile
link gonna expire in 12h

Check duplicated albums in database. EX: albumid `I1umglqa8dMM` has 2 performers. Check it out and correct later!

* Get Album
<http://www.nhaccuatui.com/flash/xml?key2=7ab190e6723074e9de3eb1389724facc>  
*Get albums' plays* 
<http://www.nhaccuatui.com/wg/get-counter?listPlaylistIds=10779538,10582398>  

**ALBUMS** means both videos and songs

* Get Song
<http://www.nhaccuatui.com/flash/xml?key1=8e95adfc88e89bd150b6e7ac780e4039>  
*Get songs' plays* 
<http://www.nhaccuatui.com/wg/get-counter?listSongIds=>  

* Thumbnail  
<http://p.img.nct.nixcdn.com/playlist/2012/12/20/0XehgKp67tZ5.jpg>  
<http://avatar.nct.nixcdn.com/playlist/2012/12/20/0XehgKp67tZ5.jpg>  
=> Same file, same host => `ip=123.30.134.21`    

Changing resolution of an image: add _640 before the file extension  
<http://avatar.nct.nixcdn.com/mv/2013/02/21/3/5/c/f/1361418082787_640.jpg>  
<http://avatar.nct.nixcdn.com/mv/2013/02/21/3/5/c/f/1361418082787.jpg>  

* Get Lyrics  
<http://www.nhaccuatui.com/ajax/get-lyric?key=2414745>  


*STATS* ~251797 songs, ~26853 albums, ~ 21057+119647 videos on feb 10

* Checking the hidden values: `inpHiddenSongKey`, `inpHiddenId`, `inpHiddenType`, `inpHiddenGenre`, `inpHiddenSingerIds`, `inpLyricId`  in every song, album or music video  

* Download song  
<http://www.nhaccuatui.com/download/song/G6DYEW6ts4zq>

**Notice: the pair (songid,albumid) gonna be duplicated while updating new albums. Be careful when use it**

---

## 17. ZAZOO.IT ##

* Content link: <http://www.zazoo-music.com/HomepagePanel3.aspx>  

* Get lyric of a link  
 LINK: <http://lyrics.zazoo.it/getlyrics>  
 METHOD: POST  

 ```json
 values={"format":"timed","keyword_id":"615596","clip_id":"67319","artist_name":"Backstreet Boys","song_title":"Backstreet Boys - As Long As You Love Me","page_title":"Backstreet Boys - As Long As You Love Me - YouTube","clip_url":"http://www.youtube.com/watch?v=0Gl2QnHNpkA","request_id":"m2rvh01xuu40a4i_698","duration_ms":219000,"view_count":14100406,"upload_date":"May 25, 2011"}  
 -----------------  
 values={"format":"timed","keyword_id":"","clip_id":"","artist_name":"","song_title":"","page_title":"","clip_url":"http://www.youtube.com/watch?v=6M6samPEMpM","request_id":"","duration_ms":0,"view_count":0,"upload_date":""}
 ```

* Get singer list  
 METHOD = POST (singer started with 'g')  
 LINK = http://api.zazoo.it/api/playlists/artists/  
 FORM = APIKey=23fdffd9fd764cb&ElementID=ArtistsBodyContent&KeywordID=0&ClipID=0&StartingLetter=g& ResultsLimit=0&PlaylistID=21  

* Get artist image  
 "http://cdn.zazoo.it/Images/Authors/615354.jpg"  
 `615354.jpg` from artist list  

* Get clip in Artist File
 METHOD = POST // test with GET method  
 LINK = http://api.zazoo.it/api/playlists/artists/clips/  
 FORM = APIKey=23fdffd9fd764cb&ElementID=ClipBodyContent&KeywordID=615354&ClipID=0&StartingLetter=& ResultsLimit=-1   

---

## 18.iCine.vn ##

* Get mp4 movie

```bash
rtmpdump -r "rtmpe://118.69.196.80:1935/VoD/cot-moc-23\850.mp4" -W "http://icine.vn/jwplayer/player1.swf" -p "http://icine.vn/a/watch-movie?movieId=2954" -o film.mp4
```
```bash
rtmpdump -r "rtmpe://118.69.196.80:1935/VoD/cot-moc-23\850.mp4" -o film.mp4
```

* Get files:  
<http://icine.vn/a/watch-movie?movieId=3387>  
1.view source => `iCinePlayer("MCwwLGZsaWdodCwzMzg3LDEsLTEsLTEsMCwy");`  
2.decode `Base64.decode('MCwwLGZsaWdodCwzMzg3LDEsLTEsLTEsMCwy')`   
3.get the file name from `"0,0,flight,3387,1,-1,-1,0,2"`   
4.play the file using the rmtpe <http://icine.vn/jwplayer/playlist/flight-vip.xml>  
5.or to get ordinary file <http://icine.vn/jwplayer/playlist/flight.xml>  
6.get sub <http://icine.vn/jwplayer/sub/flight-vn.srt>  
7.check the `crossdomain.xml`

http://icine.vn:1935/mediacache/_definst_/smil:http22/dragon-fight/playlist.smil/jwplayer.smil

`first10mPlayed = function(){}`  

<http://icine.vn/a/iCineWebDetail?id=1771&securecode=9cf03aee837fe1af94b60e8db0dabb39>   

`loadVideo("http://icine.vn:1935/mediacache/_definst_/smil:http22/the-hobbit--an-unexpected-journey/playlist.smil/jwplayer.smil")`  

loadVideo function in `http://icine.vn/js/pls.js`  

`SECRET_KEY:String = "secrete123!@#";    MD5.hash((_local3 + this.SECRET_KEY));`
for example `217secrete123!@#`

---

## 19.Movies.hdviet.com ##

* Get files  

1.Decrypt files using RC4 func  
2.Get source : <http://movies.hdviet.com/2498.xml?lucdebug=true>  
3.If the para `lucdebug=true` is disable then decrypt the file whose password is `HDVN@T@oanL@c`  
4.Decrypt the `m3u8` file using `hdviet123#@!` EX:
<http://ncs06.vn-hd.com/02022013/Deadwood_S02/E001/playlist_1280.m3u8>  

```bash
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=700000,CODECS="avc1.66.30,mp4a.40.2",RESOLUTION=480x270
480.m3u8
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1000000,CODECS="avc1.66.30,mp4a.40.2",RESOLUTION=640x360
640.m3u8
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1500000,CODECS="avc1.77.31,mp4a.40.2",RESOLUTION=800x450
800.m3u8
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=2000000,CODECS="avc1.77.31,mp4a.40.2",RESOLUTION=1024x576
1024.m3u8
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=2700000,CODECS="avc1.100.41,mp4a.40.2",RESOLUTION=1280x720
1280.m3u8
```    

5.Decrypt the files at different resolutions. Ex:  
<http://ncs06.vn-hd.com/02022013/Deadwood_S02/E001/1280.m3u8>  

```bash
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-MEDIA-SEQUENCE:0
#EXT-X-ALLOWCACHE:1
#EXTINF:7.841167,
1280/Deadwood_S02_E001_1280_0.ts
#EXTINF:5.922589,
1280/Deadwood_S02_E001_1280_1.ts
#EXTINF:5.880878,
1280/Deadwood_S02_E001_1280_2.ts
#EXTINF:5.880878,
1280/Deadwood_S02_E001_1280_3.ts
.................................
#EXTINF:5.485667,
1280/Deadwood_S02_E001_1280_489.ts
#EXT-X-TARGETDURATION:8
#EXT-X-ENDLIST
```
6.Change the relative urls to absolute ones.   EX `1280/Deadwood_S02_E001_1280_0.ts` to

```bash
http://ncs06.vn-hd.com/02022013/Deadwood_S02/E001/1280/Deadwood_S02_E001_1280_0.ts
```  
**Note** `http://ncs01.vn-hd.com/` server'll load balances between `ncs01.vn-hd.com`...`ncs09.vn-hd.com`  
7.Play `m3u8` file   
8.Decode VNese subtiltes using the pass `6e28cec025af4ff790c8337d5190184e`   

---

## 20.iphone.uphim.vn ##

* Get files

1.use user-agent to fool the server  

```bash
curl "http://iphone.uphim.vn/xem-phim-joke-link-m-2323-p-1.html" --user-agent "Mozilla/5.0 (iPhone; U; CPU iPhone"
```  
```bash
curl "http://iphone.uphim.vn/xem-phim-joke-link-m-311-p-1.html" --user-agent "Mozilla/5.0 (iPhone; U; CPU iPhone" --cookie "OAID=db6333b40159517a1a4fbaac928396ab; x_sessionid=fb835813c3b2224da2ea56ebda6ab7ac;"
```  

2. get `eval(function(p,a,c,k,e,d){...}` in the script and decode the `dean edwards packer`  
3. get `m3u8` file

---


# FETCH ALL ALBUMS FROM NHASO.NET WITH NODE.JS

Type in CLI, change the directory which contains these files, default is `~/Box Documents/Sites/nodejs`

- To create tables : `node createAlbumTable.js add`
- To delete tables : `node createAlbumTable.js delete`
- To get all albums from id 1 to id 2: `node fetchdatafromNS.js No1 No2`    
where `No1` is the first Id and `No2` is the last
EX: `node fetchdatafromNS.js 500000 502000` <- can run parallelly 3 programs 


# ELASTICSEARCH

## Couchbase

Install the couchbase nosql database

## MySQL

Run `bin/elasticsearch -f` , install plugin on [github>  

```
curl -XPUT 'localhost:9200/_river/ns_song/_meta' -d '{
    "type" : "jdbc",
    "jdbc" : {
        "driver" : "com.mysql.jdbc.Driver",
        "url" : "jdbc:mysql://localhost:8889/anbinh",
        "user" : "root",
        "password" : "root",
        "sql" : "select * from ns_song"
    },
    "index" : {
        "index" : "jdbc",
        "type" : "jdbc"
    }
}'
```

Notice: `ns_song`, choose `localhost:8889`, database `anbinh` , username `root`, password `root`, select all from table `ns_song`, choose index `jdbc` and type `jdbci`


