@controllers.controller('newEventModalCtrl', [
  '$scope'
  '$rootScope'
  '$modalInstance'
  '$log'
  '$http'
  'Restangular'

  ($scope, $rootScope, $modalInstance, $log, $http, Restangular) ->

    $scope.alerts = []
    $scope.data   = {}
    $scope.event  = {
      tbaVenueSelected: false
      bands: []
    }
    $scope.newVenue = {
      # Determines if new venue form is displayed
      # or not.
      active:  false,
      name:    null,
      address: null
    }
    $scope.eventBands = []
    $scope.newBand = {
      active:   false,
      name:     null,
      location: null
    }

    # When user picked anything in select venue
    # search field.
    $scope.$watch 'data.venueSearch', (venue) ->
      return if (venue is null) || !venue?

      if venue.id is 'new'
        $scope.newVenue.active = true
        $scope.newVenue.name   = venue.name
      else
        $scope.event.venue_id = venue.id

    # When user picked anything in select band
    # search field.
    $scope.$watch 'data.bandSearch', (band) ->
      return if (band is null) || !band?

      if band.id is 'new'
        $scope.newBand.active = true
        $scope.newBand.name   = band.name
      else
        $scope.eventBands.push _.extend band,
          index:   Math.round(new Date().getTime() / 1000)
          id:      null,
          band_id: band.id
        $scope.cancelBand()

    # When user picks anything in TBA city text field,
    # save the picked city as new TBA venue for event.
    $scope.$watch 'data.TBAVenueDetails', (val) ->
      return if (val is null) || !val?
      $scope.saveTBAVenue($scope.data.TBAVenueDetails)


    # Watch venue_id change. If it occurs, reload it's
    # data from the api.
    $scope.$watch 'event.venue_id', (venue_id) ->
      return if venue_id is ''

      Restangular.one('venues', venue_id).get().then (venue) ->
        $scope.venue = venue

    $scope.saveTBAVenue = (details) ->
      # What the hell is that?
      # return unless $scope.event.tbaVenueSelected
      venue = {
        city:         details.address_components[0].short_name
        country_code: details.address_components[4].short_name
      }

      Restangular.one('venues').one('tba').customPOST({venue: venue}).then (result) ->
        $scope.event.venue_id   = result.id
        $scope.editingTBA       = false

    # Create venue
    $scope.createVenue = () ->
      Restangular.one('venues').customPOST({venue: $scope.newVenue}).then((result) ->
        $scope.newVenue.active = false
        $scope.event.venue_id  = result.id

      , (result) ->
        $scope.resetAlerts()

        for error in result.data.venue.full_messages
          $scope.alerts.push({type: 'danger', msg: error});
      )

    # Create band
    $scope.createBand = () ->
      Restangular.one('bands').customPOST({band: $scope.newBand}).then((result) ->
        $scope.eventBands.push _.extend result,
          index: Math.round(new Date().getTime() / 1000)
        $scope.cancelBand()

      , (result) ->
        $scope.resetAlerts()

        for error in result.data.band.full_messages
          $scope.alerts.push({type: 'danger', msg: error});
      )

    # Remove venue
    # @todo rename to cancelVenue
    $scope.removeVenue = () ->
      $scope.resetAlerts()
      $scope.event.venue_id   = null
      $scope.event.newTBACity = null
      $scope.event.setCity    = false
      $scope.data.venueSearch = null
      $scope.newVenue.active  = false

    # Cancel anything related to band creation / search.
    # Basically reset everything to initial state.
    $scope.cancelBand = () ->
      $scope.resetAlerts()
      $scope.data.bandSearch  = null
      $scope.newBand.active   = false
      $scope.newBand.name     = null
      $scope.newBand.location = null
      $scope.newBand.locationDetails = null
      $scope.data.bandSearch  = null

    ##
    # Select2 shit

    venueFormatResult = (venue) ->
      markup  = '<strong>'
      markup += '<i>' if venue.id is 'new'
      markup += venue.name
      markup += ' (new)</i>' if venue.id is 'new'
      markup += '</strong><br/>'
      markup += '<small class="text-muted">' + venue.address + '</small>'
      markup

    bandFormatResult = (band) ->
      markup  = '<strong>'
      markup += '<i>' if band.id is 'new'
      markup += band.name
      markup += ' (new)</i>' if band.id is 'new'
      markup += '</strong><br/>'
      markup += '<small class="text-muted">' + band.location + '</small>'
      markup

    # Band Select2 options
    $scope.bandSearchOptions = {
      minimumInputLength: 1
      formatResult: bandFormatResult
      formatSelection: (band) ->
        band.name

      createSearchChoice: (term) ->
        return { id: 'new', name: term, location: 'Create a new Band' }

      createSearchChoicePosition: 'bottom'

      ajax:
        quietMillis: 500

        data: (term, page) ->
          query: term

        transport: (queryParams, page) ->
          # I was trying to use restangular here but it was not working
          # Sounds like i need to ask for that on stack overflow
          $http.get("/api/v1/bands?query=" + queryParams.data.query).then(queryParams.success)

        results: (data, page) ->
          results: data.data.bands
    }

    # Venue Select2 options
    $scope.venueSearchOptions = {
      minimumInputLength: 3
      formatResult: venueFormatResult
      formatSelection: (venue) ->
        venue.name

      createSearchChoice: (term) ->
        return { id: 'new', name: term, address: 'Create a new Venue' }

      createSearchChoicePosition: 'bottom'

      ajax:
        quietMillis: 500

        data: (term, page) ->
          query: term

        transport: (queryParams, page) ->
          # I was trying to use restangular here but it was not working
          # Sounds like i need to ask for that on stack overflow
          $http.get("/api/v1/venues?query=" + queryParams.data.query).then(queryParams.success)

        results: (data, page) ->
          results: data.data.venues
    }

    $scope.openBeginningAt = (event) ->
      event.stopPropagation()
      $scope.event.beginningAtOpened = !$scope.event.beginningAtOpened

    # Saves event
    $scope.save = () ->
      $scope.resetAlerts()

      formattedEventObject = _.pick $scope.event,
        'beginning_at'
        'beginning_at_time'
        'description'
        'price'
        'title'
        'venue_id'

      # Transform bands array to rails-friendly object
      formattedEventObject.event_bands_attributes = _.map $scope.eventBands, (num, key) ->
        _.pick num,
          '_destroy'
          'description'
          'id'
          'band_id'

      Restangular.one('events').customPOST({event: formattedEventObject}).then((result) ->
        alert('Event saved')
        $modalInstance.close(result)

      , (result) ->
        for message in result.data.event.full_messages
          $scope.alerts.push {
            msg:  message,
            type: 'danger'
          }

      )

    # Reset alerts
    $scope.resetAlerts = () ->
      $scope.alerts = []

    # Close alert
    $scope.closeAlert = (index) ->
      $scope.alerts.splice(index, 1);

    # Cancel modal
    $scope.cancel = () ->
      $modalInstance.dismiss('cancel')

])