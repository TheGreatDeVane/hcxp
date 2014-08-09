@services.factory 'AlertService', ['$rootScope', '$timeout', ($rootScope, $timeout) ->
  $rootScope.alerts = []

  AlertService =
    alerts: ->
      $rootScope.alerts

    add: (type, msg, timeout) ->
      timeout = 5000 unless timeout

      $rootScope.alerts.push({
        type: type
        msg: msg
        close: ->
          AlertService.closeAlert this
      })

      if timeout
        $timeout (->
          AlertService.closeAlert this
          return
        ), timeout
      return

    closeAlert: (alert) ->
      @closeAlertIndex $rootScope.alerts.indexOf(alert)

    closeAlertIndex: (index) ->
      $rootScope.alerts.splice(index, 1)

    clear: ->
      $rootScope.alerts = []
]