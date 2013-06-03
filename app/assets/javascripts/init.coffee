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


  customInputs = new app.JqueryPlugin
    el: '.ui-uploader-input'
    plugin: 'uniform'
    config:
      fileDefaultHtml: 'Select File'
      fileButtonClass: 'ui-uploader-button'
      fileClass: 'ui-uploader'
      filenameClass: 'ui-uploader-filename'


  userDropdown = new app.Toggler
    el: '.js-toggle'
    toggle: ->
      @$el.siblings '.js-dropdown'
