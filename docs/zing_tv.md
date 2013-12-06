
#ZING - TV

## Getting app info

http://api.tv.zing.vn/2.0/appinfo?api_key=d04210a70026ad9323076716781c223f&os=ios&

Response

	{
	"version": "1.1.3"
	}

## Get media

http://api.tv.zing.vn/2.0/media/info?api_key=d04210a70026ad9323076716781c223f&media_id=51179&session_key=91618dfec493ed7dc9d61ac088dff36b&

Response

 ```javascript
{
  "response": {
    "id": 51179,
    "title": "",
    "full_name": "Vietnam's Next Top Model 2013 - Tập 9",
    "episode": 9,
    "release_date": "1/12/2013",
    "duration": 4031,
    "thumbnail": "2013/1201/3d/d3c0339dbae22720060e322b0a022c1b_1385909009.jpg",
    "file_url": "stream6.tv.zdn.vn/streaming/c565075a1711a934b2c8a6c4c1237361/52a1fd5c/2013/1201/3d/a92fdb1852643fa471ba8427a58abed1.mp4?format=f360&device=ios",
    "other_url": {
      "Video3GP": "stream.m.tv.zdn.vn/tv/7a1270f6945316e563f88112d626ee1e/52a1fd5c/Video3GP/2013/1201/3d/be1c0e1b8db5dbf0bd2443afa320ff55.3gp?format=f3gp&device=ios",
      "Video720": "stream6.tv.zdn.vn/streaming/cb817ee01c998f8791f87a27d90e65e4/52a1fd5c/Video720/2013/1201/3d/3dc9498f6e724e7312ebf24a05d78f88.mp4?format=f720&device=ios",
      "Video480": "stream6.tv.zdn.vn/streaming/b0cd9461060f41802923c6666d27cd94/52a1fd5c/Video480/2013/1201/3d/a2d91214b514aeb406a76604a31150a3.mp4?format=f480&device=ios"
    },
    "link_url": "http://tv.zing.vn/video/vietnam's-next-top-model-2013-tap-9/IWZAI86B.html",
    "program_id": 1729,
    "program_name": "Vietnam's Next Top Model 2013",
    "program_thumbnail": "channel/6/4/642334a1b21115cf5e23f34f7f749ba3_1385960130.jpg",
    "program_genre": [
      {
        "id": 78,
        "name": "TV Show"
      }
    ],
    "listen": 490559,
    "comment": 231,
    "like": 384,
    "rating": 8.134680134680135,
    "sub_title": {},
    "tracking": {},
    "signature": "a35b031d8ded1f1d64780d8cae2c936c"
  }
}
```


## Home

http://api.tv.zing.vn/2.0/home/mobile2?api_key=d04210a70026ad9323076716781c223f&

Response

```javascript
{
  "response": {
    "total": 3,
    "hot_program": {
      "id": 0,
      "itemPage": {
        "total": 5,
        "page": [
          {
            "id": 1844,
            "text1": "Empress Ki - Hoàng Hậu Ki",
            "thumbnail": "channel/5/b/5b9d65deaa4823839c19425e27bd8e92_1384919928.jpg",
            "isFree": false
          },
          {
            "id": 1947,
            "text1": "Golden Rainbow - Cầu Vồng Hoàng Kim",
            "thumbnail": "channel/c/0/c08d2abb65a955fc306e002f7a7ee1c1_1384920029.jpg",
            "isFree": false
          },
          {
            "id": 1893,
            "text1": "Bố Ơi Mình Đi Đâu Thế ? (China Ver.)",
            "thumbnail": "channel/3/c/3cda6025ac30a0c2fc53b7b1b44f6953_1384506391.jpg",
            "isFree": false
          },
          {
            "id": 1936,
            "text1": "Nobuta Wo Produce - Biệt Đội Ba Chú Heo",
            "thumbnail": "channel/a/e/aedac7c8e2fc7fdf73a3b00a2f3c1332_1384920068.jpg",
            "isFree": false
          },
          {
            "id": 1729,
            "text1": "Vietnam's Next Top Model 2013",
            "thumbnail": "channel/0/f/0f2bd1f03d083cb690168ead13aaa42d_1384920113.jpg",
            "isFree": false
          }
        ]
      },
      "objectType": "HomeHotProgram"
    },
    "new_video": {
      "id": 0,
      "itemPage": {
        "total": 49,
        "page": [
          {
            "id": 51493,
            "text1": "Medical Top Team - Đội Ngũ Danh Y",
            "text2": "Tập 18",
            "thumbnail": "tv/2013/1206/23/a1d80c38e93efc3e318ac681d7a74704_1386333804.jpg",
            "isFree": false
          },
          {
            "id": 51436,
            "text1": " Best Time - Thời Gian Đẹp Nhất",
            "text2": "Tập 1",
            "thumbnail": "tv/2013/1205/50/6a830abacf736f57cc91c6a2556c87fd_1386257188.jpg",
            "isFree": false
          },
          {
            "id": 51497,
            "text1": "The Voice - Season 5",
            "text2": "Tập 23 - Vòng Liveshow",
            "thumbnail": "tv/2013/1206/e3/fb7ee815918eff0e231760e7b2f4fe2c_1386344026.jpg",
            "isFree": false
          },
          {
            "id": 51495,
            "text1": "Bố Ơi Mình Đi Đâu Thế ? (China Ver.)",
            "text2": "Tập 8 - Đảo Chim Hót",
            "thumbnail": "tv/2013/1206/a9/49b194b410fa0fc98b388149764fba94_1386338244.jpg",
            "isFree": false
          },
          {
            "id": 51030,
            "text1": "MR & MS O'STAR ",
            "text2": "Tập 3",
            "thumbnail": "tv/2013/1128/af/59b8b80a9af8f5648d3765b35db55152_1385625196.jpg",
            "isFree": false
          },
          {
            "id": 51179,
            "text1": "Vietnam's Next Top Model 2013",
            "text2": "Tập 9",
            "thumbnail": "tv/2013/1201/3d/d3c0339dbae22720060e322b0a022c1b_1385909009.jpg",
            "isFree": false
          },
          {
            "id": 49626,
            "text1": "Giọng Hát Việt Nhí",
            "text2": "Cười Lên Việt Nam Ơi",
            "thumbnail": "tv/2013/1108/e5/03d426d950ef9cbb88fb97cbd03a5bd6_1383898631.jpg",
            "isFree": false
          },
          {
            "id": 50619,
            "text1": "Biệt Đội Tay Sạch ",
            "text2": "Tập 2",
            "thumbnail": "tv/2013/1121/21/e450dc769311f03434c9aaa7f886c5cd_3.jpg",
            "isFree": false
          },
          {
            "id": 50903,
            "text1": "Empress Ki - Hoàng Hậu Ki",
            "text2": "Tập 10",
            "thumbnail": "tv/2013/1127/f3/e555073f5dece771b0125992d0197dfe_1385541856.jpg",
            "isFree": false
          },
          {
            "id": 50906,
            "text1": "Đội Đặc Nhiệm Tuổi Teen",
            "text2": "Tập 6 - Nói Với Cha Mẹ Rằng Con Yêu Cha Mẹ",
            "thumbnail": "tv/2013/1127/98/75a97cebd35b0e96d69faeb8b41376a2_1385544882.jpg",
            "isFree": false
          },
          {
            "id": 50834,
            "text1": "The Walking Dead - Season 4",
            "text2": "Tập 7 - Dead Weight",
            "thumbnail": "tv/2013/1125/ff/606d035a568104cc0119e2ff77d03bc2_1385442486.jpg",
            "isFree": false
          },
          {
            "id": 50735,
            "text1": "Vietnam's Next Top Model 2013",
            "text2": "Tập 8",
            "thumbnail": "tv/2013/1124/98/b68cc2eff674894cc2b82036e766f29d_1385287515.jpg",
            "isFree": false
          },
          {
            "id": 50919,
            "text1": "Golden Rainbow - Cầu Vồng Hoàng Kim",
            "text2": "Tập 8",
            "thumbnail": "tv/2013/1127/bd/27cc5741e263856fa81cf7819f6f7687_1385556133.jpg",
            "isFree": false
          },
          {
            "id": 50450,
            "text1": "America's Next Top Model Cycle 20 (Guys & Girls)",
            "text2": "Tập 16 - Chung Kết",
            "thumbnail": "tv/2013/1118/05/3654c261d64e04f6e38f1def0a5c1141_1384772327.jpg",
            "isFree": false
          },
          {
            "id": 50453,
            "text1": "The Walking Dead - Season 4",
            "text2": "Tập 6 - Live Bait",
            "thumbnail": "tv/2013/1118/f1/aecbae9b6e91a7cbc3d645636c9c7faa_1384837065.jpg",
            "isFree": false
          },
          {
            "id": 50429,
            "text1": "MR & MS O'STAR ",
            "text2": "Tập 1",
            "thumbnail": "tv/2013/1118/0d/2089ddb3fa58bad67bdd6b6f946a6778_1384758657.jpg",
            "isFree": false
          },
          {
            "id": 50365,
            "text1": "Reply 1994 - Lời Hồi Đáp 1994",
            "text2": "Tập 9 - Điều Tôi Muốn Nói Là...",
            "thumbnail": "tv/2013/1117/de/c0685fe62483c7f18c842983b3b2a0c9_1384647259.jpg",
            "isFree": false
          },
          {
            "id": 50334,
            "text1": "Bố Ơi Mình Đi Đâu Thế ? (China Ver.)",
            "text2": "Tập 5 - Phổ Giả Hắc",
            "thumbnail": "tv/2013/1115/a5/adef54a7faba5892878ad2fbd0509d1b_1384528250.jpg",
            "isFree": false
          },
          {
            "id": 50368,
            "text1": "Vietnam's Next Top Model 2013",
            "text2": "Tập 7",
            "thumbnail": "tv/2013/1117/08/e06d061a77a7bde916b8a91163029d41_1384684796.jpg",
            "isFree": false
          },
          {
            "id": 50101,
            "text1": "Big Brother - Người Giấu Mặt",
            "text2": "Tập 1",
            "thumbnail": "tv/2013/1113/e2/e4c80287e0430a252eef8e70f3430ed2_1384311975.jpg",
            "isFree": false
          },
          {
            "id": 50030,
            "text1": "America's Next Top Model Cycle 20 (Guys & Girls)",
            "text2": "Tập 15",
            "thumbnail": "tv/2013/1112/38/0484e1c8881be3bf8c6ab3899364b723_1384224739.jpg",
            "isFree": false
          },
          {
            "id": 49872,
            "text1": "Giọng Hát Việt",
            "text2": "Tập 18 - Liveshow 5",
            "thumbnail": "tv/2013/1110/0f/c3fbd2a3df73c07cb05da04af46e0c8f_1384100695.jpg",
            "isFree": false
          },
          {
            "id": 49830,
            "text1": "Vietnam's Next Top Model 2013",
            "text2": "Tập 6",
            "thumbnail": "tv/2013/1110/4f/3025eccb9d8c75099dee8ff19b104e57_1384074071.jpg",
            "isFree": false
          },
          {
            "id": 49778,
            "text1": "Thử Thách Cùng Bước Nhảy 2013",
            "text2": "Tập 17",
            "thumbnail": "tv/2013/1109/4c/3666baafb39e12ca7c7802e6460695df_1384049248.jpg",
            "isFree": false
          },
          {
            "id": 49220,
            "text1": "49",
            "text2": "Tập 1",
            "thumbnail": "tv/2013/1102/84/b3ba4b6a990b6ea6febee2187ef8b493_1383375545.jpg",
            "isFree": false
          },
          {
            "id": 49447,
            "text1": "Hoa Hậu Hoàn Vũ 2013",
            "text2": "Trương Thị May",
            "thumbnail": "tv/2013/1106/6c/26acbeb946e4d9de5b66fdff4535a804_1383709968.jpg",
            "isFree": false
          },
          {
            "id": 49497,
            "text1": "Golden Rainbow - Cầu Vồng Hoàng Kim",
            "text2": "Tập 2",
            "thumbnail": "tv/2013/1106/b6/00c23406c192bda6d69972a754f9f159_1383748689.jpg",
            "isFree": false
          },
          {
            "id": 49473,
            "text1": "Empress Ki - Hoàng Hậu Ki",
            "text2": "Tập 4",
            "thumbnail": "tv/2013/1106/71/32c7b6ff524d410b4d5f9849afe3530f_1383727789.jpg",
            "isFree": false
          },
          {
            "id": 50099,
            "text1": "Empress Ki - Hoàng Hậu Ki",
            "text2": "Tập 5",
            "thumbnail": "tv/2013/1112/82/2dea9f9ba83f8d1279c98206422d6e02_1384255328.jpg",
            "isFree": false
          },
          {
            "id": 48490,
            "text1": "So You Think You Can Dance - Season 10",
            "text2": "Tập 12",
            "thumbnail": "tv/2013/1021/cc/7584771a6c4aa312959694965a264384_1382324567.jpg",
            "isFree": false
          },
          {
            "id": 49299,
            "text1": "Thử Thách Cùng Bước Nhảy 2013",
            "text2": "Tập 15",
            "thumbnail": "tv/2013/1103/73/f677a1923919aaa12bdd4ea4df842123_1383458676.jpg",
            "isFree": false
          },
          {
            "id": 49144,
            "text1": "Bố Ơi Mình Đi Đâu Thế ? (China Ver.)",
            "text2": "Tập 3 - Sa Mạc Ninh Hạ ",
            "thumbnail": "tv/2013/1101/10/a5c8eb6328e37f8341dc245dce4d8f74_1383288374.jpg",
            "isFree": false
          },
          {
            "id": 49213,
            "text1": "The Voice - Season 5",
            "text2": "Tập 12 - VÃ²ng Äo vÃ¡n",
            "thumbnail": "tv/2013/1102/cd/5d85ec35874d152f9482f212fc9f3f0b_1383353391.jpg",
            "isFree": false
          },
          {
            "id": 48934,
            "text1": "Thời Niên Thiếu Đáng Nhớ",
            "text2": "Tập 3",
            "thumbnail": "tv/2013/1028/5f/56f9aa52d5dee274fee25b4d8b563c60_1382965464.jpg",
            "isFree": false
          },
          {
            "id": 48876,
            "text1": "Giọng Hát Việt",
            "text2": "Tập 17 - Liveshow 4",
            "thumbnail": "tv/2013/1028/67/2836ae5266b4a56b3dc3ce31b007de08_1382930131.jpg",
            "isFree": false
          },
          {
            "id": 48742,
            "text1": "Medical Top Team - Đội Ngũ Danh Y",
            "text2": "Tập 6",
            "thumbnail": "tv/2013/1025/3c/ad038838ce9db34414bdc7c0415440fe_1382699658.jpg",
            "isFree": false
          },
          {
            "id": 48741,
            "text1": "Bố Ơi Mình Đi Đâu Thế ? (China Ver.)",
            "text2": "Tập 2 - Thôn Linh Thủy ",
            "thumbnail": "tv/2013/1025/40/63cd31e306e52d97613f0ca9691cf18f_1382697879.jpg",
            "isFree": false
          },
          {
            "id": 48740,
            "text1": "The Voice of China - Season 1",
            "text2": "Tập 10 - Vòng Đối Đầu",
            "thumbnail": "tv/2013/1025/10/9a1d426952092fb0fa6946b80e3ce769_1382697542.jpg",
            "isFree": false
          },
          {
            "id": 44795,
            "text1": "Amazing Race US Season 22",
            "text2": "Tập 11 - END",
            "thumbnail": "tv/2013/0907/3c/1167610aa17b0813233fe82d99403e41_1382498822.jpg",
            "isFree": false
          },
          {
            "id": 48554,
            "text1": "America's Next Top Model Cycle 20 (Guys & Girls)",
            "text2": "Tập 13",
            "thumbnail": "tv/2013/1022/b6/e06d061a77a7bde916b8a91163029d41_1382429346.jpg",
            "isFree": false
          },
          {
            "id": 48481,
            "text1": "Reply 1994 - Lời Hồi Đáp 1994",
            "text2": "Tập 2 - Chúng Ta Đều Có Một Chút Xa Lạ",
            "thumbnail": "tv/2013/1021/02/043a26f6464984446605ee186dba67c6_1382297272.jpg",
            "isFree": false
          },
          {
            "id": 48550,
            "text1": "The Walking Dead - Season 4",
            "text2": "Tập 2 - Infected",
            "thumbnail": "tv/2013/1022/4f/5e5887c7ee06a6f91607575174aa4c07_1382418588.jpg",
            "isFree": false
          },
          {
            "id": 48316,
            "text1": "Cuộc Đua Kỳ Thú",
            "text2": "Tập 12 - Chung Kết",
            "thumbnail": "tv/2013/1018/1e/dab9be034e5abc81458ffd20a75a2f95_1382350289.jpg",
            "isFree": false
          },
          {
            "id": 48341,
            "text1": "Bố Ơi Mình Đi Đâu Thế ? (China Ver.)",
            "text2": "Tập 1 - Thôn Linh Thủy ",
            "thumbnail": "tv/2013/1019/af/039ecc1e865475e26572266d53e191dc_1382146194.jpg",
            "isFree": false
          },
          {
            "id": 48423,
            "text1": "Thử Thách Cùng Bước Nhảy 2013",
            "text2": "Tập 11",
            "thumbnail": "tv/2013/1020/9d/d910c0bfa749cd12cea822ced3c1f8b7_1382239598.jpg",
            "isFree": false
          },
          {
            "id": 48425,
            "text1": "Reply 1994 - Lời Hồi Đáp 1994",
            "text2": "Tập 1 - Dân Seoul",
            "thumbnail": "tv/2013/1020/02/e51ca08ea3fe8b5ca0cbb301a11ef46c_1382212744.jpg",
            "isFree": false
          },
          {
            "id": 46561,
            "text1": "Thử Thách Tâng Bóng 24h",
            "text2": "Tập 1 - Tập 1",
            "thumbnail": "tv/2013/0926/22/6c0e679a01721bce0fe64f5c0be806fc_1380180362.jpg",
            "isFree": false
          },
          {
            "id": 47915,
            "text1": "Giọng Hát Việt",
            "text2": "Tập 16 - Liveshow 3",
            "thumbnail": "tv/2013/1013/92/fc3731af4666f971ace843ef4e4f8d44_1381715271.jpg",
            "isFree": false
          },
          {
            "id": 47893,
            "text1": "Vietnam's Next Top Model 2013",
            "text2": "Tập 2",
            "thumbnail": "tv/2013/1013/22/f4c25e2611177a36dcc588b24c6f806c_1381739753.jpg",
            "isFree": false
          }
        ]
      },
      "objectType": "HomeNewVideo"
    },
    "hot_program_by_category": [
      {
        "id": 23,
        "name": "TV Show",
        "itemPage": {
          "total": 12,
          "page": [
            {
              "id": 2049,
              "text1": "Mnet Asian Music Awards 2013",
              "thumbnail": "channel/e/0/e06d061a77a7bde916b8a91163029d41_1385438215.jpg",
              "isFree": false
            },
            {
              "id": 2042,
              "text1": "Melon Music Award 2013",
              "thumbnail": "channel/e/0/e06d061a77a7bde916b8a91163029d41_1385018765.jpg",
              "isFree": false
            },
            {
              "id": 1893,
              "text1": "Bố Ơi Mình Đi Đâu Thế ? (China Ver.)",
              "thumbnail": "channel/7/1/7151184986aed9f8f418938930271d37_1380705383.jpg",
              "isFree": false
            },
            {
              "id": 1729,
              "text1": "Vietnam's Next Top Model 2013",
              "thumbnail": "channel/6/4/642334a1b21115cf5e23f34f7f749ba3_1385960130.jpg",
              "isFree": false
            }
          ]
        },
        "objectType": "HomeHotProgramInCategory"
      },
      {
        "id": 28,
        "name": "Phim Truyền Hình",
        "itemPage": {
          "total": 32,
          "page": [
            {
              "id": 1922,
              "text1": "Sự Thật Nghiệt Ngã",
              "thumbnail": "channel/0/6/06c862eb2788ca18ae83c636a4ecd397_1385016326.jpg",
              "isFree": false
            },
            {
              "id": 1947,
              "text1": "Golden Rainbow - Cầu Vồng Hoàng Kim",
              "thumbnail": "channel/0/0/00b8e889b4339e309b04ada84f98be14_1383534663.jpg",
              "isFree": false
            },
            {
              "id": 1050,
              "text1": "Dragon Zakura",
              "thumbnail": "channel/e/6/e6940ad545c5935154a55f912b20731c_1383902819.jpg",
              "isFree": false
            },
            {
              "id": 1909,
              "text1": "Đội Đặc Nhiệm Tuổi Teen",
              "thumbnail": "channel/f/b/fb4c1453ee7f6700dc9b2889287af10e_1381396024.jpg",
              "isFree": false
            }
          ]
        },
        "objectType": "HomeHotProgramInCategory"
      },
      {
        "id": 48,
        "name": "Thiếu Nhi",
        "itemPage": {
          "total": 23,
          "page": [
            {
              "id": 1401,
              "text1": "Avatar The Last Airbender - Season 1",
              "thumbnail": "channel/a/0/a0e79e5cc3a8c7952b87fe71447c4960_1380272388.jpg",
              "isFree": false
            },
            {
              "id": 1772,
              "text1": "To Aru Kagaku No Railgun S",
              "thumbnail": "channel/5/2/5236a0796f32ac4b376de1a8584e17d8_1378208839.jpg",
              "isFree": false
            },
            {
              "id": 1871,
              "text1": "Xin Chào Bút Chì",
              "thumbnail": "channel/c/c/cc3665ec29a139c0e226a21d9a64b620_1379994566.jpg",
              "isFree": false
            },
            {
              "id": 1737,
              "text1": "Oda Nobuna No Yabou",
              "thumbnail": "channel/1/e/1ed603a52e4937ea4ad436b2d104c412_1375690418.jpg",
              "isFree": false
            }
          ]
        },
        "objectType": "HomeHotProgramInCategory"
      },
      {
        "id": 25,
        "name": "Giáo Dục",
        "itemPage": {
          "total": 20,
          "page": [
            {
              "id": 2023,
              "text1": "The Power Of The Planet - Sức Mạnh Của Hành Tinh",
              "thumbnail": "channel/e/0/e06d061a77a7bde916b8a91163029d41_1384932157.jpg",
              "isFree": false
            },
            {
              "id": 2024,
              "text1": "The World At War - Chiến Tranh Thế Giới",
              "thumbnail": "channel/e/0/e06d061a77a7bde916b8a91163029d41_1384933323.jpg",
              "isFree": false
            },
            {
              "id": 1764,
              "text1": "The Universe  - Season 3",
              "thumbnail": "channel/0/c/0c32aa60919f62b3997231760f459ed9_1377506589.jpg",
              "isFree": false
            },
            {
              "id": 2003,
              "text1": "Known Universe - Vũ Trụ Quan Sát Được",
              "thumbnail": "channel/1/b/1be2b2e3ace0b2eeaa10dd4b3b0d9cff_1384749888.jpg",
              "isFree": false
            }
          ]
        },
        "objectType": "HomeHotProgramInCategory"
      },
      {
        "id": 24,
        "name": "Hài Kịch",
        "itemPage": {
          "total": 20,
          "page": [
            {
              "id": 665,
              "text1": "Hài Hoài Linh",
              "thumbnail": "channel/8/7/8737b71b76d4ca5c0e3f02a1eddcafec_1370847909.jpg",
              "isFree": false
            },
            {
              "id": 1247,
              "text1": "Thiên Thần Tóc Mây",
              "thumbnail": "channel/4/b/4b1c59c7728e2b1cb65f6cb20aaf5cf9_1366705256.jpg",
              "isFree": false
            },
            {
              "id": 1094,
              "text1": "Giã Từ Lưu Linh",
              "thumbnail": "channel/4/b/4b1c59c7728e2b1cb65f6cb20aaf5cf9_1366095591.jpg",
              "isFree": false
            },
            {
              "id": 1384,
              "text1": "Liveshow Hoài Linh: Gã Lưu Manh và Chàng Khờ",
              "thumbnail": "channel/4/b/4b1c59c7728e2b1cb65f6cb20aaf5cf9_1370921926.jpg",
              "isFree": false
            }
          ]
        },
        "objectType": "HomeHotProgramInCategory"
      }
    ]
  }
}
```

## Os registration

http://api.tv.zing.vn/2.0/ext/registration/ios?device_version=6.1.1&app_version=1.1.5&device_token=41110fcb251053179e94b2365b899c6862ab3baa624941e62db8c083f0c1d78e&device_id=60:C5:47:39:DE:E1&store=1&status=1&session_key=91618dfec493ed7dc9d61ac088dff36b&notify=1&api_key=d04210a70026ad9323076716781c223f&

Response

	{
	"code": 0,
	"message": null
	}

## User info

http://api.tv.zing.vn/2.0/user/info?api_key=d04210a70026ad9323076716781c223f&user_id=335113&

Response


	{
		"response": {
			"id": 335113,
			"user_name": "binhdna",
			"full_name": " binhdna",
			"avatar": "http://c.1.s50.avatar.zdn.vn/avatar_files/c/f/0/6/binhdna_50_-1.jpg"
		}
	}

## Get genre

http://api.tv.zing.vn/2.0/program/list?genre_id=83&page=1&list_type=new&count=20&api_key=d04210a70026ad9323076716781c223f&

Change genreid, list_type (new, hot,hot_yesterday)


 ```javascript
{
  "total": 145,
  "response": [
    {
      "id": 2038,
      "name": "Pony Bé Nhỏ Đáng Yêu - Phần 1",
      "thumbnail": "channel/e/3/e3323632731830f3171f5768874c038b_1384966110.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "25 Phút",
      "like": 76,
      "rating": "8.67"
    },
    {
      "id": 2037,
      "name": "Dreamworks Spooky Stories",
      "thumbnail": "channel/d/6/d6c77d949b657f31703396bd8ca32e22_1384965691.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "6 Tập",
      "like": 78,
      "rating": "8.45"
    },
    {
      "id": 2016,
      "name": "Ultimate SpiderMan - Season 2",
      "thumbnail": "channel/d/c/dc13de0b6ff9f0852841c81f01dcbad7_1384457286.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "14 Tập",
      "like": 64,
      "rating": "8.91"
    },
    {
      "id": 1926,
      "name": "Truyền Thuyết Về Korra - Quyển 2: Thần Linh",
      "thumbnail": "channel/c/5/c532850a6895e0328decab5fe3bb3fa6_1383902411.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "30 Phút",
      "like": 175,
      "rating": "9.04"
    },
    {
      "id": 1887,
      "name": "Những Chú Chim Cánh Cụt Đến Từ Madagascar - Vol. 2",
      "thumbnail": "channel/8/9/89d19e779ed7a29242780ee88af20a80_1380363770.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "23 Tập",
      "like": 91,
      "rating": "8.85"
    },
    {
      "id": 1886,
      "name": "Những Chú Chim Cánh Cụt Đến Từ Madagascar - Vol. 1",
      "thumbnail": "channel/b/c/bca5927ba56c3460f8cd492ff6b1146f_1380363694.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "23 Tập",
      "like": 279,
      "rating": "9.14"
    },
    {
      "id": 1871,
      "name": "Xin Chào Bút Chì",
      "thumbnail": "channel/c/c/cc3665ec29a139c0e226a21d9a64b620_1379994566.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "6 Phút",
      "like": 734,
      "rating": "7.5"
    },
    {
      "id": 1837,
      "name": "Truyền Thuyết Về Korra - Quyển 1: Khí",
      "thumbnail": "channel/4/b/4b1c59c7728e2b1cb65f6cb20aaf5cf9_1378872489.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "12 Tập",
      "like": 124,
      "rating": "9.36"
    },
    {
      "id": 1824,
      "name": "Another",
      "thumbnail": "channel/e/e/ee83a3579031022ea25fd84956447434_1378894148.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "12 Tập",
      "like": 525,
      "rating": "9.23"
    },
    {
      "id": 1808,
      "name": "Điệp Viên Siêu Hạng - Phần 4",
      "thumbnail": "channel/d/f/df53bfdbdb5e75c5fa1ee896cc113551_1377684245.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "26 Tập",
      "like": 683,
      "rating": "9.15"
    },
    {
      "id": 1807,
      "name": "Điệp Viên Siêu Hạng - Phần 3",
      "thumbnail": "channel/4/c/4cc13db3ad8deb4d9c2044b8590db3c3_1377684179.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "19 Tập",
      "like": 574,
      "rating": "8.87"
    },
    {
      "id": 1806,
      "name": "Điệp Viên Siêu Hạng - Phần 2",
      "thumbnail": "channel/c/4/c4ae493262d245857e97d31becc8396e_1377684110.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "25 Phút",
      "like": 1003,
      "rating": "8.92"
    },
    {
      "id": 1772,
      "name": "To Aru Kagaku No Railgun S",
      "thumbnail": "channel/5/2/5236a0796f32ac4b376de1a8584e17d8_1378208839.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "25 Tập",
      "like": 575,
      "rating": "8.96"
    },
    {
      "id": 1750,
      "name": "Transformers Prime - Season 3",
      "thumbnail": "channel/7/9/79eaa6090e5f3fbe60c5e9fbb010b1a2_1375861698.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "20 Phút",
      "like": 196,
      "rating": "8.56"
    },
    {
      "id": 1748,
      "name": "Transformers Prime - Season 2",
      "thumbnail": "channel/9/a/9a7b027cc44ed632e85f339eb223a640_1375861414.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "26 Tập",
      "like": 91,
      "rating": "8.72"
    },
    {
      "id": 1739,
      "name": "Gravity Falls - Season 1",
      "thumbnail": "channel/1/0/10579fdfc48c8ba7629d3d932a46eb63_1375281160.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "25 Phút",
      "like": 1037,
      "rating": "8.77"
    },
    {
      "id": 1737,
      "name": "Oda Nobuna No Yabou",
      "thumbnail": "channel/1/e/1ed603a52e4937ea4ad436b2d104c412_1375690418.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "12 Tập",
      "like": 423,
      "rating": "8.44"
    },
    {
      "id": 1731,
      "name": "To Aru Kagaku No Railgun",
      "thumbnail": "channel/2/b/2bd15ad929d55096d20f4589b2309048_1375345135.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "24 Tập",
      "like": 475,
      "rating": "8.9"
    },
    {
      "id": 1711,
      "name": "Angry Birds Toons",
      "thumbnail": "channel/e/8/e8531bc5398282a96d308805bb64a2a8_1374488518.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "4 Phút",
      "like": 571,
      "rating": "8.42"
    },
    {
      "id": 1708,
      "name": "Hyouka",
      "thumbnail": "channel/c/e/ce92abb2b95d70b9b0c4e0c8d5f7b120_1374745301.jpg",
      "genre": [
        {
          "id": 83,
          "name": "Hoạt Hình"
        }
      ],
      "duration": "22 Tập",
      "like": 394,
      "rating": "8.65"
    }
  ]
}
```

## Series

http://api.tv.zing.vn/2.0/series/medias?session_key=91618dfec493ed7dc9d61ac088dff36b&series_id=2327&page=1&count=20&api_key=d04210a70026ad9323076716781c223f&

http://api.tv.zing.vn/2.0/series/medias?session_key=91618dfec493ed7dc9d61ac088dff36b&series_id=2483&page=1&count=20&api_key=d04210a70026ad9323076716781c223f&

```javascript
{
  "series": {
    "id": 2483,
    "name": "Castle - Season 6"
  },
  "total": 9,
  "response": [
    {
      "id": 50681,
      "title": "Disciple",
      "full_name": "Tập 9 - Disciple",
      "episode": 9,
      "release_date": "03/12/2013",
      "program_name": "Castle - Season 6",
      "thumbnail": "2013/1123/1e/766570c8581a7b2ed3ede689d617d89a_1385186436.jpg",
      "file_url": "stream6.tv.zdn.vn/streaming/3b3c5d1cbd34ccdcb9919384d27ba318/52a1fff5/2013/1123/1e/133f02e5a0489cecdf42e5d75cd587b0.mp4",
      "listen": 883,
      "duration": 2582,
      "viewed": false
    },
    {
      "id": 50337,
      "title": "A Murder is Forever",
      "full_name": "Tập 8 - A Murder is Forever",
      "episode": 8,
      "release_date": "03/12/2013",
      "program_name": "Castle - Season 6",
      "thumbnail": "2013/1115/d9/4173c430f43a4819d0f28d3e0d995859_1384537150.jpg",
      "file_url": "stream6.tv.zdn.vn/streaming/4264b985730c72b3523505b1f9b8cfb6/52a1fff5/2013/1115/d9/57d4b42be121c03e6ea392c3e814fa24.mp4",
      "listen": 593,
      "duration": 2540,
      "viewed": false
    },
    {
      "id": 50263,
      "title": "Like Father, Like Daughter",
      "full_name": "Tập 7 - Like Father, Like Daughter",
      "episode": 7,
      "release_date": "",
      "program_name": "Castle - Season 6",
      "thumbnail": "2013/1115/18/df217b3dd2511a52120f66371a9ceffe_1384458052.jpg",
      "file_url": "stream6.tv.zdn.vn/streaming/df12a775821e856ebebd77db1cedbb84/52a1fff5/2013/1115/18/cdc11b86bd101e8c296304e29bb7632a.mp4",
      "listen": 555,
      "duration": 2582,
      "viewed": false
    },
    {
      "id": 50262,
      "title": "Get a Clue",
      "full_name": "Tập 6 - Get a Clue",
      "episode": 6,
      "release_date": "03/12/2013",
      "program_name": "Castle - Season 6",
      "thumbnail": "2013/1115/b2/af5baa134dbad6c8201a2ddd17848b2e_1384457940.jpg",
      "file_url": "stream6.tv.zdn.vn/streaming/01860fe839f9246c7eb451d95c6612a9/52a1fff5/2013/1115/b2/a58885d69cb5ac4c15291091a65e03db.mp4",
      "listen": 656,
      "duration": 2582,
      "viewed": false
    },
    {
      "id": 50261,
      "title": "Time Will Tell",
      "full_name": "Tập 5 - Time Will Tell",
      "episode": 5,
      "release_date": "03/12/2013",
      "program_name": "Castle - Season 6",
      "thumbnail": "2013/1115/ed/9ced0cefb4f6ff9627597fb6dcf32a29_1384456655.jpg",
      "file_url": "stream6.tv.zdn.vn/streaming/52ef82d27ea0e61618a8ec8d3d41e65d/52a1fff5/2013/1115/ed/02a30af492ab8f72acdf62eeab37d4af.mp4",
      "listen": 685,
      "duration": 2572,
      "viewed": false
    },
    {
      "id": 50260,
      "title": "Number One Fan",
      "full_name": "Tập 4 - Number One Fan",
      "episode": 4,
      "release_date": "03/12/2013",
      "program_name": "Castle - Season 6",
      "thumbnail": "2013/1115/3b/8dafcc1e6757ec74a08580cb876c1c1a_1384457424.jpg",
      "file_url": "stream6.tv.zdn.vn/streaming/80c0c4c71eca0fd50807fe7b55451746/52a1fff5/2013/1115/3b/0d4826e79f12e9c198719109fc3f5965.mp4",
      "listen": 754,
      "duration": 2583,
      "viewed": true
    },
    {
      "id": 50259,
      "title": "Need to Know",
      "full_name": "Tập 3 - Need to Know",
      "episode": 3,
      "release_date": "03/12/2013",
      "program_name": "Castle - Season 6",
      "thumbnail": "2013/1115/b5/96d5abc23682c28d2a4fa7d5f8c6b2db_1384456490.jpg",
      "file_url": "stream6.tv.zdn.vn/streaming/91b32af9e4acfdabd7a13e00174f8811/52a1fff5/2013/1115/b5/46d7534af11bcd1bfce5ee9a2be54d4d.mp4",
      "listen": 822,
      "duration": 2584,
      "viewed": false
    },
    {
      "id": 50258,
      "title": "Dreamworld",
      "full_name": "Tập 2 - Dreamworld",
      "episode": 2,
      "release_date": "03/12/2013",
      "program_name": "Castle - Season 6",
      "thumbnail": "2013/1115/7e/a5dd2963e0cf23f743aa663d4a4c395e_1384456421.jpg",
      "file_url": "stream6.tv.zdn.vn/streaming/28915f733a72326757d8f213ddee2b27/52a1fff5/2013/1115/7e/83c7bf6c5136d1220851b40a75795304.mp4",
      "listen": 953,
      "duration": 2525,
      "viewed": false
    },
    {
      "id": 50257,
      "title": "Valkyrie",
      "full_name": "Tập 1 - Valkyrie",
      "episode": 1,
      "release_date": "03/12/2013",
      "program_name": "Castle - Season 6",
      "thumbnail": "2013/1115/0c/ed8d4a844afacb315bde9beaf0d5fc78_1384456328.jpg",
      "file_url": "stream6.tv.zdn.vn/streaming/524b3892d66994e15bdd580f3c4e517a/52a1fff5/2013/1115/0c/7dfe9d6a5fd4114bc2b95ddf9ece4993.mp4",
      "listen": 1616,
      "duration": 2538,
      "viewed": false
    }
  ]
}
```
