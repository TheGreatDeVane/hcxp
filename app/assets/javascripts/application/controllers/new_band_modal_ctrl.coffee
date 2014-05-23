@controllers.controller('newBandModalCtrl', [
  '$scope'
  '$modalInstance'
  '$timeout'
  'Restangular'

  ($scope, $modalInstance, $timeout, Restangular) ->

    $scope.band = {
      name:     ''
      location: ''
    }

    $scope.alerts = []

    $scope.closeAlert = (index) ->
      $scope.alerts.splice(index, 1)

    $scope.save = (details) ->
      Restangular.one('bands').customPOST($scope.band).then((result) ->
        $scope.band.id = result.id
        $modalInstance.close($scope.band)

      , (result) ->
        for error in result.data.full_messages
          $scope.alerts.push({type: 'danger', msg: error});
      )

    $scope.cancel = () ->
      $modalInstance.dismiss('cancel')

])