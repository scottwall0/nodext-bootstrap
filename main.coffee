
nodext = require 'nodext'
path = require 'path'
fs = require 'fs'

express = require 'express'

less = require './less'
js = require './js'

exports.extension = class BootstrapExtension extends nodext.Extension
  name: 'BootstrapExtension'
  config: {}

  configure: (server) ->
    # Static files
    server.use path.join(@config.urlPrefix), express.static __dirname + '/public'
    server.use path.join(@config.urlPrefix, 'img'), express.static __dirname + '/bootstrap/img'

    # Less Compile
    cssFile = path.join __dirname,'public','css','bootstrap.css'
    less.compile cssFile, @config, (e)->
      throw e if e

    jsFile = path.join __dirname,'public','js','bootstrap.js'
    js.compile jsFile, @config, (e)->
      throw e if e

  registerRoutes: (server) ->
