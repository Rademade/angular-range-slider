#how to use it
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
    min : '='
    max : '='

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
    step = maxWidthRange / (scope.maxValue - scope.minValue)
    initMaxValue = scope.maxValue
    initMinValue = scope.minValue
    sliderRange.style.left = Math.floor(( scope.min - scope.minValue) * step) + 'px'
    sliderRange.style.right = Math.floor((scope.maxValue - scope.max) * step) + 'px'
    sliderRangeCurrentX = 0
    MAX_BUBBLE = 'MAX_BUBBLE'
    MIN_BUBBLE = 'MIN_BUBBLE'
    currentDragBubble =  false
    startPosition = (scope.min - scope.minValue) * step
    finishPosition = (scope.maxValue - scope.max) * step
    maxPosition =  Number.MAX_VALUE
    minPosition = -Number.MAX_VALUE
    scope.$watch minElement, -> minElement.style.left = -minElement.offsetWidth + 'px'
    scope.$watch maxElement, -> maxElement.style.right = -maxElement.offsetWidth  + 'px'

    maxElement.addEventListener 'mousedown', (event)-> dragBubble('right', maxElement, MAX_BUBBLE, event)
    maxElement.addEventListener 'touchstart', (event)-> dragBubble('right', maxElement, MAX_BUBBLE, event)

    minElement.addEventListener 'mousedown', (event)-> dragBubble('left', minElement, MIN_BUBBLE, event)
    minElement.addEventListener 'touchstart', (event)-> dragBubble('left', minElement, MIN_BUBBLE, event)

    document.addEventListener 'mouseup', -> dropBubble()
    document.addEventListener 'touchend', -> dropBubble()

    document.body.addEventListener 'touchmove', (event)-> moveBubble(event)
    document.body.onmousemove = (event)-> moveBubble(event)

    dragBubble = (type, element, currentBubble, event) ->
      if event.changedTouches
        event = event.changedTouches[0]

      if element.style[type]
        sliderRangeCurrentX = getPixelsOfSliderRangeProperty(type)
      currentDragBubble = currentBubble
      startPosition = Math.floor event.clientX

    dropBubble = ->
      currentDragBubble = false
      resetPosition()

    moveBubble = (event)->
      if event.changedTouches
        event = event.changedTouches[0]
      console.log currentDragBubble
      calculatePosition(event, 'right', 'left', setMaxValue, setMaxPosition, setMinPosition  ) if currentDragBubble == MAX_BUBBLE
      calculatePosition(event, 'left', 'right', setMinValue, setMinPosition, setMaxPosition  ) if currentDragBubble == MIN_BUBBLE


    calculatePosition = (event, myPosition, siblingPosition, setValue, setLeftPosition, setRightPosition )->
      finishPosition = Math.floor event.clientX
      if minPosition < finishPosition < maxPosition
        setValue()
        scope.$apply()
      if (getPixelsOfSliderRangeProperty(myPosition) < 0)
        sliderRange.style[myPosition] = '0px'
        setLeftPosition(event)
      if checkBubblesCollision()
        setRightPosition(event)
        sliderRange.style[myPosition] = (maxWidthRange - getPixelsOfSliderRangeProperty(siblingPosition)) + 'px'


    setMinPosition = (event)->
      minPosition = Math.floor event.clientX
    setMaxPosition = (event)->
      maxPosition = Math.floor event.clientX

    setMaxValue = ->
      setSliderRightPosition()
      scope.max = initMaxValue - Math.floor getPixelsOfSliderRangeProperty('right')/step if Math.floor getPixelsOfSliderRangeProperty('right') > 0
      scope.max = scope.min + 1 if scope.max <= scope.min

    setMinValue = ->
      setSliderLeftPosition()
      scope.min = initMinValue + Math.floor getPixelsOfSliderRangeProperty('left')/step if getPixelsOfSliderRangeProperty('left') > 0
      scope.min = scope.max - 1  if scope.max  <= scope.min

    setSliderRightPosition = ->
      sliderRange.style.right = sliderRangeCurrentX - (finishPosition - startPosition) + 'px'

    setSliderLeftPosition = ->
      left = Math.min(sliderRangeCurrentX - (startPosition - finishPosition), maxWidthRange - getPixelsOfSliderRangeProperty('right'))
      sliderRange.style.left = left + 'px'

    checkBubblesCollision = ->
      checkOutOfTheRange() && (finishPosition < maxPosition)

    checkOutOfTheRange = ->
      sliderRangeWidth = sliderRange.clientWidth
      sliderRangeWidth = 0 if sliderRangeWidth < 0
      maxWidthRange < (1*getPixelsOfSliderRangeProperty('left') + 1*getPixelsOfSliderRangeProperty('right') + sliderRangeWidth) - step / 2

    getPixelsOfSliderRangeProperty = (property)->
      sliderRange.style[property].slice(0, -2)

    resetPosition = ->
      maxPosition =  Number.MAX_VALUE
      minPosition = -Number.MAX_VALUE

    false
]



