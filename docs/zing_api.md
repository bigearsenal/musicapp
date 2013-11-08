# ZING API

## Albums

### Get albums by genre

	http://api.mp3.zing.vn/api/mobile/playlist/getplaylistbygenre?key={YOUR_KEY}&requestdata={{"sort":"release_date","id":8,"length":20,"start":0}}

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
