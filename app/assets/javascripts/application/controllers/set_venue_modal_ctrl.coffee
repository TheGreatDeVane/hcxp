@controllers.controller('setVenueModalCtrl', [
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
        templateUrl: 'events/new_venue_modal.html'
        controller:  'newVenueModalCtrl'

      newVenueModal.result.then (venueId) ->
        $scope.selectVenue(venueId)

])