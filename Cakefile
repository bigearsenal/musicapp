# Cakefile
 
{exec} = require "child_process"
 
REPORTER = "dot"
 
task "test", "run test with basic site: zi,nct,ns,gm,nv,csn....", ->
  exec "NODE_ENV=test 
    /usr/local/bin/mocha
    --compilers coffee:coffee-script
    --reporter #{REPORTER}
    --require coffee-script 
    --timeout 4000
    --colors  
    test/test.coffee
  ", (err, output) ->
    throw err if err
    console.log output