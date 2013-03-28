Crypto = require('ezcrypto').Crypto


phpjs = require('phpjs').registerGlobals();

data= "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"

# crypted = Crypto.DES.decrypt data,"fxtBvgVE",{mode : new Crypto.mode.ECB}

# console.log crypted

aa = utf8_decode(data)
aa = base64_decode(aa)


crypted = Crypto.AES.encrypt("Message", "fxtBvgVE", { mode: new Crypto.mode.ECB })
plain = Crypto.AES.decrypt(aa, "fxtBvgVE", { mode: new Crypto.mode.ECB })
