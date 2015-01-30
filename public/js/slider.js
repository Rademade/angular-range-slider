window.app = angular.module('app', ['ngSlider']);

app.controller('mainCtrl', [
  '$scope', function($scope) {
    $scope.minimum = 33;
    $scope.maximum = 55;
    return $scope.$watch('minimum', function() {
      return console.log($scope.minimum);
    });
  }
]);

angular.module('ngSlider', []).directive('slider', [
  function() {
    return {
      restrict: 'A',
      scope: {
        minValue: '=',
        maxValue: '=',
        min: '=',
        max: '='
      },
      template: "<div class='slider'>" + "<div class='slider-container'>" + "<div class='slider-range'  id='slider-range'>" + "<div class='slider-btn min' id='slider-btn-min'>" + "<span class='slider-btn-val'>{{min}}</span>" + "</div>" + "<div class='slider-btn max'>" + "<span class='slider-btn-val'>{{max}}</span>" + "</div>" + "</div>" + "</div>" + "</div>",
      link: function(scope) {
        var MAX_BUBBLE, MIN_BUBBLE, calculatePosition, checkBubblesCollision, checkOutOfTheRange, currentDragBubble, dragBubble, dropBubble, finishPosition, getPixelsOfSliderRangeProperty, initMaxValue, initMinValue, isStartOfStep, maxElement, maxPosition, maxWidthRange, minElement, minPosition, moveBubble, resetPosition, setAllValues, setMaxPosition, setMaxValue, setMinPosition, setMinValue, setSliderLeftPosition, setSliderRightPosition, sliderContainer, sliderRange, sliderRangeCurrentX, startPosition, step, _initialize;
        minElement = document.getElementById('slider-btn-min');
        maxElement = document.getElementsByClassName('slider-btn max')[0];
        sliderContainer = document.getElementsByClassName('slider-container')[0];
        sliderRange = document.getElementById('slider-range');
        maxWidthRange = sliderContainer.clientWidth;
        step = 0;
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
        scope.$watch(minElement, function() {
          return minElement.style.left = -minElement.offsetWidth + 'px';
        });
        scope.$watch(maxElement, function() {
          return maxElement.style.right = -maxElement.offsetWidth + 'px';
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
          step = maxWidthRange / (scope.maxValue - scope.minValue);
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
          return resetPosition();
        };
        moveBubble = function(event) {
          if (event.changedTouches) {
            event = event.changedTouches[0];
          }
          console.log(currentDragBubble);
          if (currentDragBubble === MAX_BUBBLE) {
            calculatePosition(event, 'right', 'left', setMaxValue, setMaxPosition, setMinPosition);
          }
          if (currentDragBubble === MIN_BUBBLE) {
            return calculatePosition(event, 'left', 'right', setMinValue, setMinPosition, setMaxPosition);
          }
        };
        calculatePosition = function(event, myPosition, siblingPosition, setValue, setLeftPosition, setRightPosition) {
          finishPosition = Math.floor(event.clientX);
          if ((minPosition < finishPosition && finishPosition < maxPosition)) {
            setValue();
            scope.$apply();
          }
          if (getPixelsOfSliderRangeProperty(myPosition) < 0) {
            sliderRange.style[myPosition] = '0px';
            setLeftPosition(event);
          }
          if (checkBubblesCollision()) {
            setRightPosition(event);
            sliderRange.style[myPosition] = (maxWidthRange - getPixelsOfSliderRangeProperty(siblingPosition)) + 'px';
          }
          return setAllValues();
        };
        setMinPosition = function(event) {
          return minPosition = Math.floor(event.clientX);
        };
        setMaxPosition = function(event) {
          return maxPosition = Math.floor(event.clientX);
        };
        setMaxValue = function() {
          return setSliderRightPosition();
        };
        setMinValue = function() {
          return setSliderLeftPosition();
        };
        setAllValues = function() {
          if (getPixelsOfSliderRangeProperty('right') > -1) {
            scope.max = initMaxValue - Math.floor(getPixelsOfSliderRangeProperty('right') / step);
          }
          if (scope.max <= scope.min) {
            scope.max = scope.min + 1;
          }
          if (getPixelsOfSliderRangeProperty('left') > -1) {
            scope.min = initMinValue + Math.floor(getPixelsOfSliderRangeProperty('left') / step);
          }
          if (scope.max <= scope.min) {
            return scope.min = scope.max - 1;
          }
        };
        setSliderRightPosition = function() {
          if (isStartOfStep()) {
            return sliderRange.style.right = sliderRangeCurrentX - (finishPosition - startPosition) + 'px';
          }
        };
        setSliderLeftPosition = function() {
          var left;
          if (isStartOfStep()) {
            left = Math.min(sliderRangeCurrentX - (startPosition - finishPosition), maxWidthRange - getPixelsOfSliderRangeProperty('right'));
            return sliderRange.style.left = left + 'px';
          }
        };
        checkBubblesCollision = function() {
          return checkOutOfTheRange() && (finishPosition < maxPosition);
        };
        checkOutOfTheRange = function() {
          var sliderRangeWidth;
          sliderRangeWidth = sliderRange.clientWidth;
          if (sliderRangeWidth < 0) {
            sliderRangeWidth = 0;
          }
          return maxWidthRange < (1 * getPixelsOfSliderRangeProperty('left') + 1 * getPixelsOfSliderRangeProperty('right') + sliderRangeWidth) - step / 2;
        };
        getPixelsOfSliderRangeProperty = function(property) {
          return sliderRange.style[property].slice(0, -2);
        };
        resetPosition = function() {
          maxPosition = Number.MAX_VALUE;
          return minPosition = -Number.MAX_VALUE;
        };
        isStartOfStep = function() {
          console.log(sliderRangeCurrentX - (finishPosition - startPosition) % Math.floor(step));
          return ((sliderRangeCurrentX - (finishPosition - startPosition)) % Math.floor(step)) === 0;
        };
        return false;
      }
    };
  }
]);
