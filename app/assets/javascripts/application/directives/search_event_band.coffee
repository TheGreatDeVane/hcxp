@directives.directive "hcxpSearchEventBand", [
  '$rootScope'
  '$timeout'
  'Restangular'
  ($rootScope, $timeout, Restangular) ->

    controller: ($scope) ->
      $scope.bands = []
      $scope.noResults = false
      timer = false

      $scope.searchForBand = (q) ->

        Restangular.all('bands').getList({ 'f[name_cont]': q }).then (results) ->
          $scope.bands = results.data

          if results.data.length > 0
            $scope.noResults = false
          else
            $scope.noResults = true

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

        $scope.noResults = false

        if val is ''
          $timeout.cancel timer
          $scope.bands = []
        else
          $timeout.cancel timer if timer
          timer = $timeout(->
            $scope.searchForBand(val)
          , 500)

    link: (scope, element, attrs) ->
      return

    restrict: 'A'
    templateUrl: 'search_event_band.html'
    scope: {
      eventId: '@'
    }
]