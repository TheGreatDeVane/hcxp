@controllers.controller('EventFiltersCtrl', [
  '$scope'
  '$rootScope'
  '$http'
  '$location'
  'EventListService'

  ($scope, $rootScope, $http, $location, EventListService) ->

    $scope.eventListFilters = EventListService.filters()
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

    $scope.$watchCollection 'filters.bands', (val, newVal) ->
      return false if val is newVal
      reloadBandsFilter()

    $scope.$watchCollection 'filters.venues', (val, newVal) ->
      return false if val is newVal
      reloadVenuesFilter()

    reloadVenuesFilter = () ->
      $scope.changeVenueIdsFilter(_.map($scope.filters.venues, (item) -> item.id))

    reloadBandsFilter = () ->
      $scope.changeBandIdsFilter(_.map($scope.filters.bands, (item) -> item.id))

    $scope.changeWhenFilter = (whenFilter) ->
      EventListService.setFilters({when: whenFilter})

    $scope.changeQueryFilter = (queryFilter) ->
      EventListService.setFilters({q: queryFilter})

    $scope.changeBandIdsFilter = (bandIdsFilter) ->
      EventListService.setFilters({band_ids: bandIdsFilter})

    $scope.changeVenueIdsFilter = (venueIdsFilter) ->
      EventListService.setFilters({venue_ids: venueIdsFilter})

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
          $http.get("/api/v1/bands?q=" + queryParams.data.query).then(queryParams.success)

        results: (data, page) ->
          results: data.data
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
          $http.get("/api/v1/venues?q=" + queryParams.data.query).then(queryParams.success)

        results: (data, page) ->
          results: data.data
    }

])