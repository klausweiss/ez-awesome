local plugin_loader = require("ez.plugins._loader")


-- Setting configuration is the plugins' responsibility
local setter = function (key, value)
   io.stderr:write("Tried to write main config key (" .. key .. " := " .. value .. ")\n")
end

local setup_functions = {}

local getters = {
   setup = function()
      for _, setup_function in pairs(setup_functions) do
	 setup_function()
      end
   end,
}

-- Lazily loads plugin
local plugin_getter = function (key)
   local module_, setup_function
   local status, error_ = pcall(function()
	 module_, setup_function = plugin_loader(key)
   end)
   if status then
      if setup_function then
	 setup_functions[setup_function] = setup_function
      end
      return module_
   else
      error("Couldn't load plugin " .. key .. ". Cause:\n" .. error_)
   end
end

return {
   setter = setter,
   getter = function (key)
      return getters[key] or plugin_getter(key)
   end,
}
