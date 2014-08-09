#= require_self
#= require      ./locales
#= require_tree ./controllers
#= require_tree ./services

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
  'hcxpApp.services'
]

# Config
@hcxpApp.config([
  'RestangularProvider'

  (RestangularProvider) ->

    # Config API base url
    RestangularProvider.setBaseUrl('/api/v1/')

    # Make Restangular work with our api response structure
    RestangularProvider.addResponseInterceptor( (data, operation, what, url, response, deferred) ->
      data[data.resource || response.headers('x-resource')]
    )
])

# Controllers
@controllers = angular.module('hcxpApp.controllers', [])

# Services
@services = angular.module('hcxpApp.services', [])