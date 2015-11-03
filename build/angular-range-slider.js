(function() {
  var MAX_BUBBLE, MIN_BUBBLE;

  MAX_BUBBLE = 'MAX_BUBBLE';

  MIN_BUBBLE = 'MIN_BUBBLE';

  angular.module('ngSlider', []).directive('slider', function() {
    return {
      restrict: 'A',
      scope: {
        minValue: '=',
        maxValue: '=',
        minOut: '=',
        maxOut: '=',
        jumping: '=',
        bubbleOffset: '=?'
      },
      template: "<div class=\"slider\">\n  <div class=\"slider-container\">\n    <div id=\"slider-range\" class=\"slider-range\">\n      <div id=\"slider-btn-min\" class=\"slider-btn min\">\n        <span class=\"slider-btn-val\">{{ min }}</span>\n      </div>\n      <div class=\"slider-btn max\">\n        <span class=\"slider-btn-val\">{{ max }}</span>\n      </div>\n    </div>\n  </div>\n</div>",
      link: function(scope) {
        var _initialize, bubbleOffset, bubbleSize, calculatePosition, currentDragBubble, dragBubble, dragLeftBubble, dragRightBubble, dropBubble, finishPosition, getPixelsOfSliderRangeProperty, initMaxValue, initMinValue, isDragging, leftBubblePosition, maxElement, maxPosition, maxWidthRange, minElement, minPosition, moveBubble, resetPosition, rightBubblePosition, setSliderLeftPosition, setSliderPosition, setSliderRightPosition, sliderContainer, sliderRange, sliderRangeCurrentX, startPosition, step, updateValues;
        scope.min = scope.minOut;
        scope.max = scope.maxOut;
        minElement = document.getElementById('slider-btn-min');
        maxElement = document.getElementsByClassName('slider-btn max')[0];
        sliderContainer = document.getElementsByClassName('slider-container')[0];
        sliderRange = document.getElementById('slider-range');
        bubbleSize = minElement.clientWidth;
        bubbleOffset = scope.bubbleOffset | 1;
        maxWidthRange = 0;
        step = 0;
        initMaxValue = scope.maxValue;
        initMinValue = scope.minValue;
        sliderRangeCurrentX = 0;
        currentDragBubble = false;
        startPosition = (scope.min - scope.minValue) * step;
        finishPosition = (scope.maxValue - scope.max) * step;
        maxPosition = Number.MAX_VALUE;
        minPosition = -Number.MAX_VALUE;
        rightBubblePosition = 0;
        leftBubblePosition = 0;
        isDragging = false;
        scope.$watch(minElement, function() {
          bubbleSize = minElement.clientWidth;
          minElement.style.left = -bubbleOffset + 'px';
          return rightBubblePosition = -bubbleOffset;
        });
        scope.$watch(maxElement, function() {
          maxElement.style.right = -bubbleOffset + 'px';
          return leftBubblePosition = -bubbleOffset;
        });
        scope.$watch('minOut', function() {
          if (scope.minOut >= scope.minValue && scope.minOut < scope.maxOut) {
            scope.min = scope.minOut;
            return _initialize();
          }
        });
        scope.$watch('maxOut', function() {
          if (scope.maxOut > scope.minValue && scope.maxOut <= scope.maxValue) {
            scope.max = scope.maxOut;
            return _initialize();
          }
        });
        _initialize = function() {
          maxWidthRange = sliderContainer.clientWidth - (bubbleSize - bubbleOffset) * 2;
          step = maxWidthRange / (scope.maxValue - scope.minValue - 1);
          sliderRange.style.left = Math.floor((scope.min - scope.minValue) * step) + 'px';
          return sliderRange.style.right = Math.floor((scope.maxValue - scope.max) * step) + 'px';
        };
        dragBubble = function(type, element, currentBubble, event) {
          isDragging = true;
          event.preventDefault();
          if (event.changedTouches) {
            event = event.changedTouches[0];
          }
          if (element.style[type]) {
            sliderRangeCurrentX = getPixelsOfSliderRangeProperty(type);
          }
          currentDragBubble = currentBubble;
          return startPosition = Math.floor(event.clientX);
        };
        dropBubble = function() {
          if (!isDragging) {
            return;
          }
          isDragging = false;
          currentDragBubble = false;
          resetPosition();
          updateValues();
          return scope.$apply();
        };
        dragRightBubble = function(event) {
          return dragBubble('right', maxElement, MAX_BUBBLE, event);
        };
        dragLeftBubble = function(event) {
          return dragBubble('left', minElement, MIN_BUBBLE, event);
        };
        moveBubble = function(event) {
          if (!isDragging) {
            return;
          }
          if (event.changedTouches) {
            event = event.changedTouches[0];
          }
          if (currentDragBubble === MAX_BUBBLE) {
            return calculatePosition(event, 'right', 'left', setSliderRightPosition);
          } else if (currentDragBubble === MIN_BUBBLE) {
            return calculatePosition(event, 'left', 'right', setSliderLeftPosition);
          }
        };
        calculatePosition = function(event, myPosition, siblingPosition, setValue) {
          finishPosition = Math.floor(event.clientX);
          setValue();
          return scope.$apply();
        };
        setSliderRightPosition = function() {
          return setSliderPosition(rightBubblePosition, -1, 'maxValue', 'max', 'min', initMaxValue, 'right', 'left');
        };
        setSliderLeftPosition = function() {
          return setSliderPosition(leftBubblePosition, 1, 'minValue', 'min', 'max', initMinValue, 'left', 'right');
        };
        setSliderPosition = function(bubblePosition, inversionIndex, value, limitValue, oppositeLimitValue, initValue, property, oppositeProperty) {
          var result;
          bubblePosition = sliderRangeCurrentX - (startPosition - finishPosition) * inversionIndex;
          result = scope[limitValue];
          if (bubblePosition > -1) {
            scope[limitValue] = initValue + Math.floor((bubblePosition / step) * inversionIndex);
          }
          if (scope.max <= scope.min) {
            scope[limitValue] = scope[oppositeLimitValue] - inversionIndex;
          }
          if (scope[limitValue] <= scope[value] * inversionIndex || bubblePosition < -1) {
            scope[limitValue] = scope[value];
          }
          if (scope.jumping) {
            if (scope[limitValue] !== result && scope.min < scope.max && (scope[limitValue] >= scope[value] * inversionIndex)) {
              return sliderRange.style[property] = (scope[limitValue] - initValue) * inversionIndex * step + 'px';
            }
          } else {
            if (scope.min < scope.max && scope[limitValue] >= scope[value] * inversionIndex && bubblePosition / step > 0) {
              return sliderRange.style[property] = Math.min(sliderRangeCurrentX - (startPosition - finishPosition) * inversionIndex, maxWidthRange - getPixelsOfSliderRangeProperty(oppositeProperty)) + 'px';
            }
          }
        };
        updateValues = function() {
          scope.minOut = scope.min;
          return scope.maxOut = scope.max;
        };
        getPixelsOfSliderRangeProperty = function(property) {
          return sliderRange.style[property].slice(0, -2);
        };
        resetPosition = function() {
          maxPosition = Number.MAX_VALUE;
          return minPosition = -Number.MAX_VALUE;
        };
        _initialize();
        maxElement.addEventListener('mousedown', dragRightBubble);
        maxElement.addEventListener('touchstart', dragRightBubble);
        minElement.addEventListener('mousedown', dragLeftBubble);
        minElement.addEventListener('touchstart', dragLeftBubble);
        document.body.addEventListener('mousemove', moveBubble);
        document.body.addEventListener('touchmove', moveBubble);
        document.addEventListener('mouseup', dropBubble);
        document.addEventListener('touchend', dropBubble);
        window.addEventListener('resize', _initialize);
        scope.$on('$destroy', function() {
          maxElement.removeEventListener('mousedown', dragRightBubble);
          maxElement.removeEventListener('touchstart', dragRightBubble);
          minElement.removeEventListener('mousedown', dragLeftBubble);
          minElement.removeEventListener('touchstart', dragLeftBubble);
          document.body.removeEventListener('mousemove', moveBubble);
          document.body.removeEventListener('touchmove', moveBubble);
          document.removeEventListener('mouseup', dropBubble);
          document.removeEventListener('touchend', dropBubble);
          return window.removeEventListener('resize', _initialize);
        });
        return false;
      }
    };
  });

}).call(this);
