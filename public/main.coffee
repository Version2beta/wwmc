

angular.module('wwmc', ['ngRoute']).config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider.when '/',
    templateUrl: 'views/home.html'


  $routeProvider.otherwise redirectTo: '/'
  $locationProvider.html5Mode true
]
