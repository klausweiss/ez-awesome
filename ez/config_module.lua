local plugin_loader = require("ez.plugins._loader")


-- Setting configuration is the plugins' responsibility
local setter = function (key, value)
   io.stderr:write("Tried to write main config key (" .. key .. " := " .. value .. ")\n")
end

-- Lazily loads plugin
local getter = function (key)
   local module_
   local status, error_ = pcall(function()
	 module_ = plugin_loader(key)
   end)
   if status then
      return module_
   else
      io.stderr:write("Couldn't find plugin: " .. key .. "\n")
   end
end

return {setter, getter}
