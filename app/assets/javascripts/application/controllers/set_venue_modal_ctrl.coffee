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
      $scope.recent_venues = venues

      # Searching events
      timer = false
      $scope.$watch 'search', ((query, oldQuery) ->

        # If search field is empty, results list
        # should be populated with recently used venues
        if query.query is ''
          $scope.showingRecent = true
          $scope.venues        = $scope.recent_venues
          $timeout.cancel timer
          return

        # If there is anything typed inside search box,
        # fire a search query with delay and populate
        # venues list with results.
        $timeout.cancel timer if timer
        timer = $timeout(->
          Restangular.one('search').getList('venues', { q: $scope.search.query }).then (venues) ->
            $scope.showingRecent = false
            $scope.venues        = venues
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