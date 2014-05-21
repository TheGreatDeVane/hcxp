@controllers.controller('UserLocationsCtrl', [
  '$scope'
  '$rootScope'
  'Restangular'

  ($scope, $rootScope, Restangular) ->

    $scope.addLocation = () ->
      location = {
        country_code: $scope.locationDetails.address_components[4].short_name
        city:         $scope.locationDetails.name
      }

      Restangular.one('users').one('locations').customPOST({location: location}).then () ->
        $scope.autocomplete    = ''
        loadLocations()

    loadLocations = () ->
      Restangular.one('users').getList('locations').then (locations) ->
        $scope.locations = locations

    $scope.removeLocation = (index) ->
      Restangular.one('users').customDELETE('locations', {id: $scope.locations[index].id}).then () ->
        $scope.locations.splice(index, 1)

    loadLocations()

])