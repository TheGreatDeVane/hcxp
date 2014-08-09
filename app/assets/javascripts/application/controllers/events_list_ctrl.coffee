@controllers.controller('EventsListCtrl', [
  '$scope'
  '$rootScope'
  '$modal'
  'Restangular'

  ($scope, $rootScope, $modal, Restangular) ->

    $scope.isExpanded   = false
    $scope.event        = false
    $scope.isSaved      = false
    $scope.isPromoted   = false

    loadEvent = () ->
      Restangular.one('events', $scope.eventId).get($scope.eventId).then (data) ->
        $scope.event = data
        return true

    $scope.edit = () ->
      modalInstance = $modal.open
        templateUrl: 'events/new_event_modal.html'
        controller:  'newEventModalCtrl'
        resolve: {
          mode: () ->
            return 'edit'

          eventId: () ->
            return $scope.eventId
        }

      modalInstance.result.then (event) ->
        console.log 'ok'

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
        $rootScope.$broadcast 'savesChanged', {
          id:   $scope.eventId
          type: if data.is_saved is true then 'saved' else 'unsaved'
        }
        return true

    $scope.toggleIsPromoted = () ->
      Restangular.one('events', $scope.eventId).post('toggle_promote', $scope.eventId).then (data) ->
        $scope.isPromoted = data.is_promoted
        return true

])