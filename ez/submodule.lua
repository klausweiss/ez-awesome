-- support plugins returning a setter function
-- taking parameters key and value
-- 
--   ez.plugin.key = value
--
local function_setter_dispatcher = function (setter)
   return {
      __newindex = function (_table, key, value)
	 return setter(key, value)
      end
   }
end

-- support plugins returning a setter function
-- taking parameters key and value
-- and a getter table or function
-- taking parameter key
--
-- local value = ez.plugin.key
--
local table_setter_getter_dispatcher = function (module_)
   local setter = module_[1]
   local getter = module_[2]

   -- support table of constants and a getter function
   local type_getters = {}
   type_getters["table"] = function (table_, key) return table_[key] end
   type_getters["function"] = function (_table, key) return getter(key) end
   local getter_function = type_getters[type(getter)]

   return {
      __newindex = function (_table, key, value)
	 return setter(key, value)
      end,
      __index = getter_function
   }
end

-- support plugins exporting only a setter
-- and those exporting both setter and getter
local type_dispatcher = {}
type_dispatcher["table"] = table_setter_getter_dispatcher
type_dispatcher["function"] = function_setter_dispatcher

local submodule = function (module_)
   local dispatcher = type_dispatcher[type(module_)]
   local meta_table = dispatcher(module_)
   return setmetatable({}, meta_table)
end

return submodule
