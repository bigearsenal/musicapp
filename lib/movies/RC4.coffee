class RC4 
    constructor : ()->
	    @mykey = new Array(0x0100)
	    @sbox = new Array(0x0100)
    charsToHex : (_arg1)->
        _local2 = new String("")
        _local3 = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f")
        _local4 = 0
        while (_local4 <= _arg1.length-1) 
            _local2 = (_local2 + (_local3[(_arg1[_local4] >> 4)] + _local3[(_arg1[_local4] & 15)]))
            _local4++
        _local2
    encrypt: (_arg1, _arg2)->
        _local3= @strToChars(_arg1)
        _local4= @strToChars(_arg2)
        _local5= @calculate(_local3, _local4)
        @charsToHex(_local5)
    hexToChars: (_arg1)->
        _local2 = new Array()
        _local3 = ((_arg1.substr(0, 2))=="0x") ? 2 : 0
        while (_local3 < _arg1.length) 
            _local2.push(parseInt(_arg1.substr(_local3, 2), 16))
            _local3 = (_local3 + 2)
        
        _local2
    decrypt: (_arg1, _arg2)->
        _local3 = @hexToChars(_arg1)
        _local4 = @strToChars(_arg2)
        _local5 = @calculate(_local3, _local4)
        @_pp155(@charsToStr(_local5))

    strToChars : (_arg1) ->
        _local2 = new Array()
        _local3 = 0
        while (_local3 <= _arg1.length-1) 
            _local2.push(_arg1.charCodeAt(_local3))
            _local3++
        _local2
    _pp155: (_arg1)->
        _local2 = ""
        _local3 = 0
        _local4 = 0
        _local5 = 0
        _local6 = 0
        _local7 = 0
        while (_local3 < _arg1.length) 
            _local4 = _arg1.charCodeAt(_local3)
            if (_local4 < 128)
                _local2 = (_local2 + String.fromCharCode(_local4))
                _local3 = (_local3 + 1)
            else 
                if (!(_local4 > 191))
                else 
                    (_local4 > 191)
                
                if ((_local4 > 191))
                    _local6 = _arg1.charCodeAt((_local3 + 1))
                    _local2 = (_local2 + String.fromCharCode((((_local4 & 31) << 6) | (_local6 & 63))))
                    _local3 = (_local3 + 2)
                 else 
                    _local6 = _arg1.charCodeAt((_local3 + 1))
                    _local7 = _arg1.charCodeAt((_local3 + 2))
                    _local2 = (_local2 + String.fromCharCode(((((_local4 & 15) << 12) | ((_local6 & 63) << 6)) | (_local7 & 63))))
                    _local3 = (_local3 + 3)
        _local2
    calculate : (_arg1, _arg2)->
        @initialize(_arg2)
        _local3 = 0
        _local4 = 0
        _local5 = new Array()
        _local9 = 0
        while (_local9 <= _arg1.length-1) 
            _local3 = ((_local3 + 1) % 0x0100)
            _local4 = ((_local4 + @sbox[_local3]) % 0x0100)
            _local7 = @sbox[_local3]
            @sbox[_local3] = @sbox[_local4]
            @sbox[_local4] = _local7
            _local10 = ((@sbox[_local3] + @sbox[_local4]) % 0x0100)
            _local6 = @sbox[_local10]
            _local8 = (_arg1[_local9] ^ _local6)
            _local5.push(_local8)
            _local9++
        
        _local5
    initialize: (_arg1) -> 
        _local2 = 0
        _local4 = _arg1.length
        _local5 = 0
        while (_local5 <= 0xFF) 
            @mykey[_local5] = _arg1[(_local5 % _local4)]
            @sbox[_local5] = _local5
            _local5++

        _local5 = 0
        while (_local5 <= 0xFF) 
            _local2 = (((_local2 + @sbox[_local5]) + @mykey[_local5]) % 0x0100)
            _local3 = @sbox[_local5]
            @sbox[_local5] = @sbox[_local2]
            @sbox[_local2] = _local3
            _local5++
    charsToStr : (_arg1)-> 
        _local2 = new String("")
        _local3 = 0
        while (_local3 < _arg1.length) 
            _local2 = (_local2 + String.fromCharCode(_arg1[_local3]))
            _local3++
        
        _local2
    

module.exports = RC4

anbinh = new RC4()
console.log "anbinh"
text = "aa113e97f13096daf5cc755c7c118cb2087d208881293cdc77b720255db508e416663834048aba18a027e4c403922b711d7f6c29773c58fbbf68dc903184dc9541c22f132dd4f51fc228f792b0e2b6ab757a60768e624ffd6b65381b852f33ee5c141f6713ee68c855d0627bd3733dfedd74262f6bd6a79a3b797047a9feed5a6318f0c3adb378743c4dd62a747e3d8f7e6e8b2f220aaa5214ca430c3f64db87d19991e90f7ccc0e54f949f2a8895a1b23833ff34b9970b812d003ed9e2ce67c32a080114e80ec8369cc79782c2ac2c62e6cddf18b656a2e93d3facc6a76c543d37152febe83832b005d3c099c6c1e24d30cfd651eee290e35710d2eb18d78a53bf22e0e71bcde7d59287ca37ee5e6fa3bbc71961d239c3fd72f461b327c46389657b3d941e029f53f7e010fd3d5d54b73003b2b42a06f8432a9fae099b7fd3f937297038abd83ce130bed12df03665febe1d9fadc21a77b0b471717435994dda0af27da7d38855e6f5a065a25bea10336fbc75080b9bfb74e00cf2e50fe84235a3f9a53ca5a3072a201222aad3f3133a400b1cdd2a59e3d99829a060a4479499f34eebf51bf1cf70b60b1a9d133cc91d9104e5e2f1d12d3357f1c301c0fe9ceb7cb1b3cde492302678129c18d39e3c5b77a09807c2674b3e53c8f76786d394b219b328f977abb82633a7f23db1bc98bf59b254748eb6f5c76ee578f10e37fb87c17cc45a0bba0be4d48fb54acaaa3a1200e1c2a3709291797ea1e58536627b85848859fcce0ad384b722f8d9ba80b97061c065655c859a514a3f2fe7347b2861aa5aff9b0fa7ac1469e6ea9ecb74396c1435ae9c8b68f93a363acb33d936e63208b9eb91d360ca818cbbbc0146c112d3e720395ba171eb47fa1debcf6d6afcd9d3d62f4143f23ca885259097801043c554dd1c785b65706898bd2c771c90911683ff48bf8eb032f8c3b50ddcdd317aa4c44a87a6476d41d70f586f1c17dd9416c3a65b9ac086e0d044f54f1425ce96a064b7c9e4440b9b7a9d462da405804a2578f822a02fa3bfbffe4e21a15bc055c3a754c98f8118c5c8264325e528de0fb29e509d98e9d31ee19563a07813bb61058f5da687678a1065c43f378c59a6dfb7009e9a0f4f6a0416c20f49fc8d777631203ede90052041f78cd0f5aa3a791847d5d4119fdf492997789031445d593ec28a6eebd9adf69581370da39fb804ed2d9c419ea01944f01dd229deef2dd8728694692f535991bf55ac774642e7096cfc15fb3d47895e65de15829ee9736f551b32cbd15d9e8868cf77de1f2a7ca5483e7b49af76c372c45463fdc9f4d6a9098e0904c6f00ceff54917a4c0a82bc2cda21b727486fef5e232e306fd3e1cf77343f4d669dd17176136854b03a5dcc147c53128e6323e67b42d9882c477be70e9a99859bc0723d5cb7cb031ae0c9334d35c52493c3ff59857db94e93001e0d88864ae75ad785d4051fe3d08e668f88f52a5d085925a85da6d3ff5d75083acaf7000a6a37c1dfce8abfe44fed3a505bae70246d014f95f6218db84928d4d43b52b34704292710b2a36a8cfd729ce1ce8da620fd8a9e9922aea7b18d56ac9da30e9c2f157f1da8a8db36c1703904cb8157f051b78f8db86c3c70bf357450e8cd9ff38c9804c54dee1a65b2415ea79a8277b9740e5b45c21ac4f8ebad9c8b90fb7d3a4fe68ee2e069a4c8a10e395fb54d4815db286e69ca27293d765ce0c88bec43d983d6450bea693c2c45721b6073591a0e0e2d3ecb9a777956bb69b3ffac1ff7f4b6cf0dd72c4e56541953972ba00ce64961cbe579faaf1cc1c6004ddff4f4a80fa9e2ab3beca30e799846ae0acd20fa7b11d22add114cd5d24bd32724a8c534c6be4f8c24f20bf92dd8c07151bbf33d209e2b207bf064dede64c0846e5c4cf17e2a613579bc053900b4427a67d74830d936b0e180e37ed7f9e9deb28b22fdc5141dcd1e4814ade3bb3f0be107516212b6fdce34f9878343bd5c7d1d90ed1c7c8a70135a4026c1d4e9511dc791c606bfe7cd33764a6ac0b442dfb870da450da9dc118427f40e653f62d28e6e4eac0c99670299bf0183e852f56318b10e9f3590fea3f91eb92f0e2dd39cab673dc5ce15505e2783931b07b51afee68f8ddeb471c46d6498d50833010a10a19b076d931476725996b1dff07897c2c0e1eaeb38f1673b63cb10ca91088bbdbb741bcf72fa703146192d9d204542742a23aa61b458fdf71b8417ee0379679f6652d887f0088772c24d9d8bc720f13a2a86b06b9e3b4ff8fa3d1cb74b76ded9567b1560bc520fdddeae50efc2e513d7b5addc5de1159eb65dcca3d7686b640f7e2da6e5f850604a6ed52b7fdf2ec0adf11cd702e88fd05367efb7c15f5e87705fd11e2a86fe90c0847ba1de4257e708bdef79568422b6646687348889fd6faca7ab16d2c8395072a8367640a1fa7d19367710f8d94c0d7eafb8cc516ead1f01ba672f0b1a56e0ce431a4020836d29b162c07b2e9c5c7980492a11d588b84b4bb57c70739c07952b043f43b353ede7f9814ba0b8c70acc0475e1386f24a767698fd68a43933844261ba3b159e3b3c3952f1f393311b60de25f614a14680e9af2bf8e137dfe86ef7afebc0bacfaa249732910ed3776b5430de38c6590172cf7ffebcd6bb65690c8436704e1a491b134d54842876b14c555187b5f4a35c3569b191133b18e4c86a7fc024b230d4d8dcb623c4b6f5564daf6010b9ae224e31bb2154782419f8a742d8ada6c8e46b3c875f8d401a49da0283154418092e742a11e5058810c266a7b45ecefac7d4269ea7743102cb5ed904341fe9bb7f6b1fdd7e3a4b5cba534ef7e578f9e97e76d45c3d022d2a90fadad735451fb9d6e81f2f85349381c5ae2ab1e3d2b5f3bce8c10063027a7d834765f70a01a91336fa97fea72e712c414e48792a5a471fabc485b762c123a20d2d9ae1906f0ad1ffaf8b707666cc30c0f0334ce46d6aaecbb399d0149e8760ecbe425b37fe7859eecdf4ba7ed25ed68e7f5f5e4abea28cc76a25a1adf79682478d5686b50c3918d967b60a5fd70dee0eeb4b40eeefac1eed408882e5f3129ad4d4f3dfee3"
# console.log(anbinh.encrypt(i.toString(),'hello') for i in [1..20])
key = "L0veHDV!+_"
# key = "HDVN@T@oanL@c"
# key = "HDVN@T@oanL@c"
# key = "HDVN@T@oanL@c#@!"
# key = "hdviet123#@!"
console.log  anbinh.decrypt(text,key)

