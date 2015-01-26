coffee            = require 'gulp-coffee'
gulp              = require 'gulp'
watch             = require 'gulp-watch'
batch             = require 'gulp-batch'


gulp.task "js", ->
  gulp.src("./js/*.coffee")
    .pipe(coffee(bare: true)
    .on("error", ()-> console.log 'errr'))
    .pipe gulp.dest("./public/js/")


gulp.task 'default', -> gulp.watch "./js/**/*", ['js']