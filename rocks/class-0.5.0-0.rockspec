package = "class"
version = "0.5.0-0"

source = {
   url = "git://github.com/torch/class.git",
   tag = "0.5.0-0"
}

description = {
   summary = "Class Objects for Lua",
   detailed = [[
   Simple object-oriented system for Lua, with classes supporting
   inheritance.
   ]],
   homepage = "https://github.com/torch/class",
   license = "BSD"
}

dependencies = {
   "lua >= 5.1",
   "argcheck ~> 0.5"
}

build = {
   type = "builtin",
   modules = {
      ["class.init"] = "init.lua"
   }      
}
