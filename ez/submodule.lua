local function_getter_dispatcher = function(dispatching_function)
   return {
      __newindex = function(_table, key, value)
	 return dispatching_function(key, value)
      end
   }
end

local module_getter_setter_dispatcher = function(module_)
   local dispatching_function = module_[1]
   local constants_table = module_[2]
   return {
      __newindex = function(_table, key, value)
	 return dispatching_function(key, value)
      end,
      __index = function(_table, key)
	 return constants_table[key]
      end
   }
end

local type_dispatcher = {}
type_dispatcher["table"] = module_getter_setter_dispatcher
type_dispatcher["function"] = function_getter_dispatcher

local submodule = function(module_)
   local dispatcher = type_dispatcher[type(module_)]
   local meta_table = dispatcher(module_)
   return setmetatable({}, meta_table)
end

return submodule
