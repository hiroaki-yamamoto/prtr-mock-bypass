g = require "gulp"
q = require "q"
freeport = require "freeport"
plumber = require "gulp-plumber"
notify = require "gulp-notify"
connect = require "gulp-connect"
coffee = require "gulp-coffee"
protractor = require("gulp-protractor").protractor

port = undefined

g.task "connect", ->
  q.nfcall(freeport).then (portNumber) ->
    port = portNumber
    connect.server(
      "root": "src"
      "port": port
    )

g.task "compile", ->
  g.src(
    "./src/asset.coffee"
  ).pipe(coffee()).pipe(
    g.dest("./src")
  )

g.task "config", ->
  g.src(
    "./etc/protractor.conf.coffee"
  ).pipe(coffee()).pipe g.dest "./etc"

browserConfig =
  "chrome": [
    "--capabilities.browserName=chrome"
    "--directConnect"
  ]
  "firefox": [
    "--capabilities.browserName=firefox"
    "--directConnect"
  ]

for browser, args of browserConfig
  do (browser, args) ->
    g.task "test.#{browser}", [
      "compile"
      "config"
      "connect"
    ], ->
      g.src("./test/**/spec.coffee").pipe(
        plumber "errorHandler": notify.onError '<%= error.message %>'
      ).pipe(
        protractor(
          "configFile": "./etc/protractor.conf.js"
          "args": args.concat(
            "--baseUrl", "http://localhost:#{port}/"
          )
        )
      ).on "close", connect.serverClose

g.task "default", ["connect"], ->
  g.watch "./src/asset.coffee", ["compile"]
