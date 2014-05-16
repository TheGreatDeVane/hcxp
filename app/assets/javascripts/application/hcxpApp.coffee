hcxpApp = angular.module "hcxpApp", [
  'restangular'
  'ngAutocomplete'

  'hcxpApp.controllers'
]

# Config
hcxpApp.config([
  'RestangularProvider'

  (RestangularProvider) ->

    # Config API base url
    RestangularProvider.setBaseUrl('/api/v1/')

    # Make Restangular work with our api response structure
    RestangularProvider.addResponseInterceptor( (data, operation, what, url, response, deferred) ->
      data[data.meta.resource]
    )
])

# Controllers
controllers = angular.module('hcxpApp.controllers', [])

controllers.controller('EventsFormCtrl', [
  '$scope'
  '$rootScope'
  '$timeout'
  'Restangular'

  ($scope, $rootScope, $timeout, Restangular) ->
    $scope.event = {
      title:       ''
      description: ''
      band_list:   ''
    }

    timer = false
    $scope.$watch 'event', ((event, oldEvent) ->
      return if event is oldEvent
      $timeout.cancel timer if timer

      timer = $timeout(->
        $rootScope.$emit 'eventForm.changed', $scope.event
      , 1500)
    ), true
])

controllers.controller('SimilarEventsCtrl', [
  '$scope'
  '$rootScope'
  'Restangular'

  ($scope, $rootScope, Restangular) ->

    # Listen for eventForm.change event and
    # when it occurs, reload similar events list
    $rootScope.$on 'eventForm.changed', (e, data) ->
      $scope.event = data
      loadEvents()

    # Reloads events list
    loadEvents = () ->
      if $scope.event
        Restangular.one('events').getList('similar_by',
          'event[title]':       $scope.event.title,
          'event[description]': $scope.event.description,
          'event[band_list]':   $scope.event.band_list
        ).then (events) ->
          $scope.events = events

    $scope.event = {}

])

controllers.controller('UserLocationsCtrl', [
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