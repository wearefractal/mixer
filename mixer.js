// Generated by CoffeeScript 1.3.3
(function() {
  var Base, EventEmitter, Module, guids, mixer,
    __slice = [].slice;

  EventEmitter = (function() {

    function EventEmitter() {
      this.events = {};
    }

    EventEmitter.prototype.emit = function() {
      var args, e, listener, _i, _len, _ref;
      e = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (!this.events[e]) {
        return false;
      }
      _ref = this.events[e];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        listener = _ref[_i];
        listener.apply(null, args);
      }
      return true;
    };

    EventEmitter.prototype.addListener = function(e, listener) {
      var _base, _ref;
      this.emit('newListener', e, listener);
      ((_ref = (_base = this.events)[e]) != null ? _ref : _base[e] = []).push(listener);
      return this;
    };

    EventEmitter.prototype.on = EventEmitter.prototype.addListener;

    EventEmitter.prototype.once = function(e, listener) {
      var fn,
        _this = this;
      fn = function() {
        _this.removeListener(e, fn);
        return listener.apply(null, arguments);
      };
      this.on(e, fn);
      return this;
    };

    EventEmitter.prototype.removeListener = function(e, listener) {
      var l;
      if (!this.events[e]) {
        return this;
      }
      this.events[e] = (function() {
        var _i, _len, _ref, _results;
        _ref = this.events[e];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          l = _ref[_i];
          if (l !== listener) {
            _results.push(l);
          }
        }
        return _results;
      }).call(this);
      return this;
    };

    EventEmitter.prototype.removeAllListeners = function(e) {
      if (e != null) {
        delete this.events[e];
      } else {
        this.events = {};
      }
      return this;
    };

    EventEmitter.prototype.off = EventEmitter.prototype.removeListener;

    EventEmitter.prototype.offAll = EventEmitter.prototype.removeAllListeners;

    return EventEmitter;

  })();

  Base = function() {};

  Module = {
    clone: function() {
      return mixer.module(this);
    },
    extend: function(o) {
      return mixer.extend(this, o);
    },
    get: function(k) {
      return this._.props[k];
    },
    set: function(k, v, silent) {
      if (silent == null) {
        silent = false;
      }
      this._.props[k] = v;
      if (!silent) {
        this.emit("change", k, v);
        this.emit("change:" + k, v);
        mixer.emit("change", this, k, v);
        mixer.emit("change:" + k, this, v);
      }
      return this;
    },
    has: function(k) {
      return this._.props[k] != null;
    },
    remove: function(k, silent) {
      if (silent == null) {
        silent = false;
      }
      delete this._.props[k];
      if (!silent) {
        this.emit("change", k);
        this.emit("change:" + k);
        mixer.emit("change", this, k);
        mixer.emit("change:" + k, this);
        this.emit("remove", k);
        this.emit("remove:" + k);
        mixer.emit("remove", this, k);
        mixer.emit("remove:" + k, this);
      }
      return this;
    },
    emit: function() {
      var a, _ref;
      a = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      (_ref = this._.events).emit.apply(_ref, a);
      return this;
    },
    on: function(e, fn) {
      this._.events.on(e, fn.bind(this));
      return this;
    },
    once: function(e, fn) {
      this._.events.once(e, fn.bind(this));
      return this;
    },
    off: function() {
      var a, _ref;
      a = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      (_ref = this._.events).off.apply(_ref, a);
      return this;
    },
    offAll: function() {
      var a, _ref;
      a = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      (_ref = this._.events).offAll.apply(_ref, a);
      return this;
    }
  };

  guids = -1;

  mixer = {
    _: {},
    create: function(o) {
      var inst;
      inst = mixer.nu(o);
      mixer.extend(inst, Module);
      inst.guid = ++guids;
      inst._ = mixer._[inst.guid] = {
        props: {},
        events: new EventEmitter
      };
      return inst;
    },
    nu: function(o) {
      Base.prototype = o;
      return new Base;
    },
    clone: function(o) {
      return mixer.extend({}, o);
    },
    extend: function(o, n) {
      var k, v;
      for (k in n) {
        v = n[k];
        o[k] = v;
      }
      return o;
    }
  };

  mixer.extend(mixer, new EventEmitter);

  if (typeof module !== "undefined" && module !== null) {
    module.exports = mixer;
  } else {
    window.mixer = mixer;
  }

}).call(this);
