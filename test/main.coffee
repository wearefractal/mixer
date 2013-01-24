mixer = require '../'
should = require 'should'
require 'mocha'

describe 'core', ->
  describe 'extend()', ->
    it 'should work', (done) ->
      o = test: 1, wat: 'dood'
      a = test: 2, hello: 'world'
      n = mixer.extend o, a
      n.should.eql
        test: 2
        wat: 'dood'
        hello: 'world'
      done()

describe 'modules', ->
  describe 'create', ->
    it 'should create module from empty', (done) ->
      o = mixer.module()
      should.exist o
      should.exist o.create
      done()

    it 'should create module from object', (done) ->
      o = mixer.module test: "hello"
      should.exist o
      should.exist o.create
      n = o.create()
      should.exist n.test
      n.test.should.equal "hello"
      done()

    it 'should be extendable into new modules', (done) ->
      test = mixer.module
        init: ->
          @test = "hello"
      o = test.create()
      should.exist o
      should.exist o.init
      o.init()
      should.exist o.test
      o.test.should.equal "hello"
      done()

    it 'should extend module with overrides', (done) ->
      test = mixer.module
        init: ->
          @test = "hello"
      non = test.create hello: "world"
      should.exist non
      should.exist non.init
      non.init()
      should.exist non.test
      should.exist non.get 'hello'
      non.test.should.equal "hello"
      done()

    it 'should get/set/has/remove', (done) ->
      o = mixer.module().create()
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
      o = mixer.module().create()
      should.exist o

      o.on 'change', (k, v) ->
        should.exist v
        v.should.equal 'hello'
        done()
      o.set 'test', 'hello'

    it 'should emit namespaced event on set', (done) ->
      o = mixer.module().create()
      should.exist o

      o.on 'change.test', (v) ->
        should.exist v
        v.should.equal 'hello'
        done()
      o.set 'test', 'hello'

    it 'should emit event on remove', (done) ->
      o = mixer.module().create()
      should.exist o

      o.on 'remove', (k) ->
        should.exist k
        k.should.equal 'test'
        done()
      o.remove 'test'

    it 'should emit namespaced event on remove', (done) ->
      o = mixer.module().create()
      should.exist o

      o.on 'remove.test', done
      o.remove 'test'

  describe 'global events', ->
    it 'should emit event on set', (done) ->
      o = mixer.module().create()
      should.exist o
      mixer.on 'change', (mod, k, v) ->
        should.exist mod
        should.exist k
        should.exist v
        mod.should.equal o
        k.should.equal 'test'
        v.should.equal 'hello'
        mixer.removeAllListeners()
        done()
      o.set 'test', 'hello'

    it 'should emit namespaced event on set', (done) ->
      o = mixer.module().create()
      should.exist o

      mixer.on 'change.test', (mod, v) ->
        should.exist v
        should.exist mod
        mod.should.equal o
        v.should.equal 'hello'
        mixer.removeAllListeners()
        done()
      o.set 'test', 'hello'

    it 'should emit event on remove', (done) ->
      o = mixer.module().create()
      should.exist o

      mixer.on 'remove', (mod, k) ->
        should.exist mod
        should.exist k
        mod.should.equal o
        k.should.equal 'test'
        mixer.removeAllListeners()
        done()
      o.remove 'test'

    it 'should emit namespaced event on remove', (done) ->
      o = mixer.module().create()
      should.exist o

      mixer.on 'remove.test', (mod) ->
        should.exist mod
        mod.should.equal o
        mixer.removeAllListeners()
        done()
      o.remove 'test'