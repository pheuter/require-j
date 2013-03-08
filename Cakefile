{exec} = require 'child_process'

task 'build', 'Build require-j', ->
  exec './node_modules/.bin/coffee --compile --bare --output lib/ src/', (err, stdout, stderr) ->
    throw err if err
    exec './node_modules/.bin/r.js -o demo/build-config.js', (err, stdout, stderr) ->
      console.log stdout + stderr