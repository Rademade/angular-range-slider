path              = require './path.coffee'
config            = require './config.coffee'
gulp              = require 'gulp'
compass           = require 'gulp-compass'
rename            = require 'gulp-rename'
wrap              = require 'gulp-wrap'

###
  Stylesheets tasks
###

gulp.task 'stylesheets', ['images'], ->
  stream = compileStylesheets "#{path.source}/sass/stylesheets.sass", 'stylesheets.css', "#{path.build}", "#{path.build}/images"
  if config.isProduction
    stream.pipe gulp.dest "#{path.build}"
  stream

compileStylesheets = (source, name, destination, imagesDir) ->
  gulp.src source
  .pipe compass(
    css: destination
    sass: "#{path.source}/sass",
    path: '/',
    image: imagesDir
  )
  .on 'error', (err) ->
    throw err