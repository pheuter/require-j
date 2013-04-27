{exec} = require 'child_process'

task 'build', 'Build require-j', ->
  exec './node_modules/.bin/coffee --compile --bare --output lib/ src/', (err, stdout, stderr) ->
    throw err if err
    exec './node_modules/.bin/r.js -o demo/build-config.js', (err, stdout, stderr) ->
      console.log stdout + stderr

task 'dynamic', 'Build dynamic demo app', ->
  exec './node_modules/.bin/coffee --compile --bare --output demo-dynamic/require-j/ src/', (err, stdout, stderr) ->
    throw err if err
    exec 'cp lib/jade/jade.js demo-dynamic/scripts/require-j/'
    exec 'cp lib/jade/runtime.js demo-dynamic/scripts/require-j/'

    console.log "Finished building dynamic demo app!"