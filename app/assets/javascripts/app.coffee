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

app.type = (obj) ->
  if obj == undefined or obj == null
    return String obj
  classToType = new Object
  for name in "Boolean Number String Function Array Date RegExp".split(" ")
    classToType["[object " + name + "]"] = name.toLowerCase()
  myClass = Object.prototype.toString.call obj
  if myClass of classToType
    return classToType[myClass]
  return "object"
