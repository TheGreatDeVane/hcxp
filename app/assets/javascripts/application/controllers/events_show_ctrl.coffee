@controllers.controller('EventsShowCtrl', [
  '$scope'
  '$controller'
  'EventListService'

  ($scope, $controller, EventListService) ->

    $scope.eventId  = null
    $scope.isSingle = true

    # Initialize the super class and extend it.
    # This solution is taken from http://stackoverflow.com/a/19670187/552936
    # and as one of the commenters stays, it should be moved to angular.extend
    # instead of jquerys $.extend method.
    $.extend this, $controller("EventsListCtrl",
      $scope: $scope
    )


    $scope.loadEvent = (eventId) ->
      $scope.eventId = eventId
      EventListService.setFilters({ when: 'future', per: 1, id: eventId })


    # Disable parent controller methods
    #
    $scope.loadMore = () -> return false
    $scope.toggleExpand = (event, $event) -> return false

])