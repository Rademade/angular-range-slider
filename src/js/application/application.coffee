app = angular.module('app', ['ngSlider'])
app.controller 'mainCtrl', ['$scope', ($scope)->
  $scope.minimum = 33
  $scope.maximum = 55
  $scope.$watch 'minimum', -> console.log $scope.minimum

]