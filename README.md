Object Classes for Lua
----------------------

This package provide simple object-oriented capabilities to Lua.
Each class is defined with a metatable, which contains methods.
Inheritance is achieved by setting metatables over metatables.
An efficient type checking is provided.

## Typical Example

```lua
local class = require 'class'

-- define some dummy A class
local A = class('A')

function A:__init(stuff)
  self.stuff = stuff
end

function A:run()
  print(self.stuff)
end

-- define some dummy B class, inheriting from A
local B = class('B', 'A')

function B:run5()
  for i=1,5 do
    print(self.stuff)
  end
end

-- create some instances of both classes
local a = A('hello world from A')
local b = B('hello world from B')

-- run stuff
a:run()
b:run()
b:run5()
```

## Documentation

First, require the package
```lua
local class = require 'class'
```
Note that `class` does not clutter the global namespace.

Class metatables are then created with `class(name)` or equivalently `class.new(name)`.
```lua
local A = class('A')
local B = class('B', 'A') -- B inherit from A
```

You then have to fill-up the returned metatable with methods.
```lua
function A:myMethod()
  -- do something
end
```

There are two special methods: `new()`, which already exists when the class is created and _should not be overrided_
and `__init()` which is called by `new()` at the creation of the class.
```lua
function A:__init(args)
  -- do something with args
  -- note that self exists
end
```

Creation of an instance is then achieved with the `new()` function or (equivalently) using the Lua `__call` metamethod:
```lua
local a = A('blah blah') -- an instance of A
local aa = A.new('blah blah') -- equivalent of the above
```

### `class.new(name[, parentname])`

Creates a new class called `name`, which might optionally inherit from `parentname`.
Returns a table, in which methods should be defined.

Note that the returned table is not the metatable, but a _constructor_ table (with a `__call`
function defined). In that respect, one can use the following shorthand:
```lua
local A = class.new('A')
local a = A.new() -- instance.
local aa = A()    -- another instance (shorthand).
```

There is also a shorthand`class.new()`, which is `class()`.

### `class.factory(name)`

Return a new (empty) instance of the class `name`. No `__init` method will be called.

### `class.metatable(name)`

Return the metatable (i.e. the table containing all methods) related to class `name`.

### `class.type(obj)`

Return the type of the object `obj` (if this is a known class), or the type
returned by the standard lua `type()` function (if it is not known).

### `class.istype(obj, name)`

Check is `obj` is an instance (or a child) of class `name`. Returns a boolean.


