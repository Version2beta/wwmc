angular.module('wwmc', ['ngRoute', 'ui.bootstrap']).config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider.when '/',
    templateUrl: 'views/home.html'

  $routeProvider.otherwise redirectTo: '/'
  $locationProvider.html5Mode true
]

angular.module('wwmc').directive 'scrollWithPage', ($document) ->
  (scope, el, attrs) ->
    jqDoc = $($document)

    $document.on 'scroll touchmove', (e) ->
      el.css
        transform: "translateX(#{-jqDoc.scrollLeft()}px)"

# Touch events
# handle tap events
angular.module('wwmc').directive 'onTap', ->
  (scope, element, attrs) ->
    Hammer(element[0], {
      prevent_default: true
    })
    .on "tap", (ev) ->
      return scope.$apply attrs['onTap']
.directive 'onHold', ->
  (scope, element, attrs) ->
    Hammer(element[0], {
      prevent_default: false
      hold_timeout: 0
    })
    .on "hold", (ev) ->
      return scope.$apply attrs['onHold']
