@controllers.controller('newEventModalCtrl', [
  '$scope'
  '$rootScope'
  '$modalInstance'
  '$log'
  '$http'
  'Restangular'

  ($scope, $rootScope, $modalInstance, $log, $http, Restangular) ->

    $scope.data  = {}
    $scope.event = {
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
    $scope.bands = []

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
        $scope.bands.push band
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
        for error in result.data.full_messages
          $scope.alerts.push({type: 'danger', msg: error});
      )

    # Remove venue
    # @todo rename to cancelVenue
    $scope.removeVenue = () ->
      $scope.event.venue_id   = null
      $scope.event.newTBACity = null
      $scope.event.setCity    = false
      $scope.data.venueSearch = null
      $scope.newVenue.active  = false

    # Cancel anything related to band creation / search.
    # Basically reset everything to initial state.
    $scope.cancelBand = () ->
      $scope.data.bandSearch = null

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

    # Cancel modal
    $scope.cancel = () ->
      $modalInstance.dismiss('cancel')

])