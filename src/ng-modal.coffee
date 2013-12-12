#
# ngModal
# by Adam Albrecht
# http://adamalbrecht.com
#
# Source Code: https://github.com/adamalbrecht/ngModal
#
# Compatible with Angular 1.0.8
#

app = angular.module("ngModal", [])

app.provider "ngModalDefaults", ->
  @options = {
    closeButtonHtml: "<span class='ng-modal-close-x'>X</span>"
  }
  @$get = ->
    @options

  @set = (keyOrHash, value) ->
    if typeof(keyOrHash) == 'object'
      for k, v of keyOrHash
        @options[k] = v
    else
      @options[keyOrHash] = value

app.directive 'modalDialog', ['ngModalDefaults', (ngModalDefaults) ->
  restrict: 'E'
  scope:
    show: '='
    title: '@'
  replace: true
  transclude: true
  link: (scope, element, attrs) ->
    setupCloseButton = ->
      scope.closeButtonHtml = ngModalDefaults.closeButtonHtml

    setupStyle = ->
      scope.dialogStyle = {}
      scope.dialogStyle['width'] = attrs.width if attrs.width
      scope.dialogStyle['height'] = attrs.height if attrs.height

    scope.hideModal = ->
      scope.show = false

    scope.$watch('show', (newVal, oldVal) ->
      if newVal && !oldVal
        document.getElementsByTagName("body")[0].style.overflow = "hidden";
      else
        document.getElementsByTagName("body")[0].style.overflow = "";
    )

    setupCloseButton()
    setupStyle()

  template: """
              <div class='ng-modal' ng-show='show'>
                <div class='ng-modal-overlay' ng-click='hideModal()'></div>
                <div class='ng-modal-dialog' ng-style='dialogStyle'>
                  <span class='ng-modal-title' ng-bind='title'></span>
                  <div class='ng-modal-close' ng-click='hideModal()'>
                    <div ng-bind-html-unsafe='closeButtonHtml'></div>
                  </div>
                  <div class='ng-modal-dialog-content' ng-transclude></div>
                </div>
              </div>
            """
]