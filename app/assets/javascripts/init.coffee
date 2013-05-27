jQuery ->
	traits = new app.JqueryPlugin
		el: '#traits'
		plugin: 'tagit'
		config:
			availableTags: window.traits
			fieldName: 'food[trait_names][]'
