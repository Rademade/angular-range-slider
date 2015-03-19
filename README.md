# angular-range-slider

### Template example

```slim
      div.slider-wrapper(slider='', min-value='20', max-value='65', min-out='minimum', max-out='maximum', style='width:400px;', jumping='true')
```

### Controller example

```coffee
app = angular.module('app', ['ngSlider'])
 app.controller 'mainCtrl', ['$scope', ($scope)->
   $scope.minimum = 33
   $scope.maximum = 55
   $scope.$watch 'minimum', -> console.log $scope.minimum
]
```