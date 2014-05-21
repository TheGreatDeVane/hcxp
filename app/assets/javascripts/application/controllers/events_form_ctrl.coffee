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
      band_ids:    []
      venue_id:    ''
      bands:       []
    }


    # Open venue picker modal
    $scope.setVenue = () ->
      modalInstance = $modal.open
        templateUrl: 'events/set_venue_modal.html'
        controller:  'setVenueModalCtrl'

      modalInstance.result.then (selectedVenueId) ->
        # If venue has been picked from the list
        $scope.event.venue_id = selectedVenueId



    # Open band picker modal
    $scope.addBand = () ->
      modalInstance = $modal.open
        templateUrl: 'events/add_band_modal.html'
        controller: 'addBandModalCtrl'

      modalInstance.result.then (band) ->
        # If band has been picked from the list
        $scope.event.bands.push band

    $scope.removeBand = (index) ->
      $scope.event.bands.splice(index, 1)


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


    $scope.reloadBands = () ->
      Restangular.one('bands').customGET(null, { 'id_in[]': $scope.event.band_ids }).then (bands) ->
        $scope.event.bands = bands


    # Watch bands change. If it occurs, regenerate band_ids array
    $scope.$watchCollection 'event.bands', (bands, oldBands) ->
      return if bands is oldBands

      band_ids = []

      for band in bands
        band_ids.push band.id

      return if $scope.event.band_ids is band_ids

      $scope.event.band_ids = band_ids

      # console.log _.difference(bandIds, oldBandIds)

      # Restangular.one('bands').customGET(null, { 'id_in[]': bandIds }).then (bands) ->
      #   $scope.event.bands = bands
])