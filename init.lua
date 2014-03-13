local argcheck = require 'argcheck'
local argcheckenv = require 'argcheck.env'

local class = {}
local classes = {}
local isofclass = {}

-- create a constructor table
local function constructortbl(metatable)
   local ct = {}
   setmetatable(ct, {
                   __index=metatable,
                   __newindex=metatable,
                   __metatable=metatable,
                   __call=function(self, ...)
                             return self.new(...)
                          end
                })
   return ct
end

class.new = argcheck{
   {name="name", type="string"},
   {name="parentname", type="string", opt=true},
   call =
      function(name, parentname)
         assert(not classes[name], string.format('class <%s> already exists', name))

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
         isofclass[name] = {[name]=true}

         if parentname then
            assert(classes[parentname], string.format('parent class <%s> does not exist', parentname))
            setmetatable(class, classes[parentname])
            isofclass[parentname][name] = true
            return constructortbl(class), classes[parentname]
         else
            return constructortbl(class)
         end
      end
}

class.factory = argcheck{
   {name="name", type="string"},
   call =
      function(name)
         assert(classes[name], string.format('unknown class <%s>', name))
         local t = {}
         setmetatable(t, classes[name])
         return t
      end
}

class.metatable = argcheck{
   {name="name", type="string"},
   call =
      function(name)
         return classes[name]
      end
}

function class.type(obj)
   local tname = type(obj)
   if tname == 'table' then
      local mt = getmetatable(obj)
      if mt then
         return rawget(mt, '__typename') or tname
      end
   end
   return tname
end

function class.istype(obj, typename)
   local tname = type(obj)
   if tname == 'table' then
      local mt = getmetatable(obj)
      if mt then
         local objname = rawget(mt, '__typename')
         if objname then -- we are now sure it is one of our object
            local valid = isofclass[typename]
            if valid then
               return rawget(valid, objname) or false
            else
               return false
            end
         end
      end
   end
   return tname == typename
end

-- make sure argcheck understands those types
argcheckenv.istype = class.istype

-- allow class() instead of class.new()
setmetatable(class, {__call=
                        function(self, ...)
                           return self.new(...)
                        end})

return class
