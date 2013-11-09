angular.module('wwmc', ['ngRoute']).config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    $routeProvider.when('/', {
      templateUrl: 'views/home.html'
    });
    $routeProvider.otherwise({
      redirectTo: '/'
    });
    return $locationProvider.html5Mode(true);
  }
]);
