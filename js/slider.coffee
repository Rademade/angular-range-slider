#how to use it
window.app = angular.module('app', ['ngSlider'])
app.controller 'mainCtrl', ['$scope', ($scope)->
  $scope.minimum = 33
  $scope.maximum = 55
  $scope.$watch 'minimum', -> console.log $scope.minimum

]
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
    scope.$watch minElement, -> minElement.style.left = -minElement.offsetWidth + 'px'
    scope.$watch maxElement, -> maxElement.style.right = -maxElement.offsetWidth  + 'px'


    #set init value
    console.log scope.maxValue, scope.minValue, maxWidthRange
    step = maxWidthRange / (scope.maxValue - scope.minValue)
    console.log step

    initMaxValue = scope.maxValue
    initMinValue = scope.minValue
    sliderRange.style.left = Math.floor(( scope.min - scope.minValue) * step) + 'px'
    sliderRange.style.right = Math.floor((scope.maxValue - scope.max) * step) + 'px'

    sliderRangeCurrentX = 0
    onDragEventMIN = false
    onDropEventMAX = false
    startPosition = (scope.min - scope.minValue) * step
    finishPosition = (scope.maxValue - scope.max) * step
    maxPosition =  Number.MAX_VALUE
    minPosition = -Number.MAX_VALUE
    resetPosition = ->
      maxPosition =  Number.MAX_VALUE
      minPosition = -Number.MAX_VALUE

    maxElement.addEventListener 'mousedown', (event)-> dragMinBubble(event)
    maxElement.addEventListener 'touchstart', (event)-> dragMinBubble(event)

    minElement.addEventListener 'mousedown', (event)-> dragMaxBubble(event)
    minElement.addEventListener 'touchstart', (event)-> dragMaxBubble(event)

    document.addEventListener 'mouseup', -> dropBubble()
    document.addEventListener 'touchend', -> dropBubble()

    document.body.addEventListener 'touchmove', (event)-> moveBubble(event)
    document.body.onmousemove = (event)-> moveBubble(event)

    dragMinBubble = (event) ->
      if event.changedTouches
        event = event.changedTouches[0]

      if maxElement.style.right
        sliderRangeCurrentX = getPixelsOfSliderRangeProperty('right')
      onDropEventMAX = true
      startPosition = Math.floor event.clientX
      console.log startPosition

    dragMaxBubble = (event) ->
      if event.changedTouches
        event = event.changedTouches[0]

      if minElement.style.left
        sliderRangeCurrentX = getPixelsOfSliderRangeProperty('left')
      onDragEventMIN = true
      startPosition = Math.floor event.clientX

    dropBubble = ->
      onDropEventMAX = false
      onDragEventMIN = false
      resetPosition()

    moveBubble = (event)->
      if event.changedTouches
        event = event.changedTouches[0]
      calculatePosition(event, 'right', 'left', setMaxValue, setMaxPosition, setMinPosition  ) if onDropEventMAX
      calculatePosition(event, 'left', 'right', setMinValue, setMinPosition, setMaxPosition  ) if onDragEventMIN


    calculatePosition = (event, myPosition, siblingPosition, setValue, setLeftPosition, setRightPosition )->
      finishPosition = Math.floor event.clientX
      console.log minPosition,finishPosition,maxPosition,sliderRange.style.right, sliderRange.style.left
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
      console.log '---------------',initMaxValue, Math.floor getPixelsOfSliderRangeProperty('right')/step,
      scope.max = scope.min + 1 if scope.max <= scope.min

    setMinValue = ->
      setSliderLeftPosition()
      scope.min = initMinValue + Math.floor getPixelsOfSliderRangeProperty('left')/step if getPixelsOfSliderRangeProperty('left') > 0
      scope.min = scope.max - 1  if scope.max  <= scope.min

    setSliderRightPosition = ->
      sliderRange.style.right = sliderRangeCurrentX - (finishPosition - startPosition) + 'px'

    setSliderLeftPosition = ->
#      console.log startPosition
      sliderRange.style.left = sliderRangeCurrentX - (startPosition - finishPosition) + 'px'

    checkBubblesCollision = ->
      checkOutOfTheRange() && (finishPosition < maxPosition)

    checkOutOfTheRange = ->
      sliderRangeWidth = sliderRange.clientWidth
      sliderRangeWidth = 0 if sliderRangeWidth < 0
      maxWidthRange < (1*getPixelsOfSliderRangeProperty('left') + 1*getPixelsOfSliderRangeProperty('right') + sliderRangeWidth)

    getPixelsOfSliderRangeProperty = (property)->
      sliderRange.style[property].slice(0, -2)

    false
]



