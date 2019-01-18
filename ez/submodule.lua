-- if a plugin exports a /setter/ function, it will be called
-- with /key/ and /value/ as parameters when assigning a value:
--
--   ez.plugin.key = value
--
-- if it exports a /getter/ function, it will be called
-- with /key/ as a parameter when getting a value:
--
--   local value = ez.plugin.key
--
local table_dispatcher = function (raw_module_)
   local setter = raw_module_.setter
   local getter = raw_module_.getter

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

local export_variables_to_global_scope = function (exported_variables, submodule_)
   for _, variable in pairs(exported_variables) do
      _G[variable] = submodule_[variable]
   end
end

-- module variables defined in `raw_module_.export`
-- will be exported to the global scope
local submodule = function (raw_module_)
   local meta_table = table_dispatcher(raw_module_)
   local submodule_ = setmetatable({}, meta_table)

   if raw_module_.export then
      export_variables_to_global_scope(raw_module_.export, submodule_)
   end

   return submodule_, raw_module_
end

return submodule
