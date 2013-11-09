window.HomeCtrl = function($scope, $modal) {
  $scope.skills = [
    {
      _id: "23",
      title: "Eye hand movement",
      description: "Eye–hand movements better coordinated; can put objects together, take them apart; fit large pegs into pegboard.",
      developmentalAge: 24,
      developmentalAgeRange: 12,
      dependencies: [],
      category: "cognitive"
    }
  ];
  return $scope.open = function(datas) {
    var modalInstance;
    return modalInstance = $modal.open({
      templateUrl: 'views/modal.html',
      controller: ModalCtrl,
      resolve: {
        data: function() {
          return datas;
        }
      }
    });
  };
};
