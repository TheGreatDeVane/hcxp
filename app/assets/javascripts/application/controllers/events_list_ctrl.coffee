@controllers.controller('EventsListCtrl', [
  '$scope'
  '$rootScope'
  'Restangular'

  ($scope, $rootScope, Restangular) ->

    $scope.isExpanded = false
    $scope.event      = false

    loadEvent = () ->

      Restangular.one('events', $scope.eventId).get($scope.eventId).then (data) ->
        $scope.event = data
        return true

    $scope.toggleExpand = ($event) ->

      return false if $($event.target).is('a')

      # Event should be loaded just one time
      if $scope.event is false

        if loadEvent()
          $scope.isExpanded = !$scope.isExpanded

      else
        $scope.isExpanded = !$scope.isExpanded

])