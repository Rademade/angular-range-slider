module.exports =
  source:           'src'
  build:            'build'
  debug:            'public'
  debugCache:       'public/build-cache'

  rootify: (targets, root, extension = null) ->
    targets.map (target) ->
      root + '/' + target + if extension then ".#{extension}" else ''
