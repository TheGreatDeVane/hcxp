#= require_self
#= require      ./locales
#= require_tree ./factories
#= require_tree ./controllers
#= require_tree ./services

@hcxpApp = angular.module "hcxpApp", [
  'restangular'
  'ngAutocomplete'
  'ngResource'
  'ui.bootstrap'
  'mgcrea.ngStrap.popover'
  'ui.select2'
  'templates'
  'btford.markdown'
  'angularMoment'
  'pascalprecht.translate'
  'cgBusy'
  'infinite-scroll'

  'hcxpApp.factories'
  'hcxpApp.controllers'
  'hcxpApp.services'
]

# Config
@hcxpApp.config([
  'RestangularProvider'

  (RestangularProvider) ->

    # Config API base url
    RestangularProvider.setBaseUrl('/api/v1/')
    RestangularProvider.setFullResponse(true)
])

# Controllers
@controllers = angular.module('hcxpApp.controllers', [])

# Services
@services = angular.module('hcxpApp.services', [])

# Factories
@factories = angular.module('hcxpApp.factories', [])