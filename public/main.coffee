angular.module('wwmc', ['ngRoute', 'ui.bootstrap']).config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider.when '/',
    templateUrl: 'views/home.html'

  $routeProvider.otherwise redirectTo: '/'
  $locationProvider.html5Mode true
]


angular.module('wwmc').directive 'scrollWithPage', ($document) ->
  (scope, el, attrs) ->
    jqDoc = $($document)

    $document.on 'scroll', (e) ->
      el.css
        transform: "translateX(#{-jqDoc.scrollLeft()}px)"
