@controllers.controller('EventsFormCtrl', [
  '$scope'
  '$rootScope'
  '$timeout'
  '$modal'
  'Restangular'

  ($scope, $rootScope, $timeout, $modal, Restangular) ->
    $scope.event = {
      title:       ''
      description: ''
      band_list:   ''
      venue_id:    ''
    }

    # Open venue picker modal
    $scope.setVenue = () ->
      modalInstance = $modal.open
        templateUrl: 'setVenueModal.html'
        controller:  'setVenueModalCtrl'

      modalInstance.result.then (selectedVenueId) ->
        # If venue has been picked from the list
        $scope.event.venue_id = selectedVenueId


    timer = false
    $scope.$watch 'event', ((event, oldEvent) ->
      return if event is oldEvent
      $timeout.cancel timer if timer

      timer = $timeout(->
        $rootScope.$emit 'eventForm.changed', $scope.event
      , 1500)
    ), true

    # Watch venue_id change. If it occurs, reload it's
    # data from the api.
    $scope.$watchCollection 'event.venue_id', (venue_id) ->
      return if venue_id is ''

      Restangular.one('venues', venue_id).get().then (venue) ->
        $scope.venue = venue
])