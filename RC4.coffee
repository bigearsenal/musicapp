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
    
anbinh = new RC4()
console.log "anbinh"
text = "manifestAgAKb25NZXRhRGF0YQMADWF1ZGlvY2hhbm5lbHMAQAAAAAAAAAAAD2F1ZGlvc2FtcGxlcmF0ZQBA53AAAAAAAAAMYXVkaW9jb2RlY2lkAgAEbXA0YQAMdmlkZW9jb2RlY2lkAgAEYXZjMQAJdHJhY2tpbmZvCgAAAAIDAAl0aW1lc2NhbGUAAAAAAAAAAAAACGxhbmd1YWdlAgADZW5nABFzYW1wbGVkZXNjcmlwdGlvbgoAAAABAwAKc2FtcGxldHlwZQIAAAAACQAEdHlwZQIABWF1ZGlvAAZjb25maWcCAAQxMTkwAAtkZXNjcmlwdGlvbgIAV3tBQUNGcmFtZTogY29kZWM6QUFDLCBjaGFubmVsczoyLCBmcmVxdWVuY3k6NDgwMDAsIHNhbXBsZXNQZXJGcmFtZToxMDI0LCBvYmplY3RUeXBlOkxDfQAACQMACXRpbWVzY2FsZQAAAAAAAAAAAAAIbGFuZ3VhZ2UCAANlbmcAEXNhbXBsZWRlc2NyaXB0aW9uCgAAAAEDAApzYW1wbGV0eXBlAgAAAAAJAAR0eXBlAgAFdmlkZW8AAAkADnJ0cHNlc3Npb25pbmZvAwAOY29ubmVjdGlvbmRhdGECAA9JTiBJUDQgMTAuMC4wLjIABG5hbWUCABBXb3d6YU1lZGlhU2VydmVyAAZvcmlnaW4CACYtIDgxMTY3NjE1MCA4MTE2NzYxNTAgSU4gSVA0IDEyNy4wLjAuMQAGdGltaW5nAgADMCAwAA9wcm90b2NvbHZlcnNpb24CAAEwAAphdHRyaWJ1dGVzAwAFcmFuZ2UCAAhucHQ9bm93LQAACQAACQAACQ"
x = ""
# console.log(anbinh.encrypt(i.toString(),'hello') for i in [1..20])
console.log anbinh.decrypt(text,"hdviet123#@!")

