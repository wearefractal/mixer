![status](https://secure.travis-ci.org/wearefractal/mixer.png?branch=master)

## Information

<table>
<tr> 
<td>Package</td><td>mixer</td>
</tr>
<tr>
<td>Description</td>
<td>Observable models</td>
</tr>
<tr>
<td>Node Version</td>
<td>*</td>
</tr>
<tr>
<td>Size</td>
<td>3.8k</td>
</tr>
</table>

If you don't like the coffee-script examples use js2coffee for a conversion.

## Usage

### Creating a simple module

```coffee-script
class Crap extends mixer.Module
  test: ->
    @set "hello", "test"

instance = new Crap

instance.test()

console.log instance.get("test") # hello

instance.on "change:prop", (val) ->
  console.log "prop changed to #{val}"

instance.set 'prop', 123
```

### Creating a module with a constructor

```coffee-script
class SweetModule extends mixer.Module
  constructor: (sweet) ->
    @set 'sweet', sweet

instance = new SweetModule true

console.log instance.get('sweet') # true

instance.on "change:sweet", (bool) ->
  if bool is true
    console.log "module is now sweet!"
  else
    console.log "module is no longer sweet!"

instance.set 'sweet', false
```

## Modules

All functions of a module should return the module to be chainable. All modules are an EventEmitter.

##### get(key)

Returns value of key or undefined

##### set(key, val[, silent=false])

Sets the value of key to val. 

Will emit ```change, (key, val)``` and ```change:key, (val)``` unless silent is true.

Global mixer object will emit ```change, (module, key, val)``` and ```change:key, (module, val)``` unless silent is true.

##### has(key)

Will return true if key exists, false if it doesn't.

##### remove(key[, silent=false])

Delete the value of key.

Will emit ```change, (key)``` ```change:key``` ```remove, (key)``` and ```remove:key``` unless silent is true.

Global mixer object will emit ```change, (module, key)``` ```change:key, (module)``` ```remove, (module, key)``` ```remove:key, (module)``` unless silent is true.

## LICENSE

(MIT License)

Copyright (c) 2012 Fractal <contact@wearefractal.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
