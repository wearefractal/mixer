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

Base = ->
Module =
  clone: -> mixer.module @
  extend: (o) -> mixer.extend @, o
  get: (k) -> @_.props[k]

  set: (k, v, silent=false) -> 
    @_.props[k] = v
    unless silent
      @emit "change", k, v
      @emit "change:#{k}", v
      mixer.emit "change", @, k, v
      mixer.emit "change:#{k}", @, v
    return @

  has: (k) -> @_.props[k]?

  remove: (k, silent=false) -> 
    delete @_.props[k]
    unless silent
      @emit "change", k
      @emit "change:#{k}"
      mixer.emit "change", @, k
      mixer.emit "change:#{k}", @

      @emit "remove", k
      @emit "remove:#{k}"
      mixer.emit "remove", @, k
      mixer.emit "remove:#{k}", @
    return @

  emit: (a...) ->
    @_.events.emit a...
    return @

  on: (e, fn) ->
    @_.events.on e, fn.bind @
    return @

  once: (e, fn) ->
    @_.events.once e, fn.bind @
    return @

  off: (a...) ->
    @_.events.off a...
    return @

  offAll: (a...) ->
    @_.events.offAll a...
    return @


guids = -1

mixer =
  _: {}

  create: (o) ->
    inst = mixer.nu o
    mixer.extend inst, Module
    inst.guid = ++guids
    inst._ = mixer._[inst.guid] = 
      props: {}
      events: new EventEmitter
    return inst

  nu: (o) ->
    Base:: = o
    return new Base

  clone: (o) -> mixer.extend {}, o
  extend: (o, n) ->
    o[k] = v for k,v of n
    return o

mixer.extend mixer, new EventEmitter

if module?
  module.exports = mixer
else
  window.mixer = mixer