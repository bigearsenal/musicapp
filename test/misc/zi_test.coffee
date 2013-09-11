
ZI = require '../../lib/helpers/ZI'

videoBaseURL = "http://mp3.zing.vn/html5/video/"
songBaseURL = "http://mp3.zing.vn/download/song/joke-link/"
tvBaseURL = "http://tv.zing.vn/html5/video/"
tvXMLBaseURL = "http://tv.zing.vn/tv/xml/media/"
key = "ZW66WEOF"
id = 308934409
videoKey = "ZW67F76U"
videoid = 1382545252
songKey = "ZW66WEOF"
songid = 1382428223
tvKey = "IWZ9FCW9"
console.log ZI.getID key
console.log ZI.getKey id
console.log ZI.getEncodedKey key
console.log ZI.getEncodedKey id
console.log videoBaseURL + ZI.Video.getEncodedKey videoKey
console.log videoBaseURL + ZI.Video.getEncodedKey videoKey, 240
console.log videoBaseURL + ZI.Video.getEncodedKey videoKey, 360
console.log videoBaseURL + ZI.Video.getEncodedKey videoid, 480
console.log videoBaseURL + ZI.Video.getEncodedKey videoKey, 720
console.log videoBaseURL + ZI.Video.getEncodedKey videoKey,1080
console.log songBaseURL + ZI.Song.getEncodedKey songKey, 128
console.log songBaseURL + ZI.Song.getEncodedKey songid, 320
console.log songBaseURL + ZI.Song.getEncodedKey songKey, "lossless"
console.log tvBaseURL + ZI.TV.getEncodedKey tvKey
console.log tvXMLBaseURL  + ZI.TV.getEncodedKey tvKey