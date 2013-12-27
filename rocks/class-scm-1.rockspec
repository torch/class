package = "class"
version = "scm-1"

source = {
   url = "git://github.com/torch/class.git"
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
   "argcheck >= 1"
}

build = {
   type = "builtin",
   modules = {
      ["class.init"] = "init.lua"
   }      
}
