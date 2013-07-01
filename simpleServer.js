var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end("Server down!\n" + new Date().getTime());
}).listen(3000, '192.168.0.169');
console.log('Server is running at http://192.168.0.169:3000/');
