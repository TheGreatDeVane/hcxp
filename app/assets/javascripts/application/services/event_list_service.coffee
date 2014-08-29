@services.factory 'EventListService', ['$rootScope', ($rootScope) ->

  filters = { when: 'future' }

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

    # Converts filters object to proper restangular query object
    #
    filterQueryObject: () ->
      obj = {}

      obj.q    = filters.q
      obj.when = filters.when

      # Locations
      for i of filters.locations
        obj["locations[" + i + "]"] = filters.locations[i]

      # Bands
      for i of filters.band_ids
        obj["band_ids[" + i + "]"] = filters.band_ids[i]

      # Venues
      for i of filters.venue_ids
        obj["venue_ids[" + i + "]"] = filters.venue_ids[i]

      obj
]