window.HomeCtrl = ($scope, $modal) ->
  $scope.skills = [
    {
      _id: "23",
      title: "Eye hand movement",
      description: "Eye–hand movements better coordinated; can put objects together, take them apart; fit large pegs into pegboard.",
      developmentalAge: 24,
      developmentalAgeRange: 12,
      dependencies: [
      ],
      category: "cognitive"
    }
  ]

  $scope.open = (datas) ->
    modalInstance = $modal.open {
      templateUrl: 'views/modal.html'
      controller: ModalCtrl
      resolve: {
        data: -> return datas
      }
    }

    modalInstance.result.then((item) ->
      # TODO: update scope if it is edited or something?
      console.log 'item is', item
    , ->
      console.log 'Modal dismissed at: ' + new Date()
    )
