MAX_BUBBLE = 'MAX_BUBBLE'
MIN_BUBBLE = 'MIN_BUBBLE'

angular.module('ngSlider',[]).directive 'slider', () ->
  restrict : 'A'
  scope :
    minValue : '='
    maxValue : '='
    minOut : '='
    maxOut : '='
    jumping : '='
    bubbleOffset : '=?'

  template : """
    <div class="slider">
      <div class="slider-container">
        <div id="slider-range" class="slider-range">
          <div id="slider-btn-min" class="slider-btn min">
            <span class="slider-btn-val">{{ min }}</span>
          </div>
          <div class="slider-btn max">
            <span class="slider-btn-val">{{ max }}</span>
          </div>
        </div>
      </div>
    </div>
  """

  link : (scope) ->
    scope.min = scope.minOut
    scope.max = scope.maxOut

    minElement = document.getElementById('slider-btn-min')
    maxElement = document.getElementsByClassName('slider-btn max')[0]
    sliderContainer = document.getElementsByClassName('slider-container')[0]
    sliderRange = document.getElementById('slider-range')

    bubbleSize = minElement.clientWidth
    bubbleOffset = scope.bubbleOffset | 1
    maxWidthRange = 0
    step = 0
    initMaxValue = scope.maxValue
    initMinValue = scope.minValue
    sliderRangeCurrentX = 0
    currentDragBubble = false
    startPosition = (scope.min - scope.minValue) * step
    finishPosition = (scope.maxValue - scope.max) * step
    maxPosition = Number.MAX_VALUE
    minPosition = -Number.MAX_VALUE
    rightBubblePosition = 0
    leftBubblePosition = 0
    isDragging = no

    scope.$watch minElement, () ->
      bubbleSize = minElement.clientWidth
      minElement.style.left = -bubbleOffset + 'px'
      rightBubblePosition = -bubbleOffset

    scope.$watch maxElement, () ->
      maxElement.style.right = -bubbleOffset + 'px'
      leftBubblePosition = -bubbleOffset

    scope.$watch 'minOut', () ->
      if scope.minOut >= scope.minValue && scope.minOut < scope.maxOut
        scope.min = scope.minOut
        _initialize()

    scope.$watch 'maxOut', () ->
      if scope.maxOut > scope.minValue && scope.maxOut <= scope.maxValue
        scope.max = scope.maxOut
        _initialize()

    _initialize = () ->
      maxWidthRange = sliderContainer.clientWidth - (bubbleSize - bubbleOffset) * 2
      step = maxWidthRange / (scope.maxValue - scope.minValue - 1)
      sliderRange.style.left = Math.floor((scope.min - scope.minValue) * step) + 'px'
      sliderRange.style.right = Math.floor((scope.maxValue - scope.max) * step) + 'px'

    dragBubble = (type, element, currentBubble, event) ->
      isDragging = yes
      event.preventDefault()
      event = event.changedTouches[0] if event.changedTouches
      sliderRangeCurrentX = getPixelsOfSliderRangeProperty(type) if element.style[type]
      currentDragBubble = currentBubble
      startPosition = Math.floor event.clientX

    dropBubble = () ->
      return unless isDragging
      isDragging = no
      currentDragBubble = false
      resetPosition()
      updateValues()
      scope.$apply()

    dragRightBubble = (event) ->
      dragBubble('right', maxElement, MAX_BUBBLE, event)

    dragLeftBubble = (event) ->
      dragBubble('left', minElement, MIN_BUBBLE, event)

    moveBubble = (event) ->
      return unless isDragging
      event = event.changedTouches[0] if event.changedTouches
      if currentDragBubble == MAX_BUBBLE
        calculatePosition(event, 'right', 'left', setSliderRightPosition)
      else if currentDragBubble == MIN_BUBBLE
        calculatePosition(event, 'left', 'right', setSliderLeftPosition)

    calculatePosition = (event, myPosition, siblingPosition, setValue) ->
      finishPosition = Math.floor event.clientX
      setValue()
      scope.$apply()

    setSliderRightPosition = () ->
      setSliderPosition(rightBubblePosition, -1, 'maxValue', 'max', 'min', initMaxValue, 'right', 'left')

    setSliderLeftPosition = () ->
      setSliderPosition(leftBubblePosition, 1, 'minValue', 'min', 'max', initMinValue, 'left', 'right')

    setSliderPosition = (bubblePosition, inversionIndex, value, limitValue, oppositeLimitValue, initValue, property, oppositeProperty) ->
      bubblePosition = sliderRangeCurrentX - (startPosition - finishPosition) * inversionIndex
      result = scope[limitValue]
      scope[limitValue] = initValue + Math.floor (bubblePosition / step) * inversionIndex if bubblePosition > -1
      scope[limitValue] = scope[oppositeLimitValue] - inversionIndex  if scope.max <= scope.min
      scope[limitValue] = scope[value] if scope[limitValue] <= scope[value] * inversionIndex || bubblePosition < -1
      if scope.jumping
        if scope[limitValue] != result && scope.min < scope.max && (scope[limitValue] >= scope[value] * inversionIndex)
          sliderRange.style[property] = (scope[limitValue] - initValue) * inversionIndex * step + 'px'
      else
        if scope.min < scope.max && scope[limitValue] >= scope[value] * inversionIndex && bubblePosition / step > 0
          sliderRange.style[property] = Math.min(sliderRangeCurrentX - (startPosition - finishPosition) * inversionIndex, maxWidthRange - getPixelsOfSliderRangeProperty(oppositeProperty)) + 'px'

    updateValues = () ->
      scope.minOut = scope.min
      scope.maxOut = scope.max

    getPixelsOfSliderRangeProperty = (property) ->
      sliderRange.style[property].slice(0, -2)

    resetPosition = () ->
      maxPosition = Number.MAX_VALUE
      minPosition = -Number.MAX_VALUE

    _initialize()

    maxElement.addEventListener 'mousedown', dragRightBubble
    maxElement.addEventListener 'touchstart', dragRightBubble
    minElement.addEventListener 'mousedown', dragLeftBubble
    minElement.addEventListener 'touchstart', dragLeftBubble
    document.body.addEventListener 'mousemove', moveBubble
    document.body.addEventListener 'touchmove', moveBubble
    document.addEventListener 'mouseup', dropBubble
    document.addEventListener 'touchend', dropBubble
    window.addEventListener 'resize', _initialize

    scope.$on '$destroy', () ->
      maxElement.removeEventListener 'mousedown', dragRightBubble
      maxElement.removeEventListener 'touchstart', dragRightBubble
      minElement.removeEventListener 'mousedown', dragLeftBubble
      minElement.removeEventListener 'touchstart', dragLeftBubble
      document.body.removeEventListener 'mousemove', moveBubble
      document.body.removeEventListener 'touchmove', moveBubble
      document.removeEventListener 'mouseup', dropBubble
      document.removeEventListener 'touchend', dropBubble
      window.removeEventListener 'resize', _initialize

    false