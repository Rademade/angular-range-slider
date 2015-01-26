window.app = angular.module('app', ['ngSlider', 'ngTouch']);

app.controller('mainCtrl', [
  '$scope', function($scope) {
    $scope.minimum = 14;
    $scope.maximum = 65;
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
        maxValue: '='
      },
      template: "<div class='slider'>" + "<div class='slider-container'>" + "<div class='slider-range'  id='slider-range'>" + "<div class='slider-btn min' id='slider-btn-min'>" + "<span class='slider-btn-val'>{{minValue}}</span>" + "</div>" + "<div class='slider-btn max'>" + "<span class='slider-btn-val'>{{maxValue}}</span>" + "</div>" + "</div>" + "</div>" + "</div>",
      link: function(scope) {
        var calculatePosition, checkBubblesCollision, checkOutOfTheRange, dragMaxBubble, dragMinBubble, dropBubble, finishPosition, getPixelsOfSliderRangeProperty, initMaxValue, initMinValue, maxElement, maxPosition, maxWidthRange, minElement, minPosition, moveBubble, onDragEventMIN, onDropEventMAX, resetPosition, setMaxPosition, setMaxValue, setMinPosition, setMinValue, setSliderLeftPosition, setSliderRightPosition, sliderContainer, sliderRange, sliderRangeCurrentX, startPosition, step;
        minElement = document.getElementById('slider-btn-min');
        maxElement = document.getElementsByClassName('slider-btn max')[0];
        sliderContainer = document.getElementsByClassName('slider-container')[0];
        sliderRange = document.getElementById('slider-range');
        maxWidthRange = sliderContainer.clientWidth;
        scope.$watch(minElement, function() {
          return minElement.style.left = -minElement.offsetWidth;
        });
        scope.$watch(maxElement, function() {
          return maxElement.style.right = -maxElement.offsetWidth;
        });
        sliderRange.style.left = 0;
        sliderRange.style.right = 0;
        step = sliderRange.clientWidth / (scope.maxValue - scope.minValue);
        initMaxValue = scope.maxValue;
        initMinValue = scope.minValue;
        sliderRangeCurrentX = 0;
        onDragEventMIN = false;
        onDropEventMAX = false;
        startPosition = 0;
        finishPosition = 0;
        maxPosition = Number.MAX_VALUE;
        minPosition = -Number.MAX_VALUE;
        resetPosition = function() {
          maxPosition = Number.MAX_VALUE;
          return minPosition = -Number.MAX_VALUE;
        };
        maxElement.addEventListener('mousedown', function(event) {
          return dragMinBubble(event);
        });
        maxElement.addEventListener('touchstart', function(event) {
          return dragMinBubble(event);
        });
        minElement.addEventListener('mousedown', function(event) {
          return dragMaxBubble(event);
        });
        minElement.addEventListener('touchstart', function(event) {
          return dragMaxBubble(event);
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
        dragMinBubble = function(event) {
          if (event.changedTouches) {
            event = event.changedTouches[0];
          }
          resetPosition();
          if (maxElement.style.right) {
            sliderRangeCurrentX = getPixelsOfSliderRangeProperty('right');
          }
          onDropEventMAX = true;
          return startPosition = Math.floor(event.clientX);
        };
        dragMaxBubble = function(event) {
          if (event.changedTouches) {
            event = event.changedTouches[0];
          }
          resetPosition();
          if (minElement.style.left) {
            sliderRangeCurrentX = getPixelsOfSliderRangeProperty('left');
          }
          onDragEventMIN = true;
          return startPosition = Math.floor(event.clientX);
        };
        dropBubble = function() {
          onDropEventMAX = false;
          return onDragEventMIN = false;
        };
        moveBubble = function(event) {
          if (event.changedTouches) {
            event = event.changedTouches[0];
          }
          if (onDropEventMAX) {
            calculatePosition(event, 'right', 'left', setMaxValue, setMaxPosition, setMinPosition);
          }
          if (onDragEventMIN) {
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
            return sliderRange.style[myPosition] = maxWidthRange - getPixelsOfSliderRangeProperty(siblingPosition);
          }
        };
        setMinPosition = function(event) {
          return minPosition = Math.floor(event.clientX);
        };
        setMaxPosition = function(event) {
          return maxPosition = Math.floor(event.clientX);
        };
        setMaxValue = function() {
          setSliderRightPosition();
          if (Math.floor(getPixelsOfSliderRangeProperty('right') > 0)) {
            scope.maxValue = initMaxValue - Math.floor(getPixelsOfSliderRangeProperty('right') / step);
          }
          if (scope.maxValue <= scope.minValue) {
            return scope.maxValue = scope.minValue + 1;
          }
        };
        setMinValue = function() {
          setSliderLeftPosition();
          if (getPixelsOfSliderRangeProperty('left') > 0) {
            scope.minValue = initMinValue + Math.floor(getPixelsOfSliderRangeProperty('left') / step);
          }
          if (scope.maxValue <= scope.minValue) {
            return scope.minValue = scope.maxValue - 1;
          }
        };
        setSliderRightPosition = function() {
          return sliderRange.style.right = sliderRangeCurrentX - (finishPosition - startPosition);
        };
        setSliderLeftPosition = function() {
          return sliderRange.style.left = sliderRangeCurrentX - (startPosition - finishPosition);
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
          return maxWidthRange < (1 * getPixelsOfSliderRangeProperty('left') + 1 * getPixelsOfSliderRangeProperty('right') + sliderRangeWidth);
        };
        getPixelsOfSliderRangeProperty = function(property) {
          return sliderRange.style[property].slice(0, -2);
        };
        return false;
      }
    };
  }
]);
