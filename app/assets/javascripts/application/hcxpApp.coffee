#= require_self
#= require      ./locales
#= require_tree ./controllers

@hcxpApp = angular.module "hcxpApp", [
  'restangular'
  'ngAutocomplete'
  'ui.bootstrap'
  'mgcrea.ngStrap.popover'
  'ui.select2'
  'templates'
  'btford.markdown'
  'angularMoment'
  'pascalprecht.translate'

  'hcxpApp.controllers'
]

# Config
@hcxpApp.config([
  'RestangularProvider'

  (RestangularProvider) ->

    # Config API base url
    RestangularProvider.setBaseUrl('/api/v1/')

    # Make Restangular work with our api response structure
    RestangularProvider.addResponseInterceptor( (data, operation, what, url, response, deferred) ->
      console.log data[data.resource || response.headers('x-resource')]
      data[data.resource || response.headers('x-resource')]
    )
])

# Controllers
@controllers = angular.module('hcxpApp.controllers', [])