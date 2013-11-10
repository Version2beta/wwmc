isDebug = -> false

fixupSkills = (skills) ->
  skills.forEach (s) ->
    s.id = s._id
  skills

angular.module('wwmc', ['ui.router']).config [
  '$stateProvider',
  '$urlRouterProvider',
  ($stateProvider, $urlRouterProvider, $locationProvider) ->
    $stateProvider.state('skills', {
      url: '/skills'
      templateUrl: 'views/home.html'
      controller: HomeCtrl
    })

    $urlRouterProvider.otherwise 'skills'
]

angular.module('wwmc').directive 'scrollWithPage', ($document) ->
  (scope, el, attrs) ->
    jqDoc = $($document)

    $document.on 'scroll touchmove', (e) ->
      el.css
        transform: "translateX(#{-jqDoc.scrollLeft()}px)"
