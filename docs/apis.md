

## Lyricwiki

### GetSong

	/api.php?action=lyrics&func=getSong&fmt=realjson&artist=Man&song=Love&fallbackSearch=1&fullApiAuth=98a47e43f0c24870aa890e81fb498719

```
GET /api.php?action=lyrics&func=getSong&fmt=realjson&artist=Man&song=Love&fallbackSearch=1&fullApiAuth=98a47e43f0c24870aa890e81fb498719 HTTP/1.1
Host: lyrics.wikia.com
X-Requested-With: XMLHttpRequest
Accept-Encoding: gzip
Cookie: Geo={%22city%22:%22FIXME%22%2C%22country%22:%22VN%22%2C%22continent%22:%22AS%22}; wikia_beacon_id=52JFlLe4Pg
Connection: keep-alive
User-Agent: Appcelerator Titanium/1.7.2 (iPhone/7.0.4; iPhone OS; en_US;)
```

## SongFreaks

### Getting a song without LRC

	http://apiv2.songfreaks.com//lyric.do?

```
POST //lyric.do? HTTP/1.1
Host: apiv2.songfreaks.com
Accept-Encoding: gzip
Content-Type: application/x-www-form-urlencoded; charset=utf-8
Content-Length: 111
Connection: close
Cookie: JSESSIONID=6CC743E279D2C32FFFED9EFDCE075A66
User-Agent: SongFreaks 2.1.1 (iPhone; iPhone OS 7.0.4; en_US)

apikey=6c7a95aa8238f3b437b1db24e644c2ee&comments=true&appname=sf_iphone&sfid=4099520&version=2.1.1&territory=US
```

### Getting LRC

```
POST //lyric.do? HTTP/1.1
Host: apiv2.songfreaks.com
Accept-Encoding: gzip
Content-Type: application/x-www-form-urlencoded; charset=utf-8
Content-Length: 131
Connection: close
Cookie: JSESSIONID=5C9ACFA7C007743E976F004308FEB0C3
User-Agent: SongFreaks 2.1.1 (iPhone; iPhone OS 7.0.4; en_US)

sfid=3921858&appname=sf_iphone&comments=true&territory=US&lrc=lrc&videos=true&version=2.1.1&apikey=6c7a95aa8238f3b437b1db24e644c2ee
```


### Getting top artists

```
POST //topartists.do? HTTP/1.1
Host: apiv2.songfreaks.com
Accept-Encoding: gzip
Content-Type: application/x-www-form-urlencoded; charset=utf-8
Content-Length: 84
Connection: close
Cookie: JSESSIONID=7C3978872B5D686C559B92315497E1CE
User-Agent: SongFreaks 2.1.1 (iPhone; iPhone OS 7.0.4; en_US)

apikey=6c7a95aa8238f3b437b1db24e644c2ee&appname=sf_iphone&version=2.1.1&territory=US
```

### Search

```
POST //search.do? HTTP/1.1
Host: apiv2.songfreaks.com
Accept-Encoding: gzip
Content-Type: application/x-www-form-urlencoded; charset=utf-8
Content-Length: 136
Connection: close
Cookie: JSESSIONID=4C1AC461A77F739AEECE0DC19B788FCA
User-Agent: SongFreaks 2.1.1 (iPhone; iPhone OS 7.0.4; en_US)

apikey=6c7a95aa8238f3b437b1db24e644c2ee&appname=sf_iphone&type=TRACK&limit=10&alltracks=true&version=2.1.1&all=Man&offset=0&territory=US
```

## METRO LYRIC

	http://api.metrolyrics.com/v1/get/fullbody/?title=Call%20Me%20Maybe&artist=Carly%20Rae%20Jepsen&X-API-KEY=b84a4db3a6f9fb34523c25e43b387f1f56f987a5&format=json

```
GET /v1/get/fullbody/?title=Call%20Me%20Maybe&artist=Carly%20Rae%20Jepsen&X-API-KEY=b84a4db3a6f9fb34523c25e43b387f1f56f987a5&format=json HTTP/1.1
Host: api.metrolyrics.com
Accept-Encoding: gzip, deflate
Accept: */*
Accept-Language: en-us
Connection: keep-alive
Pragma: no-cache
User-Agent: metrolyrics/102 CFNetwork/672.0.8 Darwin/14.0.0
```


## AUDIOSCROBBLER 

### Get artist's info

	http://ws.audioscrobbler.com/2.0/?api_key=d1b0b71880806ca19d6c8891ced0a0ac&artist=Ellie%20Goulding&limit=500&method=artist.getSimilar&api_sig=4d1318fd6830b87ebc84e531391e2cd5

```
GET /2.0/?api_key=d1b0b71880806ca19d6c8891ced0a0ac&artist=Ellie%20Goulding&limit=500&method=artist.getSimilar&api_sig=4d1318fd6830b87ebc84e531391e2cd5 HTTP/1.1
Host: ws.audioscrobbler.com
Accept-Encoding: gzip, deflate
Accept: */*
Accept-Language: en-us
Connection: keep-alive
User-Agent: metrolyrics/102 CFNetwork/672.0.8 Darwin/14.0.0
```

## LYRIC FIND

	https://api.lyricfind.com/lyric.do?apikey=31c9f10b8c2d83e38e80e15f41e810f7&reqtype=default&trackid=amg:29799008&output=json

```
GET /lyric.do?apikey=31c9f10b8c2d83e38e80e15f41e810f7&reqtype=default&trackid=amg:10220629&output=json HTTP/1.1
Host: api.lyricfind.com
Proxy-Connection: keep-alive
Accept-Encoding: gzip, deflate
Accept: */*
Cookie: JSESSIONID=9268BFD5FDB46DA58EA13369F92A088F
Connection: keep-alive
Accept-Language: en-us
User-Agent: gsound/963 CFNetwork/672.0.8 Darwin/14.0.0
```

## SOUNDHOUND 

Valid with User-Agent

	https://secureapi.midomi.com/v2/?method=getTrackInformation&track_id=100673773554619402&format=lyrics&from=chart_hottest

	https://secureapi.midomi.com/v2/?method=getVideos&artist_name=Eminem&track_name=The+Monster

```
GET /v2/?method=getTrackInformation&track_id=100514407746028155&format=lyrics&from=search&search_id=7ea861174e420c260fba4ebb9c9ece84_1388231599.9980_external&log_only=1 HTTP/1.1
Host: secureapi.midomi.com:443
Proxy-Connection: keep-alive
Accept-Encoding: gzip, deflate
Accept: */*
Cookie: PHPSESSID=7ea861174e420c260fba4ebb9c9ece84; freemium_num_searches=-1; freemium_state=XRDYDVwfa45lu4Rt3SZCNsBGQxRxCFZa0iXRWrQa%2Br7oG9RthoCqsdk1b6XDdvvJQ%2BF%2FyEIm6%2Fj%2FqQvC%2BoE4xX9s71cfS6s7wMPbSRvdnyxm0rQhqVjH1AhSpJqmlNuMzgxbhX1fNlp8Hq9KBRR795iWgMDCmzVECqQFgCerL3g4oPWLvAZGerd7wTPDXNu25wpxQch66wEQnjVL4tQZmv4UHhF%2FXcQntt67YLt4%2BXHc4sPTxWvfS1y2qFPfAVkTnBnWZgeOMrMMfIng5NyzrPuUYunLXAuwk%2Bzz2ALdQjvylcNP%2Bfqp2tJy3FWW2ZW%2BuSjEqrbJEVFcdK3VvHlwmQJiFtg1G%2BWaXqRmNn8qP%2BPPkmL6LszZGHNOVLWjLbLQEL6w5Phf6hsQZWUJqDfQZkGnM4BBc4cxXCn%2Fhu%2FUIbQRFwCtFvLtGI%2F%2BqxPDEuDaEJZD1Mvbk0akFkchm4MQc6jnC6yfhnWbNG7eFreaPZOpov8teB%2F%2Fz8JI2soCwaF2jOZSzmnlKXYzTPNtPP41Tjfj%2FdaT8XEylZ0JdP6RdWNFqkQgseUDnoJIPUFwdyebINqFAfAy1kq%2B9fUxSmH86FHBbJmunB53pIU4IC6HCygGHVEIr9JYRqF%2FRW7u6aDGwmiv1swsPL6vGn%2BjNylS2semZtMpEPIjr%2FlS7stIRSD9RRlJouhuEiO6U7rwyh9qo0zwLpHhO%2FE6Iv%2BPhKS8n78jFEF80xydMMrpp%2FQ4ZAFC7wf6sHDL7G94vak4sCrW; num_searches_cookie=%7B%22omr_pos%22%3A4%2C%22omr_neg%22%3A0%2C%22hasSeenListenOnStart%22%3Afalse%7D; partners_cookie=%7B%22installed%22%3A%5B%22shf%22%5D%7D; recent_searches_cookie_1=%5B%22100514407746028155%22%5D
Connection: keep-alive
Accept-Language: en-us
User-Agent: AppNumber=2 AppVersion=5.6.0b APIVersion=2.0.0.0 VID=948924eb76124499a7ec2985aa204e04 VUID=454692A6-AE40-4131-9EFC-9DEBB42BE9F1 IFA=AD1306BB-E587-48D9-BB61-F4E001F98B3E COUNTRY=US ITUNES=US LANG=en DEV=iPhone_4.1 FIRMWARE=7.0.4 MAPS=1
```

## STROPH.ES (FAILED)

### Getting lyric

	http://stroph.es/api/lyrics/lyrics.php?id=10212914

```
GET /api/lyrics/lyrics.php?id=10212914 HTTP/1.1
Host: stroph.es
Authorization: Token token="b58ee217ee431f3c704f2d0ff5afa1802d28fb52"
Accept: application/json
Accept-Encoding: gzip, deflate
Accept-Language: en;q=1, fr;q=0.9, de;q=0.8, zh-Hans;q=0.7, zh-Hant;q=0.6, ja;q=0.5
Connection: keep-alive
Territory: US
User-Agent: Strophes/94 (iPhone; iOS 7.0.4; Scale/2.00)
```

