path              = require './path.coffee'
gulp              = require 'gulp'
rimraf            = require 'gulp-rimraf'

gulp.task 'clean', ->
  gulp.src([
    path.build,
    path.debug,
    path.debugCache
  ], read: no).pipe(rimraf())