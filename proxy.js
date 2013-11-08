var fs = require('fs'),
http = require('http'),
    https = require('https'),
    httpProxy = require('http-proxy');

var options = {
  https: {
    key: fs.readFileSync('/Users/daonguyenanbinh/server.key', 'utf8'),
    cert: fs.readFileSync('/Users/daonguyenanbinh/server.crt', 'utf8')
  }
};

httpProxy.createServer(3001, '192.168.1.100').listen(3000);
httpProxy.createServer(3001, '192.168.1.100',options).listen(3002);


//
http.createServer(function (req, res) {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.write('hello http\n');
  res.write( req.url+ '\n');
  console.log(req.url);
  res.end();
}).listen(3001);

