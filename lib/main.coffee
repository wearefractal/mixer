if process? and exports?
  {EventEmitter2} = require '../deps/EventEmitter2'
else
  EventEmitter2 = window.EventEmitter2

extend = (o, n) -> 
  o[k]=v for own k,v of n
  return o

class SilentModule extends EventEmitter2
  constructor: (o) ->
    super()
    @_ = props: {}
    extend @, o

  get: (k) -> @_.props[k]
  getAll: -> @_.props

  set: (k, v, silent) ->
    return unless k?
    if typeof k is 'object'
      @set ky, v for ky,v of k
      return @
    else
      return unless v?
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

class Module extends SilentModule
  constructor: (o) ->
    super o
    @onAny (a...) ->
      mixer.emit @event, @, a...

mixer = new SilentModule
  Module: Module
  Emitter: EventEmitter2
  module: (a...) ->
    create: (o) ->
      mod = new Module a...
      mod.set o
      return mod
    subclass: (b) -> mixer.module a.concat(b)...

  extend: extend

if module?
  module.exports = mixer
else
  window.mixer = mixer