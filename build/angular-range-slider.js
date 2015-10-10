(function() {
  angular.module('ngSlider', []).directive('slider', [
    function() {
      return {
        restrict: 'A',
        scope: {
          minValue: '=',
          maxValue: '=',
          minOut: '=',
          maxOut: '=',
          jumping: '='
        },
        template: "<div class='slider'>" + "<div class='slider-container'>" + "<div class='slider-range'  id='slider-range'>" + "<div class='slider-btn min' id='slider-btn-min'>" + "<span class='slider-btn-val'>{{min}}</span>" + "</div>" + "<div class='slider-btn max'>" + "<span class='slider-btn-val'>{{max}}</span>" + "</div>" + "</div>" + "</div>" + "</div>",
        link: function(scope) {
          var MAX_BUBBLE, MIN_BUBBLE, bubbleErrorOffset, bubbleSize, calculatePosition, currentDragBubble, dragBubble, dropBubble, finishPosition, getPixelsOfSliderRangeProperty, initMaxValue, initMinValue, leftBubblePosition, maxElement, maxPosition, maxWidthRange, minElement, minPosition, moveBubble, resetPosition, rightBubblePosition, setSliderLeftPosition, setSliderPosition, setSliderRightPosition, sliderContainer, sliderRange, sliderRangeCurrentX, startPosition, step, updateValues, _initialize;
          minElement = document.getElementById('slider-btn-min');
          maxElement = document.getElementsByClassName('slider-btn max')[0];
          sliderContainer = document.getElementsByClassName('slider-container')[0];
          sliderRange = document.getElementById('slider-range');
          bubbleSize = minElement.clientWidth;
          bubbleErrorOffset = 1;
          maxWidthRange = 0;
          step = 0;
          scope.min = scope.minOut;
          scope.max = scope.maxOut;
          initMaxValue = scope.maxValue;
          initMinValue = scope.minValue;
          sliderRangeCurrentX = 0;
          MAX_BUBBLE = 'MAX_BUBBLE';
          MIN_BUBBLE = 'MIN_BUBBLE';
          currentDragBubble = false;
          startPosition = (scope.min - scope.minValue) * step;
          finishPosition = (scope.maxValue - scope.max) * step;
          maxPosition = Number.MAX_VALUE;
          minPosition = -Number.MAX_VALUE;
          rightBubblePosition = 0;
          leftBubblePosition = 0;
          scope.$watch(minElement, function() {
            bubbleSize = minElement.clientWidth;
            minElement.style.left = -bubbleErrorOffset + 'px';
            return rightBubblePosition = -bubbleErrorOffset;
          });
          scope.$watch(maxElement, function() {
            maxElement.style.right = -bubbleErrorOffset + 'px';
            return leftBubblePosition = -bubbleErrorOffset;
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
          maxElement.addEventListener('mousedown', function(event) {
            return dragBubble('right', maxElement, MAX_BUBBLE, event);
          });
          maxElement.addEventListener('touchstart', function(event) {
            return dragBubble('right', maxElement, MAX_BUBBLE, event);
          });
          minElement.addEventListener('mousedown', function(event) {
            return dragBubble('left', minElement, MIN_BUBBLE, event);
          });
          minElement.addEventListener('touchstart', function(event) {
            return dragBubble('left', minElement, MIN_BUBBLE, event);
          });
          document.addEventListener('mouseup', function() {
            return dropBubble();
          });
          document.addEventListener('touchend', function() {
            return dropBubble();
          });
          document.body.addEventListener('touchmove', function(event) {
            return moveBubble(event);
          });
          document.body.onmousemove = function(event) {
            return moveBubble(event);
          };
          window.addEventListener('resize', function() {
            return _initialize();
          });
          _initialize = function() {
            maxWidthRange = sliderContainer.clientWidth - (bubbleSize - bubbleErrorOffset) * 2;
            step = maxWidthRange / (scope.maxValue - scope.minValue - 1);
            sliderRange.style.left = Math.floor((scope.min - scope.minValue) * step) + 'px';
            return sliderRange.style.right = Math.floor((scope.maxValue - scope.max) * step) + 'px';
          };
          _initialize();
          dragBubble = function(type, element, currentBubble, event) {
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
            currentDragBubble = false;
            resetPosition();
            updateValues();
            return scope.$apply();
          };
          moveBubble = function(event) {
            if (event.changedTouches) {
              event = event.changedTouches[0];
            }
            if (currentDragBubble === MAX_BUBBLE) {
              calculatePosition(event, 'right', 'left', setSliderRightPosition);
            }
            if (currentDragBubble === MIN_BUBBLE) {
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
          return false;
        }
      };
    }
  ]);

}).call(this);
