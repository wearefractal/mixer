mixer = require '../'
should = require 'should'
require 'mocha'

describe 'core', ->
  describe 'nu()', ->
    it 'should create new nu from empty', (done) ->
      o = mixer.nu()
      should.exist o
      done()

    it 'should create new nu from object', (done) ->
      o = mixer.nu test: "hello"
      should.exist o
      should.exist o.test
      o.test.should.equal "hello"
      done()

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
  describe 'create()', ->
    it 'should create module from empty', (done) ->
      o = mixer.create()
      should.exist o
      done()

    it 'should create module from object', (done) ->
      o = mixer.create test: "hello"
      should.exist o
      should.exist o.test
      o.test.should.equal "hello"
      done()

    it 'should create module from module', (done) ->
      o = mixer.create(test: "hello").set('hello','world')
      non = o.create()
      should.exist non
      should.exist non.test
      should.not.exist non.get 'hello'
      non._.id.should.not.equal o._.id
      non.test.should.equal "hello"
      done()

    it 'should extend module with overrides', (done) ->
      opt =
        test: "hello"
        create: (o) -> mixer.create(@clone(), o).set 'hello', 'world'

      o = mixer.create opt
      non = o.create()
      should.exist non
      should.exist non.test
      should.exist non.get 'hello'
      non._.id.should.not.equal o._.id
      non.test.should.equal "hello"
      done()

    it 'should get/set/has/remove', (done) ->
      o = mixer.create()
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
      o = mixer.create()
      should.exist o

      o.on 'change', (k, v) ->
        should.exist v
        v.should.equal 'hello'
        done()
      o.set 'test', 'hello'

    it 'should emit namespaced event on set', (done) ->
      o = mixer.create()
      should.exist o

      o.on 'change:test', (v) ->
        should.exist v
        v.should.equal 'hello'
        done()
      o.set 'test', 'hello'

    it 'should emit event on remove', (done) ->
      o = mixer.create()
      should.exist o

      o.on 'remove', (k) ->
        should.exist k
        k.should.equal 'test'
        done()
      o.remove 'test'

    it 'should emit namespaced event on remove', (done) ->
      o = mixer.create()
      should.exist o

      o.on 'remove:test', done
      o.remove 'test'

  describe 'global events', ->
    it 'should emit event on set', (done) ->
      o = mixer.create()
      should.exist o
      mixer.on 'change', (mod, k, v) ->
        should.exist mod
        should.exist k
        should.exist v
        mod.should.equal o
        k.should.equal 'test'
        v.should.equal 'hello'
        mixer.offAll()
        done()
      o.set 'test', 'hello'

    it 'should emit namespaced event on set', (done) ->
      o = mixer.create()
      should.exist o

      mixer.on 'change:test', (mod, v) ->
        should.exist v
        should.exist mod
        mod.should.equal o
        v.should.equal 'hello'
        mixer.offAll()
        done()
      o.set 'test', 'hello'

    it 'should emit event on remove', (done) ->
      o = mixer.create()
      should.exist o

      mixer.on 'remove', (mod, k) ->
        should.exist mod
        should.exist k
        mod.should.equal o
        k.should.equal 'test'
        mixer.offAll()
        done()
      o.remove 'test'

    it 'should emit namespaced event on remove', (done) ->
      o = mixer.create()
      should.exist o

      mixer.on 'remove:test', (mod) ->
        should.exist mod
        mod.should.equal o
        mixer.offAll()
        done()
      o.remove 'test'