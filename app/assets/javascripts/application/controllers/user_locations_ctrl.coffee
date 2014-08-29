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
      $scope.data.location = {
        country_code: details.address_components[4].short_name
        city:         details.name
      }

      Restangular.one('users').one('locations').customPOST({location: $scope.data.location}).then () ->
        $scope.data.autocomplete = ''
        loadLocations()
        updateEventListFilters()

    loadLocations = () ->
      Restangular.one('users').getList('locations').then (locations) ->
        $scope.data.locations = locations
        updateEventListFilters()

    $scope.removeLocation = (index) ->
      Restangular.one('users').customDELETE('locations', {id: $scope.data.locations[index].id}).then () ->
        $scope.data.locations.splice(index, 1)
        updateEventListFilters()

    $scope.done = () ->
      $rootScope.$broadcast 'alert', {type: 'success', msg: 'Location has been saved.'}

    updateEventListFilters = () ->
      EventListService.setFilters({ locations: _.map($scope.data.locations, (num, key) -> num.city ) })

    $scope.changeWhenFilter = (whenFilter) ->
      EventListService.setFilters({when: whenFilter})

    loadLocations()
])