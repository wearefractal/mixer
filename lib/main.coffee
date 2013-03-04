if process?
  {EventEmitter} = require 'events'
else
  EventEmitter = require 'emitter'

class Module extends EventEmitter
  constructor: (o) ->
    @_props = {}
    @set o

  get: (k) -> @_props[k]
  getAll: -> @_props

  set: (k, v, silent) ->
    return unless k?
    if typeof k is 'object'
      @set ky, v, silent for ky,v of k
      return @
    else
      @_props[k] = v
      unless silent
        @emit "change", k, v
        @emit "change:#{k}", v
      return @

  clear: (silent) ->
    @remove k, silent for k,v of @_props
    return @

  has: (k) -> @_props[k]?

  remove: (k, silent) -> 
    delete @_props[k]
    unless silent
      @emit "change", k
      @emit "change:#{k}"

      @emit "remove", k
      @emit "remove:#{k}"
    return @

  toJSON: -> @getAll()

mixer =
  Module: Module
  Emitter: EventEmitter

module.exports = mixer