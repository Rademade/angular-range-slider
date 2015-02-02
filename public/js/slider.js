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
        var MAX_BUBBLE, MIN_BUBBLE, calculatePosition, currentDragBubble, dragBubble, dropBubble, finishPosition, getPixelsOfSliderRangeProperty, initMaxValue, initMinValue, leftBubblePosition, maxElement, maxPosition, maxWidthRange, minElement, minPosition, moveBubble, resetPosition, rightBubblePosition, setSliderLeftPosition, setSliderRightPosition, sliderContainer, sliderRange, sliderRangeCurrentX, startPosition, step, updateValues, _initialize;
        minElement = document.getElementById('slider-btn-min');
        maxElement = document.getElementsByClassName('slider-btn max')[0];
        sliderContainer = document.getElementsByClassName('slider-container')[0];
        sliderRange = document.getElementById('slider-range');
        maxWidthRange = sliderContainer.clientWidth;
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
          minElement.style.left = -minElement.offsetWidth + 'px';
          return rightBubblePosition = -minElement.offsetWidth;
        });
        scope.$watch(maxElement, function() {
          maxElement.style.right = -maxElement.offsetWidth + 'px';
          return leftBubblePosition = -minElement.offsetWidth;
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
          maxWidthRange = sliderContainer.clientWidth;
          step = maxWidthRange / (scope.maxValue - scope.minValue - 1);
          sliderRange.style.left = Math.floor((scope.min - scope.minValue) * step) + 'px';
          return sliderRange.style.right = Math.floor((scope.maxValue - scope.max) * step) + 'px';
        };
        _initialize();
        dragBubble = function(type, element, currentBubble, event) {
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
          var lastMax;
          rightBubblePosition = sliderRangeCurrentX - (finishPosition - startPosition);
          lastMax = scope.max;
          if (rightBubblePosition > -1) {
            scope.max = initMaxValue - Math.floor(rightBubblePosition / step);
          }
          if (scope.max <= scope.min) {
            scope.max = scope.min + 1;
          }
          if (scope.max >= scope.maxValue) {
            scope.max = scope.maxValue;
          }
          if (scope.jumping) {
            if (scope.max !== lastMax && scope.max > scope.min && scope.max <= scope.maxValue) {
              return sliderRange.style.right = (initMaxValue - scope.max) * step + 'px';
            }
          } else {
            if (scope.max > scope.min && scope.max <= scope.maxValue && rightBubblePosition / step > 0) {
              return sliderRange.style.right = rightBubblePosition + 'px';
            }
          }
        };
        setSliderLeftPosition = function() {
          var lastMin, left;
          leftBubblePosition = sliderRangeCurrentX - (startPosition - finishPosition);
          lastMin = scope.min;
          if (leftBubblePosition > -1) {
            scope.min = initMinValue + Math.floor(leftBubblePosition / step);
          }
          if (scope.max <= scope.min) {
            scope.min = scope.max - 1;
          }
          if (scope.min <= scope.minValue) {
            scope.min = scope.minValue;
          }
          if (scope.jumping) {
            if (scope.min !== lastMin && scope.min >= scope.minValue && scope.min < scope.max) {
              return sliderRange.style.left = (scope.min - initMinValue) * step + 'px';
            }
          } else {
            if (scope.min < scope.max && scope.min >= scope.minValue && leftBubblePosition / step > 0) {
              left = Math.min(sliderRangeCurrentX - (startPosition - finishPosition), maxWidthRange - getPixelsOfSliderRangeProperty('right'));
              return sliderRange.style.left = left + 'px';
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
