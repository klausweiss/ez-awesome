-- support plugins returning a setter function
-- taking parameters key and value
--
-- ez.plugin.key = value
--
-- and a getter table or function
-- taking parameter key
--
-- local value = ez.plugin.key
--
local table_dispatcher = function (module_)
   local setter = module_.setter
   local getter = module_.getter

   -- support table of constants and a getter function
   local type_getters = {}
   type_getters["table"]    = function (_table, key) return getter[key] end
   type_getters["function"] = function (_table, key) return getter(key) end
   local getter_function = type_getters[type(getter)]

   return {
      __newindex = function (_table, key, value) return setter(key, value) end,
      __index = getter_function,
   }
end

local set_global_variables = function (exported_variables, submodule_)
   for _, variable in pairs(exported_variables) do
      _G[variable] = submodule_[variable]
   end
end


-- setup function (function to be called after the whole setup)
-- can be set under the /setup/ key in the exported table
local submodule = function (module_)
   local meta_table = table_dispatcher(module_)
   local setup = module_.setup
   local submodule_ = setmetatable({}, meta_table)

   if module_.export then
      set_global_variables(module_.export, submodule_)
   end

   return submodule_, setup
end

return submodule
