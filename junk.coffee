fs = require 'fs'
console.log "anbinh"

file = fs.readFileSync "./README.md", "utf8"

file = file.replace(/\[http/g,'<http').replace(/\]\(http.+/g,'>  ')

fs.writeFileSync './README.done.md',file
