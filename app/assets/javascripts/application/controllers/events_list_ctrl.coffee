@controllers.controller('EventsListCtrl', [
  '$scope'
  '$rootScope'
  '$modal'
  'Restangular'
  'Event'
  '$q'

  ($scope, $rootScope, $modal, Restangular, Event) ->

    $scope.isExpanded   = false
    $scope.event        = false
    $scope.isSaved      = false
    $scope.isPromoted   = false
    $scope.events       = []

    Event.query (data) ->
      $scope.events = data

      $scope.groupedByDay = _.groupBy $scope.events, (item) ->
        item.beginning_at.substring(0, 10)

      return

    ###############################################################################
    ###############################################################################
    ###############################################################################

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

    $scope.toggleExpand = (event, $event) ->
      return false if $($event.target).is('.no-expand')

      # Event should be loaded just one time
      event.isExpanded = !event.isExpanded

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