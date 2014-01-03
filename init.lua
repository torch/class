local argcheck = require 'argcheck'

local class = {}

local classes = {}

class.new =
   argcheck(
   {{name="name", type="string"},
    {name="parentname", type="string", opt=true}},
   function(name, parentname)   
      assert(not classes[name], 'class <%s> already exists', name)

      local class = {__typename = name, __version=1}
      class.__index = class

      class.__init =
         function()
         end

      class.new =
         function(...)
            local self = {}
            setmetatable(self, class)
            self:__init(...)
            return self
         end
      
      classes[name] = class
      
      if parentname then
         assert(classes[parentname], 'parent class <%s> does not exist', parentname)
         setmetatable(class, classes[parentname])
         return class, classes[parentname]
      else
         return class
      end
   end
)

class.factory =
   argcheck(
   {{name="name", type="string"}},
   function(name)
      assert(classes[name], string.format('unknown class <%s>', name))
      local t = {}
      setmetatable(t, classes[name])
      return t
   end
)

class.metatable =
   argcheck(
   {{name="name", type="string"}},
   function(name)
      return classes[name]
   end
)

local function constructor(metatable, constructor)
   local ct = {}
   setmetatable(ct, {
                   __index=metatable,
                   __newindex=metatable,
                   __metatable=metatable,
                   __call=function(self, ...)
                             return constructor(...)
                          end
                })
   return ct
end

class.constructor =
   argcheck(
   {{name="metatable", type="table"},
    {name="ctname", type="string", default="new"}},
    function(metatable, ctname)
       assert(metatable[ctname], string.format('constructor <%s> does not exist in metatable', ctname))
       return constructor(metatable, metatable[ctname])
    end,

   {{name="metatable", type="table"},
    {name="constructor", type="function"}},
   constructor
)

class.type =
   function(obj)
      local tname = type(obj)
      if tname == 'table' then
         return obj.__typename or tname
      end
      return tname
   end

-- DEBUG: OUCH, THAT IS TOO SLOW
class.istype =
   function(obj, typename)
      local tname = type(obj)
      if tname == 'table' and typename ~= 'table' then
         if obj.__typename then
            obj = getmetatable(obj)
            while type(obj) == 'table' do
               if obj.__typename == typename then
                  return true
               else
                  obj = getmetatable(obj)
               end
            end
            return false
         else
            return tname == typename
         end
      else
         return typename == tname
      end
   end

-- make sure argcheck understands those types
local argcheckenv = getfenv(argcheck)
argcheckenv.type = class.type
argcheckenv.istype = class.istype

return class
