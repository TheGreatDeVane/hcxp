@controllers.controller('UserLocationsCtrl', [
  '$scope'
  '$rootScope'
  'Restangular'
  'EventListService'

  ($scope, $rootScope, Restangular, EventListService) ->

    $scope.data = {}
    $scope.eventListFilters = EventListService.filters()

    $scope.$on('mapentrySelected', (data) ->
      $scope.addLocation(data.targetScope.details)
    )

    $scope.addLocation = (details) ->
      switch details.types[0]
        when 'locality'
          $scope.data.location = {
            country_code:  details.address_components[4].short_name
            country_name:  details.address_components[4].long_name
            city:          details.name
            location_type: details.types[0]
          }
        when 'country'
          $scope.data.location = {
            country_code:  details.address_components[0].short_name
            country_name:  details.address_components[0].long_name
            location_type: details.types[0]
          }

      Restangular.one('users').one('locations').customPOST({location: $scope.data.location}).then () ->
        $scope.data.autocomplete = ''
        loadLocations()
        updateEventListFilters()

    loadLocations = () ->
      Restangular.one('users').getList('locations').then ((result) ->
        $scope.data.locations = result.data
        updateEventListFilters()
      ), ((res) ->
        # If response code is 401 (which means user is not authorized [not signed-in])
        # we should reload the events list anyway to display all the events.
        if res.status is 401
          updateEventListFilters()
      )

    $scope.removeLocation = (index) ->
      Restangular.one('users').customDELETE('locations', {id: $scope.data.locations[index].id}).then () ->
        $scope.data.locations.splice(index, 1)
        updateEventListFilters()

    $scope.done = () ->
      # $rootScope.$broadcast 'alert', {type: 'success', msg: 'Location has been saved.'}

    updateEventListFilters = () ->
      locations = _.map($scope.data.locations, (num, key) -> {
        q: num.city || num.country_name,
        location_type: num.location_type
      } )
      EventListService.setFilters({ locations: locations })

    $scope.changeWhenFilter = (whenFilter) ->
      EventListService.setFilters({when: whenFilter})

    loadLocations()
])