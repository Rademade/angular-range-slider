module.exports = (->

  path = require './path.coffee'
  manifests = {}

  manifests.vendor = ->
    path.rootify [
      'angular/angular'
      'angular-ui-router/release/angular-ui-router'
      'jquery/dist/jquery'
      'angularjs-rails-resource/angularjs-rails-resource'

    ], "bower_components", 'js'

  manifests.application = ->
    path.rootify [
      'app'
      'routes'
      '**/*'
    ], "#{path.source}/js", 'coffee'

  manifests

)()