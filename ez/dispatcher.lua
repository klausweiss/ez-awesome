local dispatcher = function(dispatching_function)
   local dispatcher_meta = {
      __newindex = function(_table, key, value)
	 return dispatching_function(key, value)
      end
   }

   return setmetatable({}, dispatcher_meta)
end

return dispatcher
