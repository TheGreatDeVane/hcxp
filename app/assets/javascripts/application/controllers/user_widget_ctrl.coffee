@controllers.controller('UserWidgetCtrl', [
  '$scope'
  '$rootScope'
  '$http'

  ($scope, $rootScope, $http) ->

    $scope.user = {}

    $scope.$on 'savesChanged', (event, args) ->
      $scope.user.saved = $scope.user.saved + 1 if args.type is 'saved'
      $scope.user.saved = $scope.user.saved - 1 if args.type is 'unsaved'

    $scope.loadUser = () ->
      $http({method: 'GET', url: '/api/v1/users/current'}).
        success((data) ->
          $scope.user = data.user
        ).
        error((data) ->
          console.log 'Error', data
        )

    $scope.loadUser()
])