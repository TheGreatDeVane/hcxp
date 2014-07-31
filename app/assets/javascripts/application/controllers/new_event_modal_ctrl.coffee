@controllers.controller('newEventModalCtrl', [
  '$scope'
  '$rootScope',
  '$modalInstance'
  'Restangular'

  ($scope, $rootScope, $modalInstance, Restangular) ->

    $scope.cancel = () ->
      $modalInstance.dismiss('cancel')
])