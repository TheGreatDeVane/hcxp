@controllers.controller('EventFiltersCtrl', [
  '$scope'
  '$rootScope'
  '$http'
  '$location'

  ($scope, $rootScope, $http, $location) ->

    $scope.filters = {
      when:     'future'
      order:    'date'
      bands:    []
      venues:   []
      band_ids: []
    }

    $scope.$watch 'foundBand', (band) ->
      return false unless band?
      $scope.foundBand = null
      $scope.filters.bands.push band

    $scope.$watch 'foundVenue', (venue) ->
      return false unless venue?
      $scope.foundVenue = null
      $scope.filters.venues.push venue

    $scope.removeBand = (index) ->
      $scope.filters.bands.splice(index, 1)

    $scope.removeVenue = (index) ->
      $scope.filters.venues.splice(index, 1)

    bandFormatResult = (band) ->
      markup  = '<strong>'
      markup += band.name
      markup += '</strong><br/>'
      markup += '<small class="text-muted">' + band.location + '</small>'
      markup

    venueFormatResult = (venue) ->
      markup  = '<strong>'
      markup += venue.name
      markup += '</strong><br/>'
      markup += '<small class="text-muted">' + venue.address + '</small>'
      markup

    # Band Select2 options
    $scope.bandSearchOptions = {
      minimumInputLength: 1
      formatResult: bandFormatResult
      formatSelection: (band) ->
        band.name

      ajax:
        quietMillis: 500

        data: (term, page) ->
          query: term

        transport: (queryParams, page) ->
          $http.get("/api/v1/bands?query=" + queryParams.data.query).then(queryParams.success)

        results: (data, page) ->
          results: data.data.bands
    }

    # Venue Select2 options
    $scope.venueSearchOptions = {
      minimumInputLength: 1
      formatResult: venueFormatResult
      formatSelection: (venue) ->
        venue.name

      ajax:
        quietMillis: 500

        data: (term, page) ->
          query: term

        transport: (queryParams, page) ->
          $http.get("/api/v1/venues?query=" + queryParams.data.query).then(queryParams.success)

        results: (data, page) ->
          results: data.data.venues
    }

])