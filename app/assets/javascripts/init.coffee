jQuery ->
  traits = new app.JqueryPlugin
    el: '#traits'
    plugin: 'tagit'
    config:
      availableTags: window.traits
      fieldName: 'food[trait_names][]'
      animate: false
      autocomplete:
        appendTo: '#traits-wrapper'
        position:
          my: 'left top'
          at: 'left bottom'
          of: '#traits'
          offset: '0 -3'

  userDropdown = new app.Toggler
    el: '.js-toggle'
    toggle: ->
      @$el.siblings '.js-dropdown'
