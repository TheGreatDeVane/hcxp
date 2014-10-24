#= require_self
#= require      ./locales
#= require_tree ./factories
#= require_tree ./controllers
#= require_tree ./services
#= require_tree ./directives

@hcxpApp = angular.module "hcxpApp", [
  'restangular'
  'ngAutocomplete'
  'ngResource'
  'ui.bootstrap'
  'mgcrea.ngStrap.popover'
  'ui.select2'
  'ui.sortable'
  'templates'
  'btford.markdown'
  'angularMoment'
  'pascalprecht.translate'
  'monospaced.elastic'

  'hcxpApp.factories'
  'hcxpApp.controllers'
  'hcxpApp.services'
  'hcxpApp.directives'
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

# Directives
@directives = angular.module('hcxpApp.directives', [])