@directives.directive "hcxpSearchEventBand", [
  '$rootScope'
  '$http'
  'Restangular'
  ($rootScope, $http, Restangular) ->

    controller: ($scope) ->
      $scope.bands = []

      $scope.searchForBand = () ->
        Restangular.all('bands').getList({ q: $scope.searchQuery }).then (results) ->
          $scope.bands = results.data

      $scope.addBand = (index) ->
        params = {
          event_band: {
            band_id: $scope.bands[index].id
          }
        }
        console.log params
        Restangular.one('events', $scope.eventId).one('event_bands').customPOST(params).then (results) ->
          $.pjax({url: '/' + $scope.eventId + '/edit/bands', container: '.pjax-container'})

      $scope.$watchCollection 'searchQuery', (val, oldVal) ->
        return false if val is oldVal
        $scope.searchForBand()

    link: (scope, element, attrs) ->
      return

    restrict: 'A'
    templateUrl: 'search_event_band.html'
    scope: {
      eventId: '@'
    }
]