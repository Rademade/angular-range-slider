path              = require './path.coffee'
gulp              = require 'gulp'
rename            = require 'gulp-rename'
preprocess        = require 'gulp-preprocess'
###
  Layout tasks
###

gulp.task 'layout', ->
  gulp.src 'server/views/layout.html'
  .pipe preprocess()
  .pipe rename('index.html')
  .pipe gulp.dest(path.build)