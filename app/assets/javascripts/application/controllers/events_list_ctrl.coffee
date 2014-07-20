@controllers.controller('EventsListCtrl', [
  '$scope'
  '$rootScope'
  'Restangular'

  ($scope, $rootScope, Restangular) ->

    $scope.isExpanded   = false
    $scope.event        = false
    $scope.isSaved      = false

    loadEvent = () ->

      Restangular.one('events', $scope.eventId).get($scope.eventId).then (data) ->
        $scope.event = data
        return true

    $scope.toggleExpand = ($event) ->
      console.log $event.target
      return false if $($event.target).is('.no-expand')

      # Event should be loaded just one time
      if $scope.event is false
        if loadEvent()
          $scope.isExpanded = !$scope.isExpanded
      else
        $scope.isExpanded = !$scope.isExpanded

    $scope.toggleIsSaved = () ->
      Restangular.one('events', $scope.eventId).post('toggle_save', $scope.eventId).then (data) ->
        $scope.isSaved = data.is_saved
        return true

])