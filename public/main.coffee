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
      resolve: {
        skills: ($http) ->
          $http.get('/skills').then (data) ->
            fixupSkills data.data
      }
      controller: HomeCtrl
    }).state('skills.detail', {
      url: '/:id'
      templateUrl: '/views/skill_detail.html'
      controller: ($scope, $http, $stateParams) ->
        $http.get('/skills/' + $stateParams.id).then (data) ->
          $scope.skill = data.data[0]
          $scope.skill.id = $scope.skill._id
    }).state('welcome', {
      url: '/welcome'
      templateUrl: 'views/welcome.html'
    })

    $urlRouterProvider.otherwise 'skills'
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
