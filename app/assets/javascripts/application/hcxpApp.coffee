#= require_self
#= require_tree ./controllers

hcxpApp = angular.module "hcxpApp", [
  'restangular'
  'ngAutocomplete'
  'ui.bootstrap'
  'templates'

  'hcxpApp.controllers'
]

# Config
hcxpApp.config([
  'RestangularProvider'

  (RestangularProvider) ->

    # Config API base url
    RestangularProvider.setBaseUrl('/api/v1/')

    # Make Restangular work with our api response structure
    RestangularProvider.addResponseInterceptor( (data, operation, what, url, response, deferred) ->
      data[data.meta.resource]
    )
])

# Controllers
@controllers = angular.module('hcxpApp.controllers', [])