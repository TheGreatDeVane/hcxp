hcxpApp = angular.module "hcxpApp", [
  'restangular'
  'ngAutocomplete'
  'ui.bootstrap'

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
  '$modal'
  'Restangular'

  ($scope, $rootScope, $timeout, $modal, Restangular) ->
    $scope.event = {
      title:       ''
      description: ''
      band_list:   ''
      venue_id:    ''
    }

    # Open venue picker modal
    $scope.setVenue = () ->
      modalInstance = $modal.open
        templateUrl: 'setVenueModal.html'
        controller:  'setVenueModalCtrl'

      modalInstance.result.then (selectedVenueId) ->
        # If venue has been picked from the list
        $scope.event.venue_id = selectedVenueId


    timer = false
    $scope.$watch 'event', ((event, oldEvent) ->
      return if event is oldEvent
      $timeout.cancel timer if timer

      timer = $timeout(->
        $rootScope.$emit 'eventForm.changed', $scope.event
      , 1500)
    ), true

    # Watch venue_id change. If it occurs, reload it's
    # data from the api.
    $scope.$watchCollection 'event.venue_id', (venue_id) ->
      return if venue_id is ''

      Restangular.one('venues', venue_id).get().then (venue) ->
        $scope.venue = venue
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

controllers.controller('EventsShowCtrl', [
  '$scope'
  '$rootScope'

  ($scope, $rootScope) ->
    $scope.descriptionExpanded = false
])

controllers.controller('setVenueModalCtrl', [
  '$scope'
  '$rootScope'
  '$modalInstance'
  '$timeout'
  '$modal'
  'Restangular'

  ($scope, $rootScope, $modalInstance, $timeout, $modal, Restangular) ->

    $scope.search = {
      query: ''
    }

    # Load default set of venues (recently used by current user)
    Restangular.one('users').getList('recent_venues').then (venues) ->
      $scope.venues = venues

    # Searching events
    timer = false
    $scope.$watch 'search', ((query, oldQuery) ->
      return if query is oldQuery
      $timeout.cancel timer if timer

      timer = $timeout(->
        Restangular.one('search').getList('venues', { q: $scope.search.query }).then (venues) ->
          $scope.venues = venues
      , 500)
    ), true

    # Set venue action
    $scope.selectVenue = (venueId) ->
      $modalInstance.close(venueId)

    # Cancel action
    $scope.cancel = () ->
      $modalInstance.dismiss('cancel')

    # Create new event action
    $scope.newVenue = () ->
      newVenueModal = $modal.open
        templateUrl: 'newVenueModal.html'
        controller:  'newVenueModalCtrl'

      newVenueModal.result.then (venueId) ->
        $scope.selectVenue(venueId)

])

controllers.controller('newVenueModalCtrl', [
  '$scope'
  '$modalInstance'
  '$timeout'
  'Restangular'

  ($scope, $modalInstance, $timeout, Restangular) ->

    $scope.venue = {
      name:    ''
      address: ''
    }

    $scope.alerts = []

    $scope.closeAlert = (index) ->
      $scope.alerts.splice(index, 1)

    $scope.save = (details) ->
      Restangular.one('venues').customPOST($scope.venue).then((result) ->
        $modalInstance.close(result.id)

      , (result) ->
        for error in result.data.full_messages
          $scope.alerts.push({type: 'danger', msg: error});
      )

    $scope.cancel = () ->
      $modalInstance.dismiss('cancel')

])