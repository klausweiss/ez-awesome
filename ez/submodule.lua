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

-- support plugins exporting only a setter
-- and those exporting both setter and getter
--
-- setup function (function to be called after the whole setup)
-- can be set in when the module is exported as a table
-- under the /setup/ key
local type_dispatcher = {}
type_dispatcher["table"]    = table_dispatcher
type_dispatcher["function"] = function_setter_dispatcher

local submodule = function (module_)
   local dispatcher = type_dispatcher[type(module_)]
   local meta_table = dispatcher(module_)

   local setup
   if type(module_) == "table" then
      setup = module_.setup
   end

   return setmetatable({}, meta_table), setup
end

return submodule
