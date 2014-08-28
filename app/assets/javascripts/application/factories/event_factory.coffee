@factories.factory('Event', [
  '$resource'

  ($resource) ->
    $resource '/api/v1/events/:id'
])