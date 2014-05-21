@controllers.controller('addBandModalCtrl', [
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

    # Searching bands
    timer = false
    $scope.$watch 'search', ((query, oldQuery) ->
      return if query is oldQuery

      # If there is anything typed inside search box,
      # fire a search query with delay and populate
      # venues list with results.
      $timeout.cancel timer if timer
      timer = $timeout(->
        Restangular.one('search').getList('bands', { q: $scope.search.query }).then (bands) ->
          $scope.bands = bands
      , 500)
    ), true

    # Set band action
    $scope.selectBand = (index) ->
      $modalInstance.close($scope.bands[index])

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