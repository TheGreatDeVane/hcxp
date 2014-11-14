@directives.directive "hcxpEventBandsForm", [
  '$rootScope'
  '$http'
  'Restangular'
  ($rootScope, $http, Restangular) ->

    controller: ($scope) ->
      $scope.event_bands = []

      $scope.uiSortableOptions = {
        axis:   'y',
        cursor: 'ns-resize'
      }

      isLoading()
      Restangular.one('events', $scope.eventId).all('event_bands').getList().then (results) ->
        $scope.event_bands = results.data
        isLoading(false)

    link: (scope, element, attrs) ->
      return

    restrict: 'A'
    templateUrl: 'event_band.html'
    scope: {
      eventId: '@'
    }
]