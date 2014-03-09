- [ZING API](#zing-api)
	- [SONGS](#songs)
		- [Get song info](#get-song-info)
		- [Get song lyrics](#get-song-lyrics)
        - [Get song comments](#get-song-comments)
	- [ALBUMS](#albums)
		- [Get albums by genre](#get-albums-by-genre)
		- [Get songs of an album](#get-songs-of-an-album)
		- [Get album info](#get-album-info)
		- [Get album comments](#get-album-comments)
	- [VIDEOS](#videos)
		- [Get videos by genre](#get-videos-by-genre)
		- [Get video info](#get-video-info)
		- [Get video lyrics](#get-video-lyrics)
		- [Get video suggestion](#get-video-suggestion)
		- [Get video comments](#get-video-comments)
	- [ARTISTS](#artists)
		- [Get artists by genre](#get-artists-by-genre)
		- [Get artist info](#get-artist-info)
		- [Get artist albums](#get-artist-albums)
		- [Get artist songs](#get-artist-songs)
		- [Get artist videos](#get-artist-videos)
	- [CHARTS](#charts)
		- [All](#all)
	- [TOP 100](#top-100)
	- [SONG BY THEMES](#song-by-themes)
		- [Get list](#get-list)
	- [SEARCH](#search)
		- [Songs](#songs)
		- [ALbums](#albums)
		- [Videos](#videos)

# ZING API

## SONGS

### Get song info

    http://api.mp3.zing.vn/api/mobile/song/getsonginfo?keycode={YOUR_KEY}&requestdata={"id":"ZW67FWWF"}

Example:

    http://api.mp3.zing.vn/api/mobile/song/getsonginfo?keycode=fafd463e2131914934b73310aa34a23f&requestdata={"id":"ZW67FWWF"}

Response:
    
```json
{
    "song_id": 1074700719,
    "song_id_encode": "ZW67FWWF",
    "title": "Bức Tranh Từ Nước Mắt",
    "artist_id": "13705",
    "artist": "Mr. Siro",
    "album_id": 1073845392,
    "album": "Bức Tranh Từ Nước Mắt",
    "composer_id": 303,
    "composer": "Mr Siro",
    "genre_id": "1,8",
    "zaloid": 0,
    "username": "mp3",
    "is_hit": 1,
    "is_official": 1,
    "download_status": 1,
    "copyright": "",
    "thumbnail": "avatars/c/b/cb1c0681ed21166b63979e08e27b9a94_1348329834.jpg",
    "total_play": 37428183,
    "link": "/bai-hat/Buc-Tranh-Tu-Nuoc-Mat-Mr-Siro/ZW67FWWF.html",
    "source": {
        "128": "http://api.mp3.zing.vn/api/mobile/source/song/LmxHTZnalNGmNLEykDJyvnLm",
        "320": "http://api.mp3.zing.vn/api/mobile/source/song/LmJHyZGNSaGmNLuTdvGtDnZn",
        "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/ZnJnyLmazsGHNLutrPffIMKfyvnLm"
    },
    "link_download": {
        "128": "http://api.mp3.zing.vn/api/mobile/download/song/kmJnyLnNlaHHNLEyLvJyFHLG",
        "320": "http://api.mp3.zing.vn/api/mobile/download/song/LnJHTZGazNHHNLEydFnybGLm",
        "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/LGxHyZnNlaHnskEyrPffrMKftbHZn"
    },
    "album_cover": null,
    "likes": 27460,
    "like_this": false,
    "favourites": 0,
    "favourite_this": false,
    "comments": 831,
    "genre_name": "Việt Nam, Nhạc Trẻ",
    "video": {
        "video_id": 1074700719,
        "title": "Bức Tranh Từ Nước Mắt",
        "artist": "Mr. Siro",
        "thumbnail": "thumb_video/2/b/2b01f358a38b70c2761eb2913daec382_1379306977.jpg",
        "duration": 340
    },
    "response": {
        "msgCode": 1
    }
}
```

### Get song lyrics

    http://api.mp3.zing.vn/api/mobile/song/getlyrics?keycode={YOUR_KEY}&requestdata={"id":"ZW67FWWF"}

Example:

    http://api.mp3.zing.vn/api/mobile/comment/getcommentofsong?key=fafd463e2131914934b73310aa34a23f&requestdata={"id":1073852647,"start":0,"length":20}


Response:

```json
{
    "id": "1188945",
    "content": "Chuyện hai chúng ta bây giờ khác rồi\nThật lòng anh không muốn ai phải bối rối\nSợ em nhìn thấy nên anh đành phải lẳng lặng đứng xa\nChuyện tình thay đổi nên bây giờ trở thành người thứ ba\nTrách ai bây giờ, trách mình thôi.....\n\nĐK:\nNhìn em hạnh phúc bên ai càng làm anh tan nát lòng\nMới hiểu tại sao tình yêu người ta sợ khi cách xa\nĐiều anh lo lắng cứ vẫn luôn xảy ra\nNếu không đổi thay chẳng có ai sống được vì thiếu mất yêu thương.\n\nThời gian giết chết cuộc tình còn đau hơn giết chính mình\nTại sao mọi thứ xung quanh vẫn thế chỉ lòng người thay đổi\nGiờ em chỉ là tất cả quá khứ anh phải cố xoá trong nước mắt\n\n[ Trong tình yêu, thuộc về ai không quan trọng\nMột giây mơ màng là đã mất nhau....]\n\nCàng nghĩ đến em, anh càng hối hận\nVì xa em nên mất em thật ngu ngốc\nGiờ tình anh như bức tranh bằng nước mắt không màu sắc\nNhẹ nhàng và trong suốt cho dù đau đớn vẫn lặng yên\nTrách ai bây giờ, trách mình thôi....\n\nĐK:\nNhìn em hạnh phúc bên ai càng làm anh tan nát lòng\nMới hiểu tại sao tình yêu người ta sợ khi cách xa\nĐiều anh lo lắng cứ vẫn luôn xảy ra\nNếu không đổi thay chẳng có ai sống được vì thiếu mất yêu thương.\n\nThời gian giết chết cuộc tình còn đau hơn giết chính mình\nTại sao mọi thứ xung quanh vẫn thế chỉ lòng người thay đổi\nGiờ em chỉ là tất cả quá khứ anh phải cố xoá trong nước mắt.\n\nNụ cười em vẫn như xưa mà lòng em sao khác rồi\nNỗi đau này chỉ mình anh nhận lấy vì anh đã sai\nGiờ anh phải cố giữ nước mắt đừng rơi\nBức tranh tình yêu của em từ lâu đã không hề có anh......\n\nTrong tình yêu, thuộc về ai không quan trọng, rồi cũng mất nhau…",
    "mark": 3876,
    "author": "o0cobemuaxuan0o",
    "response": {
        "msgCode": 1
    }
}
```

### Get song comments

    http://api.mp3.zing.vn/api/mobile/comment/getcommentofsong?key=fafd463e2131914934b73310aa34a23f&requestdata={"id":1073852647,"start":0,"length":20}


Response:

```json
{
  "numFound": 6,
  "docs": [
    {
      "commentId": 2010319847,
      "time": 1394189943,
      "content": "Em muốn với mình êu nhau đi mới hay nhất tuyệt zời ông mặt trời",
      "time_span": 147066,
      "owner": {
        "avatar": "http://b2.avatar.zdn.vn/180/3/a/9/2/sakurakjnomoto2003_180_117.jpg",
        "userName": "sakurakjnomoto2003",
        "displayName": "AmMy cAnDy gIrL"
      }
    },
    {
      "commentId": 1962175708,
      "time": 1390698783,
      "content": "Hay wá đj àk, hêm bjk em đã nghe bao nhiu lần rùj nx. Chị hát hay lắm ",
      "time_span": 3638226,
      "owner": {
        "avatar": "http://b2.avatar.zdn.vn/180/0/0/0/5/my_tran_iu_anh_180_16.jpg",
        "userName": "my_tran_iu_anh",
        "displayName": "oOo HeO sOcIu mÚn wÊn hÌnH bÓnG cŨ oOo"
      }
    },
    {
      "commentId": 1936703871,
      "time": 1388631875,
      "content": "Cố lên chị ơi.ablum sẽ là của năm e iu chị:) chị cũg sớm ra ca khúc mới nhé",
      "time_span": 5705134,
      "owner": {
        "avatar": "http://b2.avatar.zdn.vn/180/6/f/b/c/tien_tienyen_180_2.jpg",
        "userName": "tien_tienyen",
        "displayName": "Dinh TruongPhong"
      }
    },
    {
      "commentId": 1920299324,
      "time": 1387604320,
      "content": "Iu chi phuong wá.em muốn xin chu ki chi p lắm.làm. sao có chu ki chi day.out nhá",
      "time_span": 6732689,
      "owner": {
        "avatar": "http://b2.avatar.zdn.vn/180/1/a/5/5/milanxinxin_180_13.jpg",
        "userName": "milanxinxin",
        "displayName": " Milanxinxin"
      }
    },
    {
      "commentId": 1878309504,
      "time": 1384179588,
      "content": "Bài nào kũg hay nhưg thích nhất là: chỉ là e giấu đi,khoảg lặng,nếu hp k fải e,e k làm đk đâu",
      "time_span": 10157421,
      "owner": {
        "avatar": "http://b2.avatar.zdn.vn/180/d/5/f/a/liulypham_180_0.jpg",
        "userName": "liulypham",
        "displayName": "liulypham"
      }
    },
    {
      "commentId": 1873606740,
      "time": 1383888877,
      "content": "Nếu a có về em sẽ vờ như chẳg có j xảy ra , vờ như thiếu a cuộc đời e vẫn tươi tắn và hối hả. Chỉ là...chỉ là...e giấu đi Qá hay",
      "time_span": 10448132,
      "owner": {
        "avatar": "http://b2.avatar.zdn.vn/180/d/5/f/a/liulypham_180_0.jpg",
        "userName": "liulypham",
        "displayName": "liulypham"
      }
    }
  ],
  "response": {
    "msgCode": 1
  }
}
```

## ALBUMS

### Get albums by genre

Sorted by date released

	http://api.mp3.zing.vn/api/mobile/playlist/getplaylistbygenre?key={YOUR_KEY}&requestdata={{"sort":"release_date","id":8,"length":20,"start":0}}

`sort` params : `release_date`, `total_play`, and ``
`id` : genre id

Example:

	http://api.mp3.zing.vn/api/mobile/playlist/getplaylistbygenre?key=fafd463e2131914934b73310aa34a23f&requestdata={"sort":"release_date","id":8,"length":20,"start":0}

Response: 

```json
{
    "numFound": 4101,
    "start": 0,
    "docs": [
        {
            "playlist_id": 1073852692,
            "title": "Nhật Ký Âm Nhạc 2013",
            "artist": "Kyo York",
            "cover": "covers/b/8/b84bc16918d33cdd592ddd9b6964199d_1383886232.jpg",
            "total_play": 0,
            "link": "/album/Nhat-Ky-Am-Nhac-2013-Kyo-York/ZWZB0I9U.html"
        },
        {
            "playlist_id": 1073852647,
            "title": "Chỉ Là Em Giấu Đi",
            "artist": "Bích Phương",
            "cover": "covers/f/5/f5ce8b99f1b45e90a7e4fc8c24a6f6af_1383816253.jpg",
            "total_play": 0,
            "link": "/album/Chi-La-Em-Giau-Di-Bich-Phuong/ZWZB0I67.html"
        },
        {
            "playlist_id": 1073852646,
            "title": "Gọi Anh",
            "artist": "Nguyễn Trần Trung Quân,Bảo Trâm",
            "cover": "covers/9/3/93148beb0c04c68c09bbb6bbec3e811b_1383807813.jpg",
            "total_play": 0,
            "link": "/album/Goi-Anh-Nguyen-Tran-Trung-Quan-Bao-Tram/ZWZB0I66.html"
        },
        {
            "playlist_id": 1073852645,
            "title": "Khi Anh Lặng Im",
            "artist": "Quốc Thiên",
            "cover": "covers/2/6/26479eba577537cfc37f20021d968c14_1383790807.jpg",
            "total_play": 0,
            "link": "/album/Khi-Anh-Lang-Im-Quoc-Thien/ZWZB0I6Z.html"
        },
        {
            "playlist_id": 1073852564,
            "title": "Hai Phương Trời",
            "artist": "Lâm Chấn Kiệt",
            "cover": "covers/8/f/8f8deb741e3abf6cec43c878aa9c4e16_1383726682.jpg",
            "total_play": 0,
            "link": "/album/Hai-Phuong-Troi-Lam-Chan-Kiet/ZWZB0IIU.html"
        },
        {
            "playlist_id": 1073852561,
            "title": "Giá Như Anh Hiểu",
            "artist": "Song Thư",
            "cover": "covers/a/f/af1dd6456c314bf499e26ba0fa1a8761_1383713426.jpg",
            "total_play": 0,
            "link": "/album/Gia-Nhu-Anh-Hieu-Song-Thu/ZWZB0III.html"
        },
        {
            "playlist_id": 1073852560,
            "title": "Tại Sao Bạn Đến Trái Đất Này (Single)",
            "artist": "MTV,Phương Thanh",
            "cover": "covers/f/e/fe26d895721d161cc8c0759ce90c6e3c_1383712379.jpg",
            "total_play": 0,
            "link": "/album/Tai-Sao-Ban-Den-Trai-Dat-Nay-Single-MTV-Phuong-Thanh/ZWZB0II0.html"
        },
        {
            "playlist_id": 1073852169,
            "title": "Câu Chuyện Của Aslan",
            "artist": "Aslan",
            "cover": "covers/a/f/af1dd6456c314bf499e26ba0fa1a8761_1383631802.jpg",
            "total_play": 0,
            "link": "/album/Cau-Chuyen-Cua-Aslan-Aslan/ZWZAFF89.html"
        },
        {
            "playlist_id": 1073852105,
            "title": "Gọi Nhau Về",
            "artist": "Kasim Hoàng Vũ",
            "cover": "covers/4/6/46138094b1b336311460c731ea2d5e5d_1383550685.jpg",
            "total_play": 0,
            "link": "/album/Goi-Nhau-Ve-Kasim-Hoang-Vu/ZWZAFFU9.html"
        },
        {
            "playlist_id": 1073852102,
            "title": "Chỉ Cần Em Vui (Single)",
            "artist": "Đinh Ứng Phi Trường",
            "cover": "covers/b/3/b3526c7b6c190a331562390c47f92a75_1383534863.jpg",
            "total_play": 0,
            "link": "/album/Chi-Can-Em-Vui-Single-Dinh-Ung-Phi-Truong/ZWZAFFU6.html"
        },
        {
            "playlist_id": 1073852101,
            "title": "Acoustic",
            "artist": "3979 Band",
            "cover": "covers/0/9/09f98084b27ec25950f35c3ca62e3bae_1383534571.jpg",
            "total_play": 0,
            "link": "/album/Acoustic-3979-Band/ZWZAFFUZ.html"
        },
        {
            "playlist_id": 1073852099,
            "title": "Smile (Hãy Cười)",
            "artist": "Y Thanh",
            "cover": "covers/b/b/bb0cdcc6f610f84f3965060ff0766f8b_1383551583.jpg",
            "total_play": 0,
            "link": "/album/Smile-Hay-Cuoi-Y-Thanh/ZWZAFFUO.html"
        },
        {
            "playlist_id": 1073852097,
            "title": "Tháng Ngày Không Trở Lại (Single)",
            "artist": "Đào Bá Lộc",
            "cover": "covers/3/5/353d805711a2497c5425d7b14321217c_1383533697.jpg",
            "total_play": 0,
            "link": "/album/Thang-Ngay-Khong-Tro-Lai-Single-Dao-Ba-Loc/ZWZAFFUI.html"
        },
        {
            "playlist_id": 1073852094,
            "title": "Thanh Niên Ế (Single)",
            "artist": "Cris Nguyễn,Kick",
            "cover": "covers/0/4/0494736b1cd8c3ac7fe97789c4ad6dcb_1383492433.jpg",
            "total_play": 0,
            "link": "/album/Thanh-Nien-E-Single-Cris-Nguyen-Kick/ZWZAFFOE.html"
        },
        {
            "playlist_id": 1073852068,
            "title": "Cho Anh Quay Về (Single)",
            "artist": "Cường Tom",
            "cover": "covers/c/3/c300ae434343b009621c000ef85bc849_1383391244.jpg",
            "total_play": 0,
            "link": "/album/Cho-Anh-Quay-Ve-Single-Cuong-Tom/ZWZAFFWU.html"
        },
        {
            "playlist_id": 1073851929,
            "title": "Anh Phải Đi (Single)",
            "artist": "KnK",
            "cover": "covers/3/5/353d805711a2497c5425d7b14321217c_1383296979.jpg",
            "total_play": 0,
            "link": "/album/Anh-Phai-Di-Single-KnK/ZWZAFE99.html"
        },
        {
            "playlist_id": 1073851882,
            "title": "Người Đó Không Phải Anh",
            "artist": "Julie Phương Thùy",
            "cover": "covers/3/5/353d805711a2497c5425d7b14321217c_1383293201.jpg",
            "total_play": 0,
            "link": "/album/Nguoi-Do-Khong-Phai-Anh-Julie-Phuong-Thuy/ZWZAFE6A.html"
        },
        {
            "playlist_id": 1073851841,
            "title": "Vẫn Còn Những Yêu Thương (Single)",
            "artist": "Hà Anh",
            "cover": "covers/b/3/b3526c7b6c190a331562390c47f92a75_1383289823.jpg",
            "total_play": 0,
            "link": "/album/Van-Con-Nhung-Yeu-Thuong-Single-Ha-Anh/ZWZAFEUI.html"
        },
        {
            "playlist_id": 1073851783,
            "title": "Nhạc Hot Việt Tháng 11/2013",
            "artist": "Various Artists",
            "cover": "covers/0/9/09bdb4a26d1a5c3c10faf5d0163afb7f_1383279849.jpg",
            "total_play": 0,
            "link": "/album/Nhac-Hot-Viet-Thang-11-2013-Various-Artists/ZWZAFE07.html"
        },
        {
            "playlist_id": 1073851779,
            "title": "Nhạc Việt Mới Tháng 11/2013",
            "artist": "Various Artists",
            "cover": "covers/8/d/8dfd59eecf913ae8109188bb4cd93351_1383279974.jpg",
            "total_play": 0,
            "link": "/album/Nhac-Viet-Moi-Thang-11-2013-Various-Artists/ZWZAFE0O.html"
        }
    ],
    "response": {
        "msgCode": 1
    }
}
```

### Get songs of an album

	http://api.mp3.zing.vn/api/mobile/playlist/getsonglist?key={YOUR_KEY}&requestdata={{"id":1073816610,"start":0,"length":200}}

`id` is album id derived from key

Example:

	http://api.mp3.zing.vn/api/mobile/playlist/getsonglist?key=fafd463e2131914934b73310aa34a23f&requestdata={"id":1073816610,"start":0,"length":200}

Response:

```json
{
    "numFound": 9,
    "docs": [
        {
            "song_id": 1074458243,
            "title": "Chiến Sỹ",
            "artist_id": "28768",
            "artist": "Stillrock",
            "album_id": "1073816610",
            "username": "france_song",
            "download_status": 1,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHxGyLHNSAWJDldyZFcyDmZG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LHJGTLmNzlQcDlVTdFmyDmLG",
                "lossless": ""
            },
            "copyright": "",
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LmcmtknNSlQJDzdyLvJTvHLH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmJmyZnallQxFldydDGtvnLm",
                "lossless": ""
            },
            "link": "/bai-hat/Chien-Sy-Stillrock/ZW6UOF0O.html",
            "thumbnail": "covers/3/e/3e2c54b351be6220c2afe114f2cc0b90_1356856078.jpg"
        },
        {
            "song_id": 1074458244,
            "title": "Có Say",
            "artist_id": "28768",
            "artist": "Stillrock",
            "album_id": "1073816610",
            "username": "thebestofmusic",
            "download_status": 1,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kmcHtZHaSzQJvzzyLFcyFnLn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LnxmyZnNlzQxvzAydDnyFGLG",
                "lossless": ""
            },
            "copyright": "",
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LHxGyLGalzpxblSyLbJtDmLH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHxHTLnNllWcbAztBDmTvnLn",
                "lossless": ""
            },
            "link": "/bai-hat/Co-Say-Stillrock/ZW6UOF0U.html",
            "thumbnail": "covers/3/e/3e2c54b351be6220c2afe114f2cc0b90_1356856078.jpg"
        },
        {
            "song_id": 1074458245,
            "title": "Rock",
            "artist_id": "28768",
            "artist": "Stillrock",
            "album_id": "1073816610",
            "username": "hiphop_world",
            "download_status": 1,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHcmtknallQcDlQtLFcyvnLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kncmyknNzSWJvlQTBFnybHZG",
                "lossless": ""
            },
            "copyright": "",
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZGxHTZHNlAWxDSpTLvxtvHkm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHcHykGNAAWJbSptBDnTbGLH",
                "lossless": ""
            },
            "link": "/bai-hat/Rock-Stillrock/ZW6UOF0Z.html",
            "thumbnail": "covers/3/e/3e2c54b351be6220c2afe114f2cc0b90_1356856078.jpg"
        },
        {
            "song_id": 1074458246,
            "title": "Rung",
            "artist_id": "28768",
            "artist": "Stillrock",
            "album_id": "1073816610",
            "username": "bbzing",
            "download_status": 1,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kHxmtLGNSAWcDShyLbJtbnkG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kmcHyLGNASQxbSXtBvntbnZG",
                "lossless": ""
            },
            "copyright": "",
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kHxHyZnsSlQxvzgyLbJTFnLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHJHyLGazSpJbAXtdDHyDGZm",
                "lossless": ""
            },
            "link": "/bai-hat/Rung-Stillrock/ZW6UOF06.html",
            "thumbnail": "covers/3/e/3e2c54b351be6220c2afe114f2cc0b90_1356856078.jpg"
        },
        {
            "song_id": 1074458247,
            "title": "Tất Cả",
            "artist_id": "28768",
            "artist": "Stillrock",
            "album_id": "1073816610",
            "username": "thuhuynh",
            "download_status": 1,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kHxnTZGaAlpcFAaTZvctDmLn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZmxGyknslzQxvlayVvntbnLn",
                "lossless": ""
            },
            "copyright": "",
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZnJHTkHNASpxFlayLvJybnkH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHcHTkmallQcbAstdFHyDmLH",
                "lossless": ""
            },
            "link": "/bai-hat/Tat-Ca-Stillrock/ZW6UOF07.html",
            "thumbnail": "covers/3/e/3e2c54b351be6220c2afe114f2cc0b90_1356856078.jpg"
        },
        {
            "song_id": 1074458248,
            "title": "Tiễn Bạn",
            "artist_id": "28768",
            "artist": "Stillrock",
            "album_id": "1073816610",
            "username": "nemomb",
            "download_status": 1,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LmcmTZHsAAQcblJTkFctDnLH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LncmyknNAzQxFAcyBDHyDmLG",
                "lossless": ""
            },
            "copyright": "",
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZHxHTLHsAlQcvzJyZDxtvHZn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kGxmyknaASQJvlxyVDntbHkn",
                "lossless": ""
            },
            "link": "/bai-hat/Tien-Ban-Stillrock/ZW6UOF08.html",
            "thumbnail": "covers/3/e/3e2c54b351be6220c2afe114f2cc0b90_1356856078.jpg"
        },
        {
            "song_id": 1074458249,
            "title": "Tơ Nhện",
            "artist_id": "28768",
            "artist": "Stillrock",
            "album_id": "1073816610",
            "username": "mp3lover",
            "download_status": 1,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LGJntknNlAQJDAiTLDJyDnLm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LHxnTLmsllWJDSEtdbmTFmZG",
                "lossless": ""
            },
            "copyright": "",
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LGJGyLmszAQxDAitLbxTvHZn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LnxntLGNlAQcbzuyVDHTvnkG",
                "lossless": ""
            },
            "link": "/bai-hat/To-Nhen-Stillrock/ZW6UOF09.html",
            "thumbnail": "covers/3/e/3e2c54b351be6220c2afe114f2cc0b90_1356856078.jpg"
        },
        {
            "song_id": 1074458267,
            "title": "Thời gian",
            "artist_id": "28768",
            "artist": "Stillrock",
            "album_id": "1073816610",
            "username": "nemomb",
            "download_status": 1,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LGJmtknNzSQcbCaTLDJybHZH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZnxnTkGNAAQJbgaTdDmybnZH",
                "lossless": ""
            },
            "copyright": "",
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LGxGykGazAQJvCstLDJtbnLG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kGxnTkmsSAQcvhsyBvGyDGLm",
                "lossless": ""
            },
            "link": "/bai-hat/Thoi-gian-Stillrock/ZW6UOFIB.html",
            "thumbnail": "covers/3/e/3e2c54b351be6220c2afe114f2cc0b90_1356856078.jpg"
        },
        {
            "song_id": 1074458268,
            "title": "Trăng Mờ",
            "artist_id": "28768",
            "artist": "Stillrock",
            "album_id": "1073816610",
            "zaloid": 0,
            "username": "mp3lover",
            "download_status": 1,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZHxHyZmaAlQJbhJTLDJyvnLn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LncmyLGNSlQJvXcydvmTvGLn",
                "lossless": ""
            },
            "copyright": "",
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZnxGyZGslSQcbXJtkFJTFmLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LmcGTLGNlSWxvgJydFHTbHLn",
                "lossless": ""
            },
            "link": "/bai-hat/Trang-Mo-Stillrock/ZW6UOFIC.html",
            "thumbnail": "covers/3/e/3e2c54b351be6220c2afe114f2cc0b90_1356856078.jpg"
        }
    ],
    "response": {
        "msgCode": 1
    }
}
```

### Get album info

	http://api.mp3.zing.vn/api/mobile/playlist/getplaylistinfo?key={YOUR_KEY}&requestdata={"id":1073816610}

Example:
	
	http://api.mp3.zing.vn/api/mobile/playlist/getplaylistinfo?key=fafd463e2131914934b73310aa34a23f&requestdata={"id":1073816610}

Response:

```json
{
    "playlist_id": 1073816610,
    "title": "Thời Gian",
    "artist_id": "28768",
    "artist": "Stillrock",
    "genre_id": "1,10",
    "zaloid": 0,
    "username": "",
    "cover": "covers/3/e/3e2c54b351be6220c2afe114f2cc0b90_1356856078.jpg",
    "description": "Ý tưởng của album dựa trên những diễn biến cuộc sống đời thường của ban nhạc. Có bắt tay vào làm việc mà cụ thể là đầu tư cho một album rock trong điều kiện còn nhiều khó khăn quả thực lúc đó mới biết quí THỜI GIAN. Đam mê thứ tài sản vô giá mà mỗi rocker chân chính có được, ROCK gieo vào đầu óc những ý nghĩ tích cực: sự mạnh mẽ, sự táo bạo và cả sự nghiêm túc đàng hoàng. Quả thực, rock đã tiếp sức để mỗi người trẻ tự vượt qua những cám dỗ trong cuộc sống, những lũ nhện ma quái giăng tơ huyền ảo khắp nơi. Đó chính là TƠ NHỆN.  Niềm vui , những điều hạnh phúc vừa đến, lại phải đối mặt với khó khăn và nỗi đau. Trong văn chương nói rất nhiều cái gọi là cõi tạm, sinh ra là khóc là khổ. Vậy mới biết “Có nước mắt trôi trên cuộc đời, có sóng gió mênh mang bầu trời, hãy đứng vững bằng đôi chân không mềm yếu” (trích lời bài CHIẾN SĨ) . Phải đứng vững trên đôi chân mình, chân lí sống không bao giờ thay đổi và hãy nghe TẤT CẢ  để thấy mình trong đó, cuộc sống đôi khi vô thường, nhàm chán đến tận cùng, vậy mới biết lí trí chẳng vượt qua được sự tận cùng. Chưa hết, TRĂNG MỜ muốn đem tới cho rock fan một chút cảm thụ nhân văn mà tác giả Phan Hoàng Thái muốn gửi gắm. Quả đất là một vòng tròn, Mặt trăng là một vòng tròn, mỗi con người lần lượt  phải đi qua cái vòng tròn lẫn quẩn đó… cái chết. Để rồi khi đối mặt với nó có nghĩa là chúng ta thấy sự sống quí giá chừng nào. RUNG xô đẩy người nghe từ đất liền ra biển khơi, ở đâu cũng vậy cũng có hiền nhân và quĩ dữ, cũng có nguy nan và bình s",
    "is_hit": 1,
    "is_official": 1,
    "is_album": 1,
    "year": "2008",
    "status_id": 1,
    "link": "/album/Thoi-Gian-Stillrock/ZWZA7UAW.html",
    "total_play": 272684,
    "genre_name": "Việt Nam, Rock Việt",
    "likes": 95,
    "like_this": false,
    "comments": 0,
    "favourites": 0,
    "favourite_this": false,
    "response": {
        "msgCode": 1
    }
}
```

### Get album comments

    http://api.mp3.zing.vn/api/mobile/comment/getcommentofplaylist?key={YOUR_KEY}&requestdata={"id":1073852647,"start":0,"length":20}

Example: 

    http://api.mp3.zing.vn/api/mobile/comment/getcommentofplaylist?key=fafd463e2131914934b73310aa34a23f&requestdata={"id":1073852647,"start":0,"length":20}

Response:

```json
{
    "numFound": 32,
    "docs": [
        {
            "commentId": 1874068398,
            "time": 1383914264,
            "content": "sao bài em muốn nhìn môi chị ghê vậy ! chỉ là em giấu đi môi đẹp lắm á ",
            "owner": {
                "userName": "cunannoinhonhe",
                "displayName": "cunannoinhonhe"
            }
        },
        {
            "commentId": 1874016578,
            "time": 1383913642,
            "content": "chỉ là anh giấu đi....chỉ là anh giấu đi....chỉ là anh giấu đi....",
            "owner": {
                "userName": "lethanhtam53",
                "displayName": " alone"
            }
        },
        {
            "commentId": 1873946477,
            "time": 1383911942,
            "content": ":) bùi bích phương. chị thật... làm cho em khóc rồi nè.. :'(((( nghe xong mà... buồn quá trời buồn.",
            "owner": {
                "userName": "hatnangguongcuoi",
                "displayName": "Triệu Thị Thu Thủy"
            }
        },
        {
            "commentId": 1873939440,
            "time": 1383910767,
            "content": "Nếu BP phát hành album chắc chắn mình sẽ mua bản gốc. Trước giờ chỉ muốn nghe nhạc chùa của các ca sĩ khác thôi nhưng của BP lại khác ^^",
            "owner": {
                "userName": "icysnowflake93",
                "displayName": "icysnowflake93"
            }
        },
        {
            "commentId": 1873937933,
            "time": 1383910698,
            "content": "thế cái bài có lời là :\" vì e biết 1 ngày nào đó k thể bên a, k thể ngắm nhìn đc nụ cười và đc ôm a, nếu có trách e cũng đành hãy cứ để những nụ cười e giữ riêng....\" là bài nào ạ, e nghe k có thấy",
            "owner": {
                "userName": "try_life_yb",
                "displayName": " forget"
            }
        },
        {
            "commentId": 1873764968,
            "time": 1383902841,
            "content": "Xin lỗi anh nhé!............... .E không làm được đâu :(",
            "owner": {
                "userName": "ngoc_nghech_1993",
                "displayName": "Ngoc_Nghech_1993 Ngoc_Nghech_1993"
            }
        },
        {
            "commentId": 1873756370,
            "time": 1383902064,
            "content": "bài hát này hay quá!BP hát bài nào cũng thấy cảm xúc.",
            "owner": {
                "userName": "binhhien225",
                "displayName": "Đinh Thị Hiên"
            }
        },
        {
            "commentId": 1873739118,
            "time": 1383900464,
            "content": "càng nghe nhiều nhạc của bích phương, mình càng mất dần niềm tin vào tình yêu :p. Đùa chứ nghe buồn mà hay ghê ^^.",
            "owner": {
                "userName": "phattrumvt114",
                "displayName": "Đinh Ngọc Phát"
            }
        },
        {
            "commentId": 1873725097,
            "time": 1383898704,
            "content": "bài này đúng tâm trạng đúng hoàn cảnh của mình..........",
            "owner": {
                "userName": "pelun365",
                "displayName": "Ny Nũng Nịu"
            }
        },
        {
            "commentId": 1873703509,
            "time": 1383896706,
            "content": "xin lỗi anh nhé............ em không làm được đâu >\"",
            "owner": {
                "userName": "nana_vq",
                "displayName": "Na Còi"
            }
        },
        {
            "commentId": 1873703508,
            "time": 1383896458,
            "content": "album này rất đáng nghe, bài nào cũng hay, bài Khoảng Lặng giai điệu lạ, bài chia tay nhưng nghe k não nề :D",
            "owner": {
                "userName": "tsu21376",
                "displayName": " tsu21376"
            }
        },
        {
            "commentId": 1873686652,
            "time": 1383893566,
            "content": "Khoảng lặng là bài hát chia tay mà nghe sao vui thế nhỉ ^^",
            "owner": {
                "userName": "cherry_aries",
                "displayName": " MrsEraser"
            }
        },
        {
            "commentId": 1873686644,
            "time": 1383893302,
            "content": "yêu chị bích phương nhìu lém . mấy bài chị hát cảm động đến rơi nước mắt lun. Chúc chị thành công trong sự nghiệp ca hát",
            "owner": {
                "userName": "tienvip_bmt",
                "displayName": "oOo Ny xXx Ngok oOo"
            }
        },
        {
            "commentId": 1873643935,
            "time": 1383891345,
            "content": "Mấy cái bài hát kia hay hơn cả bài chủ chốt =.= Bài Khoảng lặng hay ^^",
            "owner": {
                "userName": "heocoi_95",
                "displayName": "Vân Anh"
            }
        },
        {
            "commentId": 1873616184,
            "time": 1383889813,
            "content": "Thích những bài hát này. Yêu giọng hát của Phương. Đã theo dõi bạn qua cuộc thi VNID rồi thích luôn bài Có khi nào rời xa,Có Lẽ Em, Em Muốn... cả album này bài nào cũng thích. Chúc bạn thành công nhé.",
            "owner": {
                "userName": "nguyentranle1405",
                "displayName": " nguyentranle1405"
            }
        },
        {
            "commentId": 1873616183,
            "time": 1383889741,
            "content": "kết nhất bài Nếu Hạnh Phúc Không Phải Em ... tâm trạng quá :(",
            "owner": {
                "userName": "mitukun",
                "displayName": " mitukun"
            }
        },
        {
            "commentId": 1873607705,
            "time": 1383888931,
            "content": "Chị Bích Phương hát bài nào cũng hay..thích nguyên cả album của chị..rất đúng tâm trạng..cố gắng lên nữa chị nhé............ ",
            "owner": {
                "userName": "hien_milo",
                "displayName": "GjA DinH II  VIP VInG QuAnG II luv Ga"
            }
        },
        {
            "commentId": 1873487243,
            "time": 1383880097,
            "content": "nghe bài nào cũng hay, cũng tâm trạng. Càng ngày càng thích giọng Bích Phương, êm ái, dịu dàng, ngọt ngào như hình ảnh của P vậy! Nhưng nhạc của P buồn lắm nên ai thất tình thì đừng có nghe nhiều!!! :3",
            "owner": {
                "userName": "anhtubkk57",
                "displayName": "Devil Nim"
            }
        },
        {
            "commentId": 1873469468,
            "time": 1383879418,
            "content": "ko có gì đặt biệt lắm , bài nào cũng mang 1 âm hưởng",
            "owner": {
                "userName": "duy1231979",
                "displayName": "Kẹo Bông"
            }
        },
        {
            "commentId": 1873469323,
            "time": 1383878508,
            "content": "^^ hình abum giông boom ghê lun.dễ thương quá đi.hát cũng hay nữa hii",
            "owner": {
                "userName": "razu55",
                "displayName": "Huỳnh Minh Tài"
            }
        }
    ],
    "response": {
        "msgCode": 1
    }
}
```

## VIDEOS

### Get videos by genre

	http://api.mp3.zing.vn/api/mobile/video/getvideobygenre?key={YOUR_KEY}&requestdata={{"sort":"release_date","id":11,"length":20,"start":0}}

`sort` params : `release_date`, `total_play`, and ``
`id` : genre id

Example: 
	
	http://api.mp3.zing.vn/api/mobile/video/getvideobygenre?key=fafd463e2131914934b73310aa34a23f&requestdata={"sort":"release_date","id":11,"length":20,"start":0}

Response:

```json
{
    "numFound": 724,
    "start": 0,
    "docs": [
        {
            "video_id": 1074322430,
            "title": "Anh Đi Chăn Trâu",
            "artist_id": "9045",
            "artist": "Lâm Quang Long",
            "composer_id": 806,
            "composer": "Phi Bằng ",
            "genre_id": "1,11,13",
            "thumbnail": "thumb_video/5/b/5b8e6fe01e1911831cd330420cad1772_1383883513.jpg",
            "tag": "",
            "duration": 259,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1383883476,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/ZHJGTZmszdFFAdmyDlHtFHLH",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/ZmxmtLHNSdDDlBnTdXnyDGLG",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/ZGJHTLnNlVFvSVmySJHyvHZH",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/LmxHyknszdvblVHyNFnyvnZG",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/kGJmyLnNSBbvzdHTLnxntFnLH"
            },
            "link": "/video-clip/Anh-Di-Chan-Trau-Lam-Quang-Long/ZW6WWC7E.html",
            "total_play": 21361,
            "likes": 19,
            "comments": 0
        },
        {
            "video_id": 1074659334,
            "title": "Đôi Khi",
            "artist_id": "2889",
            "artist": "Nguyễn Hồng Ân",
            "composer_id": 807,
            "composer": "Minh Đức",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/2/c/2cc4db934788a07b70179a9d21a664b1_1383818448.jpg",
            "tag": "",
            "duration": 371,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1383818113,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/ZGxGTLnNSCWEVVAyDSntvHLH",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/ZHJnTLnNlXQRBVSyBXmyFnZm",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/kncGyLnazCpEdVSySxmtbHLm",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/ZHxmtLnNAgWiVdlyaFGyDnZn",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/knxnTkGaSCpEBBztZnJHtDHkG"
            },
            "link": "/video-clip/Doi-Khi-Nguyen-Hong-An/ZW67Z086.html",
            "total_play": 24698,
            "likes": 4,
            "comments": 0
        },
        {
            "video_id": 1074766528,
            "title": "Liên Khúc Mẹ Từ Bi",
            "artist_id": "11888",
            "artist": "Hoàng Minh Phi",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/3/c/3caa74ca37e89ea17f73c97abb5a7edd_1383809141.jpg",
            "tag": "",
            "duration": 436,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1383809117,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/kHcGyZHslNCgQvJtvzntFHZG",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/kHJHyZGNSshgQDxyBXGyDGkG",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LHJnyLmsAaChQvctScnTvHLH",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/kHJHTLmalahgQvJTaDGyDGLH",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/LnJnykHNzsChpvJTZGxmtbnZm"
            },
            "link": "/video-clip/Lien-Khuc-Me-Tu-Bi-Hoang-Minh-Phi/ZW68FOU0.html",
            "total_play": 18401,
            "likes": 16,
            "comments": 0
        },
        {
            "video_id": 1074764786,
            "title": "Bông Ô Môi",
            "artist_id": "42513",
            "artist": "Thùy Dương",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/e/4/e4b901f80594fef9547542186fcd40d6_1383291140.jpg",
            "tag": "",
            "duration": 1495,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1383291134,
            "source": {
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LmxntLmaSsCSNxhyVCnTDHLH"
            },
            "link": "/video-clip/Bong-O-Moi-Thuy-Duong/ZW68EC7W.html",
            "total_play": 52950,
            "likes": 21,
            "comments": 3
        },
        {
            "video_id": 1074764784,
            "title": "Lấy Chồng Xứ Lạ",
            "artist_id": "42513",
            "artist": "Thùy Dương",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,8,11",
            "thumbnail": "thumb_video/5/3/534460d2ad1dad4b7da63c4768c9bbe3_1383290952.jpg",
            "tag": "",
            "duration": 548,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1383290948,
            "source": {
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/kHcmTZnNlNgSNJzTBgHybmLG"
            },
            "link": "/video-clip/Lay-Chong-Xu-La-Thuy-Duong/ZW68EC70.html",
            "total_play": 63352,
            "likes": 53,
            "comments": 0
        },
        {
            "video_id": 1074764783,
            "title": "Người Thương Kẻ Nhớ",
            "artist_id": "42513",
            "artist": "Thùy Dương",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/5/b/5b95c15488057177e7b398ffc249b2f2_1383290878.jpg",
            "tag": "",
            "duration": 271,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1383290872,
            "source": {
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/knJntZHazsXSaJdyBhmyvGZH"
            },
            "link": "/video-clip/Nguoi-Thuong-Ke-Nho-Thuy-Duong/ZW68EC6F.html",
            "total_play": 21947,
            "likes": 16,
            "comments": 0
        },
        {
            "video_id": 1074764782,
            "title": "Đính Ước",
            "artist_id": "42513,11736",
            "artist": "Thùy Dương , Vũ Duy",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/4/0/4053c05b22640ef0980929c0e5336511_1383290791.jpg",
            "tag": "",
            "duration": 283,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1383290786,
            "source": {
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/ZHJmtknaSNXzNxvyBXmTbmZm"
            },
            "link": "/video-clip/Dinh-Uoc-Thuy-Duong-Vu-Duy/ZW68EC6E.html",
            "total_play": 22330,
            "likes": 15,
            "comments": 0
        },
        {
            "video_id": 1074764780,
            "title": "Khóc Thầm",
            "artist_id": "42513",
            "artist": "Thùy Dương",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/8/b/8beefc4425a9706df00d9ce2504460e9_1383290687.jpg",
            "tag": "",
            "duration": 343,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1383290681,
            "source": {
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/ZnxmyZmNAsglsJHydhnyDHkn"
            },
            "link": "/video-clip/Khoc-Tham-Thuy-Duong/ZW68EC6C.html",
            "total_play": 5417,
            "likes": 9,
            "comments": 0
        },
        {
            "video_id": 1074764778,
            "title": "Mùa Hoa Cưới",
            "artist_id": "42513,6434",
            "artist": "Thùy Dương , Trọng Phúc",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/9/8/98cab19a021f3e6c2e96905c9537ff24_1383290589.jpg",
            "tag": "",
            "duration": 529,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1383290585,
            "source": {
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LnxGyLGNANClsNcydhHyvnLm"
            },
            "link": "/video-clip/Mua-Hoa-Cuoi-Thuy-Duong-Trong-Phuc/ZW68EC6A.html",
            "total_play": 8489,
            "likes": 6,
            "comments": 0
        },
        {
            "video_id": 1074764776,
            "title": "Lời Nhớ Lời Thương",
            "artist_id": "42513",
            "artist": "Thùy Dương",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/9/2/92da1399adf012219842cc50d6a09f69_1383290514.jpg",
            "tag": "",
            "duration": 349,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1383290509,
            "source": {
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LHJntZnslNhlNNgTdhHyvGkH"
            },
            "link": "/video-clip/Loi-Nho-Loi-Thuong-Thuy-Duong/ZW68EC68.html",
            "total_play": 3623,
            "likes": 2,
            "comments": 0
        },
        {
            "video_id": 1074764775,
            "title": "Anh Sáu Về Quê",
            "artist_id": "42513",
            "artist": "Thùy Dương",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,11,13",
            "thumbnail": "thumb_video/1/c/1cab9223efe1eb29be707c48266c252b_1383290434.jpg",
            "tag": "",
            "duration": 506,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1383290427,
            "source": {
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LnJHtZHNSNhSNNWtBhHyvmZn"
            },
            "link": "/video-clip/Anh-Sau-Ve-Que-Thuy-Duong/ZW68EC67.html",
            "total_play": 10884,
            "likes": 10,
            "comments": 0
        },
        {
            "video_id": 1074764774,
            "title": "Miền Tây Quê Tôi",
            "artist_id": "42513",
            "artist": "Thùy Dương",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,11,13",
            "thumbnail": "thumb_video/b/a/bacab7a6e23784cc9560ff7c2b79550f_1383290323.jpg",
            "tag": "",
            "duration": 299,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1383290315,
            "source": {
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/ZmxmTLHaSNClNNATdCHTbnZn"
            },
            "link": "/video-clip/Mien-Tay-Que-Toi-Thuy-Duong/ZW68EC66.html",
            "total_play": 10609,
            "likes": 16,
            "comments": 0
        },
        {
            "video_id": 1074761638,
            "title": "Cõng Mẹ Đi Chơi",
            "artist_id": "43616",
            "artist": "Nguyễn Duy Dũng",
            "composer_id": 482,
            "composer": "Trần Quế Sơn",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/f/9/f9e84037e128f3e52fc11510c98adaa2_1382585737.jpg",
            "tag": "",
            "duration": 338,
            "is_hit": 0,
            "have_lyrics": 1,
            "status_id": 1,
            "created_date": 1382585202,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/kHJGykmNANXLXVcyDAGybGZm",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LGJGtZnNlNhZXdxtVXnTbGLn",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LmJHTLGaAahZgVJTScmybHLG",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/kHcmyLmNzNCkXdxTNbGybmZG",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/ZHJHyLGsSNXkCdxTLnJmyvnLG"
            },
            "link": "/video-clip/Cong-Me-Di-Choi-Nguyen-Duy-Dung/ZW68E0W6.html",
            "total_play": 14571,
            "likes": 21,
            "comments": 2
        },
        {
            "video_id": 1074613928,
            "title": "Ngày Còn Anh Bên Tôi",
            "artist_id": "29901",
            "artist": "Lê Duy",
            "composer_id": 279,
            "composer": "Duy Khánh",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/0/d/0d59aaee64d6fbd36aee0f13385f6ba8_1382414068.jpg",
            "tag": "",
            "duration": 287,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1382411623,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/LGcmtZHNzXLBiFcyFlnTbnLH",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LnJHtLmazhZBEDcydCGyFGkn",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LHJmyLGalXkBibxyzcGtDmkn",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/LHcmtLHNAgZdRFxysFnybmLH"
            },
            "link": "/video-clip/Ngay-Con-Anh-Ben-Toi-Le-Duy/ZW669FW8.html",
            "total_play": 33836,
            "likes": 26,
            "comments": 0
        },
        {
            "video_id": 1074707561,
            "title": "Sông Nước Quê Tôi",
            "artist_id": "40023",
            "artist": "Steven Chí Dũng",
            "composer_id": 45,
            "composer": "Hồng Xương Long",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/c/9/c98dfcc2cfc904b1527eb28a993e6c57_1382354837.jpg",
            "tag": "",
            "duration": 323,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1382354580,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/ZGcmykGsANnNQgkTDAmyvGLH",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/ZnJmTLnsSNHNQCktVCntFnLH",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LmJnTkHNSaGsQgZTzxGtDnLG",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/LHJGtknNSNHNQgLyNFHybnLn",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/ZnJntLHazaGsQCkyZGJGTbGkH"
            },
            "link": "/video-clip/Song-Nuoc-Que-Toi-Steven-Chi-Dung/ZW680CE9.html",
            "total_play": 35640,
            "likes": 34,
            "comments": 2
        },
        {
            "video_id": 1074707530,
            "title": "Ba Chuyến Đò Ngang",
            "artist_id": "40023",
            "artist": "Steven Chí Dũng",
            "composer_id": 460,
            "composer": "Sơn Hạ",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/7/6/768341ac5a34ba3ceaa0de3d74913a1b_1382354529.jpg",
            "tag": "",
            "duration": 323,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1382354175,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/ZHJmtLGNlaGNWBnyvAmTDnLn",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/ZHxHtLnaSaGNpdntdCGyFmLG",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LmxGTLHsANGapVnySJmTvnLH",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/ZHxmTknNzNHNQVGTsbGtbGLn",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/kmcmtLmNlNnNQdGyLGJGTvnZm"
            },
            "link": "/video-clip/Ba-Chuyen-Do-Ngang-Steven-Chi-Dung/ZW680CCA.html",
            "total_play": 26346,
            "likes": 25,
            "comments": 6
        },
        {
            "video_id": 1074753351,
            "title": "LK Sến 2: Thói Đời",
            "artist_id": "42136",
            "artist": "Hoàng Long",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/3/8/386842227615223be38c4055aee0ae42_1382067747.jpg",
            "tag": "",
            "duration": 324,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1382067657,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/ZGJGTknaSNWVdWLyDznybGZn",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LGJnykmNlNWVBQLtBXnyvnZH",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/kHJmyLGNzNQddpLyAJmTDmLm",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/LGxHtkGNAaWBdpLtNvGTbnZm",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/LGJmTLHalapdBQLyZGJHybmZm"
            },
            "link": "/video-clip/LK-Sen-2-Thoi-Doi-Hoang-Long/ZW68BFC7.html",
            "total_play": 56478,
            "likes": 65,
            "comments": 2
        },
        {
            "video_id": 1074752203,
            "title": "Cảm Ơn Mẹ (Mẹ Tôi)",
            "artist_id": "5",
            "artist": "Quách Tuấn Du",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,8,11",
            "thumbnail": "thumb_video/c/3/c37dae7c1fb6267db15232a864826d59_1382001595.jpg",
            "tag": "",
            "duration": 287,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1382001590,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/knJmtZHszsWbFmBTFlGyDnLH",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LGcmyZnNzspFvmVtBCGybGLn",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/knJntLmszNpDvndyAJnyvmLH",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/LHxGtkHNzapbvGVyNDnTFHZH",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/knJGtZmalNQvbndTkGJmTbmLm"
            },
            "link": "/video-clip/Cam-On-Me-Me-Toi-Quach-Tuan-Du/ZW68BBUB.html",
            "total_play": 186748,
            "likes": 296,
            "comments": 7
        },
        {
            "video_id": 1074748031,
            "title": "Quang Gánh Mẹ Tôi (Teaser)",
            "artist_id": "2086",
            "artist": "Various Artists",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,11",
            "thumbnail": "thumb_video/1/d/1d8df4c4db941fa67cca682c2f68c935_1381738521.jpg",
            "tag": "",
            "duration": 35,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1381738514,
            "source": {
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LHJGyZHazNlcmdkydhGybmkm"
            },
            "link": "/video-clip/Quang-Ganh-Me-Toi-Teaser-Various-Artists/ZW68AAFF.html",
            "total_play": 47761,
            "likes": 129,
            "comments": 0
        },
        {
            "video_id": 1074748029,
            "title": "Liên Khúc Nỗi Buồn Hoa Phượng - Phượng Buồn",
            "artist_id": "40804,8905",
            "artist": "Triệu Phát , Nguyệt Ánh",
            "composer_id": 0,
            "composer": "",
            "genre_id": "1,8,11,13",
            "thumbnail": "thumb_video/e/2/e23ac71f830a2bdccd98a5d160e67c2f_1381737814.jpg",
            "tag": "",
            "duration": 255,
            "is_hit": 0,
            "have_lyrics": 0,
            "status_id": 1,
            "created_date": 1381737808,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/LGJnyLmNlNAxHbitvznTDGkm",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/ZHJGykGNSsScnbuyBCnTvnZn",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/kmxGyLmsAsSxHvETSJHTFmZm",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/LmxHTkmNSsAcmDEtNvGybHLn",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/LmcmTLGazslJGvETkHJHTvnZG"
            },
            "link": "/video-clip/Lien-Khuc-Noi-Buon-Hoa-Phuong-Phuong-Buon-Trieu-Phat-Nguyet-Anh/ZW68AAFD.html",
            "total_play": 56637,
            "likes": 59,
            "comments": 4
        }
    ],
    "response": {
        "msgCode": 1
    }
}
```
### Get video info

	http://api.mp3.zing.vn/api/mobile/video/getvideoinfo?keycode={YOUR_KEY}&requestdata={{"id":1074729245}}

Example: 

	http://api.mp3.zing.vn/api/mobile/video/getvideoinfo?keycode=fafd463e2131914934b73310aa34a23f&requestdata={"id":1074729245}

Response:

```json
{
    "video_id": 1074729245,
    "title": "Xin Anh Đừng Đến",
    "artist_id": "465",
    "artist": "Bảo Thy",
    "genre_id": "1,8,66",
    "thumbnail": "thumb_video/d/c/dcacff355635deedf62fd80de34f2346_1380622208.jpg",
    "duration": 307,
    "status_id": 1,
    "link": "/video-clip/Xin-Anh-Dung-Den-Bao-Thy/ZW686I9D.html",
    "source": {
        "240": "http://api.mp3.zing.vn/api/mobile/source/video/kHJGykmsSNvEbzWyblmtFmZH",
        "360": "http://api.mp3.zing.vn/api/mobile/source/video/kGcmTkGNlsDEvzQtdXnyDHLn",
        "480": "http://api.mp3.zing.vn/api/mobile/source/video/kmcGTLmNSNbuvSpySxnTvmLm",
        "720": "http://api.mp3.zing.vn/api/mobile/source/video/kGJGyLHNzaDRDzpysvmyvHkm",
        "1080": "http://api.mp3.zing.vn/api/mobile/source/video/ZHxmyknNSNDuFSWyZmJGtDHLG"
    },
    "total_play": 1550841,
    "likes": 7147,
    "like_this": false,
    "favourites": 0,
    "favourite_this": false,
    "comments": 229,
    "genre_name": "Việt Nam, Nhạc Trẻ, Nhạc Dance",
    "response": {
        "msgCode": 1
    }
}
```

### Get video lyrics

	http://api.mp3.zing.vn/api/mobile/video/getlyrics?keycode={YOUR_KEY}&requestdata={{"id":1074729245}}

Example 

	http://api.mp3.zing.vn/api/mobile/video/getlyrics?keycode=fafd463e2131914934b73310aa34a23f&requestdata={"id":1074729245}

```json
{
    "id": "1207338",
    "content": "Xin Anh Đừng Đến\n(Bảo Thy on the mind)\nÁnh sáng trắng xóa bỗng thấy em trong cơn mơ\nMột mình em như kề bên không còn ai\nBờ vai em đang run run khi không gian đang chìm sâu\nTrong ánh mắt em giờ đây một màu u tối.\n\nNhớ ánh mắt ấy tiếng nói ấy sao giờ đây\nChỉ còn em đang ngồi bên những niềm đau\nTự dặn mình hãy cố xóa hết những giấc mơ khi bên anh\nEm còn mơ, em còn mơ đầy thương nhớ.\n\nEm sẽ xóa hết những phút giây ta yêu thương\nĐể về sau gặp lại nhau em sẽ vơi đi nỗi đau\nHãy để nỗi nhớ khi mà em đang bơ vơ\nKhông cần anh không cần thương nhớ\nNhững ngày còn vụn vỡ\n\n(em sẽ cố quên)\n(tình yêu đó)\n\n[ĐK:]\nXin anh hãy nói, đôi ta chia tay\nCho con tim em không như bao ngày\nXin anh đừng đến trong cơn mơ\nĐể từng ngày qua em thôi trông mong chờ\nLeave me alone!\n\nHey Boy ! Shake your body x3\nHey Girl ! Let me Put your hands up in the air\n\n[ĐK:]\nXin anh hãy nói, đôi ta chia tay\nCho con tim em không như bao ngày\nXin anh đừng đến trong cơn mơ\nĐể từng ngày qua em thôi trông mong chờ\nLeave me alone!",
    "mark": 419,
    "status_id": 0,
    "author": "pynyuno",
    "created_date": 1380727569,
    "response": {
        "msgCode": 1
    }
}
```
### Get video suggestion

	http://api.mp3.zing.vn/api/mobile/video/getvideosuggest?requestdata={{"id":1074729245,"start":0,"length":20}}

Example: 

	http://api.mp3.zing.vn/api/mobile/video/getvideosuggest?requestdata={"id":1074729245,"start":0,"length":20}

Response:

```json
{
    "docs": [
        {
            "video_id": 1074721681,
            "title": "Xin Anh Đừng Đến (Teaser)",
            "artist": "Bảo Thy",
            "thumbnail": "thumb_video/f/6/f64dd9f5a429f0034481c443daf3fb64_1379901020.jpg",
            "total_play": 39622,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/LnxnTLnslaFZXJZyDlGTFGLH",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LHJmTLmazNvLCJkydgnybGkn",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/kHcHyLnNzNbLgcLyAxGtvHkn",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/kmJHtLGNzaDkgcLyNFmTvnZn"
            },
            "likes": 89,
            "comments": 3
        },
        {
            "video_id": 1074054885,
            "title": "Ngày Vắng Anh",
            "artist": "Bảo Thy",
            "thumbnail": "thumb_video/6/6/661d19a45bfcb6e78d52d6760985f1ce_1320380971.jpg",
            "total_play": 5032925,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LncmyZHNznQzxcWyAJHTbmLn"
            },
            "likes": 4111,
            "comments": 1600
        },
        {
            "video_id": 1073968552,
            "title": "Ngại Ngùng",
            "artist": "Angela Phương Trinh",
            "thumbnail": "thumb_video/c/c/cc1b33c32447f0150efbe492237f14cc_1314172216.jpg",
            "total_play": 4453329,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LGxnykHNBuCcWWvtAJGTbGkm"
            },
            "likes": 3664,
            "comments": 1448
        },
        {
            "video_id": 1074758835,
            "title": "Buồn",
            "artist": "Uyên Linh",
            "thumbnail": "thumb_video/b/2/b2ddd2fca2331c0a206154e68b21fa8e_1382422365.jpg",
            "total_play": 168493,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/LmxnyZnaSNWccBWtDzHyFnLH",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LHJnyLnNlsQxJdQyVXGTbnLn",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LnJHtknsSapxJdQyzxHybGkm",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/LGcnTLHNlsWxJdQtNbHyFnZG",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/ZGJmtkGNANQJxdWyLGcGTvGLm"
            },
            "likes": 2175,
            "comments": 44
        },
        {
            "video_id": 1074575248,
            "title": "Quên Đi",
            "artist": "Emily",
            "thumbnail": "thumb_video/b/a/ba99b7fcde085e754e22f5c6aed8494b_1367553445.jpg",
            "total_play": 2873232,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LmJnyLmaSQaQDSJyAxGyFHkG"
            },
            "likes": 5946,
            "comments": 146
        },
        {
            "video_id": 1074360360,
            "title": "Đắn Đo",
            "artist": "Hồ Ngọc Hà",
            "thumbnail": "thumb_video/5/2/52a2c0f065b3e44f78fb0825b03f6006_1349863571.jpg",
            "total_play": 2415019,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LnJHtZHazdgndhmyAJmtDmkn"
            },
            "likes": 3342,
            "comments": 313
        },
        {
            "video_id": 1074673921,
            "title": "Growl (Korean Ver.)",
            "artist": "EXO",
            "thumbnail": "thumb_video/3/8/383f016ec268ed4879da4d9aed743544_1375337116.jpg",
            "total_play": 559852,
            "source": {
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LHJmTkGNzgsVubLyBhHyDmZH",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/knJnyLnNlXaBEDLtlJGybnLG",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/LGxGTZGaACNdEbZyaDHTbnkG"
            },
            "likes": 3135,
            "comments": 75
        },
        {
            "video_id": 1074724027,
            "title": "Request",
            "artist": "Infinite",
            "thumbnail": "thumb_video/8/7/8739e961e6508fc359da5be9b3f79d4a_1380338530.jpg",
            "total_play": 116070,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/LnxGtknalNbAGvayDzHyFHLm",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/ZHJmtLnNANFlHvaTVXHTFHkH",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/knJnyknNlNbAmvstlJGTbmLn",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/kHxHTZmaANvAHFsysbHtDGZn",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/kGcmtZmNANbSHDNtLHJntbmLH"
            },
            "likes": 474,
            "comments": 12
        },
        {
            "video_id": 1074564782,
            "title": "Ngày Tinh Khôi",
            "artist": "Thanh Tâm (Tâm Tít)",
            "thumbnail": "thumb_video/7/9/799bad5a3b514f096e69bbc4a7896cd9_1365829680.jpg",
            "total_play": 694865,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LnxGyZGsAphAaJbylJHTFGkm"
            },
            "likes": 2027,
            "comments": 46
        },
        {
            "video_id": 1074641100,
            "title": "Bar Bar Bar",
            "artist": "Crayon Pop",
            "thumbnail": "thumb_video/2013/06/26/1/5/1514a4a931708f91e61048cc381cc9f4_3.jpg",
            "total_play": 590358,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LHJntZmszgALLHnySxGybmLG"
            },
            "likes": 1075,
            "comments": 82
        },
        {
            "video_id": 1074748062,
            "title": "Tình Mênh Mang",
            "artist": "Bảo Thy",
            "thumbnail": "thumb_video/1/5/15c1e690da9956fe55cec65cbbbdb6fb_1381741865.jpg",
            "total_play": 55852,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/knJnTLGNlsAJnhFTDlGybHLG",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/ZmJHtkGNANSJnCDTdXHtbnLH",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/kmJGyLnaAaSJHXvtlxnyDnLn",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/LGcntZmaANSJGhvyavmybHkn",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/LHJnTZmNANlJnhbyLHJHTFGLn"
            },
            "likes": 167,
            "comments": 0
        },
        {
            "video_id": 1074717521,
            "title": "Cheated",
            "artist": "5Dolls",
            "thumbnail": "thumb_video/2013/09/23/1/9/19a4c58ef831f2549990040ca37325ad_3.jpg",
            "total_play": 116965,
            "source": {
                "240": "http://api.mp3.zing.vn/api/mobile/source/video/LGJGtLnaSaksQbLyFSmyFHkn",
                "360": "http://api.mp3.zing.vn/api/mobile/source/video/LnJGyLHsSsLNWDZydXHyvnLn",
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LGJHTLmNzNZNpbZtAJGybmLn",
                "720": "http://api.mp3.zing.vn/api/mobile/source/video/LnxmyZHaSaLNQbLtNvHTbGZH",
                "1080": "http://api.mp3.zing.vn/api/mobile/source/video/LHJmtLGNlaLsWFZTLmJGTbHZn"
            },
            "likes": 299,
            "comments": 12
        }
    ],
    "numFound": 12,
    "response": {
        "msgCode": 1
    }
}
```

### Get video comments

	http://api.mp3.zing.vn/api/mobile/comment/getcommentofvideo?keycode={YOUR_KEY}&requestdata={"id":1074729245,"start":0,"length":20}

Example:

	http://api.mp3.zing.vn/api/mobile/comment/getcommentofvideo?keycode=fafd463e2131914934b73310aa34a23f&requestdata={"id":1074729245,"start":0,"length":20}

Response:

```json
{
    "numFound": 229,
    "docs": [
        {
            "commentId": 1873639651,
            "time": 1383891067,
            "content": "nhìn chất .đúng là bảo thy. bài nào cũng thấy hay.",
            "owner": {
                "userName": "heroin_la_tao",
                "displayName": "phươngg anhh"
            }
        },
        {
            "commentId": 1872645802,
            "time": 1383806416,
            "content": "sao mình thích nghe nhạc của chị bảo thy zậy ta !!! hay wá à",
            "owner": {
                "userName": "stella566.com",
                "displayName": "barbie hot girl kute"
            }
        },
        {
            "commentId": 1870829097,
            "time": 1383650179,
            "content": "mới nghe thôi mà đã thấy hay rùi, bài này nhìn chị giống người ai cập quá àk",
            "owner": {
                "userName": "loverabit_27",
                "displayName": "oOo Bunny Lâm cute oOo"
            }
        },
        {
            "commentId": 1870265868,
            "time": 1383575376,
            "content": "bài này mới nhìn zô tưởng người ấn độ nè lên top nhé",
            "owner": {
                "userName": "pemo121",
                "displayName": "Quân Phạm"
            }
        },
        {
            "commentId": 1869491949,
            "time": 1383527612,
            "content": "cố gắng ở lại top 10 nhe Em Không Còn Buồn, nghe hoài không chán nè, vui tóa",
            "owner": {
                "userName": "pynyuno",
                "displayName": "Pyn Yuno"
            }
        },
        {
            "commentId": 1869199064,
            "time": 1383484136,
            "content": "phong cách hàn.cũng tốt.rất biết tận dụng sự yêu thích của giới trẻ việt nam đối với nền âm nhạc Hàn quốc",
            "owner": {
                "userName": "baby_lonely919",
                "displayName": "Nhóc Ít Nói"
            }
        },
        {
            "commentId": 1869164659,
            "time": 1383483292,
            "content": "chị lô na ơi hay quá chị ơi em mong được nghe mấy bài nhạc sôi động cũa chị , hay hơn nhạc hàn quốc nữa mà cái này hơi dài, nếu từ 3 đến 4 phút thì thật tuyệt vời, tại em thích mấy bài ngắn ngắn nghe cho nó qua mau",
            "owner": {
                "userName": "ocsen9s",
                "displayName": "ocsen9s"
            }
        },
        {
            "commentId": 1868577658,
            "time": 1383459441,
            "content": "chị hát hay quá chị nhớ ra bài mới nửa nha mà nhớ ra bài hay giống vậy nha chị",
            "owner": {
                "userName": "nguyengiaquynh123",
                "displayName": "Nguyễn Gia Quỳnh"
            }
        },
        {
            "commentId": 1866168910,
            "time": 1383300810,
            "content": "hay wá.iu chị bảo thy nhìu.nổi nhất là đôi giày cao gót màu đen đính hạt vàng mà ở đoạn đầu chị bảo thy đội mũ đen đó.",
            "owner": {
                "userName": "ngocanh8102003",
                "displayName": "Lê Bảo Ngọc Anh"
            }
        },
        {
            "commentId": 1863798932,
            "time": 1383056927,
            "content": "chị bảo thy thân mến em rất thích bài hát này của chị em là fan hâm mộ của chị bảo thy em rất mến chị bảo thy",
            "owner": {
                "userName": "kimyensakura",
                "displayName": "kimyensakura"
            }
        },
        {
            "commentId": 1863764156,
            "time": 1383055499,
            "content": "bài này không hợp với bảo thy lắm. bảo thy là phải là công chúa bong bóng chứ",
            "owner": {
                "userName": "puccaubeo",
                "displayName": "Nguyễn Lý Gia Hân"
            }
        },
        {
            "commentId": 1863010824,
            "time": 1383011539,
            "content": "úi giời hay tuyệt vũ điệu của chị bảo thy hay thiệt",
            "owner": {
                "userName": "duc_thannuoc",
                "displayName": "Hồ Mạnh Đức"
            }
        },
        {
            "commentId": 1862324715,
            "time": 1382941541,
            "content": "hay wá đi chị bảo thy quay video wá cá tính dễ thương",
            "owner": {
                "userName": "camerlia",
                "displayName": "SUM x FLORA x STELLA x AISHA hÓm hỈnH"
            }
        },
        {
            "commentId": 1862169322,
            "time": 1382931391,
            "content": "nghe có khúc giống nhạc tiếng anh,là sao ta!chắc là đạo nhạc nưa rồi",
            "owner": {
                "userName": "nhoxrua0106",
                "displayName": "pe vjrut"
            }
        },
        {
            "commentId": 1862088966,
            "time": 1382923459,
            "content": "bài này hay quá đi à nhất là khúc dạo nhạc í chị thy ơi làm nhìu mv hay nữa nha",
            "owner": {
                "userName": "sori12645",
                "displayName": "Nguyễn Huỳnh Trúc Thy"
            }
        },
        {
            "commentId": 1861265030,
            "time": 1382857734,
            "content": "chị Bảo Thy ơi!Chị hát bài nào cũng hay hết.Em rất yêu chị,chị đẹp như thiên thần",
            "owner": {
                "userName": "nguyenquynhan2001",
                "displayName": " nguyenquynhan2001"
            }
        },
        {
            "commentId": 1860303216,
            "time": 1382793255,
            "content": "bảo thy nhảy đẹp thật! nữ hoàng ai cập bảo thy tuyệt vời",
            "owner": {
                "userName": "hienthichhuuhuy",
                "displayName": "Phan Thị Hiền"
            }
        },
        {
            "commentId": 1855971948,
            "time": 1382442763,
            "content": "chị hát hay wá em hum mộ chị lắm mong chị ra nhìu mc mới nhen",
            "owner": {
                "userName": "suna1912",
                "displayName": "Pôn Pé Pự"
            }
        },
        {
            "commentId": 1854888134,
            "time": 1382349985,
            "content": "Chị hát hay quá em sẽ mãi là fan của chịu I LOVE YOU BẢO THY",
            "owner": {
                "userName": "nhiprolaclam",
                "displayName": "Nhi Trần"
            }
        },
        {
            "commentId": 1854827122,
            "time": 1382346354,
            "content": "vũ đạo tuyệt cú mèo! nữ hoàng ai cập bảo tky muôn năm!!!!",
            "owner": {
                "userName": "heo548",
                "displayName": "ĨiÍ ngỐ ÍiĨ"
            }
        }
    ],
    "response": {
        "msgCode": 1
    }
}
```

## ARTISTS

### Get artists by genre

	http://api.mp3.zing.vn/api/mobile/artist/getartistbygenre?key={YOUR_KEY}&requestdata={{"sort":"","id":0,"length":20,"start":0}}

`{"sort":"alphabet","id":4,"length":20,"filter":"C","start":0}` => get artists whose names starting with "C"
`id` => genre, `Viet nam` or `Han quoc` ....

Example:
	
	http://api.mp3.zing.vn/api/mobile/artist/getartistbygenre?key=fafd463e2131914934b73310aa34a23f&requestdata={"sort":"","id":0,"length":20,"start":0}

Response:

```json
{
    "numFound": 42874,
    "start": 0,
    "docs": [
        {
            "artist_id": 16,
            "name": "Đàm Vĩnh Hưng",
            "avatar": "avatars/8/b/8bfbdc043fed3c56c42eb27108aac199_1376293480.jpg",
            "link": "/nghe-si/Dam-Vinh-Hung"
        },
        {
            "artist_id": 828,
            "name": "Quang Lê",
            "avatar": "avatars/9/6/96c7f8568cdc943997aace39708bf7b6_1376539870.jpg",
            "link": "/nghe-si/Quang-Le"
        },
        {
            "artist_id": 66,
            "name": "Đan Trường",
            "avatar": "avatars/c/9/c93c54b690b08b0fffa8833f44137c6c_1328519684.jpg",
            "link": "/nghe-si/Dan-Truong"
        },
        {
            "artist_id": 2806,
            "name": "Khắc Việt",
            "avatar": "avatars/8/3/83865cedbe1e47ee62e62650f6c4d6d6_1380021418.jpg",
            "link": "/nghe-si/Khac-Viet"
        },
        {
            "artist_id": 3663,
            "name": "Phạm Trưởng",
            "avatar": "avatars/9/8/9852df962d52b3660be01189150f765a_1372655379.jpg",
            "link": "/nghe-si/Pham-Truong"
        },
        {
            "artist_id": 100,
            "name": "Lệ Quyên",
            "avatar": "avatars/1/4/141d134b51150f2c5ce233686b105a5b_1368517961.jpg",
            "link": "/nghe-si/Le-Quyen"
        },
        {
            "artist_id": 242,
            "name": "Lương Bích Hữu",
            "avatar": "avatars/a/0/a0ab8112abab50b3de78d440a15e211e_1371293203.jpg",
            "link": "/nghe-si/Luong-Bich-Huu"
        },
        {
            "artist_id": 209,
            "name": "Khánh Phương",
            "avatar": "avatars/3/8/38269d87c2710617130cf2c17796ac74_1366620491.jpg",
            "link": "/nghe-si/Khanh-Phuong"
        },
        {
            "artist_id": 6083,
            "name": "Hồ Quang Hiếu",
            "avatar": "avatars/1/b/1b03ea82b35e244e353228d6417cd53c_1380765906.jpg",
            "link": "/nghe-si/Ho-Quang-Hieu"
        },
        {
            "artist_id": 444,
            "name": "Đông Nhi",
            "avatar": "avatars/d/0/d0d31439e6c0ea1ae5afe5b73f04ce94_1343730207.jpg",
            "link": "/nghe-si/Dong-Nhi"
        },
        {
            "artist_id": 29,
            "name": "Cao Thái Sơn",
            "avatar": "avatars/e/7/e76998c126e70feb0b14779b36268128_1381922690.jpg",
            "link": "/nghe-si/Cao-Thai-Son"
        },
        {
            "artist_id": 465,
            "name": "Bảo Thy",
            "avatar": "avatars/d/f/dfeb09792969220943592c08142b9ef7_1376839232.jpg",
            "link": "/nghe-si/Bao-Thy"
        },
        {
            "artist_id": 484,
            "name": "Hồ Ngọc Hà",
            "avatar": "avatars/c/3/c300ae434343b009621c000ef85bc849_1381059559.jpg",
            "link": "/nghe-si/Ho-Ngoc-Ha"
        },
        {
            "artist_id": 966,
            "name": "Noo Phước Thịnh",
            "avatar": "avatars/a/c/acac606ea8ccc82446d3111736734a9f_1353582559.jpg",
            "link": "/nghe-si/Noo-Phuoc-Thinh"
        },
        {
            "artist_id": 3879,
            "name": "Minh Vương M4U",
            "avatar": "avatars/e/2/e2358dc9ba8b5b5e9bc0476dea165e9d_1373258860.jpg",
            "link": "/nghe-si/Minh-Vuong-M4U"
        },
        {
            "artist_id": 376,
            "name": "Mỹ Tâm",
            "avatar": "avatars/d/b/dbdbdce97a2ba5a55cebbea6a1119cd3_1369815533.jpg",
            "link": "/nghe-si/My-Tam"
        },
        {
            "artist_id": 6094,
            "name": "HKT",
            "avatar": "avatars/1/5/150840b5b5849fc50cfd4902cc102d99_1343638478.jpg",
            "link": "/nghe-si/HKT"
        },
        {
            "artist_id": 3094,
            "name": "The Men",
            "avatar": "avatars/a/d/ad7bc863acc50ad3b747c51c2f85b431_1373259706.jpg",
            "link": "/nghe-si/The-Men"
        },
        {
            "artist_id": 832,
            "name": "Tuấn Hưng",
            "avatar": "avatars/1/3/13f387c9049b09498fcd6df2a311b0e7_1369826590.jpg",
            "link": "/nghe-si/Tuan-Hung"
        },
        {
            "artist_id": 494,
            "name": "Thủy Tiên",
            "avatar": "avatars/2/3/23bf3db84bba29db458b1851ae7994bb_1380254086.jpg",
            "link": "/nghe-si/Thuy-Tien"
        }
    ],
    "response": {
        "msgCode": 1
    }
}
```

### Get artist info

    http://api.mp3.zing.vn/api/mobile/artist/getartistinfo?key={YOUR_KEY}&requestdata={{"id":828}}

Example:

    http://api.mp3.zing.vn/api/mobile/artist/getartistinfo?key=fafd463e2131914934b73310aa34a23f&requestdata={"id":828}

```json
{
    "artist_id": 828,
    "name": "Quang Lê",
    "alias": "",
    "birthname": "Leon Quang Lê",
    "birthday": "24/01/1981",
    "sex": 1,
    "genre_id": "1,11,13",
    "avatar": "avatars/9/6/96c7f8568cdc943997aace39708bf7b6_1376539870.jpg",
    "cover": "cover_artist/9/9/9920ce8b6c7eb43328383041acb58e76_1376539928.jpg",
    "cover2": "",
    "zme_acc": "",
    "role": "1",
    "website": "",
    "biography": "Quang Lê sinh ra tại Huế, trong gia đình gồm 6 anh em và một người chị nuôi, Quang Lê là con thứ 3 trong gia đình.\r\nĐầu những năm 1990, Quang Lê theo gia đình sang định cư tại bang Missouri, Mỹ.\r\nHiện nay Quang Lê sống cùng gia đình ở Los Angeles, nhưng vẫn thường xuyên về Việt Nam biểu diễn.\r\n\r\nSự nghiệp:\r\n\r\nSay mê ca hát từ nhỏ và niềm say mê đó đã cho Quang Lê những cơ hội để đi đến con đường ca hát ngày hôm nay. Có sẵn chất giọng Huế ngọt ngào, Quang Lê lại được cha mẹ cho theo học nhạc từ năm lớp 9 đến năm thứ 2 của đại học khi gia đình chuyển sang sống ở California . Anh từng đoạt huy chương bạc trong một cuộc thi tài năng trẻ tổ chức tại California. Thời gian đầu, Quang Lê chỉ xuất hiện trong những sinh hoạt của cộng đồng địa phương, mãi đến năm 2000 mới chính thức theo nghiệp ca hát. Nhưng cũng phải gần 2 năm sau, Quang Lê mới tạo được chỗ đứng trên sân khấu ca nhạc của cộng đồng người Việt ở Mỹ. Và từ đó, Quang Lê liên tục nhận được những lời mời biểu diễn ở Mỹ, cũng như ở Canada, Úc...\r\nLà một ca sĩ trẻ, cùng gia đình định cư ở Mỹ từ năm 10 tuổi, Quang Lê đã chọn và biểu diễn thành công dòng nhạc quê hương. Nhạc sĩ lão thành Châu Kỳ cũng từng khen Quang Lê là ca sĩ trẻ diễn đạt thành công nhất những tác phẩm của ông…\r\nQuang Lê rất hạnh phúc và anh xem lời khen tặng đó là sự khích lệ rất lớn để anh cố gắng nhiều hơn nữa trong việc diễn đạt những bài hát của nhạc sĩ Châu Kỳ cũng như những bài hát về tình yêu quê hương đất nước. 25 tuổi, được xếp vào số những ca sĩ trẻ thành công, nhưng Quang Lê luôn khiêm tốn cho rằng thành công thường đi chung với sự may mắn, và điều may mắn của anh là được lớn lên trong tiếng đàn của cha, giọng hát của mẹ.\r\nTiếng hát, tiếng đàn của cha mẹ anh quyện lấy nhau, như một sợi dây vô hình kết nối mọi người trong gia đình lại với nhau. Những âm thanh ngọt ngào đó chính là dòng nhạc quê hương mà Quang Lê trình diễn ngày hôm nay. Quang Lê cho biết: \"Mặc dù sống ở Mỹ đã lâu nhưng hình ảnh quê hương không bao giờ phai mờ trong tâm trí Quang Lê, nên mỗi khi hát những nhạc phẩm quê hương, những hình ảnh đó lại như hiện ra trước mắt\". Có lẽ vì thế mà giọng hát của Quang Lê như phảng phất cái không khí êm đềm của thành phố Huế.\r\nQuang Lê là con thứ 3 trong gia đình gồm 6 anh em và một người chị nuôi. Từ nhỏ, Quang Lê thường được người chung quanh khen là có triển vọng. Cậu bé chẳng hiểu \"có triển vọng\" là gì, chỉ biết là mình rất thích hát, và thích được cất tiếng hát trước người thân, để được khen ngợi và cổ vũ.\r\nĐầu những năm 1990, Quang Lê theo gia đình sang định cư tại bang Missouri, Mỹ. Một hôm, nhân có buổi lễ được tổ chức ở ngôi chùa gần nhà, một người quen của gia đình đã đưa Quang Lê đến để giúp vui cho chương trình sinh hoạt của chùa, và anh đã nhận được sự đón nhận nhiệt tình của khán giả. Quang Lê nhớ lại, \"người nghe không chỉ vỗ tay hoan hô mà còn thưởng tiền nữa\". Đối với một đứa trẻ 10 tuổi, thì đó quả là một niềm hạnh phúc lớn lao, khi nghĩ rằng niềm đam mê của mình lại còn có thể kiếm tiền giúp đỡ gia đình.\r\nQuan điểm của Quang Lê là khi dự định làm một việc gì thì hãy cố gắng hết mình để đạt được những điều mà mình mơ ước. Quang Lê cho biết anh toàn tâm toàn ý với dòng nhạc quê hương trữ tình mà anh đã chọn lựa và được đón nhận, nhưng anh tiết lộ là những lúc đi hát vũ trường, vì muốn thay đổi và để hòa đồng với các bạn trẻ, anh cũng trình bày những ca khúc \"Techno\" và cũng nhảy nhuyễn không kém gì vũ đoàn minh họa.\r\n\r\nAlbum:\r\n\r\nSương trắng miền quê ngoại (2003)\r\nXin gọi nhau là cố nhân (2004)\r\nHuế đêm trăng (2004)\r\nKẻ ở miền xa (2004)\r\n7000 đêm góp Lại (2005)\r\nĐập vỡ cây đàn (2007)\r\nHai quê (2008)\r\nTương tư nàng ca sĩ (2009)\r\nĐôi mắt người xưa (2010)\r\nPhải lòng con gái bến tre (2011)\r\nKhông phải tại chúng mình (2012)",
    "agency_name": "Ca sĩ Tự Do",
    "national_name": "Việt Nam",
    "is_official": 1,
    "year_active": "2000",
    "status_id": 1,
    "created_date": 0,
    "link": "/nghe-si/Quang-Le",
    "genre_name": "Việt Nam, Nhạc Trữ Tình",
    "response": {
        "msgCode": 1
    }
}
```

### Get artist albums

	http://api.mp3.zing.vn/api/mobile/artist/getalbumofartist?key={YOUR_KEY}&requestdata={{"id":347,"start":0,"length":20}}

Example:

	http://api.mp3.zing.vn/api/mobile/artist/getalbumofartist?key=fafd463e2131914934b73310aa34a23f&requestdata={"id":347,"start":0,"length":20}

Response:

```json
{
    "numFound": 30,
    "start": 0,
    "docs": [
        {
            "playlist_id": 1073744608,
            "playlist_id_encode": "ZWZ9ZB60",
            "title": "Bolero",
            "title_stripviet": "Bolero",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/a/5/a59f1cacc3ab574a35c0b01fdec4bea8_1288284042.jpg",
            "total_play": 24230
        },
        {
            "playlist_id": 1073744777,
            "playlist_id_encode": "ZWZ9ZC09",
            "title": "Kimi ga Suki",
            "title_stripviet": "Kimi-ga-Suki",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/3/7/3793f4e083d1035f76f3cbc7993fd491_1288455851.jpg",
            "total_play": 12239
        },
        {
            "playlist_id": 1073744544,
            "playlist_id_encode": "ZWZ9ZBW0",
            "title": "Home",
            "title_stripviet": "Home",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/6/3/63ec47b251e1e81af3c2b4f91709bb11_1288186336.jpg",
            "total_play": 11316
        },
        {
            "playlist_id": 1073743704,
            "playlist_id_encode": "ZWZ9Z7D8",
            "title": "I ♥ U",
            "title_stripviet": "I-U",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/f/d/fd0ca29665717bca6c98b8fee90cc75e_1286987677.jpg",
            "total_play": 11076
        },
        {
            "playlist_id": 1073813826,
            "playlist_id_encode": "ZWZA69CW",
            "title": "[(an imitation) blood orange]",
            "title_stripviet": "an-imitation-blood-orange",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/2/0/20edeceb5051a172872534eb427206a4_1354776514.jpg",
            "total_play": 10938
        },
        {
            "playlist_id": 1073788577,
            "playlist_id_encode": "ZWZA07WI",
            "title": "Mr.Children 2005-2010 (macro)",
            "title_stripviet": "Mr-Children-2005-2010-macro",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/5/5/551fc24b29280ddd91f617436759cc27_1336799552.jpg",
            "total_play": 10158
        },
        {
            "playlist_id": 1073748390,
            "playlist_id_encode": "ZWZ96AW6",
            "title": "Mr.Children 1996-2000",
            "title_stripviet": "Mr-Children-1996-2000",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/1/b/1be2a3dfc1f2fc5bb8d75e03477f759c_1291223563.jpg",
            "total_play": 9492
        },
        {
            "playlist_id": 1073788576,
            "playlist_id_encode": "ZWZA07W0",
            "title": "Mr.Children 2001-2005 (micro)",
            "title_stripviet": "Mr-Children-2001-2005-micro",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/8/3/83b8262dc815ef7ff2bf193cc08c8942_1336799512.jpg",
            "total_play": 9214
        },
        {
            "playlist_id": 1073748389,
            "playlist_id_encode": "ZWZ96AWZ",
            "title": "Mr.Children 1992-1995",
            "title_stripviet": "Mr-Children-1992-1995",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/c/7/c70b8d579bdacf419d87c4868dcbf3bb_1291223410.jpg",
            "total_play": 7956
        },
        {
            "playlist_id": 1073749798,
            "playlist_id_encode": "ZWZ96FA6",
            "title": "It's A Wonderful World",
            "title_stripviet": "It-s-A-Wonderful-World",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/9/2/9260db3c2a13022a6c4a5a01c78d6842_1292755945.jpg",
            "total_play": 7333
        },
        {
            "playlist_id": 1073758521,
            "playlist_id_encode": "ZWZ99IB9",
            "title": "B-SIDE (CD1)",
            "title_stripviet": "B-SIDE-CD1",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/d/d/dd50a1043fa6d2050347e3185e5d6aa1_1304625975.jpg",
            "total_play": 6841
        },
        {
            "playlist_id": 1073758522,
            "playlist_id_encode": "ZWZ99IBA",
            "title": "B-SIDE (CD2)",
            "title_stripviet": "B-SIDE-CD2",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/d/d/dd50a1043fa6d2050347e3185e5d6aa1_1304626030.jpg",
            "total_play": 6500
        },
        {
            "playlist_id": 1073787149,
            "playlist_id_encode": "ZWZA0I8D",
            "title": "祈り ~涙の軌道 (Inori - Namida no Kido) / End Of The Day / Pieces",
            "title_stripviet": "Inori-Namida-no-Kido-End-Of-The-Day-Pieces",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/0/8/08c88ce745e2e18f18ec504d12ccafcb_1335319523.jpg",
            "total_play": 4828
        },
        {
            "playlist_id": 1073744550,
            "playlist_id_encode": "ZWZ9ZBW6",
            "title": "Q.",
            "title_stripviet": "Q",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/a/3/a30590dee90d658f2504b1d7613a3f6e_1288188594.jpg",
            "total_play": 4755
        },
        {
            "playlist_id": 1073748388,
            "playlist_id_encode": "ZWZ96AWU",
            "title": "Sense",
            "title_stripviet": "Sense",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/3/9/39fd461c5b7410b0485f8d9afac73dd7_1291222436.jpg",
            "total_play": 4338
        },
        {
            "playlist_id": 1073748500,
            "playlist_id_encode": "ZWZ96A9U",
            "title": "Tomorrow Never Knows",
            "title_stripviet": "Tomorrow-Never-Knows",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/d/7/d78019fe1d47d665495010d469f954e8_1291291673.jpg",
            "total_play": 3902
        },
        {
            "playlist_id": 1073743285,
            "playlist_id_encode": "ZWZ9Z6OZ",
            "title": "Supermarket Fantasy",
            "title_stripviet": "Supermarket-Fantasy",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/f/7/f75524897b4478351b193b5478d2d13b_1286649327.jpg",
            "total_play": 3674
        },
        {
            "playlist_id": 1073743698,
            "playlist_id_encode": "ZWZ9Z7DW",
            "title": "Hanabi",
            "title_stripviet": "Hanabi",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/0/8/0850d62b8fe3f54842cf0f2ef3a47c17_1286971202.jpg",
            "total_play": 3585
        },
        {
            "playlist_id": 1073744551,
            "playlist_id_encode": "ZWZ9ZBW7",
            "title": "シフクノオト (Shifuku no Oto)",
            "title_stripviet": "Shifuku-no-Oto",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/1/1/11caff0ece444802136f802e69629ec9_1288190249.jpg",
            "total_play": 3456
        },
        {
            "playlist_id": 1073744561,
            "playlist_id_encode": "ZWZ9ZBOI",
            "title": "Discovery",
            "title_stripviet": "Discovery",
            "artist": "Mr.Children",
            "artist_stripviet": "Mr-Children",
            "cover": "covers/7/c/7c5512d92038cf06aec6cd63f8a20a33_1288191848.jpg",
            "total_play": 2818
        }
    ],
    "response": {
        "msgCode": 1
    }
}
```

### Get artist songs

	http://api.mp3.zing.vn/api/mobile/artist/getsongofartist?key={YOUR_KEY}&requestdata={{"id":347,"start":0,"length":20}}

Example:

	http://api.mp3.zing.vn/api/mobile/artist/getsongofartist?key=fafd463e2131914934b73310aa34a23f&requestdata={"id":347,"start":0,"length":20}

```json
{
    "numFound": 285,
    "start": 0,
    "docs": [
        {
            "song_id": 1074432315,
            "title": "過去と未来と交信する男 (Kako To Mirai To Koushin Suru Otoko)",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kGJHTZGslzBbVLQykDJyDnLm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kGxGykGNzSdDdZQyVFnyDmLn",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kncnyZHNAAdvVZQyLFJybnZn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LGxnTknNAABvdkWyVbGTvnLG",
                "lossless": ""
            },
            "link": "/bai-hat/Kako-To-Mirai-To-Koushin-Suru-Otoko-Mr-Children/ZW6OD9BB.html"
        },
        {
            "song_id": 1074432316,
            "title": "Happy Song",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LncnTkHNlABDVZXTLvJyvmkm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LncnyknszSdFVLhyVDnTDmZG",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LHJHTLmNlldbVkhtLvcTDGLn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LGJGTLGaSlBvdLhtdFmTbHkm",
                "lossless": ""
            },
            "link": "/bai-hat/Happy-Song-Mr-Children/ZW6OD9BC.html"
        },
        {
            "song_id": 1074432310,
            "title": "常套句 (Joutouku)",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/knJGyZnNSldbBLGtZvJyFHLH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LmxGyLnNlSdbVLHTdvmTbnZn",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LGJmTLHNzABDdLHtLFJyvHLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZnJnyLnaAldbdkntdbGyFHZm",
                "lossless": ""
            },
            "link": "/bai-hat/Joutouku-Mr-Children/ZW6OD9B6.html"
        },
        {
            "song_id": 1074432317,
            "title": "祈り 〜涙の軌道 (Inori -Namida No Kidou)",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZHJGTLnNlAdFBkNTZbcyDnZH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kGJGTLGNSlBDVLsTBbGybmkn",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LmJGyZmsASBFdLsyLFJyFGLG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmxmtLmNlzBDdLNTdDmtvmkG",
                "lossless": ""
            },
            "link": "/bai-hat/Inori-Namida-No-Kidou-Mr-Children/ZW6OD9BD.html"
        },
        {
            "song_id": 1074432312,
            "title": "イミテーションの木 (Imitation No Ki)",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHcHyZnazAVDVkvyLvJybHkn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LmJGyknNAAdbVkbydDnTDnLn",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kGxmTknaSAVvdkDyZDJtFmLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LmJGyZmNlSVbBLvtBvHTDmkH",
                "lossless": ""
            },
            "link": "/bai-hat/Imitation-No-Ki-Mr-Children/ZW6OD9B8.html"
        },
        {
            "song_id": 1074432308,
            "title": "Marshmallow Day",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kGJHtLGsllVFBGJTkbJTDGLH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kHJHyLHaAzdDBmcyVDHybmkm",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LnJmyZnNSlVFdHcyZFxybmLH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZnJHtZGNzlVvVnxydbHyFHZH",
                "lossless": ""
            },
            "link": "/bai-hat/Marshmallow-Day-Mr-Children/ZW6OD9BU.html"
        },
        {
            "song_id": 1074198877,
            "title": "And I Love You",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHJHTLnazLucJNsykvJTDHLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LGcnyknNlLuJJaNydvnTvmZG",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LHJmyLnaALuxxsNyLDxyvnZH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZncmTLGNALixJaNyBbnyvmLn",
                "lossless": ""
            },
            "link": "/bai-hat/And-I-Love-You-Mr-Children/ZW60U9DD.html"
        },
        {
            "song_id": 1074192516,
            "title": "祈り ~涙の軌道 (Inori - Namida No Kido)",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kHJntLHaSLEbWLhyZvctvGkG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kHJHyLHslZEvWkCyVvnyvmLG",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LncmyLHsSLuvQLCTLFJybHkn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LmcHtkHaSLEFQkgtdvnTDGLH",
                "lossless": ""
            },
            "link": "/bai-hat/Inori-Namida-No-Kido-Mr-Children/ZW60OI0U.html"
        },
        {
            "song_id": 1074198876,
            "title": "Sign",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kGJnTLGaALuJJshTZDcyDHLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LmJntLGslZuJcaXyBDmTFnLH",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZmJnTLHNzZRJcsCTLvJybHLG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmJGtLGalkEcJaCtdDnyFmZn",
                "lossless": ""
            },
            "link": "/bai-hat/Sign-Mr-Children/ZW60U9DC.html"
        },
        {
            "song_id": 1074198879,
            "title": "ランニングハイ (Running High)",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kGJHykHNSLuxJsRyLDJTDmkG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LnJmyLHszZEJcsutVvmTDnkn",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LGxGtZGNAkEccNiTkFJyFGZH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZmcmTLGslZEJJsuTdbHyvnkG",
                "lossless": ""
            },
            "link": "/bai-hat/Running-High-Mr-Children/ZW60U9DF.html"
        },
        {
            "song_id": 1074198848,
            "title": "Hanabi",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LnJHyLHNAkEJxlxyZvxyDnkG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZGJmyZHszLixclxyVFHtDHZG",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LmxGykHazLicJlJTZbxyvGLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kHcnykGNALucJSJtBvnTFnZH",
                "lossless": ""
            },
            "link": "/bai-hat/Hanabi-Mr-Children/ZW60U9C0.html"
        },
        {
            "song_id": 1074192518,
            "title": "Pieces",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LGJGtLHNlZRDWkctLvJTvGZn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LmcmtZGsALRbpLctBvntbmLG",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZHJHyLmNSZuDpZJyLbJyFmLG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZHcGyZmNALiDpZJydFmyDGZm",
                "lossless": ""
            },
            "link": "/bai-hat/Pieces-Mr-Children/ZW60OI06.html"
        },
        {
            "song_id": 1073759034,
            "title": "HANABI",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHcGtLGaBaQuHVzTLbJyFnkH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZnxHTLGNVspRHBzydFGTvHZm",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LGJmtkGsVaQEGdzTLbJtvHLG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LmJnyLGsVNQunVSyBbmyDmZG",
                "lossless": ""
            },
            "link": "/bai-hat/HANABI-Mr-Children/ZWZ99OBA.html"
        },
        {
            "song_id": 1073821691,
            "title": "One, Two, Three",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LnJnyLmNBxDLXEkyLDcyFnkn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LHJHTLHsBxbLCRZyVFmTvGZH",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LmJGTLGaVJDZhiZTkbxyvmLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LncmyZnsdJFkgEkTBvnyFnLm",
                "lossless": ""
            },
            "link": "/bai-hat/One-Two-Three-Mr-Children/ZWZA887B.html"
        },
        {
            "song_id": 1073759904,
            "title": "And I Love You",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZnxHTLGsdsQuiHzTZvJyFmZn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LHxntZGadapiimStBvmybHZH",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZmcGyLmNVNWEuGztLvxyDmZG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHJntkHNBsWiRGATVvnTDnLH",
                "lossless": ""
            },
            "link": "/bai-hat/And-I-Love-You-Mr-Children/ZWZ997W0.html"
        },
        {
            "song_id": 1074198878,
            "title": "未来 (Mirai)",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHJmyLGNALuJcaJyZFJtbnLH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZmJGyLmslZuxcNxydDGTvmkG",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LHJmykmsALuccNxyZFJyFnLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmxGTLGaALixJaJyBvHTvHLm",
                "lossless": ""
            },
            "link": "/bai-hat/Mirai-Mr-Children/ZW60U9DE.html"
        },
        {
            "song_id": 1074198875,
            "title": "くるみ (Kurumi)",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kHJHTknNAZEccNQyZvxTDHZm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZHcGyknNzZuJcaQTdbmybHLn",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kHcHTLHNALuJxspyLvxyDmkG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHJnyLmsSZRJcspydbnyFGLn",
                "lossless": ""
            },
            "link": "/bai-hat/Kurumi-Mr-Children/ZW60U9DB.html"
        },
        {
            "song_id": 1073808652,
            "title": "Tomorrow Never Knows",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kGcHyLmadJnJCpDykbctDmLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZGJmtLHsdJmJhQvTdDHTDHkn",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LHJHyLmNVcmJXQvtkDJtvnkG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kGJmyZnNdcHxgQDtBFGyDmZn",
                "lossless": ""
            },
            "link": "/bai-hat/Tomorrow-Never-Knows-Mr-Children/ZWZAZZ8C.html"
        },
        {
            "song_id": 1073808486,
            "title": "Innocent World",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZHJnyZnNVcncAxCykvxtFGkG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LmJHTZGNdJmJSxCyVDnTvnLm",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZHJntLmNVJmJlJCyLbJTvGZm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZHxGykGNVcnJzJgtdbmTFHLG",
                "lossless": ""
            },
            "link": "/bai-hat/Innocent-World-Mr-Children/ZWZAZUE6.html"
        },
        {
            "song_id": 1074198874,
            "title": "掌 (Tenohira)",
            "artist_id": "347",
            "artist": "Mr.Children",
            "album_id": 0,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LnJGTLnszZEJxslyLDJtvnZH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/knJnyZHNzLiJxNSyVvGtvmZH",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LHcmTZmaALucxNStLvJyDmkn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmxHtLGaAZiJcaAydbHyDHZn",
                "lossless": ""
            },
            "link": "/bai-hat/Tenohira-Mr-Children/ZW60U9DA.html"
        }
    ],
    "response": {
        "msgCode": 1
    }
}
```

### Get artist videos

	http://api.mp3.zing.vn/api/mobile/artist/getvideoofartist?key={YOUR_KEY}&requestdata={{"id":347,"start":0,"length":20}}

Example:

	http://api.mp3.zing.vn/api/mobile/artist/getvideoofartist?key=fafd463e2131914934b73310aa34a23f&requestdata={"id":347,"start":0,"length":20}

Response:

```json
{
    "numFound": 91,
    "start": 0,
    "docs": [
        {
            "video_id": "1074618459",
            "title": "Worlds End",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/8/b/8b7c7848606c3c74cedd9818fcaf6113_2.jpg",
            "total_play": 889,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/ZGJnyZnaSgkJlpuylJGyFHkG"
            },
            "link": "/video-clip/Worlds-End-Mr-Children/ZW66B0DB.html"
        },
        {
            "video_id": "1074618458",
            "title": "Worlds End & 365 Day (Music Station)",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/2/f/2f8a0cadcafd198b24b4c668ff67ea4f_2.jpg",
            "total_play": 424,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LmJHyknNzCkJlQJtSxmyDGZH"
            },
            "link": "/video-clip/Worlds-End-365-Day-Music-Station-Mr-Children/ZW66B0DA.html"
        },
        {
            "video_id": "1074618457",
            "title": "To U 2007 Home Tour Live",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/d/9/d9cf373c07af90b9e2d549738ed86c85_1.jpg",
            "total_play": 53,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/kHcHtZHalgkJApaTzcmyDHLG"
            },
            "link": "/video-clip/To-U-2007-Home-Tour-Live-Mr-Children/ZW66B0D9.html"
        },
        {
            "video_id": "1074618456",
            "title": "Tenohira (2004 Tour live)",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/2/e/2ee9805716c7c0f0647ee69bcb2e7cc6_2.jpg",
            "total_play": 144,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/knJHTZmNSXkcAWCtSJGTvHkn"
            },
            "link": "/video-clip/Tenohira-2004-Tour-live-Mr-Children/ZW66B0D8.html"
        },
        {
            "video_id": "1074618455",
            "title": "Shirushi (Karaoke)",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/4/b/4b587126043dd2bc4442404a73cc567e_1.jpg",
            "total_play": 364,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/ZmcmykHNACZJzWQTzxGyFGLG"
            },
            "link": "/video-clip/Shirushi-Karaoke-Mr-Children/ZW66B0D7.html"
        },
        {
            "video_id": "1074618454",
            "title": "Marshmallow day (2012 FN)",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/b/c/bc70a91ab70a31244f76ea665e90864d_1.jpg",
            "total_play": 0,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/kGxGyZGsSCkJlQAtlxHyvnLG"
            },
            "link": "/video-clip/Marshmallow-day-2012-FN-Mr-Children/ZW66B0D6.html"
        },
        {
            "video_id": "1074618453",
            "title": "Joutouku (Best Artist 2012)",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/3/3/33d662e326e46073e40bd25b4965e4c2_2.jpg",
            "total_play": 191,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/ZHxHtLHazXZxlWdtSJGybHZG"
            },
            "link": "/video-clip/Joutouku-Best-Artist-2012-Mr-Children/ZW66B0DZ.html"
        },
        {
            "video_id": "1074618452",
            "title": "Joutouku (2012 FNS)",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/3/5/3536ad9729569926d0925b955425e223_3.jpg",
            "total_play": 0,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LHxntLHNzXZxAQvTSJnyvGLm"
            },
            "link": "/video-clip/Joutouku-2012-FNS-Mr-Children/ZW66B0DU.html"
        },
        {
            "video_id": "1074618451",
            "title": "HANABI",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/f/4/f44f1317d57a7fe4b7795dbbeb5c7e1f_3.jpg",
            "total_play": 322,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LmJmykHszhLJApZtScGtFnkn"
            },
            "link": "/video-clip/HANABI-Mr-Children/ZW66B0DO.html"
        },
        {
            "video_id": "1074618450",
            "title": "Gift",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/b/f/bf6752fdc89580a4914a9a33e9a1c33e_2.jpg",
            "total_play": 0,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/ZmxmTLmNlgZJSpmySxmyvHLG"
            },
            "link": "/video-clip/Gift-Mr-Children/ZW66B0DW.html"
        },
        {
            "video_id": "1074618449",
            "title": "Find The Way (live)",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/f/e/fedc3e30687d67e70f3a21c6de7d7040_3.jpg",
            "total_play": 0,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/ZHcGtLmsSXLJSliyzxmTFnLm"
            },
            "link": "/video-clip/Find-The-Way-live-Mr-Children/ZW66B0DI.html"
        },
        {
            "video_id": "1074618448",
            "title": "Any",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/f/f/ff2e8f095a6559bd642899ddf8e6d527_1.jpg",
            "total_play": 337,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LGxHyLmslCLJzzJyzJHtFGLn"
            },
            "link": "/video-clip/Any-Mr-Children/ZW66B0D0.html"
        },
        {
            "video_id": "1074618447",
            "title": "Final journey Warinaki (2009 Dome Tour Supermarket Fantasy)",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/d/c/dce8ebd14bd10d139dfd5f0d8f801f31_3.jpg",
            "total_play": 0,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LmcntLmaACZczAatAcHTDmLH"
            },
            "link": "/video-clip/Final-journey-Warinaki-2009-Dome-Tour-Supermarket-Fantasy-Mr-Children/ZW66B0CF.html"
        },
        {
            "video_id": "1074618446",
            "title": "GIFT & Esora (HAPPY X'mas SHOW)",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/b/5/b59ea98fb5e8673ac2adcc4180fe08e1_2.jpg",
            "total_play": 20,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/knJGTknaAgZxAAgTlJntbnLm"
            },
            "link": "/video-clip/GIFT-Esora-HAPPY-X-mas-SHOW-Mr-Children/ZW66B0CE.html"
        },
        {
            "video_id": "1074618445",
            "title": "and I love you (live)",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/d/9/d92b2cf446bf89fb1e30dd7948c699e5_3.jpg",
            "total_play": 105,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LGcmyLmsAgZJllQylJGyvHLm"
            },
            "link": "/video-clip/and-I-love-you-live-Mr-Children/ZW66B0CD.html"
        },
        {
            "video_id": "1074618444",
            "title": "Imagine 2007 Home Tour",
            "artist": "Mr.Children , John Lennon",
            "thumbnail": "thumb_video/2013/06/06/8/f/8f0a655a4952390f9ccbc3697d568ca4_2.jpg",
            "total_play": 113,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LGJntZnsSXkJllSTAJGybmLm"
            },
            "link": "/video-clip/Imagine-2007-Home-Tour-Mr-Children-John-Lennon/ZW66B0CC.html"
        },
        {
            "video_id": "1074618443",
            "title": "Tomorrow Never Knows",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/7/8/7856c45c77c148a671952792a6b3522c_3.jpg",
            "total_play": 0,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/ZGJnyZHsSXZczzBtAJGTDnkH"
            },
            "link": "/video-clip/Tomorrow-Never-Knows-Mr-Children/ZW66B0CB.html"
        },
        {
            "video_id": "1074618434",
            "title": "Yasashii Uta",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/d/3/d3d60012e90c6ff22fa7ff3f37c75127_3.jpg",
            "total_play": 6,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LnJmTZmNShLxSBlTAcGyvHkH"
            },
            "link": "/video-clip/Yasashii-Uta-Mr-Children/ZW66B0CW.html"
        },
        {
            "video_id": "1074618433",
            "title": "Tomorrow Never Knows (Anime Ver.)",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/d/0/d04f93fdb5732a1f38360386ea570eff_1.jpg",
            "total_play": 1602,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/kHJHtLnsACZxAdVTSxHtbmLH"
            },
            "link": "/video-clip/Tomorrow-Never-Knows-Anime-Ver-Mr-Children/ZW66B0CI.html"
        },
        {
            "video_id": "1074618432",
            "title": "Sign (Karaoke)",
            "artist": "Mr.Children",
            "thumbnail": "thumb_video/2013/06/06/7/e/7e07aec3c80049d29d5c37d5588c0e35_3.jpg",
            "total_play": 120,
            "source": {
                "480": "http://api.mp3.zing.vn/api/mobile/source/video/LHJnykmNlhLJzBvyAJnTDHLn"
            },
            "link": "/video-clip/Sign-Karaoke-Mr-Children/ZW66B0C0.html"
        }
    ],
    "response": {
        "msgCode": 1
    }
}
```

## CHARTS

### All

	http://api.mp3.zing.vn/api/mobile/charts/getchartslist?key={YOUR_KEY}&requestdata={{"type":"all"}}

Example 1: Getting general info 

	http://api.mp3.zing.vn/api/mobile/charts/getchartslist?key=fafd463e2131914934b73310aa34a23f&requestdata={"type":"all"}

Response:

```json
{
    "numFound": 0,
    "docs": {
        "song": [
            {
                "charts_id": 1,
                "thumbnail": "avatars/c/4/c41664c555e4e39cd4c98617e8903734_1383458736.jpg"
            },
            {
                "charts_id": 50,
                "thumbnail": "avatars/0/2/02cc63cf5c74cf4fd497e32da404e986_1380957810.jpg"
            },
            {
                "charts_id": 51,
                "thumbnail": "avatars/d/9/d993b700c132ab1400e0e8a342011edf_1383409988.jpg"
            }
        ],
        "video": [
            {
                "charts_id": 2,
                "thumbnail": "avatars/7/6/76d193be4217d858b53f965aa229491f_1383458503.jpg"
            },
            {
                "charts_id": 52,
                "thumbnail": "avatars/a/a/aa37f90f0ab715e01d5654c45b96eb32_1382778605.png"
            },
            {
                "charts_id": 53,
                "thumbnail": "avatars/8/7/87c4ed8a05d0cf57dfd745d6370eb817_1383411112.jpg"
            }
        ],
        "album": [
            {
                "charts_id": 3,
                "thumbnail": "avatars/8/9/89090568d141e9d574184d2e2801f76c_1383458485.jpg"
            },
            {
                "charts_id": 54,
                "thumbnail": "covers/6/2/62637d23e96b19ff8fed97ad8926dcd0_1379396734.jpg"
            },
            {
                "charts_id": 55,
                "thumbnail": "avatars/e/2/e279262902af0d22dd4c5efa2133ba0d_1381595002.jpg"
            }
        ]
    },
    "start": 0,
    "response": {
        "msgCode": 1
    }
}
```

Example 2: Getting top items (songs,albums or videos) in each category

	http://api.mp3.zing.vn/api/mobile/charts/getchartsinfo?key=fafd463e2131914934b73310aa34a23f&requestdata={"week":44,"id":50,"year":2013,"length":40,"start":0}

Response:

```json
{
    "charts_id": 50,
    "charts_id_encode": "IWZ9Z0BW",
    "title": "Bảng Xếp Hạng Bài Hát Âu Mỹ - Tuần 44, 2013",
    "album_id": 1073852092,
    "name": "Âu Mỹ",
    "type": "song",
    "group": "us-uk",
    "week": 44,
    "year": "2013",
    "date_start": 1382893200,
    "item": [
        {
            "song_id": 1074649254,
            "title": "Royals",
            "artist": "Lorde",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/0/2/02cc63cf5c74cf4fd497e32da404e986_1380957810.jpg",
            "order": 1,
            "pos_status": 0,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Royals-Lorde/ZW67W9W6.html",
            "total_play": 397268,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LnJmTLGazXliDQzyLbcTFGZH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kGcGTZHaACzRDQAyBFHTvHkG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/ZHxmtLGaACzuFQltrwffUYeftvnLG"
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LHxmyLnNAglEbQSyLvctbmZn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LmJmyLmaAgzRvQSTdDmtFGLH",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/ZnxHtLGaSCSiFWAyrOKfUoKfTvHLn"
            }
        },
        {
            "song_id": 1074681564,
            "title": "Roar",
            "artist": "Katy Perry",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/3/e/3e7b91cf901d8b4137a2be7875dd7e1f_1379600711.jpg",
            "order": 2,
            "pos_status": 0,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Roar-Katy-Perry/ZW67A7ZC.html",
            "total_play": 1053654,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LmxGyLGslhxkWgSTLbJtbHLn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LHJGyLGNzhckQgStdFGTbmZm",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/knJmTZmNlXcLWhSTkbJyFGkn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kGJGykmsAXcZWXlTBbGTFmLG",
                "lossless": ""
            }
        },
        {
            "song_id": 1074693721,
            "title": "Wrecking Ball",
            "artist": "Miley Cyrus",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/5/0/50d2def00bcf2ac3f3780300218be884_1380955655.jpg",
            "order": 3,
            "pos_status": 0,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Wrecking-Ball-Miley-Cyrus/ZW67D6D9.html",
            "total_play": 842002,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHxnTLnNSCRBaFLtLvctbnLH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZnJnyZmNlhRdabLtBFnTDHkn",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LmJGtZGNlXEdNFZyLbJyDGZn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZGcnyLHNzCiVNvLtVbHyFnLH",
                "lossless": ""
            }
        },
        {
            "song_id": 1074643883,
            "title": "Wake Me Up",
            "artist": "Avicii",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 0,
            "copyright": "Universal Music Group",
            "thumbnail": "avatars/b/f/bfa21f99ddb0c6c23b8f5e42213bb2e0_1375154566.jpg",
            "order": 4,
            "pos_status": 0,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Wake-Me-Up-Avicii/ZW67IUWB.html",
            "total_play": 400951,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHcGtkGNlCAVxJVTLvJyFmkn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/knJmyLHsSXSBJcdtBFmtvnLm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/LGxHTLHazCzVJxByrwffroefyDHLH"
            },
            "download_disable": 1,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZHJmyZGslXSdcJdTLvJtFmZn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LGxHykmsSXzVJcBTVFntDmZG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/ZmxntZHazglBxJVTUqKfIoKeTbGLH"
            }
        },
        {
            "song_id": 1074693421,
            "title": "Hold On, We're Going Home",
            "artist": "Drake , Majid Jordan",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/1/1/1167610aa17b0813233fe82d99403e41_1291644677.jpg",
            "order": 5,
            "pos_status": 0,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Hold-On-We-re-Going-Home-Drake-Majid-Jordan/ZW67DZAD.html",
            "total_play": 50776,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kGJHTZGalCEdSFLyZFcTDHZm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZGxGyZmalgRBAFkyBbntbmZn",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZmJnyZnazXEdzDkTLbxyFGZm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LnxntkmNSXRBzvZyVFHtbHLn",
                "lossless": ""
            }
        },
        {
            "song_id": 1074651373,
            "title": "Holy Grail",
            "artist": "Jay-Z , Justin Timberlake",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/f/b/fb99c47e948491d78859930807a78f77_1289881708.jpg",
            "order": 6,
            "pos_status": 2,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Holy-Grail-Jay-Z-Justin-Timberlake/ZW67OI6D.html",
            "total_play": 191977,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LnJHtLnNzgQkVNdTLbcTvmkn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZGxHtZGNzCQZdNdyVvGTbnZm",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LnxHyLnNAgQkdNdtLvJTvmLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LGJmyLGNzhQLVNdydDGtFGLG",
                "lossless": ""
            }
        },
        {
            "song_id": 1074682641,
            "title": "Applause",
            "artist": "Lady Gaga",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 0,
            "copyright": "Universal Music Group",
            "thumbnail": "avatars/d/c/dc9ddf34269d7a6e6ee8f7065f348b94_1376360932.jpg",
            "order": 7,
            "pos_status": 2,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Applause-Lady-Gaga/ZW67AB9I.html",
            "total_play": 317760,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LnJmtLnsSCJvhzLTkvJTDnZH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/knJHtLmNlCJvXALydbHtFGkG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/LmcmtkmslgJvhAZyUOKfUMffyFnZn"
            },
            "download_disable": 1,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZHxHyknazhJDhzLtLDJyvmLG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmxmyLnaAgxbhlZyBbGybGLG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/ZnxHtZmNlXxFgzLyIPfeUYffTDGLG"
            }
        },
        {
            "song_id": 1074545998,
            "title": "Counting Stars",
            "artist": "OneRepublic",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/4/f/4f982e2c106089dcfd59a222aab1ac3c_1363925216.jpg",
            "order": 8,
            "pos_status": 7,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Counting-Stars-OneRepublic/ZW6Z9ZCE.html",
            "total_play": 174306,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZGcHyLHNlWSpRRJTLDJTvnZG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LGxmtLmsAQlWuicyBbHyvmZm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/kGJntLGNAQzQERJtUOKeIoefTDHLm"
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LncmTLHNzpSQuiJTLvcTbHLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LGxGtkHalQSpRictVFntvnkG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/LmxGyZmszWlQuiJtUPeKIoffyDnZm"
            }
        },
        {
            "song_id": 1074330219,
            "title": "Demons",
            "artist": "Imagine Dragons",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 0,
            "copyright": "Universal Music Group",
            "thumbnail": "avatars/6/d/6d68e439d5a39d6888e323ade4c241e2_1348365793.png",
            "order": 9,
            "pos_status": 3,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Demons-Imagine-Dragons/ZW6WUAEB.html",
            "total_play": 264536,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/knJGyLnNzBdmvkEyLFJybnLm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZGJnykGslBdmFLiyVDHybnZn",
                "lossless": ""
            },
            "download_disable": 1,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZnJnyZmsSBBHbLETkDxyFnZH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kGJnykmsAdBGDLRyVvHyvGLn",
                "lossless": ""
            }
        },
        {
            "song_id": 1074708972,
            "title": "The Fox",
            "artist": "Ylvis",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/7/1/717f582d50a9389a483208e611757828_1379074216.jpg",
            "order": 10,
            "pos_status": -4,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/The-Fox-Ylvis/ZW68IW6C.html",
            "total_play": 151244,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kGJHyZGNlNHxRNFTZFxyDGkm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LHxHyLGNlanJRNbyVFmTFnLm",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kHJGtLGslNnJRNFTLFxyFHkH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmJHyLmNANmJiNFTBvHtvGkG",
                "lossless": ""
            }
        },
        {
            "song_id": 1074611041,
            "title": "Blurred Lines",
            "artist": "Robin Thicke , T.I. , Pharell",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 0,
            "copyright": "Universal Music Group",
            "thumbnail": "avatars/6/d/6d9fc951b2621a4b76b9231325c9e4d9_1378399023.jpg",
            "order": 11,
            "pos_status": -1,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Blurred-Lines-Robin-Thicke-T-I-Pharell/ZW669OEI.html",
            "total_play": 636682,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHxGykmNzCkLmAktLFJybHZm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LHJmtkGaAgkLGlLydDGTbHkm",
                "lossless": ""
            },
            "download_disable": 1,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZHJnyLmNAXkLHzLyLvJyvmLH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kHJnyZHalCLknAkydvHtFnZG",
                "lossless": ""
            }
        },
        {
            "song_id": 1074734975,
            "title": "23",
            "artist": "Mike WiLL Made-It , Miley Cyrus , Wiz Khalifa , Juicy J",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": null,
            "order": 12,
            "pos_status": 2,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/23-Mike-WiLL-Made-It-Miley-Cyrus-Wiz-Khalifa-Juicy-J/ZW6877FF.html",
            "total_play": 14849,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZnJGyZHNzNdlRaWyLFcybmZG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LGJHyLnsAsdAiaWtVvmyvGLm",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LGJGykHNSsBzENQyZFJTvGZm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LGJHTZmsSNdSiNWtdbnTFnZH",
                "lossless": ""
            }
        },
        {
            "song_id": 1074758144,
            "title": "Do What U Want",
            "artist": "Lady Gaga , R. Kelly",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 0,
            "copyright": "",
            "thumbnail": "avatars/d/c/dc9ddf34269d7a6e6ee8f7065f348b94_1376360932.jpg",
            "order": 13,
            "pos_status": null,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Do-What-U-Want-Lady-Gaga-R-Kelly/ZW68DW80.html",
            "total_play": 20716,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LGcGyLnsSNpxZSStLFctFHLn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LHJGyLHalaQJLzSyBvGyDmkH",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/ZGJGTkmszNpxklzTIPKfrYKKybmLn"
            },
            "download_disable": 1,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZmJGyLnazNpJkSlTkbctFGLH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmcHyLmalNQJLSlydDGtvGLm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/ZGJmtknNSNQJkSSTIOffrjeeyDGZn"
            }
        },
        {
            "song_id": 1074251942,
            "title": "Summertime Sadness",
            "artist": "Lana Del Rey",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 0,
            "copyright": "Universal Music Group",
            "thumbnail": "avatars/5/7/57e3d4ea7f883ed7adda48eb500030bd_1346828295.jpg",
            "order": 14,
            "pos_status": -3,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Summertime-Sadness-Lana-Del-Rey/ZW6II9W6.html",
            "total_play": 137959,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHJmtLGNlvQLilvTkDcyFnZn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LGJHyLnaAbQZEzvydFntvHLG",
                "lossless": ""
            },
            "download_disable": 1,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LGJmtLmNSvpkiSbtLbJyFHLn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LncHtkHNlvQkRAbTBbGyFHkG",
                "lossless": ""
            }
        },
        {
            "song_id": 1074524840,
            "title": "Safe And Sound",
            "artist": "Capital Cities",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 0,
            "copyright": "Universal Music Group",
            "thumbnail": null,
            "order": 15,
            "pos_status": -2,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Safe-And-Sound-Capital-Cities/ZW6ZUOW8.html",
            "total_play": 112267,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kmJGtkGsSWDAcznykFJyFmLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZHxHyZGsAQDAJAnydvntFHZm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/kGcnTLHNAQblJzntUwffIMeKyvHLG"
            },
            "download_disable": 1,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZnJnyLHsSWvlJSmyLvJyvHZn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LnJnyLHalWvSxAnydvHyDHLm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/LnxntLHsSpDSJlnyrOferjefTFHLm"
            }
        },
        {
            "song_id": 1074330215,
            "title": "Radioactive",
            "artist": "Imagine Dragons",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 0,
            "copyright": "Universal Music Group",
            "thumbnail": "avatars/6/d/6d68e439d5a39d6888e323ade4c241e2_1348365793.png",
            "order": 16,
            "pos_status": 0,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Radioactive-Imagine-Dragons/ZW6WUAE7.html",
            "total_play": 560398,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/knJnyLGaSddmbkQTLFJtFnLn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/knxmyZmNlVBGbLQtBFHTDmLG",
                "lossless": ""
            },
            "download_disable": 1,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZmxHyZGsSddnFLQyLDJyFnkH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/knJHtLnsAVdHFLWyBDmyDnLm",
                "lossless": ""
            }
        },
        {
            "song_id": 1074181714,
            "title": "Let Her Go",
            "artist": "Passenger",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": null,
            "order": 17,
            "pos_status": 2,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Let-Her-Go-Passenger/ZW6006DW.html",
            "total_play": 176280,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LnJnTLGNlZJkNkztLDxybHLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LmJHtLHsAZxkNkltdbmybnLn",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZncntLGNALcZNZATkvJybmLG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZGxmtZHaALcLaklTVvGybmLm",
                "lossless": ""
            }
        },
        {
            "song_id": 1074686064,
            "title": "That's My Kind Of Night",
            "artist": "Luke Bryan",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/5/d/5db9ccb0c565a88ef4c8065f82835578_1336249012.jpg",
            "order": 18,
            "pos_status": -1,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/That-s-My-Kind-Of-Night-Luke-Bryan/ZW67B8F0.html",
            "total_play": 8584,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZmxGtLGalCJXnXSyZbJTDGZn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LnxmyZHsSCxCnCzyBFmybGkm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/ZnxHykGNSXJXmClyIOKeUYefyvnLn"
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZGcntLGszCcgHhzyLbJyFnLn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHJGyLGslhchGXSyVFnyDGkG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/LGxGyLnNAhJhmhlTrqeeIMffyDmZH"
            }
        },
        {
            "song_id": 1074525100,
            "title": "Sail",
            "artist": "AWOLNATION",
            "username": "freshy89",
            "download_status": 1,
            "thumbnail": null,
            "order": 19,
            "pos_status": 4,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Sail-AWOLNATION/ZW6ZUUWC.html",
            "total_play": 29229,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZnJGyLmNzQFpLmHyLFJTDnkn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LGcmTLGNlQbWZHnyVDHybHZn",
                "lossless": ""
            },
            "copyright": "",
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LnxnyLGNlpFpLHmyZvcyvHZG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHxmyLmslWvQkGHyVvHTbGkG",
                "lossless": ""
            }
        },
        {
            "song_id": 1074755595,
            "title": "My Hitta",
            "artist": "YG , Jeezy , Rich Homie Quan",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/1/1/1167610aa17b0813233fe82d99403e41_1293264507.jpg",
            "order": 20,
            "pos_status": 0,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/My-Hitta-YG-Jeezy-Rich-Homie-Quan/ZW68C88B.html",
            "total_play": 1014,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kGxHtkHNSaWWQiptZvJtvnLm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kHcntkGazNWQpiWyBbmtvGLn",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LHxnTLmNSNQQQuWyLvJyFHkG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LGJGtZnszNQQpEQTVFHyFHLH",
                "lossless": ""
            }
        },
        {
            "song_id": 1074748647,
            "title": "Rap God",
            "artist": "Eminem",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/6/4/6491c2173d300d5bbbee6b4c326fa561_1376557444.jpg",
            "order": 21,
            "pos_status": -14,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Rap-God-Eminem/ZW68AD67.html",
            "total_play": 32589,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHxnyLmNlNSJXlstZDxyDGZn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LGJGyLnazNzJhSsydvHTbnkG",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LncnTkHNzsSJCzsykvJybnZG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LmJmTLGazaAxXANyVbHTbnLn",
                "lossless": ""
            }
        },
        {
            "song_id": 1074432393,
            "title": "Gorilla",
            "artist": "Bruno Mars",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/a/4/a4c4e539f35b30fb6c0c5c8d134990ef_1366022661.jpg",
            "order": 22,
            "pos_status": 0,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Gorilla-Bruno-Mars/ZW6ODA09.html",
            "total_play": 19539,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZmJmyLnNzSdFdRdTkFxyFmkG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZHxntZHsSlBFduBydvmTbHLm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/LnJmtLHNSzdvdRByrqKfroeeyFnkm"
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LHxntLmNzSdbdudykbctbmLH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHcmTZmNAldvBEdyVDHtbHZH",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/kGcntknNlldvdRdTUOefrjfeybmLH"
            }
        },
        {
            "song_id": 1074666509,
            "title": "Love More",
            "artist": "Chris Brown , Nicki Minaj",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/1/f/1fe0516fe9ab44c75fc969c939c03e55_1341891567.jpg",
            "order": 23,
            "pos_status": 2,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Love-More-Chris-Brown-Nicki-Minaj/ZW676C8D.html",
            "total_play": 19373,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LGJGTLHszgCgQnutLFJTFmZm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kmcHtkHNzhggQHRyVvmyFHLG",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kGJnyLGalCCCQGitLvxtDHZH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHJnTLHsAhghWHiydvHyDnkn",
                "lossless": ""
            }
        },
        {
            "song_id": 1074553051,
            "title": "Still Into You",
            "artist": "Paramore",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/b/0/b0430e6b2709e4ee4b2ad67850d7f2ca_1334840008.jpg",
            "order": 24,
            "pos_status": 2,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Still-Into-You-Paramore/ZW6ZBIZB.html",
            "total_play": 30780,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZnJnTLmNlQWVHpZtkvJyFGkn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LncHTZHNAQWBHQZtdFGyDmkH",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/ZHxGTLmsApQdmQLTIPKeUjeftbnLH"
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kHJGTLHazQpVGpZyLbJyFnLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LnJGyLnNzQWdmWkydFnyDmZm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/LmJnTkmNAQQdmpkTrPffrYKftFHkm"
            }
        },
        {
            "song_id": 1074694056,
            "title": "Berzerk",
            "artist": "Eminem",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/6/4/6491c2173d300d5bbbee6b4c326fa561_1376557444.jpg",
            "order": 25,
            "pos_status": -7,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Berzerk-Eminem/ZW67D8W8.html",
            "total_play": 82549,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZGcnykmNzCRlnpCtLDcTbHLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZnJHTLGNSCElGWgyBFmtbGZG",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LnJGyLHNlCESHpXykvxybmkn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHxnyZGsShEAHWhyBDnyvnkm",
                "lossless": ""
            }
        },
        {
            "song_id": 1074616949,
            "title": "We Can't Stop",
            "artist": "Miley Cyrus",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/d/f/df7f79399e9e96e7d5d4e41f15cddb54_1342772217.jpg",
            "order": 26,
            "pos_status": -5,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/We-Can-t-Stop-Miley-Cyrus/ZW66AAFZ.html",
            "total_play": 892424,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LmJnyLmNlXZhiSuyZvcTvnZn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LmJHTZnNAhkCRAuTdDmTbnZm",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kGcGTLnNSCLhiAEyZDJtvHkm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZHcHtLmaACZCuzEyVDntDHZH",
                "lossless": ""
            }
        },
        {
            "song_id": 1074689070,
            "title": "It Goes Like This",
            "artist": "Thomas Rhett",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": null,
            "order": 27,
            "pos_status": 0,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/It-Goes-Like-This-Thomas-Rhett/ZW67CUAE.html",
            "total_play": 4742,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZmJHykGNzhJuGsGTZDJybHZn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LnJntZnaSgxEmNnTdbmybmkH",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZmJnyZGNSCxuHNmyZbJyvmLH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/knJmTLnazXcRHsmyBDnyFGLn",
                "lossless": ""
            }
        },
        {
            "song_id": 1074716992,
            "title": "Dark Horse",
            "artist": "Katy Perry , Juicy J",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/5/d/5de3323223aa43c9290905c906fc7027_1383201200.jpg",
            "order": 28,
            "pos_status": null,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Dark-Horse-Katy-Perry-Juicy-J/ZW68OIC0.html",
            "total_play": 24620,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZnxGyLmNSsLgEuvyLbxybGLn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LnxmtLnNAsLXEEDydvGtvGkn",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/ZnJmyLGNANLhiuFTIOffrjfetDnkm"
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZHJntZmsAaLhRiFTLDxtDnLG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHcHtZmaAaZCEuvTBFGTDnLn",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/LnJntLnalNZhuEbyrOffUoKKtvnLn"
            }
        },
        {
            "song_id": 1074751533,
            "title": "Unconditionally",
            "artist": "Katy Perry",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/5/d/5de3323223aa43c9290905c906fc7027_1383201200.jpg",
            "order": 29,
            "pos_status": null,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Unconditionally-Katy-Perry/ZW68B8AD.html",
            "total_play": 10683,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LncntLGNAaQLpdByZvJyFGZn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZHJHykHNzNQZQBVydDmyvHLm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/kGxGyknNzNWLQdBTrqfKUjfKTvHkH"
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kGJGtLnaANQLQdVykbJybGZH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmxntLHaANpkQddydbntFmZn",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/ZGJHTkGNlapkQBVyrqfKUYfKTvGZH"
            }
        },
        {
            "song_id": 1074505824,
            "title": "Mirrors",
            "artist": "Justin Timberlake",
            "zaloid": 0,
            "username": "nemomb",
            "download_status": 1,
            "thumbnail": "avatars/e/4/e40221c3b040ea2bdc51ba7429ed401a_1363061978.png",
            "order": 30,
            "pos_status": 0,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Mirrors-Justin-Timberlake/ZW6UF8E0.html",
            "total_play": 1256099,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LncntLHNlQGWJFlTZbJyvmkH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LmJHyZnazQGpJDlydFHtDmZm",
                "lossless": ""
            },
            "copyright": "",
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZnJHTLGNlQGWJDlyLvJtvHLH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZnxmTkHslpGpxDSydbmyDmLG",
                "lossless": ""
            }
        },
        {
            "song_id": 1074586873,
            "title": "Brave",
            "artist": "Sara Bareilles",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/f/7/f705db87f1c7e09904464d6a87c152ad_1336283971.jpg",
            "order": 31,
            "pos_status": 7,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Brave-Sara-Bareilles/ZW66OZ79.html",
            "total_play": 16386,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHJmTkmNzQxhJadTkDJyDnkn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kmJnTLnsSQJCJNBTBvmtFGkm",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZHJnTkmsSWJXcNByZDJtbHkm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmxGtkHNSWJhJNBtVDnTvnLG",
                "lossless": ""
            }
        },
        {
            "song_id": 1074710293,
            "title": "Slow Down",
            "artist": "Selena Gomez",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/7/f/7f40a1a40081599265f38b59e46fef54_1370320369.jpg",
            "order": 32,
            "pos_status": 4,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Slow-Down-Selena-Gomez/ZW68I79Z.html",
            "total_play": 9935,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZGJGyLGNAaZnbRdtkvJybHkn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LmcGTLmNSNknviVydbGyDmLn",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kmxnyLnNSsLnFidtLFctbHLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmxHtLnsSskmDEdtdFHtbmLn",
                "lossless": ""
            }
        },
        {
            "song_id": 1074758142,
            "title": "Sweeter Than Fiction",
            "artist": "Taylor Swift",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/b/3/b3e58c5301cc4af4c6a6282ba3a820f8_1345605469.jpg",
            "order": 33,
            "pos_status": null,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Sweeter-Than-Fiction-Taylor-Swift/ZW68DW7E.html",
            "total_play": 47602,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LGJnTLHNSNpxkzvyLDJTbnLm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LmcnTLnslNQcZAbydDGtFGLG",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/knxnTLGNANQJklvykFJybGZn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LmJGyknszNpxklbydbmybmZG",
                "lossless": ""
            }
        },
        {
            "song_id": 1074738874,
            "title": "Timber",
            "artist": "Pitbull , Ke$ha",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/b/7/b77dc720eb2a45161874450fda56336f_1354537808.jpg",
            "order": 34,
            "pos_status": null,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Timber-Pitbull-Ke-ha/ZW6887OA.html",
            "total_play": 26782,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZmxHtLmslsBJJNSTZDctbnZG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZHJHyZGaAsBcJsATdFnTbnLH",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kmJHtZnNzNBccNSykbJtbmZH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kGJGyZnNSsdxJNzyVbmyFnkG",
                "lossless": ""
            }
        },
        {
            "song_id": 1074714639,
            "title": "Work Bitch",
            "artist": "Britney Spears",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/1/5/15ed530214c7ee6417bdc9af69130822_1379305081.jpg",
            "order": 35,
            "pos_status": -7,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Work-Bitch-Britney-Spears/ZW68W88F.html",
            "total_play": 91737,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/kHJHtLGazNZAgBitZvxTbnkm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LnJHyLGsSNLSgdRyBbGTFHZH",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kmcmyknslsLACdutLDJyvHZn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kHJHtLGNANLzCdiTBFmyFnkG",
                "lossless": ""
            }
        },
        {
            "song_id": 1074381083,
            "title": "Everything Has Changed",
            "artist": "Taylor Swift,Ed Sheeran",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/b/3/b3e58c5301cc4af4c6a6282ba3a820f8_1345605469.jpg",
            "order": 36,
            "pos_status": 1,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Everything-Has-Changed-Taylor-Swift-Ed-Sheeran/ZW6OII9B.html",
            "total_play": 190231,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LmJntZGNzdxLHJBTLDJyDHZm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LGxGyLmNldxLGJVyVbnybmkG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/kHJGTZHNzVJLGxdtrOKfIMeeTvmkn"
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kGJHyLHNSBcLmcdykbJtbHZG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kHJmtkmNSdJkHcByBFmyFnZH",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/kmxntLmaldxkGJdTrwKeIMfetvnLn"
            }
        },
        {
            "song_id": 1074628325,
            "title": "Crooked Smile",
            "artist": "J. Cole , TLC",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/f/3/f3ccdd27d2000e3f9255a7e3e2c48800_1351157725.jpg",
            "order": 37,
            "pos_status": -2,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Crooked-Smile-J-Cole-TLC/ZW66D76Z.html",
            "total_play": 4041,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/knJHtLnsAgbcBvpyZFxybnLm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kGJnTZGNAXDxBbQyVFnTvGZH",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/ZGJHyZmslgvJdbQtrOKeIYefybGZG"
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LHxnyLnNAXvcVFQykDJTFmkn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZGxnTZGNzXDcdvWydbmTFnLn",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/ZncntZHsSCvJdDQTrOKfUoKfTDnLH"
            }
        },
        {
            "song_id": 1074583946,
            "title": "Get Lucky",
            "artist": "Daft Punk , Pharrell Williams",
            "zaloid": 0,
            "username": "freshyidol",
            "download_status": 1,
            "thumbnail": "avatars/8/b/8bbb68c673fb24304e49ebe4338a1c72_1335021176.jpg",
            "order": 38,
            "pos_status": -6,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Get-Lucky-Daft-Punk-Pharrell-Williams/ZW66WA0A.html",
            "total_play": 195431,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZmJntkHazQxBESCyLFcyFHLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kHxGyLHNAQcduShTdbnyvmLm",
                "lossless": ""
            },
            "copyright": "",
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LnJmtLGNAWJVizXyZFxTbnZG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kHxHykmNlpJBRSCyVvHyFHLm",
                "lossless": ""
            }
        },
        {
            "song_id": 1074684637,
            "title": "Survival",
            "artist": "Eminem",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/6/4/6491c2173d300d5bbbee6b4c326fa561_1376557444.jpg",
            "order": 39,
            "pos_status": -8,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Survival-Eminem/ZW67BOZD.html",
            "total_play": 15571,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LmxGykmNShxlXdNTLFxyFHLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZGcHTLHszgcSgVstBvntDHkH",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZHJHtLGaACJSXdNyZDctvmZG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmcGtLmsAhxSCBNtBDnTvmLG",
                "lossless": ""
            }
        },
        {
            "song_id": 1074546059,
            "title": "Mine Would Be You",
            "artist": "Blake Shelton",
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": "",
            "thumbnail": "avatars/9/c/9c168c4be1ad91d5df0db332e48cb412_1347297367.jpg",
            "order": 40,
            "pos_status": null,
            "wplay": 0,
            "wlike": 0,
            "wcomment": 0,
            "zpoint": 0,
            "link": "/bai-hat/Mine-Would-Be-You-Blake-Shelton/ZW6Z960B.html",
            "total_play": 1286,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LmJHTLnNzQlCHQutZDJTbmkm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LncnyLHNSQShGQEyVFntDGLG",
                "lossless": ""
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZmcmTZmNlpSgmQETkDcTDmkm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LHxnTLHslWlhHQRTVFHtDGLH",
                "lossless": ""
            }
        }
    ],
    "numFound": 40,
    "likes": 68,
    "like_this": false,
    "favourites": 0,
    "favourite_this": false,
    "response": {
        "msgCode": 1
    }
}
```

## TOP 100

    http://api.mp3.zing.vn/api/mobile/charts/gettopsong?key={YOUR_KEY}&requestdata={"id":66,"start":0,"length":100}

Example: 
    
    http://api.mp3.zing.vn/api/mobile/charts/gettopsong?key=fafd463e2131914934b73310aa34a23f&requestdata={"id":66,"start":0,"length":100}

```json
{
    "numFound": 100,
    "start": 0,
    "docs": [
        {
            "song_id": 1074729245,
            "title": "Xin Anh Đừng Đến",
            "artist": "Bảo Thy",
            "album_id": 0,
            "zaloid": 0,
            "username": "mp3",
            "download_status": 1,
            "copyright": 0,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/knJnTZHslsDuvzQTkFJtDHkm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LHJntZnsSsbuDzQydvnyDmZG"
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kncnyLHNzNbivlWykvJtDnZG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZHxGtLHslNbubzQTVbGybGZm"
            },
            "link": "/bai-hat/Xin-Anh-Dung-Den-Bao-Thy/ZW686I9D.html",
            "thumbnail": null
        },
        {
            "song_id": 1074516665,
            "title": "Xóa Hết Remix",
            "artist": "Du Thiên",
            "album_id": "1073822975",
            "zaloid": 0,
            "username": "minhth26",
            "download_status": 1,
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LGcGtkGsAWZCCXQTkFJtFmkH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZnJGtLGaAQLCXgQyBDGTDnZG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/ZHJGykGsSpLgXCQtrwefIYfftDmLm"
            },
            "download_disable": 0,
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kGxGTLGNApLChCWykbJtFmZG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/knJmtLHaSpLgXgQTVbmTvmkm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/LGxntLnNzQZhXXQTrwffIjfetvmkG"
            },
            "link": "/bai-hat/Xoa-Het-Remix-Du-Thien/ZW6ZWOO9.html",
            "thumbnail": ""
        }
        ......................................................................
    ],
    "response": {
        "msgCode": 1
    }
}
```

## SONG BY THEMES

### Get list

    http://api.mp3.zing.vn/api/mobile/song/gettopiclist?keycode={YOUR_KEY}

Example: 

    http://api.mp3.zing.vn/api/mobile/song/gettopiclist?keycode=fafd463e2131914934b73310aa34a23f

Response:

```json
{
    "docs": [
        {
            "topic_id": 72,
            "topic_name": "Nhạc Hot Việt",
            "numFound": 38,
            "item": [
                {
                    "playlist_id": 1073851783,
                    "title": "Nhạc Hot Việt Tháng 11/2013",
                    "artist": "Various Artists",
                    "zaloid": 0,
                    "username": "mp3",
                    "cover": "covers/0/9/09bdb4a26d1a5c3c10faf5d0163afb7f_1383279849.jpg",
                    "description": "Album tập hợp những ca khúc nhạc Việt hay nhất được ra mắt trong tháng 11 tại Zing Mp3.",
                    "is_album": 0,
                    "modified_date": 1383909854,
                    "total_play": 2403208
                }
            ]
        },
        {
            "topic_id": 109,
            "topic_name": "Nhạc Việt Mới",
            "numFound": 30,
            "item": [
                {
                    "playlist_id": 1073851779,
                    "title": "Nhạc Việt Mới Tháng 11/2013",
                    "artist": "Various Artists",
                    "zaloid": 0,
                    "username": "mp3",
                    "cover": "covers/8/d/8dfd59eecf913ae8109188bb4cd93351_1383279974.jpg",
                    "description": "Album tập hợp những ca khúc nhạc Việt mới nhất được ra mắt trong tháng 11 tại Zing Mp3.",
                    "is_album": 0,
                    "modified_date": 1383909733,
                    "total_play": 606093
                }
            ]
        },
        {
            "topic_id": 76,
            "topic_name": "Nhạc Hot Rap Việt",
            "numFound": 34,
            "item": [
                {
                    "playlist_id": 1073851762,
                    "title": "Nhạc Hot Rap Việt Tháng 11/2013",
                    "artist": "Various Artists",
                    "zaloid": 0,
                    "username": "mp3",
                    "cover": "covers/9/6/9651cc991aa67672d888896c734baa33_1383280184.jpg",
                    "description": "",
                    "is_album": 0,
                    "modified_date": 1383797051,
                    "total_play": 732961
                }
            ]
        },
        {
            "topic_id": 75,
            "topic_name": "Nhạc Hot Âu Mỹ",
            "numFound": 37,
            "item": [
                {
                    "playlist_id": 1073851763,
                    "title": "Nhạc Hot US-UK Tháng 11/2013",
                    "artist": "Various Artists",
                    "zaloid": 0,
                    "username": "mp3",
                    "cover": "covers/e/1/e19820190b1c59040d3f89b1f6069d93_1383280103.jpg",
                    "description": "",
                    "is_album": 0,
                    "modified_date": 1383628776,
                    "total_play": 392204
                }
            ]
        },
        {
            "topic_id": 74,
            "topic_name": "Nhạc Hot Hàn",
            "numFound": 38,
            "item": [
                {
                    "playlist_id": 1073851626,
                    "title": "Nhạc Hot K-Pop Tháng 11/2013",
                    "artist": "Various Artists",
                    "zaloid": 0,
                    "username": "mp3",
                    "cover": "covers/1/0/1096b0d160bb84948306d25893786e03_1383280023.jpg",
                    "description": "",
                    "is_album": 0,
                    "modified_date": 1383869941,
                    "total_play": 161688
                }
            ]
        },
        {
            "topic_id": 89,
            "topic_name": "Love Songs",
            "numFound": 66,
            "item": [
                {
                    "playlist_id": 1073832201,
                    "title": "Best Ballad Songs 5 (Tuyển Tập Các Ca Khúc Ballad Hay Nhất)",
                    "artist": "Various Artists",
                    "zaloid": 0,
                    "username": "mp3",
                    "cover": "covers/b/d/bd51972e296a4224a01da3e0c03cdf4c_1368680810.jpg",
                    "description": "Cùng Zing Mp3 thưởng thức 15 ca khúc Pop Ballads hay được yêu mến trong thời gian qua.",
                    "is_album": 0,
                    "modified_date": 1370833220,
                    "total_play": 3864866
                }
            ]
        },
        {
            "topic_id": 84,
            "topic_name": "Nhạc Sàn",
            "numFound": 47,
            "item": [
                {
                    "playlist_id": 1073792639,
                    "title": "Hit Remixes Vol.2",
                    "artist": "Various Artists",
                    "zaloid": 0,
                    "username": "mp3",
                    "cover": "covers/5/0/5088a23fdb4b60e1629f4028ddca1a1d_1373604263.jpg",
                    "description": "Album tập hợp những single được remix lại theo một phong cách sôi động rất thích hợp cho những buổi party cuối tuần. Mời các bạn cùng thưởng thức. ",
                    "is_album": 0,
                    "modified_date": 1377139637,
                    "total_play": 1345690
                }
            ]
        },
        {
            "topic_id": 151,
            "topic_name": "Nhạc Phim ",
            "numFound": 84,
            "item": [
                {
                    "playlist_id": 1073849035,
                    "title": "About Time OST",
                    "artist": "Various Artists",
                    "zaloid": 0,
                    "username": "mp3",
                    "cover": "covers/6/5/6573c74a05e65e62970947f9d941c110_1381235659.jpg",
                    "description": "About Time (tên Việt là Đã đến lúc), bộ phim tình cảm của Anh là bản ballad ngọt ngào, lãng mạn và đầy ý nghĩa về tình yêu, tình thân. Tác phẩm nhắc người xem nâng niu từng phút giây được sống. Tác phẩm là bài ca về tình yêu và cuộc sống, chân thật như hơi thở con người. Nếu nhìn poster hay xem trailer About time, không ít người nghĩ đây là phim tình cảm lứa đôi. Điều đó đúng nhưng chưa đủ. Mối tình lãng mạn trong phim như cái cớ để đạo diễn Richard Curtis kể câu chuyện về cuộc sống muôn màu. About Time OST là album soundtrack trong phim, vừa phát hành vào ngày 02/09 bởi hãng ghi âm Decca, với các ca khúc vô cùng ngọt ngào của Sugababes, t.A.T.u, Ellie Goulding, ... album chắc chắn sẽ làm bạn hài lòng, mời các bạn cùng thưởng thức những ca khúc ngọt ngào này nhé.",
                    "is_album": 1,
                    "modified_date": 1381240195,
                    "total_play": 187128
                }
            ]
        },
        {
            "topic_id": 149,
            "topic_name": "Nhạc Thúy Nga",
            "numFound": 52,
            "item": [
                {
                    "playlist_id": 1073847359,
                    "title": "Lắng Nghe Thời Gian (Top Hits 57)",
                    "artist": "Various Artists",
                    "zaloid": 0,
                    "username": "mp3",
                    "cover": "covers/d/6/d625050fbe50ad9924135049fec6a81a_1379923565.jpg",
                    "description": "Đây là CD tổng hợp thứ 527 của trung tâm Thúy Nga phát hành. Album tập hợp các giọng ca vàng của trung tâm như Ngọc Anh, Thu Phương, Minh Tuyết, Tóc Tiên, Lương Tùng Quang, Trịnh Lam...\r\n\r\nĐây cũng là những ca khúc từng xuất hiện trong Thúy Nga 108 chủ đề Dòng Thời Gian",
                    "is_album": 1,
                    "modified_date": 1380010376,
                    "total_play": 593152
                }
            ]
        },
        {
            "topic_id": 156,
            "topic_name": "The Voice Mỹ",
            "numFound": 6,
            "item": [
                {
                    "playlist_id": 1073850694,
                    "title": "The Voice US Season 5 (EP 7) (Battle Round)",
                    "artist": "Various Artists",
                    "zaloid": 0,
                    "username": "mp3",
                    "cover": "covers/b/7/b72d76f2bee453fa0297d4d6fbc61e9a_1382068413.jpg",
                    "description": "Album tổng hợp các ca khúc ở vòng Đối Đầu cuộc thi The Voice Mỹ mùa thứ 5, phát sóng trên đài truyền hình NBC vào tháng 9 năm 2013",
                    "is_album": 1,
                    "modified_date": 1382172125,
                    "total_play": 96873
                }
            ]
        },
        {
            "topic_id": 107,
            "topic_name": "Zing Collection",
            "numFound": 123,
            "item": [
                {
                    "playlist_id": 1073808572,
                    "title": "Tuyển Tập Những Bài Hát Hay Nhất Ngày Halloween",
                    "artist": "Various Artists",
                    "zaloid": 0,
                    "username": "mp3",
                    "cover": "covers/0/c/0ca3540b0843bbe15534ca55c6429eff_1382672903.jpg",
                    "description": "Album tập hợp những bài hát hay nhất mọi thời đại dành riêng cho ngày lễ Halloween. Đây là danh sách từng được tạp chí Billboard của Mỹ giới thiệu.",
                    "is_album": 0,
                    "modified_date": 1382672940,
                    "total_play": 42468
                }
            ]
        },
        {
            "topic_id": 83,
            "topic_name": "Nhạc Giáng Sinh",
            "numFound": 131,
            "item": [
                {
                    "playlist_id": 1073814327,
                    "title": "Những Bài Hát Giáng Sinh Hay Nhất",
                    "artist": "Various Artists",
                    "zaloid": 0,
                    "username": "",
                    "cover": "covers/e/e/ee83a99b184ee963bb526b61aac9c6fb_1355210048.jpg",
                    "description": "Với album này, các bạn sẽ được nghe những ca khúc Giáng sinh hay nhất của các nghệ sỹ quốc tế. Đây có thể nói là các ca khúc bất hủ mỗi mùa Noel về. Có những ca khúc ra đời đôi khi còn lớn tuổi hơn cả chúng ta nhưng nó vẫn được yêu thích đến ngày hôm nay nhờ ca từ ý nghĩa cũng như giai điệu vui tươi, tạo không khí Giáng sinh đến từng trái tim người yêu nhạc và sống mãi với thời gian.\r\n\r\nNhững ca khúc này có rất nhiều phiên bản khác nhau nhưng tất cả đều có một điểm chung là mang lại cho người nghe nhiều cảm xúc đặc biệt mỗi mùa Giáng sinh về. Những bài hát trong album này có thể bạn đã được nghe đâu đó vào mùa Noel và hy vọng album \"Những Bài Hát Giáng Sinh Hay Nhất\" sẽ góp một phần nho nhỏ trong món ăn tinh thần vào mỗi mùa Giáng Sinh.\r\n\r\nChúc các bạn Giáng sinh an lành và hạnh phúc.\r\n\r\n-Zing Mp3 -",
                    "is_album": 0,
                    "modified_date": 1356179988,
                    "total_play": 3346589
                }
            ]
        },
        {
            "topic_id": 116,
            "topic_name": "The Best Of's",
            "numFound": 124,
            "item": [
                {
                    "playlist_id": 1073845469,
                    "title": "Tuyển Tập Các Bài Hát Hay Nhất Của Mr.Siro",
                    "artist": "Mr. Siro",
                    "zaloid": 0,
                    "username": "mp3",
                    "cover": "covers/a/8/a807e616c8ded5b645354b8900f82395_1378277339.jpg",
                    "description": "Tuyển Tập Các Bài Hát Hay Nhất Của Mr.Siro",
                    "is_album": 0,
                    "modified_date": 1378277341,
                    "total_play": 2516943
                }
            ]
        }
    ],
    "numFound": 0,
    "response": {
        "msgCode": 1
    }
}
```

## SEARCH

### Songs

    http://api.mp3.zing.vn/api/mobile/search/song?keycode={YOUR_KEY}&requestdata={"t":"","q":"Man","length":20,"sort":"","filter":0,"start":0,"upload":0}

Example:

    http://api.mp3.zing.vn/api/mobile/search/song?keycode=fafd463e2131914934b73310aa34a23f&requestdata={"t":"","q":"Man","length":20,"sort":"","filter":0,"start":0,"upload":0}

Response:

```json
{
    "numFound": 3553,
    "start": 0,
    "docs": [
        {
            "song_id": 1073903286,
            "title": "Goldseries 2",
            "artist": "Man",
            "genre": "",
            "username": "mp3",
            "bitrate": "128 | 320 | lossless",
            "duration": 288,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZHxmykmNdEHdvJgyZFcyFGLH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kGJHyLGsVinVbxgyBvHyDGLG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/knJmykmaViHVFcgyUwKKrofKybGLn"
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZmxmyknaVunVDxhTLvxtDmLn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LGJmtkHsdindbJgyVDnTbnLG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/LmJGyZmadEGVvJCTIqfeIofeTbGkH"
            },
            "link": "/bai-hat/Goldseries-2-Man/ZWZBC7O6.html"
        },
        {
            "song_id": 1073833229,
            "title": "Tìm Lại Hạnh Phúc",
            "artist": "Quang Mẫn",
            "genre": "Việt Nam, Nhạc Trẻ",
            "username": "mp3",
            "bitrate": "128 | 320 | lossless",
            "duration": 321,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZmcGTkHNVcVBbviykFcTDHZm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZncmyZnadJddvFiyVDHtDHkG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/LncntLHadJddFDuTIwKfIYeftvGZG"
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LGJnyLmNBJddFDutkFJyFGLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/knJGyLHsBcddvFiydFGtbHLm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/kGJHyZGsBxBVbDiTIPfeIoefyFHLH"
            },
            "link": "/bai-hat/Tim-Lai-Hanh-Phuc-Quang-Man/ZWZABZ8D.html"
        },
        {
            "song_id": 1074135284,
            "title": "Sự Thật Sau Đôi Mắt",
            "artist": "Quang Mẫn",
            "genre": "Việt Nam, Nhạc Trẻ",
            "username": "mp3",
            "bitrate": "128 | 320 | lossless",
            "duration": 276,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LGxGtLGNSZdQbxzyLFxybGLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LGJGTkHNSLBWbJSydbmyvnZn",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/LHcHyZHaSZBQDcATIOffrMffybmkn"
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LHxnyZGNlZBpFxzykvxybHZm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LGJmtZmazZdQDxltdvGtbnLG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/ZHcmtLHszLBWbJlyrqeKIMfetvGZm"
            },
            "link": "/bai-hat/Su-That-Sau-Doi-Mat-Quang-Man/ZWZFZI7U.html"
        },
        {
            "song_id": 1074162902,
            "title": "Vì Em Đổi Thay",
            "artist": "Quang Mẫn",
            "genre": "Việt Nam, Nhạc Trẻ",
            "username": "mp3",
            "bitrate": "128 | 320 | lossless",
            "duration": 283,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZHcHyZnsSLhbiGbyLvcyDGLm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LHcnyLHNALCvRnbydDnyFnkG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/LGcGykmNzZhbuGvTIPKeIMfeyvGZH"
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZGJmTLmaSLCvEnDtkFxTDHLm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZHJHTZGaAkXDinDtdbGyvGkH",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/LGJHyZGNAkhFumDyrwefrYfftvGLG"
            },
            "link": "/bai-hat/Vi-Em-Doi-Thay-Quang-Man/ZWZFBDZ6.html"
        },
        {
            "song_id": 1073833243,
            "title": "Xua Tan Niềm Đau",
            "artist": "Quang Mẫn",
            "genre": "Việt Nam, Nhạc Trẻ",
            "username": "mp3",
            "bitrate": "128 | 320 | lossless",
            "duration": 339,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZncmyZmNVcdBDlBtkFJtbnZn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZnJGyknNVJdBbzBydFmyvnZH",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/LmJnyZGNVxVBbzByrqffrYeftFGZn"
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/knJnyZGNdJBBvlVtZDcyDnZn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LGJGyLnsVJBVvldtBFmtvnLm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/kHxHtkmNdxddFzdyIwefUYefybGZG"
            },
            "link": "/bai-hat/Xua-Tan-Niem-Dau-Quang-Man/ZWZABZ9B.html"
        },
        {
            "song_id": 1074283294,
            "title": "Đừng Vì Cô Đơn",
            "artist": "Quang Mẫn",
            "genre": "Việt Nam, Nhạc Trẻ, Nhạc Trữ Tình, R&B",
            "username": "mp3",
            "bitrate": "128 | 320 | lossless",
            "duration": 284,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHJmyLHszbxBFultLvJybHLm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZGxntZHsAvJBDiATdDnyFnZn",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/LmxHyknNSFJdbEATrwefUMfKyDHZH"
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZGcHTknNzvJBbuzykbctFGZn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LncntZnNlbJdvEAydvmtFmkn",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/kmcGtLGaAFJdvRSyrPeKIYffybnkn"
            },
            "link": "/bai-hat/Dung-Vi-Co-Don-Quang-Man/ZW6I9O9E.html"
        },
        {
            "song_id": 1073833240,
            "title": "Đau ( Slow Version )",
            "artist": "Quang Mẫn",
            "genre": "Việt Nam, Nhạc Trẻ",
            "username": "mp3",
            "bitrate": "128 | 320 | lossless",
            "duration": 289,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LnxHTkmsVJVVFlnTLvcTbHkn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZHcGtknNdxddvlnyBbnTFHZm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/LGJGTZmNBJddbznyUOferofftvnkG"
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LHJntLGsBxVVbSGyLbxybGLH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LncmTLHNVJdVvlHyBFGyFGLG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/kGcnyLHNVJVBDlGyUqKfroeftDmLm"
            },
            "link": "/bai-hat/Dau-Slow-Version-Quang-Man/ZWZABZ98.html"
        },
        {
            "song_id": 1074179867,
            "title": "Chắc Có Lẽ",
            "artist": "Quang Mẫn",
            "genre": "Việt Nam, Nhạc Trẻ",
            "username": "mp3",
            "bitrate": "128 | 320 | lossless",
            "duration": 205,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LGJGTLGNALNEJXNyZvxtvnkH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LmxGyknNSLaEJhayBbGyvnZm",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/kGcGtLnsSkNiJgayUweKrjKftbnkH"
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZHxntknNALsiJXNyZbxtvmLG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZnxmyknsAZaEJXsTdvGyFGkH",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/LHxHTLmaSksRxXNyrOfeIMfeyDGLm"
            },
            "link": "/bai-hat/Chac-Co-Le-Quang-Man/ZWZFFF9B.html"
        },
        {
            "song_id": 1073990725,
            "title": "Tìm Lại Hạnh Phúc",
            "artist": "Quang Mẫn",
            "genre": "Nhạc Trẻ, Việt Nam",
            "username": "mp3",
            "bitrate": "128 | 320",
            "duration": 322,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZnxnyZGNVuumaFQTLFcTDHLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kmxntkHNBiiHNFQyVFntDGZH",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LnJntLmNduuHaDpTkDJtFGLn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kmJmTkGadiuHNbQydDmyvHZH",
                "lossless": ""
            },
            "link": "/bai-hat/Tim-Lai-Hanh-Phuc-Quang-Man/ZWZDICCZ.html"
        },
        {
            "song_id": 1073993753,
            "title": "Khúc Hát Sông Quê",
            "artist": "Lê Mận",
            "genre": "Nhạc Quê Hương, Việt Nam",
            "username": "mp3",
            "bitrate": "128 | 320",
            "duration": 296,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZnxHyknNdEiVNpdyLbxyDnLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LGxnTLHNVEEBaQdyVbmybnkH",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/kmxGtLmNVuuVNpdyLvJTDmkG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LnxntLHsVERdNWBTBbnybHLn",
                "lossless": ""
            },
            "link": "/bai-hat/Khuc-Hat-Song-Que-Le-Man/ZWZDW899.html"
        },
        {
            "song_id": 1073833230,
            "title": "Anh Còn Yêu",
            "artist": "Quang Mẫn",
            "genre": "Việt Nam, Nhạc Trẻ",
            "username": "mp3",
            "bitrate": "128 | 320 | lossless",
            "duration": 311,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LmxnyZmNdJdVDdHtZvJyFmLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LnJHyLGsBxVBDdHydDGyDnLn",
                "lossless": "http://api.mp3.zing.vn/api/mobile/source/song/LHcntLGaVcdBDVHyrweKrMfftFmZH"
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZHJHyLGNBJddbVGyLvJtbmkG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LmxnTkHsdJBdbBGTVDnyFmZG",
                "lossless": "http://api.mp3.zing.vn/api/mobile/download/song/LmcGykmsdJBdFBGTIPeeUMffybmLH"
            },
            "link": "/bai-hat/Anh-Con-Yeu-Quang-Man/ZWZABZ8E.html"
        },
        {
            "song_id": 1073993760,
            "title": "Về Quê",
            "artist": "Lê Mận",
            "genre": "Nhạc Quê Hương, Việt Nam",
            "username": "mp3",
            "bitrate": "128 | 320",
            "duration": 349,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LmxnTZGNBiEBNXmTkFxtbmkm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LncHykGNBRidNCGtVFmtDHLH",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LmJmtkmNBRiVsCnyLDJtDmLn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LnJntLnNdiRdNCmyBbmyvnZG",
                "lossless": ""
            },
            "link": "/bai-hat/Ve-Que-Le-Man/ZWZDW8A0.html"
        },
        {
            "song_id": 1073990705,
            "title": "Vẫn Yêu Dù Biết Sẽ Đau",
            "artist": "Quang Mẫn",
            "genre": "Nhạc Trẻ, Việt Nam",
            "username": "mp3",
            "bitrate": "128 | 320",
            "duration": 299,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHcGTLmNBREnNnWykbJyFGkH",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZmcGtkHNduuGNnpyBbmyDmkH",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LmJmtknNduEmNGQtLFcyDGLn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kHJGyLHsBiuHsnWTVFmyDmZG",
                "lossless": ""
            },
            "link": "/bai-hat/Van-Yeu-Du-Biet-Se-Dau-Quang-Man/ZWZDICBI.html"
        },
        {
            "song_id": 1073993759,
            "title": "Quê Hương",
            "artist": "Lê Mận",
            "genre": "Nhạc Quê Hương, Việt Nam",
            "username": "mp3",
            "bitrate": "128 | 320",
            "duration": 255,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZHJHtLHNVuRdNWEyZvctFHLm",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LGcGtZmNdEEVNpEydvGyFmLH",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LmJHykGNduEBNWutkFJyFnkH",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LnJHykmaBREdNpuyVDnyvHkm",
                "lossless": ""
            },
            "link": "/bai-hat/Que-Huong-Le-Man/ZWZDW89F.html"
        },
        {
            "song_id": 1073993752,
            "title": "Giếng Quê",
            "artist": "Lê Mận",
            "genre": "Nhạc Quê Hương, Việt Nam",
            "username": "mp3",
            "bitrate": "128 | 320",
            "duration": 331,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/knxHtLGNdREdNWbtLFxybHLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/ZHcmyLGaBiidNWvydFmTFHZG",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LmJHtLGsduudNQDyZvxyFGLG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZncHyLmNdRRdapvydvGtDGLG",
                "lossless": ""
            },
            "link": "/bai-hat/Gieng-Que-Le-Man/ZWZDW898.html"
        },
        {
            "song_id": 1073993756,
            "title": "Một Câu Hò Sông Hương",
            "artist": "Lê Mận",
            "genre": "Nhạc Quê Hương, Việt Nam",
            "username": "mp3",
            "bitrate": "128 | 320",
            "duration": 349,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LGcHyLnsBEEdsWCykvJyvGLG",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LHcnTZmNduRBaphtVFGTvmZn",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LncHTknsVuRdsQgykbJTDmkn",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/LmJHTLGsVRiVNWXtBbmyvGLH",
                "lossless": ""
            },
            "link": "/bai-hat/Mot-Cau-Ho-Song-Huong-Le-Man/ZWZDW89C.html"
        },
        {
            "song_id": 1073993758,
            "title": "Lời Quê",
            "artist": "Lê Mận",
            "genre": "Nhạc Quê Hương, Việt Nam",
            "username": "mp3",
            "bitrate": "128 | 320",
            "duration": 463,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LGcntZnNVERBNQJtLFcyDnLn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/kmcmtLHadREBNWcydbHtbHLG",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/LnJHTLnadEEBaQJTLFcyDmZm",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/kGJGyLGsduEdNQJtBFmyvnZn",
                "lossless": ""
            },
            "link": "/bai-hat/Loi-Que-Le-Man/ZWZDW89E.html"
        },
        {
            "song_id": 1073993754,
            "title": "Lội Dòng Sông Quê",
            "artist": "Lê Mận",
            "genre": "Nhạc Trữ Tình, Việt Nam",
            "username": "mp3",
            "bitrate": "128 | 320",
            "duration": 304,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LnJnyLmNduidNQztkFxTFnZn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LHcHykHadiEBapztBbntDmLn",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/knJmTZmsBERdapltkFxTbnZG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZnJnTLnaduRdsWAydvHtvHLG",
                "lossless": ""
            },
            "link": "/bai-hat/Loi-Dong-Song-Que-Le-Man/ZWZDW89A.html"
        },
        {
            "song_id": 1073993757,
            "title": "Tình Làng Quê",
            "artist": "Lê Mận",
            "genre": "Nhạc Quê Hương, Việt Nam",
            "username": "mp3",
            "bitrate": "128 | 320",
            "duration": 509,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/LHJHyLHsBRudaWayLvJtbGZn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LGcGyknaduRVsWNtdvnyDHLH",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/knJHyLGadiRVaQNykDJTDnZG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/knJHtLmsBuudNQNyBFmTDGLm",
                "lossless": ""
            },
            "link": "/bai-hat/Tinh-Lang-Que-Le-Man/ZWZDW89D.html"
        },
        {
            "song_id": 1073990728,
            "title": "Tìm Lại Hạnh Phúc (Beat)",
            "artist": "Quang Mẫn",
            "genre": "Nhạc Không Lời, Việt Nam",
            "username": "mp3",
            "bitrate": "128 | 320",
            "duration": 318,
            "have_rbt": false,
            "download_status": 1,
            "copyright": "",
            "source": {
                "128": "http://api.mp3.zing.vn/api/mobile/source/song/ZGJnyLmNdEunsFJykbctbnLn",
                "320": "http://api.mp3.zing.vn/api/mobile/source/song/LncGyZnNduEnNFxydDmTFGLm",
                "lossless": ""
            },
            "link_download": {
                "128": "http://api.mp3.zing.vn/api/mobile/download/song/ZmJHykGaVREnNFJyLbJyFGkG",
                "320": "http://api.mp3.zing.vn/api/mobile/download/song/ZHcnyZGNdEEHNDcTVbmyFHLG",
                "lossless": ""
            },
            "link": "/bai-hat/Tim-Lai-Hanh-Phuc-Beat-Quang-Man/ZWZDICC8.html"
        }
    ],
    "listens": {
        "1073833229": 1765901,
        "1073833230": 114311,
        "1073833240": 37777,
        "1073833243": 88076,
        "1073903286": 478,
        "1073990705": 65258,
        "1073990725": 191668,
        "1073990728": 27419,
        "1073993752": 55961,
        "1073993753": 118146,
        "1073993754": 39347,
        "1073993756": 49226,
        "1073993757": 32815,
        "1073993758": 47779,
        "1073993759": 57415,
        "1073993760": 70486,
        "1074135284": 260322,
        "1074162902": 116951,
        "1074179867": 217782,
        "1074283294": 43447
    },
    "charts": {
        "1073981322": 25,
        "1074053957": 24,
        "1074257899": 26,
        "1074385775": 18,
        "1074446501": 20,
        "1074571860": 34,
        "1074585023": 37,
        "1074589158": 39,
        "1074605906": 36,
        "1074616662": 15,
        "1074623382": 33,
        "1074645723": 19,
        "1074647050": 23,
        "1074668552": 6,
        "1074677962": 14,
        "1074679839": 1,
        "1074690527": 9,
        "1074692886": 10,
        "1074693776": 4,
        "1074693816": 3,
        "1074695206": 13,
        "1074697537": 27,
        "1074700719": 2,
        "1074701320": 29,
        "1074705762": 5,
        "1074706105": 32,
        "1074706249": 35,
        "1074706251": 30,
        "1074710584": 17,
        "1074728365": 7,
        "1074739175": 8,
        "1074739871": 16,
        "1074748253": 38,
        "1074748272": 21,
        "1074750623": 28,
        "1074758146": 11,
        "1074758744": 22,
        "1074758749": 12,
        "1074760199": 31,
        "1074763565": 40
    },
    "t": "artist",
    "response": {
        "msgCode": 1
    }
}
```

### ALbums
    
    http://api.mp3.zing.vn/api/mobile/search/playlist?keycode={YOUR_KEY}&requestdata={"t":"","q":"Man","length":20,"sort":"","filter":0,"start":0,"upload":0}

RequestDate: 

`{"t":"composer","q":"Man","length":20,"sort":"total_play","filter":0,"start":0,"upload":0}` Searching by composer, sorted by the number of plays

`{"t":"lyrics","q":"Man","length":20,"sort":"created_date","filter":3,"start":0,"upload":0}` Searching by lyrics, sorted by date created.

More options but they are neglected for simplicity.

Example:

    http://api.mp3.zing.vn/api/mobile/search/playlist?keycode=fafd463e2131914934b73310aa34a23f&requestdata={"t":"","q":"Man","length":20,"sort":"","filter":0,"start":0,"upload":0}

### Videos

    http://api.mp3.zing.vn/api/mobile/search/video?keycode={YOUR_KEY}&requestdata={"t":"","q":"Man","length":20,"sort":"","filter":0,"start":0,"upload":0}

Example:

    http://api.mp3.zing.vn/api/mobile/search/video?keycode=fafd463e2131914934b73310aa34a23f&requestdata={"t":"","q":"Man","length":20,"sort":"","filter":0,"start":0,"upload":0}

