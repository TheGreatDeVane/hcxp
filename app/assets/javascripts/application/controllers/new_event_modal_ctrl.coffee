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
    }
    $scope.newVenue = {
      active:  false,
      name:    null,
      address: null
    }

    $scope.$watch 'data.venueSearch', (venue) ->
      return if venue is ''

      if venue.id is 'new'
        $scope.newVenue.active = true
        $scope.newVenue.name   = venue.name
      else
        $scope.event.venue_id = venue.id

    $scope.$watch 'data.TBAVenueDetails', (val) ->
      return if val is ''
      $scope.saveTBAVenue($scope.data.TBAVenueDetails)


    # Watch venue_id change. If it occurs, reload it's
    # data from the api.
    $scope.$watch 'event.venue_id', (venue_id) ->
      return if venue_id is ''

      Restangular.one('venues', venue_id).get().then (venue) ->
        $scope.venue = venue

    $scope.cancel = () ->
      $modalInstance.dismiss('cancel')

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
        console.log result
        $scope.newVenue.active = false
        $scope.event.venue_id  = result.id

      , (result) ->
        for error in result.data.full_messages
          $scope.alerts.push({type: 'danger', msg: error});
      )

    # Remove venue
    $scope.removeVenue = () ->
      $scope.event.venue_id   = null
      $scope.event.newTBACity = null
      $scope.event.setCity    = false
      $scope.data.venueSearch = null

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
          console.log queryParams.data
          $http.get("/api/v1/venues?query=" + queryParams.data.query).then(queryParams.success)

        results: (data, page) ->
          results: data.data.venues
    }

    # Cancel modal
    $scope.cancel = () ->
      $modalInstance.dismiss('cancel')

])