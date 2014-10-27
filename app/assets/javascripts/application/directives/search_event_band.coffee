@directives.directive "hcxpSearchEventBand", [
  '$rootScope'
  '$timeout'
  'Restangular'
  ($rootScope, $timeout, Restangular) ->

    controller: ($scope) ->
      $scope.bands = []
      timer = false

      $scope.searchForBand = (q) ->

        Restangular.all('bands').getList({ q: q }).then (results) ->
          $scope.bands = results.data

      $scope.addBand = (index) ->
        params = {
          event_band: {
            band_id: $scope.bands[index].id
          }
        }

        Restangular.one('events', $scope.eventId).one('event_bands').customPOST(params).then (results) ->
          $.pjax({url: '/' + $scope.eventId + '/edit/bands', container: '.pjax-container'})

      $scope.$watchCollection 'searchQuery', (val, oldVal) ->
        return false if val is oldVal

        if val is ''
          $timeout.cancel timer
          $scope.bands = []
        else
          $timeout.cancel timer if timer
          timer = $timeout(->
            $scope.searchForBand(val)
          , 500)
        end

    link: (scope, element, attrs) ->
      return

    restrict: 'A'
    templateUrl: 'search_event_band.html'
    scope: {
      eventId: '@'
    }
]