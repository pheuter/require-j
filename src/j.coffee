{nodeRequire} = require

define (require) ->
  {compile} = require 'jade'

  fs = undefined
  getXhr = undefined
  progIds = ["Msxml2.XMLHTTP", "Microsoft.XMLHTTP", "Msxml2.XMLHTTP.4.0"]
  fetchText = ->
    throw new Error("Environment unsupported.")

  buildMap = {}
  if typeof process isnt "undefined" and process.versions and !!process.versions.node

    #Using special require.nodeRequire, something added by r.js.
    fs = nodeRequire 'fs'
    fetchText = (path, callback) ->
      callback fs.readFileSync(path, "utf8")
  else if (typeof window isnt "undefined" and window.navigator and window.document) or typeof importScripts isnt "undefined"

    # Browser action
    getXhr = ->

      #Would love to dump the ActiveX crap in here. Need IE 6 to die first.
      xhr = undefined
      i = undefined
      progId = undefined
      if typeof XMLHttpRequest isnt "undefined"
        return new XMLHttpRequest()
      else
        i = 0
        while i < 3
          progId = progIds[i]
          try
            xhr = new ActiveXObject(progId)
          if xhr
            progIds = [progId] # so faster next time
            break
          i += 1
      throw new Error("getXhr(): XMLHttpRequest not available")  unless xhr
      xhr

    fetchText = (url, callback) ->
      xhr = getXhr()
      xhr.open "GET", url, true
      xhr.onreadystatechange = (evt) ->

        #Do not explicitly handle errors, those should be
        #visible via console output in the browser.
        callback xhr.responseText  if xhr.readyState is 4

      xhr.send null

  # end browser.js adapters
  else if typeof Packages isnt "undefined"

    #Why Java, why is this so awkward?
    fetchText = (path, callback) ->
      stringBuffer = undefined
      line = undefined
      encoding = "utf-8"
      file = new java.io.File(path)
      lineSeparator = java.lang.System.getProperty("line.separator")
      input = new java.io.BufferedReader(new java.io.InputStreamReader(new java.io.FileInputStream(file), encoding))
      content = ""
      try
        stringBuffer = new java.lang.StringBuffer()
        line = input.readLine()

        # Byte Order Mark (BOM) - The Unicode Standard, version 3.0, page 324
        # http://www.unicode.org/faq/utf_bom.html

        # Note that when we use utf-8, the BOM should appear as "EF BB BF", but it doesn't due to this bug in the JDK:
        # http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4508058

        # Eat the BOM, since we've already found the encoding on this file,
        # and we plan to concatenating this buffer with others; the BOM should
        # only appear at the top of a file.
        line = line.substring(1)  if line and line.length() and line.charAt(0) is 0xfeff
        stringBuffer.append line
        while (line = input.readLine()) isnt null
          stringBuffer.append lineSeparator
          stringBuffer.append line

        #Make sure we return a JavaScript string and not a Java string.
        content = String(stringBuffer.toString()) #String
      finally
        input.close()
      callback content

  j =
    version: '0.0.1'

    load: (name, parentRequire, onload, config) ->
      path = parentRequire.toUrl name + '.jade'

      fetchText path, (text) ->
        func = compile text,
          client: true

        buildMap[name] = func if config.isBuild

        onload()

    write: (pluginName, moduleName, write) ->
      if moduleName of buildMap
        func = buildMap[moduleName]

        write.asModule pluginName + "!" + moduleName,
          """
          define(function() {
            return #{func}
          });
          """

  return j