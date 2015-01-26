#how to use it
#window.app = angular.module('app', ['ngSlider'])
#app.controller 'mainCtrl', ['$scope', ($scope)->
#  $scope.minimum = 14
#  $scope.maximum = 65
#  $scope.$watch 'minimum', -> console.log $scope.minimum
#
#]
angular.module('ngSlider',[]).directive 'slider',[ ->
  restrict : 'A'
  scope :
    minValue : '='
    maxValue : '='

  template : "<div class='slider'>"+
               "<div class='slider-container'>"+
                  "<div class='slider-range'  id='slider-range'>"+
                    "<div class='slider-btn min' id='slider-btn-min'>"+
                      "<span class='slider-btn-val'>{{minValue}}</span>"+
                    "</div>"+
                    "<div class='slider-btn max'>"+
                      "<span class='slider-btn-val'>{{maxValue}}</span>"+
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
    sliderRange.style.left = '0px'
    sliderRange.style.right = '0px'
    step = sliderRange.clientWidth / (scope.maxValue - scope.minValue)

    initMaxValue = scope.maxValue
    initMinValue = scope.minValue

    sliderRangeCurrentX = 0
    onDragEventMIN = false
    onDropEventMAX = false
    startPosition = 0
    finishPosition = 0
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
      scope.maxValue = initMaxValue - Math.floor getPixelsOfSliderRangeProperty('right')/step if Math.floor getPixelsOfSliderRangeProperty('right') > 0
      scope.maxValue = scope.minValue + 1 if scope.maxValue <= scope.minValue

    setMinValue = ->
      setSliderLeftPosition()
      scope.minValue = initMinValue + Math.floor getPixelsOfSliderRangeProperty('left')/step if getPixelsOfSliderRangeProperty('left') > 0
      scope.minValue = scope.maxValue - 1  if scope.maxValue  <= scope.minValue

    setSliderRightPosition = ->
      sliderRange.style.right = sliderRangeCurrentX - (finishPosition - startPosition) + 'px'

    setSliderLeftPosition = ->
      console.log startPosition
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



