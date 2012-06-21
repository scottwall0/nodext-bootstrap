
path = require 'path'
fs = require 'fs'
spawn = (require 'child_process').spawn
uglify = require 'uglify-js'

exports.compile = (outfile, options, callback) ->
  
  jsFile = path.join __dirname,'public','js','bootstrap.js'
  jsPrefix = path.join __dirname,'node_modules','bootstrap','js/'
  cat = spawn 'cat', ["#{jsPrefix}bootstrap-transition.js",
                      "#{jsPrefix}bootstrap-alert.js",
                      "#{jsPrefix}bootstrap-button.js",
                      "#{jsPrefix}bootstrap-carousel.js",
                      "#{jsPrefix}bootstrap-collapse.js",
                      "#{jsPrefix}bootstrap-dropdown.js",
                      "#{jsPrefix}bootstrap-modal.js",
                      "#{jsPrefix}bootstrap-tooltip.js",
                      "#{jsPrefix}bootstrap-popover.js",
                      "#{jsPrefix}bootstrap-scrollspy.js",
                      "#{jsPrefix}bootstrap-tab.js",
                      "#{jsPrefix}bootstrap-typeahead.js"]
  jsOut = ''
  cat.stdout.on 'data', (data)->
    jsOut = jsOut.concat data.toString()
  cat.on 'exit', (e)->
    callback e if e

    options.compress ?= true
    jsOut = minify jsOut if options.compress
    fs.writeFile outfile, jsOut, callback


minify = (data) ->
    jsp = uglify.parser
    pro = uglify.uglify
    ast = jsp.parse data

    ast = pro.ast_mangle ast
    ast = pro.ast_squeeze ast
    pro.gen_code ast