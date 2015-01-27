path              = require './path.coffee'
config            = require './config.coffee'
gulp              = require 'gulp'
concat            = require 'gulp-concat'
wrap              = require 'gulp-wrap'
declare           = require 'gulp-declare'
jade              = require 'gulp-jade'

###
  Templates tasks
###

gulp.task 'templates', ->
  place = if config.isProduction then "#{path.buildCache}" else "#{path.build}"
  compileTemplates "#{path.source}/templates/**/*", 'templates.js', place

nameProcessor = (filePath) ->
  declare.processNameByPath(filePath.replace("#{path.source}/templates", '')).replace /\./g, '/'

compileTemplates = (source, name, destination) ->
  gulp.src "#{path.source}/templates/**/*"
  .pipe jade(
    client: yes
    debug: no
    pretty: not config.isProduction
  )
  .pipe wrap('(<%= contents %>)()')
  .pipe declare(
    namespace: 'Chatrulez.Templates',
    noRedeclare: yes,
    processName: nameProcessor
  )
  .pipe concat(name)
  .pipe gulp.dest(destination)