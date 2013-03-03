{exec} = require 'child_process'

task 'build', 'Build cs src to js', ->
  exec './node_modules/.bin/coffee --compile --bare --output lib/ src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'test', 'Run sample app that uses r-jade', ->
  exec './node_modules/.bin/coffee --compile --bare --output lib/ src/', (err, stdout, stderr) ->
    throw err if err
    exec './node_modules/.bin/r.js -o test/build-config.js', (err, stdout, stderr) ->
      console.log stdout + stderr