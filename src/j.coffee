{nodeRequire} = require

global.window ?= {} if global?

define (require) ->
  jade = require 'jade'
  {compile} = jade

  progIds = ["Msxml2.XMLHTTP", "Microsoft.XMLHTTP", "Msxml2.XMLHTTP.4.0"]
  
  fetchText = ->
    throw new Error("Environment unsupported.")

  if process?.versions?.node?
    fs = nodeRequire 'fs'

    fetchText = (path) ->
      fs.readFileSync path, "utf8"

  else if (window?.navigator? and window?.document?) or importScripts?
    getXhr = ->
      if XMLHttpRequest?
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
      throw new Error("getXhr(): XMLHttpRequest not available") unless xhr

      return xhr

    fetchText = (url, callback) ->
      xhr = getXhr()
      xhr.open "GET", url, true
      xhr.onreadystatechange = (evt) ->
        callback xhr.responseText if xhr.readyState is 4

      xhr.send null

  else if Packages?
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
        line = line.substring(1) if line and line.length() and line.charAt(0) is 0xfeff
        stringBuffer.append line
        while (line = input.readLine()) isnt null
          stringBuffer.append lineSeparator
          stringBuffer.append line

        content = String(stringBuffer.toString())
      finally
        input.close()

      callback content


  if process?.versions?.node?
    jade.Parser::parseInclude = ->
      baseUrl = require.toUrl '.'

      path = @expect("include").val.trim()
      path += ".jade" if path.indexOf(".") is -1

      str = fetchText baseUrl + path

      parser = new jade.Parser str, path, @options
      parser.blocks = jade.utils.merge {}, @blocks
      parser.mixins = @mixins

      @context parser
      ast = parser.parse()
      @context()
      ast.filename = path

      ast.includeBlock().push(@block()) if "indent" is @peek().type

      return ast

    jade.Parser::parseExtends = ->
      baseUrl = require.toUrl '.'

      path = @expect("extends").val.trim()
      path += ".jade" if path.indexOf(".") is -1

      str = fetchText baseUrl + path

      parser = new jade.Parser str, path, @options
      parser.blocks = @blocks
      parser.contexts = @contexts

      @extending = parser

      new jade.nodes.Literal("")

  buildMap = {}

  j =
    version: '0.0.1'

    load: (name, parentRequire, onload, config) ->
      path = parentRequire.toUrl name + '.jade'

      text = fetchText path
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