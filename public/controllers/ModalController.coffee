window.ModalCtrl = ($scope, $modalInstance, data) ->
  $scope.data = data

  $scope.ok = ->
    $modalInstance.close $scope.data

  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'
