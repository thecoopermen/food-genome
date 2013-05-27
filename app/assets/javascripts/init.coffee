jQuery ->
	traits = new app.JqueryPlugin
		el: '#traits'
		plugin: 'tagit'
		config:
			availableTags: ['hi', 'bye']
