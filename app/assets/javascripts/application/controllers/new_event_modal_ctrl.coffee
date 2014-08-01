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

    $scope.$watch 'data.venueSearch', (venue) ->
      return if venue is ''
      $scope.event.venue_id = venue.id

    $scope.$watch 'data.TBAVenueDetails', (val) ->
      return if val is ''
      $scope.saveTBAVenue($scope.data.TBAVenueDetails)


    # Watch venue_id change. If it occurs, reload it's
    # data from the api.
    $scope.$watchCollection 'event.venue_id', (venue_id) ->
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

    ##
    # Select2 shit

    venueFormatResult = (venue) ->
      markup  = '<strong>' + venue.name + '</strong><br/>'
      markup += '<small class="text-muted">' + venue.address + '</small>'
      markup

    # Venue Select2 options
    $scope.venueSearchOptions = {
      minimumInputLength: 3
      formatResult: venueFormatResult
      formatSelection: (venue) ->
        venue.name

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

    # Remove venue
    $scope.removeVenue = () ->
      $scope.event.venue_id   = null
      $scope.event.newTBACity = null
      $scope.event.setCity    = false
      $scope.data.venueSearch = null

    # Cancel modal
    $scope.cancel = () ->
      $modalInstance.dismiss('cancel')

])