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
    $scope.isBusy       = false


    # Loads events from the API
    #
    $scope.loadEvents = () ->
      $scope.eventsPromise = Restangular.one('events').get(EventListService.filterQueryObject()).then (response) ->
        $scope.events = response.data

        $scope.nextPageLink   = EventListService.getPaginationLinks(response, 'next')
        $scope.hasMoreResults = EventListService.hasMoreResults(response)

        regroupEvents()

        return


    # Watch for eventLocationsChanged event and reload
    # events list if it occurs.
    $rootScope.$on('eventListFiltersChanged', (e, data) ->
      $scope.loadEvents()
    )


    # Watch for eventUpdated event and if it occurs,
    # refresh updated event on the list
    #
    $rootScope.$on('eventUpdated', (e, data) ->
      _.each($scope.events, (event) ->
        if event.id is data.id
          event = _.extend(event, _.pick(data,
            'title'
            'description'
            'excerpt'
            'venue'
            'bands'
            'beginning_at'
            'beginning_at_time'
            'price'
          ))
          regroupEvents()
      )
    )


    # Regroups events to days
    #
    regroupEvents = () ->
       $scope.groupedByDay = _.groupBy $scope.events, (item) ->
          item.beginning_at.substring(0, 10)


    # Loads more events
    #
    $scope.loadMore = () ->
      return false if $scope.isBusy

      if $scope.hasMoreResults
        console.log EventListService.filterQueryObject()
        $scope.isBusy = true
        console.log 'Loading more...'

        Restangular.allUrl('events', $scope.nextPageLink).getList().then (response) ->
          $scope.nextPageLink   = EventListService.getPaginationLinks(response, 'next')
          $scope.hasMoreResults = EventListService.hasMoreResults(response)

          $scope.events = $scope.events.concat response.data
          regroupEvents()

          $scope.isBusy = false

      else
        $scope.isBusy = false


    # Checks if event is from the past or not
    #
    $scope.isPast = (event) ->
      moment(Date.now()).diff(event.beginning_at, 'days') > 0


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
      Restangular.one('events', event.id).post('toggle_save', event.id).then (result) ->
        event.is_saved = result.data.is_saved

        $rootScope.$broadcast 'savesChanged', {
          id:   $scope.eventId
          type: if result.data.is_saved is true then 'saved' else 'unsaved'
        }
        return true

    $scope.toggleIsPromoted = () ->
      Restangular.one('events', $scope.eventId).post('toggle_promote', $scope.eventId).then (result) ->
        $scope.isPromoted = result.data.is_promoted
        return true

])