@controllers.controller('SimilarEventsCtrl', [
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
          'event[band_list]':   $scope.event.band_ids
        ).then (events) ->
          $scope.events = events

    $scope.event = {}

])