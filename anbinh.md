# TOC
   - [THE WEBSITE MP3.ZING.VN](#the-website-mp3zingvn)
     - [Song ID: ZW6ZC807](#the-website-mp3zingvn-song-id-zw6zc807)
     - [Album ID: ZWZAAIW0](#the-website-mp3zingvn-album-id-zwzaaiw0)
   - [THE WEBSITE NHACSO.NET](#the-website-nhacsonet)
     - [Song ID: X1pZVkpYbg](#the-website-nhacsonet-song-id-x1pzvkpybg)
     - [Album ID: WF5YUEVY](#the-website-nhacsonet-album-id-wf5yuevy)
     - [Video ID: X15RV0N](#the-website-nhacsonet-video-id-x15rv0n)
<a name=""></a>
 
<a name="the-website-mp3zingvn"></a>
# THE WEBSITE MP3.ZING.VN
<a name="the-website-mp3zingvn-song-id-zw6zc807"></a>
## Song ID: ZW6ZC807
should be encoded into 1382402055, has plays, topic and no author.

```js
var link, songid;
zing.connect();
songid = 1382402055;
link = "http://mp3.zing.vn/bai-hat/joke-link/" + (zing._convertToId(songid)) + ".html";
return zing._getFileByHTTP(link, function(data) {
  var arr, _i, _len, _song, _topic, _topics;
  _song = {
    sid: songid,
    songid: zing._convertToId(songid)
  };
  if (data.match(/Lượt\snghe\:.+<\/p>/g)) {
    _song.plays = data.match(/Lượt\snghe\:.+<\/p>/g)[0].replace(/Lượt\snghe\:|<\/p>|\./g, '').trim();
  } else {
    _song.plays = 0;
  }
  if (data.match(/Sáng\stác\:.+<\/a><\/a>/g)) {
    _song.author = encoder.htmlDecode(data.match(/Sáng\stác\:.+<\/a><\/a>/g)[0].replace(/^.+\">|<.+$/g, '').trim());
  } else {
    _song.author = '';
  }
  if (data.match(/Thể\sloại\:.+\|\sLượt\snghe/g)) {
    _topics = data.match(/Thể\sloại\:.+\|\sLượt\snghe/g)[0].replace(/Thể\sloại\:|\s\|\sLượt\snghe/g, '').split(',');
    arr = [];
    for (_i = 0, _len = _topics.length; _i < _len; _i++) {
      _topic = _topics[_i];
      arr.push(_topic.replace(/\<a.+\"\>|\<\/a\>/g, '').trim());
    }
    _song.topic = JSON.stringify(arr);
  } else {
    _song.topic = '';
  }
  if (data.match(/xmlURL.+/)) {
    _link = data.match(/xmlURL.+/)[0].match(/http:\/\/mp3\.zing\.vn\/xml\/song-xml\/[a-zA-Z]+/)[0];
    _link = _link.replace(/song-xml/, 'song').replace(/mp3/, 'm.mp3');
  }
  song = _song;
  expect(song.songid).to.equal("ZW6ZC807");
  expect(parseInt(song.plays, 10)).to.match(/\d+/);
  expect(song.author).to.equal("");
  expect(song.topic).to.equal('["Âu Mỹ","Pop","Audiophile"]');
  return done();
});
```

should be called Meditation, composed by Olivia Ong, created on 2013-04-07, has link and path.

```js
zing.connect();
return zing._getFileByHTTP(_link, function(data) {
  var created, i, path, testArr, _i, _ref, _ref1, _str;
  data = JSON.parse(data);
  song.song_name = data.data[0].title.trim();
  song.song_artist = JSON.stringify(data.data[0].performer.trim().split(','));
  song.song_link = data.data[0].source;
  _str = song.song_link.replace(/^.+load-song\//g, '').replace(/^.+song-load\//g, '');
  testArr = [];
  for (i = _i = 0, _ref = _str.length - 1; _i <= _ref; i = _i += 4) {
    testArr.push(zing._decodeString(_str.slice(i, i + 4)));
  }
  path = decodeURIComponent(testArr.join('').match(/.+mp3/g));
  created = (_ref1 = path.match(/^\d{4}\/\d{2}\/\d{2}/)) != null ? _ref1[0].replace(/\//g, "-") : void 0;
  song.path = path;
  song.created = created;
  expect(song.song_name).to.equal('Meditation');
  expect(song.song_artist).to.equal('["Olivia Ong"]');
  expect(song.song_link).to.equal('http://m.mp3.zing.vn/xml/song-load/MjAxMyUyRjA0JTJGMDclMkY3JTJGNCUyRjc0ZGQ3YWM4MzMyNTQxZDEwNjNhNTg4MGM5MWU1NGQxLm1wMyU3QzI=');
  expect(song.path).to.equal('2013/04/07/7/4/74dd7ac8332541d1063a5880c91e54d1.mp3');
  expect(song.created).to.equal('2013-04-07');
  return done();
});
```

<a name="the-website-mp3zingvn-album-id-zwzaaiw0"></a>
## Album ID: ZWZAAIW0
should be called "Anh Muốn Quay Lại... Đến Khi Nào" and has certain properties.

```js
var albumid, link;
zing.connect();
albumid = 1381671200;
link = "http://mp3.zing.vn/album/joke-link/" + (zing._convertToId(albumid)) + ".html";
return zing._getFileByHTTP(link, function(data) {
  var result;
  result = zing._processAlbum(albumid, data);
  expect(result.albumid).to.equal("ZWZAAIW0");
  expect(result.album_name).to.equal("Anh Muốn Quay Lại... Đến Khi Nào");
  expect(result.album_artist).to.equal('["Khắc Việt"]');
  expect(result.topic).to.equal('["Việt Nam","Nhạc Trẻ"]');
  expect(parseInt(result.plays, 10)).to.match(/\d+/);
  expect(parseInt(result.released_year, 10)).to.equal(2013);
  expect(parseInt(result.nsongs, 10)).to.equal(2);
  expect(result.album_thumbnail).to.equal('http://image.mp3.zdn.vn/thumb/165_165/covers/5/2/5284f196b781e762b443f762a612172f_1365388107.jpg');
  expect(result.description).to.equal('“Đến khi nào”. “Anh muốn quay lại” là nỗi nhớ người yêu da diết được Khắc Việt chuyển tải qua giai điệu sâu lắng từ đầu đến cuối. Đúng như tựa đề, “Anh muốn quay lại” như một đề nghị muộn màng khi tình cảm đã chia ly. Trong khi đó “Đến khi nào” lại là một tình yêu rộng lượng của người con trai sẵn sàng hy sinh để đem lại hạnh phúc cho người mình yêu. Việc sử dụng điệp từ “Đến khi nào” nhiều lần trong ca khúc cùng tên khiến cho người nghe đồng cảm nhiều hơn với tình yêu chung thủy của chàng trai trong ca khúc này. ');
  expect(result.created).to.equal("2013-4-8 9:28:27");
  return done();
});
```

<a name="the-website-nhacsonet"></a>
# THE WEBSITE NHACSO.NET
<a name="the-website-nhacsonet-song-id-x1pzvkpybg"></a>
## Song ID: X1pZVkpYbg
should be official, 320kbps, "Nhạc Trữ Tình", and has lyric.

```js
var encoded_id, link, options,
  _this = this;
ns.connect();
encoded_id = "X1pZVkpYbg";
link = "http://nhacso.net/nghe-nhac/link-joke." + encoded_id + "==.html";
options = {
  id: encode(encoded_id),
  song: {}
};
return getFileByHTTP(link, function(data) {
  nsSong = ns.processSong(data, options);
  expect(ns._decodeId(1285971)).to.equal("X1pZVkpYbg");
  expect(nsSong.official).to.equal(1);
  expect(nsSong.bitrate).to.equal(320);
  expect(nsSong.plays).to.match(/\d+/);
  expect(nsSong.topic).to.equal('Nhạc Trữ Tình');
  expect(nsSong.islyric).to.equal(1);
  expect(nsSong.lyric).to.equal("Em dấu yêu ơi anh đang quay về mười năm xa vắng\nanh đã đưa em, đưa em đi tìm một giấc mơ đời\nmười năm lạc loài phải không em\nmười năm hận thù trĩu trong tim\nta trót trao nhau thân, ta chót vong ân\nmang tuổi hoa niên, làm kiếp lưu đầy\nBóng tà ngả trên lưng đồi cỏ non\nGió hiền thoáng vi vu hàng lau xanh\nngoài kia là đồng thơm hương lúa mới\nbên lũy tre xanh ngả nghiêng hàng dừa\nvà đây là giòng sông ta thương mến,\nsoi bóng chung đôi những ngày ấu thơ\nAnh sẽ đưa em, đưa em xa rời vùng mây tăm tối\nAnh sẽ đưa em, đưa em đi về, về lối chân hiền\ncòn ai đợi chờ nữa không em\ncòn ai giận hờn nữa không em\nem hãy theo anh, men lối ăn năn\nta thoát cơn mê cùng giắt nhau về ");
  return done();
});
```

should be called "Vó Ngựa Trên Đồi Cỏ Non" and has certain properties.

```js
var id, link, options,
  _this = this;
ns.connect();
id = 1285971;
link = "http://nhacso.net/flash/song/xnl/1/id/" + ns._decodeId(id);
options = {
  id: id
};
return getFileByHTTP(link, function(data) {
  var created, ts, _ref;
  ns.data = data;
  expect(ns.getValueXML(ns.data, "name", 1)).to.equal("Vó Ngựa Trên Đồi Cỏ Non");
  expect(ns.getValueXML(ns.data, "artist", 0)).to.equal("Trường Vũ");
  expect(parseInt(ns.getValueXML(ns.data, "artistlink", 0).replace(/\.html/g, '').replace(/^.+-/g, ''), 10)).to.equal(2428);
  expect(ns.getValueXML(ns.data, "author", 0)).to.equal("Ngân Giang");
  expect(parseInt(ns.getValueXML(ns.data, "authorlink", 0).replace(/\.html/g, '').replace(/^.+-/g, ''), 10)).to.equal(963);
  expect(parseInt((_ref = ns.data.match(/totalTime.+totalTime/)) != null ? _ref[0].replace(/^.+>|<.+$/g, '') : void 0, 10)).to.equal(320);
  expect(ns.getValueXML(ns.data, "mp3link", 0)).to.equal("http://st01.freesocialmusic.com/mp3/2013/05/10/1178050012/136817005912_7480.mp3");
  ts = ns.getValueXML(ns.data, "mp3link", 0).match(/\/[0-9]+_/g)[0].replace(/\//, "").replace(/_/, "");
  ts = parseInt(ts) * Math.pow(10, 13 - ts.length);
  created = ns.formatDate(new Date(ts));
  expect(created).to.equal("2013-5-10 14:14:19");
  return done();
});
```

<a name="the-website-nhacsonet-album-id-wf5yuevy"></a>
## Album ID: WF5YUEVY
should be called "B-Sides And Other Things I Forgot" and has certain properties.

```js
var encoded_id, link, options,
  _this = this;
encoded_id = "WF5YUEVY";
link = "http://nhacso.net/nghe-album/ab." + encoded_id + ".html";
options = {
  id: encode(encoded_id)
};
return getFileByHTTP(link, function(data) {
  ns._updateAlbum = function() {};
  ns.getTotalSongsInAlbum = function() {};
  ns.onAlbumFail = function() {};
  album = ns.processAlbum(data, options);
  expect(album.albumid).to.equal(669367);
  expect(album.title).to.equal("B-Sides And Other Things I Forgot");
  expect(album.artist).to.equal("Blue Stahli");
  expect(album.artistid).to.equal(97145);
  expect(album.thumbnail).to.equal("http://st.nhacso.net/images/album/2013/05/09/1072071738/136807196518_99_120x120.jpg");
  expect(album.songs).to.eql([1285687, 1285688, 1285689, 1285690, 1285691, 1285692, 1285693, 1285694, 1285695, 1285696, 1285697, 1285698]);
  return done();
});
```

should contain 12 songs.

```js
var link,
  _this = this;
link = "http://nhacso.net/album/gettotalsong?listIds=" + album.albumid;
return getFileByHTTP(link, function(data) {
  var nsongs, strId;
  data = JSON.parse(data);
  strId = "nsn:album:total:song:id:" + album.albumid;
  nsongs = parseInt(data.result[strId].TotalSong, 10);
  expect(nsongs).to.equal(12);
  return done();
});
```

should be released in 2013 and has description .

```js
var link,
  _this = this;
link = "http://nhacso.net/album/getdescandissuetime?listIds=" + album.albumid;
return getFileByHTTP(link, function(data) {
  var description, released_date;
  data = JSON.parse(data).result[0];
  released_date = data.IssueTime;
  description = ns.processStringorArray(data.AlbumDesc);
  expect(parseInt(released_date, 10)).to.equal(2013);
  expect(description).to.equal("Label: FiXT\r\nGenre: Alternative");
  return done();
});
```

should have been played more than 42 times .

```js
var link,
  _this = this;
link = "http://nhacso.net/statistic/albumtotallisten?listIds=" + album.albumid;
return getFileByHTTP(link, function(data) {
  var plays;
  data = JSON.parse(data);
  plays = parseInt(data.result["" + album.albumid].totalListen, 10);
  expect(plays).to.be.above(42);
  return done();
});
```

<a name="the-website-nhacsonet-video-id-x15rv0n"></a>
## Video ID: X15RV0N
should be called "Người Yêu Cũ" and has certain properties.

```js
var encoded_id, link, options,
  _this = this;
encoded_id = "X15RV0N";
link = "http://nhacso.net/xem-video/joke-link." + encoded_id + "=.html";
options = {
  id: encode(encoded_id)
};
return getFileByHTTP(link, function(data) {
  ns.getVideoDurationAndSublink = function() {};
  video = ns.processVideo(data, options);
  expect(video.videoid).to.equal(16040);
  expect(video.title).to.equal("Người Yêu Cũ");
  expect(video.artists).to.equal('["Phan Mạnh Quỳnh"]');
  expect(video.topic).to.equal('Nhạc Trẻ');
  expect(video.plays).to.be.at.least(1310);
  expect(video.official).to.equal(1);
  expect(video.producerid).to.equal(0);
  expect(video.link).to.equal('http://st01.freesocialmusic.com/mp4/2013/05/09/1430055571/13680778242_4392.mp4');
  expect(video.thumbnail).to.equal('http://st.nhacso.net/images/video/2013/05/09/1430055571/136807791310_2665_190x110.jpg');
  expect(video.created).to.equal('2013-5-9 12:37:4');
  return done();
});
```

should have subtitle and 303 second long.

```js
var link,
  _this = this;
link = "http://nhacso.net/flash/video/xnl/1/id/" + ns._decodeId(video.videoid);
return getFileByHTTP(link, function(data) {
  var duration, sublink;
  duration = parseInt(ns.getValueXML(data, "duration", 0).replace(/<\/duration>|<duration>/g, ''), 10);
  sublink = ns.getValueXML(data, "subUrl", 0);
  expect(duration).to.equal(303);
  expect(sublink).to.equal("http://nhacso.net/flash/crypting/1/xnl/id/X15RV0M=");
  return done();
});
```

