if process?
  {EventEmitter} = require 'events'
else
  EventEmitter = require 'emitter'

extend = (o, n) -> 
  o[k]=v for own k,v of n
  return o

class Module extends EventEmitter
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
      @_.props[k] = v
      unless silent
        @emit "change", k, v
        @emit "change:#{k}", v
      return @

  clear: ->
    for k,v of @_props
      @set k, undefined
  has: (k) -> @_.props[k]?

  remove: (k, silent) -> 
    delete @_.props[k]
    unless silent
      @emit "change", k
      @emit "change:#{k}"

      @emit "remove", k
      @emit "remove:#{k}"
    return @

mixer =
  Module: Module
  Emitter: EventEmitter
  extend: extend
  module: (a...) ->
    create: (o) ->
      mod = new Module a...
      mod.set o
      return mod
    subclass: (b) -> mixer.module a.concat(b)...

module.exports = mixer