class EventEmitter
  constructor: ->
    @events = {}

  emit: (e, args...) ->
    return false unless @events[e]
    listener args... for listener in @events[e]
    return true

  addListener: (e, listener) ->
    @emit 'newListener', e, listener
    (@events[e]?=[]).push listener
    return @

  on: @::addListener

  once: (e, listener) ->
    fn = =>
      @removeListener e, fn
      listener arguments...
    @on e, fn
    return @

  removeListener: (e, listener) ->
    return @ unless @events[e]
    @events[e] = (l for l in @events[e] when l isnt listener)
    return @

  removeAllListeners: (e) ->
    if e?
      delete @events[e]
    else
      @events = {}
    return @

  off: @::removeListener
  offAll: @::removeAllListeners

class Module extends EventEmitter
  constructor: (o) ->
    super
    @_ = props: {}
    @set o if o?

  extend: (o) -> mixer.extend @, o
  get: (k) -> @_.props[k]
  getAll: -> @_.props

  set: (k, v, silent) -> 
    if typeof k is 'object'
      @set ky, v for ky,v of k
      return @
    else
      @_.props[k] = v
      unless silent
        @emit "change", k, v
        @emit "change:#{k}", v
      return @

  has: (k) -> @_.props[k]?

  remove: (k, silent) -> 
    delete @_.props[k]
    unless silent
      @emit "change", k
      @emit "change:#{k}"

      @emit "remove", k
      @emit "remove:#{k}"
    return @

  emit: (e, d...) ->
    super
    mixer.emit e, @, d...
    return @

Module.create = -> new @ arguments...

mixer =
  _events: new EventEmitter
  module: Module
  emitter: EventEmitter
  create: -> mixer.module.create arguments...
  extend: (o={}, n={}) -> 
    o[k]=v for k,v of n
    return o

mixer.extend mixer, mixer._events

if module?
  module.exports = mixer
else
  window.mixer = mixer