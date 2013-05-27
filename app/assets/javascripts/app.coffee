window.app = {}

app.isFunc = (fn, callback) ->
	if fn and app.type(fn) == 'function'
		if callback then callback()
		return true
	else
		new Error fn + 'is not a valid function'
		return false

app.callFunc = (fn, ctx, args...) ->
	app.isFunc fn, ->
		if ctx
			fn.call ctx, args
		else
			fn()
