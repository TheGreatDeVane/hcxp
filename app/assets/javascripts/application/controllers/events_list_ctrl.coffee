@controllers.controller('EventsListCtrl', [
  '$scope'
  '$rootScope'
  '$modal'
  'Restangular'
  'EventListService'

  ($scope, $rootScope, $modal, Restangular, EventListService) ->

    $scope.isExpanded   = false
    $scope.event        = false
    $scope.isSaved      = false
    $scope.isPromoted   = false
    $scope.events       = []

    $scope.loadEvents = () ->
      $scope.eventsPromise = Restangular.one('events').get(EventListService.filterQueryObject()).then (data) ->
        $scope.events = data

        $scope.groupedByDay = _.groupBy $scope.events, (item) ->
          item.beginning_at.substring(0, 10)

        return

    # Load all events on startup
    # $scope.loadEvents()

    # Watch for eventLocationsChanged event and reload
    # events list if it occurs.
    $rootScope.$on('eventListFiltersChanged', (e, data) ->
      $scope.loadEvents()
    )

    ###############################################################################
    ###############################################################################
    ###############################################################################

    $scope.edit = (event) ->
      modalInstance = $modal.open
        templateUrl: 'events/new_event_modal.html'
        controller:  'newEventModalCtrl'
        resolve: {
          mode: () ->
            return 'edit'

          eventId: () ->
            return event.id
        }

      modalInstance.result.then (event) ->
        console.log 'ok'

    $scope.toggleExpand = (event, $event) ->
      # Do not toggle-expand an event if user clicked an
      # element with .no-expand class.
      return false if $($event.target).is('.no-expand')

      # Event should be loaded just one time
      event.isExpanded = !event.isExpanded

    $scope.toggleIsSaved = (event) ->
      Restangular.one('events', event.id).post('toggle_save', event.id).then (data) ->
        event.is_saved = data.is_saved

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