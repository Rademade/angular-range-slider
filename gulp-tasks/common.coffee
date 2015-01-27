path              = require './path.coffee'
gulp              = require 'gulp'
nodemon           = require 'gulp-nodemon'


gulp.task 'default', ['clean'], ->
  gulp.start [
    'stylesheets',
    'javascript',
    'templates',
    'layout',
    'watch',
    'server'
  ]

gulp.task 'watch', ->
  gulp.watch "#{path.source}/sass/**/*",                ['stylesheets']
  gulp.watch "#{path.source}/js/**/*",                  ['javascript']
  gulp.watch "#{path.source}/templates/**/*",           ['templates']
  gulp.watch "server/views/**/*",                       ['layout']

gulp.task 'server', ->
  nodemon
    script: 'minichat_server.js'
    ext: 'coffee js html jade'
    ignore: [
      "#{path.build}/**/*",
      "#{path.source}/**/*",
      'gulpfile.js',
      'gulpfile.coffee'
    ]
  .on 'restart', ->
    console.log 'Express server restarted'