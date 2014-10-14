@directives.directive "eventFilters", [
  '$rootScope'
  '$http'
  'Restangular'
  ($rootScope, $http, Restangular) ->

    controller: ($scope) ->

      parsedFilters = JSON.parse($scope.eventFilterParams)
      $scope.filters = {
        when:      parsedFilters.when || 'future'
        bands:     []
        venues:    []
        band_ids:  (_.map parsedFilters.band_ids, (num) -> parseInt(num)) || []
        venue_ids: (_.map parsedFilters.venue_ids, (num) -> parseInt(num)) || []
        locations: parsedFilters.locations || []
      }

      console.log $scope.filters.locations


      # Filter listeners
      #
      #

      $scope.$watchCollection 'filters.band_ids', (val, oldVal) ->
        return false if val is oldVal
        $scope.applyFilters()

      $scope.$watchCollection 'filters.venue_ids', (val, oldVal) ->
        return false if val is oldVal
        $scope.applyFilters()

      $scope.$watchCollection 'filters.band_ids', (val, oldVal) ->
        unless val.length
          $scope.filters.bands = []
          return false

        query = ''
        _.each val, (i) -> query += '&id_in[]=' + i
        query = query.replace(/^\&/, "?")

        Restangular.all('bands').customGET(query).then (bands) ->
          $scope.filters.bands = bands.data

      $scope.$watchCollection 'filters.venue_ids', (val, oldVal) ->
        unless val.length
          $scope.filters.venues = []
          return false

        query = ''
        _.each val, (i) -> query += '&id_in[]=' + i
        query = query.replace(/^\&/, "?")

        Restangular.all('venues').customGET(query).then (venues) ->
          $scope.filters.venues = venues.data

      $scope.$watch 'filters.when', (val, oldVal) ->
        return false if val is oldVal
        $scope.applyFilters()

      $scope.$watchCollection 'filters.locations', (val, oldVal) ->
        return false if val is oldVal
        $scope.applyFilters()


      # Select2 and autocomplete listeners
      #

      $scope.$watch 'foundBand', (band) ->
        return false unless band?
        $scope.foundBand = null
        $scope.filters.band_ids.push band.id

      $scope.$watch 'foundVenue', (venue) ->
        return false unless venue?
        $scope.foundVenue = null
        $scope.filters.venue_ids.push venue.id

      $scope.$watch 'foundLocation.address_details', (location) ->
        return if (location is null) || !location?
        $scope.foundLocation = {}

        location_obj      = {}
        location_obj.type = location.types[0]
        location_obj.q    = location.formatted_address
        $scope.filters.locations.push location_obj



      # Methods
      #

      $scope.removeBand = (index) ->
        $scope.filters.band_ids = _.reject $scope.filters.band_ids, (row) ->
          $scope.filters.bands[index].id is row

      $scope.removeVenue = (index) ->
        $scope.filters.venue_ids = _.reject $scope.filters.venue_ids, (row) ->
          $scope.filters.venues[index].id is row

      $scope.removeLocation = (index) ->
        $scope.filters.locations.splice(index, 1)

      $scope.applyFilters = () ->
        query = 'when=' + $scope.filters.when

        _.forEach $scope.filters.band_ids, (val) ->
          query += '&band_ids[]=' + val

        _.forEach $scope.filters.venue_ids, (val) ->
          query += '&venue_ids[]=' + val

        _.forEach $scope.filters.locations, (val, index) ->
          query += '&locations[' + index + '][type]=' + val.type
          query += '&locations[' + index + '][q]=' + val.q

        $.pjax({url: '/browse?' + query, container: '.pjax-container'})



      # Result formatters for select2
      #

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
      #

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
      #

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

    link: (scope, element, attrs) ->
      return

    restrict: 'A'
    templateUrl: 'event_filters.html'
    scope: {
      eventFilterParams: '@'
    }
]