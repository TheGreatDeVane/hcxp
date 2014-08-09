@controllers.controller('AppCtrl', [
  '$scope'
  '$rootScope'
  'AlertService'

  ($scope, $rootScope, AlertService) ->

  	$scope.$on 'alert', (event, args) ->
      AlertService.add(args.type, args.msg, args.timeout)

])