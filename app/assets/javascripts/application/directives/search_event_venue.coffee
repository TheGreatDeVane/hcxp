@directives.directive "hcxpSearchEventVenue", [
  '$rootScope'
  '$timeout'
  'Restangular'
  ($rootScope, $timeout, Restangular) ->

    controller: ($scope) ->
      $scope.venues = []
      timer = false

      $scope.searchForVenue = (q) ->
        Restangular.all('venues').getList({ q: q }).then (results) ->
          $scope.venues = results.data

      $scope.$watchCollection 'searchQuery', (val, oldVal) ->
        return false if val is oldVal

        if val is ''
          $timeout.cancel timer
          $scope.venues = []
        else
          $timeout.cancel timer if timer
          timer = $timeout(->
            $scope.searchForVenue(val)
          , 500)
        end

    link: (scope, element, attrs) ->
      return

    restrict: 'A'
    templateUrl: 'search_event_venue.html'
    scope: {
      eventId: '@'
    }
]