@controllers.controller('EventsShowCtrl', [
  '$scope'
  '$rootScope'
  'Restangular'

  ($scope, $rootScope, Restangular) ->
    $scope.descriptionExpanded = false

    $scope.togglePromote = () ->
      Restangular.one('events', $scope.event.id).one('promote').put().then (event) ->
        console.log event
        $scope.event.isPromoted = event.is_promoted
])