@services.factory 'EventListService', ['$rootScope', ($rootScope) ->

  filters = {
    when: 'future'
    page: 1
    per:  10
  }

  EventListService =

    # Returns current filters
    #
    filters: ->
      filters

    # Sets new filter params
    #
    setFilters: (f) ->
      filters = _.extend(filters, f)
      $rootScope.$emit 'eventListFiltersChanged', filters

    # Reload events
    #
    reloadEvents: () ->
      $rootScope.$emit 'eventListFiltersChanged'

    # Converts filters object to proper restangular query object
    #
    filterQueryObject: () ->
      obj = {}

      obj.q    = filters.q    if filters.q
      obj.id   = filters.id   if filters.id
      obj.when = filters.when
      obj.page = filters.page
      obj.per  = filters.per

      # Locations
      for i of filters.locations
        obj["locations[" + i + "][type]"] = filters.locations[i].location_type
        obj["locations[" + i + "][q]"]    = filters.locations[i].q

      # Bands
      for i of filters.band_ids
        obj["band_ids[" + i + "]"] = filters.band_ids[i]

      # Venues
      for i of filters.venue_ids
        obj["venue_ids[" + i + "]"] = filters.venue_ids[i]

      obj

    getPaginationLinks: (response, rel) ->
      links = []
      links_header = response.headers('link')
      return null if links_header is null

      links = links_header.split(',')

      for link in links
        unless link.search(rel) is -1
          return /\<(.*)\>/.exec(link)[1]

      return null

    hasMoreResults: (response) ->
      EventListService.getPaginationLinks(response, 'next') != null
]