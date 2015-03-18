#window.app = angular.module('app', ['ngSlider'])
#app.controller 'mainCtrl', ['$scope', ($scope)->
#  $scope.minimum = 33
#  $scope.maximum = 55
#  $scope.$watch 'minimum', -> console.log $scope.minimum
#
#]
angular.module('ngSlider',[]).directive 'slider',[ ->
  restrict : 'A'
  scope :
    minValue : '='
    maxValue : '='
    minOut : '='
    maxOut : '='
    jumping : '='

  template : "<div class='slider'>"+
               "<div class='slider-container'>"+
                  "<div class='slider-range'  id='slider-range'>"+
                    "<div class='slider-btn min' id='slider-btn-min'>"+
                      "<span class='slider-btn-val'>{{min}}</span>"+
                    "</div>"+
                    "<div class='slider-btn max'>"+
                      "<span class='slider-btn-val'>{{max}}</span>"+
                    "</div>"+
                  "</div>"+
               "</div>"+
             "</div>"

  link: (scope) ->
    minElement = document.getElementById('slider-btn-min')
    maxElement = document.getElementsByClassName('slider-btn max')[0]
    sliderContainer = document.getElementsByClassName('slider-container')[0]
    sliderRange = document.getElementById('slider-range')
    maxWidthRange = sliderContainer.clientWidth
    step = 0
    scope.min = scope.minOut
    scope.max = scope.maxOut
    initMaxValue = scope.maxValue
    initMinValue = scope.minValue
    sliderRangeCurrentX = 0
    MAX_BUBBLE = 'MAX_BUBBLE'
    MIN_BUBBLE = 'MIN_BUBBLE'
    currentDragBubble =  false
    startPosition = (scope.min - scope.minValue) * step
    finishPosition = (scope.maxValue - scope.max) * step
    maxPosition =  Number.MAX_VALUE
    minPosition = -Number.MAX_VALUE
    rightBubblePosition = 0
    leftBubblePosition = 0

    scope.$watch minElement, ->
      minElement.style.left = -minElement.offsetWidth + 'px'
      rightBubblePosition = -minElement.offsetWidth

    scope.$watch maxElement, ->
      maxElement.style.right = -maxElement.offsetWidth  + 'px'
      leftBubblePosition = -minElement.offsetWidth

    scope.$watch 'minOut', ->
      if scope.minOut >=  scope.minValue && scope.minOut < scope.maxOut
        scope.min = scope.minOut
        _initialize()
    scope.$watch 'maxOut', ->
      if scope.maxOut >  scope.minValue && scope.maxOut <= scope.maxValue
        scope.max = scope.maxOut
        _initialize()

    maxElement.addEventListener 'mousedown', (event)-> dragBubble('right', maxElement, MAX_BUBBLE, event)
    maxElement.addEventListener 'touchstart', (event)-> dragBubble('right', maxElement, MAX_BUBBLE, event)

    minElement.addEventListener 'mousedown', (event)-> dragBubble('left', minElement, MIN_BUBBLE, event)
    minElement.addEventListener 'touchstart', (event)-> dragBubble('left', minElement, MIN_BUBBLE, event)

    document.addEventListener 'mouseup', -> dropBubble()
    document.addEventListener 'touchend', -> dropBubble()

    document.body.addEventListener 'touchmove', (event)-> moveBubble(event)
    document.body.onmousemove = (event)-> moveBubble(event)

    window.addEventListener 'resize', -> _initialize()


    _initialize = ->
      maxWidthRange = sliderContainer.clientWidth
      step = maxWidthRange / (scope.maxValue - scope.minValue - 1)
      sliderRange.style.left = Math.floor(( scope.min - scope.minValue) * step) + 'px'
      sliderRange.style.right = Math.floor((scope.maxValue - scope.max) * step) + 'px'

    _initialize()

    dragBubble = (type, element, currentBubble, event) ->
      event.preventDefault()
      if event.changedTouches
        event = event.changedTouches[0]

      if element.style[type]
        sliderRangeCurrentX = getPixelsOfSliderRangeProperty(type)
      currentDragBubble = currentBubble
      startPosition = Math.floor event.clientX

    dropBubble = ->
      currentDragBubble = false
      resetPosition()
      updateValues()
      scope.$apply()

    moveBubble = (event)->
      if event.changedTouches
        event = event.changedTouches[0]
      calculatePosition(event, 'right', 'left', setSliderRightPosition  ) if currentDragBubble == MAX_BUBBLE
      calculatePosition(event, 'left', 'right', setSliderLeftPosition  ) if currentDragBubble == MIN_BUBBLE

    calculatePosition = (event, myPosition, siblingPosition, setValue)->
        finishPosition = Math.floor event.clientX
        setValue()
        scope.$apply()

    setSliderRightPosition = -> setSliderPosition(rightBubblePosition, -1, 'maxValue','max', 'min', initMaxValue, 'right', 'left' )
    setSliderLeftPosition = -> setSliderPosition(leftBubblePosition, 1, 'minValue','min', 'max', initMinValue, 'left', 'right' )

    setSliderPosition = (bubblePosition, inversionIndex, value, limitValue, oppositeLimitValue, initValue, property, oppositeProperty ) ->
      bubblePosition = sliderRangeCurrentX - (startPosition - finishPosition) * inversionIndex
      result = scope[limitValue]
      scope[limitValue] = initValue + Math.floor (bubblePosition/step) * inversionIndex if bubblePosition > -1
      scope[limitValue] = scope[oppositeLimitValue] - inversionIndex  if scope.max  <= scope.min
      scope[limitValue] = scope[value] if scope[limitValue] <= scope[value] * inversionIndex || bubblePosition < -1
      if scope.jumping
        console.log  scope[limitValue] != result
        if scope[limitValue] != result &&  scope.min < scope.max  && (scope[limitValue] >= scope[value] * inversionIndex)
          sliderRange.style[property] = (scope[limitValue] - initValue) * inversionIndex * step + 'px'
      else
        if scope.min < scope.max && scope[limitValue] >= scope[value] * inversionIndex && bubblePosition/step > 0
          sliderRange.style[property] = Math.min(sliderRangeCurrentX - (startPosition - finishPosition) * inversionIndex ,maxWidthRange - getPixelsOfSliderRangeProperty(oppositeProperty)) + 'px'

    updateValues = ->
      scope.minOut = scope.min
      scope.maxOut = scope.max

    getPixelsOfSliderRangeProperty = (property)->
      sliderRange.style[property].slice(0, -2)

    resetPosition = ->
      maxPosition =  Number.MAX_VALUE
      minPosition = -Number.MAX_VALUE

    false
]



