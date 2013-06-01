class app.Toggler extends app.JqueryBase
  action: ->
    self = @
    if !@options.event then @options.event = 'click'
    _.each @$el, (el) ->
      if app.isFunc(self.options.toggle)
        $toggle = self.options.toggle.call self

      $(el).on self.options.event, ->
        self.toggle $(@), $toggle

  toggle: ($el, $toggle) ->
    $toggle.toggle().toggleClass 's-active'
    $el.toggleClass 's-active'

  toggleOnEffect: ($toggle) ->
    $toggle.show()

  toggleOffEffect: ($toggle) ->
    $toggle.hide()
