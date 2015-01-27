path              = require './path.coffee'
config            = require './config.coffee'
gulp              = require 'gulp'
concat            = require 'gulp-concat'
rimraf            = require 'rimraf'
uglify            = require 'gulp-uglify'
manifests         = require './javascript-manifests.coffee'
coffee            = require 'gulp-coffee'

###
  JavaScript tasks
###

javascriptDirectory = ->
  if config.isProduction then "#{path.buildCache}" else "#{path.build}"

gulp.task 'javascript:application', ->
  collectJavaScript manifests.application(), 'application.js', javascriptDirectory(), coffee: yes

gulp.task 'javascript:vendor', ->
  collectJavaScript manifests.vendor(), 'vendor.js', javascriptDirectory(), coffee: no

gulp.task 'javascript', [
  'templates',
  'javascript:vendor',
  'javascript:application'
], ->
  if config.isProduction
    gulp.src manifests.production()
    .pipe concat('application.js')
    .pipe uglify()
    .pipe gulp.dest("#{path.build}")
    .on 'end', ->
      rimraf path.buildCache, ->

collectJavaScript = (source, name, destination, opts) ->
  stream = gulp.src source
  stream = stream.pipe coffee(bare: no) if opts and opts.coffee
  stream
  .pipe concat(name)
  .pipe gulp.dest(destination)

