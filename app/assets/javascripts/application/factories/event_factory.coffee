@factories.factory('Event', [
  '$resource'

  ($resource) ->
    $resource '/api/v1/events/:id', {}, {
      toggle_save: { params: { names: 'names' }, method: 'POST' }
    }
])