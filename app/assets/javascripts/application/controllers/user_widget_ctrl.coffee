@controllers.controller('UserWidgetCtrl', [
  '$scope'
  '$rootScope'
  '$http'
  'Restangular'

  ($scope, $rootScope, $http, Restangular) ->

    $scope.user = {}

    $scope.$on 'savesChanged', (event, args) ->
      $scope.user.saved = $scope.user.saved + 1 if args.type is 'saved'
      $scope.user.saved = $scope.user.saved - 1 if args.type is 'unsaved'

    $scope.loadUser = () ->
      Restangular.one('users').one('current').get().then (data) ->
        $scope.user = data

    $scope.loadUser()
])