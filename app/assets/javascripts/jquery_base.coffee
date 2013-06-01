class app.JqueryBase
	constructor: (@options) ->
		if @options.el
			@$el = $(@options.el)

			if @$el.length
				app.callFunc @options.beforeInitialize, @

				@action.call @

				app.callFunc @options.onInitialize, @
