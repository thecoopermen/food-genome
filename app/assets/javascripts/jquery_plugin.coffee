class app.JqueryPlugin extends app.JqueryBase
	constructor: (@options) ->
		super

	action: ->
		@$el[@options.plugin](@options.config)

	update: ->
		@constructor(@options)
