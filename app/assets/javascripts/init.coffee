jQuery ->
  traits = new app.JqueryPlugin
    el: '#traits'
    plugin: 'tagit'
    config:
      availableTags: window.traits
      fieldName: 'food[trait_names][]'
      animate: false

  userDropdown = new app.Toggler
    el: '.js-toggle'
    toggle: ->
      @$el.siblings '.js-dropdown'
