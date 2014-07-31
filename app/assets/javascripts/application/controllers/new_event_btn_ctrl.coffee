@controllers.controller('newEventBtnCtrl', [
  '$scope'
  '$rootScope'
  '$modal'
  'Restangular'

  ($scope, $rootScope, $modal, Restangular) ->

    $scope.open = () ->
      modalInstance = $modal.open
        templateUrl: 'events/new_event_modal.html'
        controller:  'newEventModalCtrl'

      modalInstance.result.then (event) ->
        console.log 'ok'

])