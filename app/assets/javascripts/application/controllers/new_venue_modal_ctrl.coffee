@controllers.controller('newVenueModalCtrl', [
  '$scope'
  '$modalInstance'
  '$timeout'
  'Restangular'

  ($scope, $modalInstance, $timeout, Restangular) ->

    $scope.venue = {
      name:    ''
      address: ''
    }

    $scope.alerts = []

    $scope.closeAlert = (index) ->
      $scope.alerts.splice(index, 1)

    $scope.save = (details) ->
      Restangular.one('venues').customPOST($scope.venue).then((result) ->
        $modalInstance.close(result.id)

      , (result) ->
        for error in result.data.full_messages
          $scope.alerts.push({type: 'danger', msg: error});
      )

    $scope.cancel = () ->
      $modalInstance.dismiss('cancel')

])