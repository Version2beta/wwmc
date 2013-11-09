
angular.module('wwmc', ['ui.router']).config [
  '$stateProvider',
  '$urlRouterProvider',
  '$locationProvider',
  ($stateProvider, $urlRouterProvider, $locationProvider) ->
    $stateProvider.state('skills', {
      url: '/skills'
      templateUrl: 'views/home.html'
      controller: HomeCtrl
    }).state('skills.slider', {
      url: '/:id'
      templateUrl: '/views/slider.html'
      controller: ($scope, $http, $stateParams) ->
        $http.get('/skills/' + $stateParams.id).then (data) ->
          $scope.skill = data.data[0]
          $scope.skill.id = $scope.skill._id
    }).state('welcome', {
      url: '/welcome'
      templateUrl: 'views/welcome.html'
    })

    $urlRouterProvider.otherwise 'skills'
    $locationProvider.html5Mode true
]
