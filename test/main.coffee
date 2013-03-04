mixer = require '../'
should = require 'should'
require 'mocha'

describe 'modules', ->
  describe 'create', ->
    it 'should create module from empty', (done) ->
      o = new mixer.Module
      should.exist o
      done()

    it 'should create module from object', (done) ->
      class test extends mixer.Module
        test: "hello"
      n = new test
      should.exist n.test
      n.test.should.equal "hello"
      done()

    it 'should be extendable into new modules', (done) ->
      class test extends mixer.Module
        init: ->
          @test = "hello"

      class testt extends test
        init: ->
          @hello = "ye"
          super

      o = new testt
      should.exist o
      should.exist o.init
      o.init()
      should.exist o.test
      o.test.should.equal "hello"
      should.exist o.hello
      o.hello.should.equal "ye"
      done()

    it 'should extend module with overrides', (done) ->
      class test extends mixer.Module
        init: ->
          @test = "hello"
      non = new test hello: "world"
      should.exist non
      should.exist non.init
      non.init()
      should.exist non.test
      should.exist non.get 'hello'
      non.test.should.equal "hello"
      done()

    it 'should get/set/has/remove', (done) ->
      o = new mixer.Module
      should.exist o

      nuo = o.set 'test', 'hello'
      should.exist nuo
      nuo.should.equal o

      should.exist o.get 'test'
      o.get('test').should.equal 'hello'

      should.exist o.has 'test'
      o.has('test').should.equal true

      done()

  describe 'module events', ->
    it 'should emit event on set', (done) ->
      o = new mixer.Module
      should.exist o

      o.on 'change', (k, v) ->
        should.exist v
        v.should.equal 'hello'
        done()
      o.set 'test', 'hello'

    it 'should emit event on silent set', (done) ->
      o = new mixer.Module
      should.exist o

      o.on 'change', (k, v) ->
        throw new Error "not supposed to emit"

      o.set 'test', 'hello', true
      done()

    it 'should emit event on silent set with object', (done) ->
      o = new mixer.Module
      should.exist o

      o.on 'change', (k, v) ->
        throw new Error "not supposed to emit"

      o.set {test: 'hello'}, true
      done()

    it 'should emit namespaced event on set', (done) ->
      o = new mixer.Module
      should.exist o

      o.on 'change:test', (v) ->
        should.exist v
        v.should.equal 'hello'
        done()
      o.set 'test', 'hello'

    it 'should emit event on remove', (done) ->
      o = new mixer.Module
      should.exist o

      o.on 'remove', (k) ->
        should.exist k
        k.should.equal 'test'
        done()
      o.remove 'test'

    it 'should emit namespaced event on remove', (done) ->
      o = new mixer.Module
      should.exist o

      o.on 'remove:test', done
      o.remove 'test'