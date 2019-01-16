local awful         = require("awful")
local plugin_loader = require("ez.plugins._loader")


-- Setting configuration is the plugins' responsibility
local setter = function (key, value)
   io.stderr:write("Tried to write main config key (" .. key .. " := " .. value .. ")\n")
end

-- Setup functions need to be called in order (ez.theme needs to be loaded first)
local setup_functions = {}
local functions_in_order = {}

local reapply_client_rules = function ()
   for _, client_ in ipairs(client.get()) do
      awful.rules.apply(client_)
   end
end

local getters = {
   setup = function()
      for _, setup_function in ipairs(functions_in_order) do
	 setup_function()
      end
      reapply_client_rules()
   end,
}

local add_setup_function = function (setup_function)
   if not setup_functions[setup_function] then
      setup_functions[setup_function] = setup_function
      table.insert(functions_in_order, setup_function)
   end
end

-- Lazily loads plugin
local plugin_getter = function (key)
   local module_, setup_function
   local status, error_ = pcall(function()
	 module_, setup_function = plugin_loader(key)
   end)
   if status then
      if setup_function then
	 add_setup_function(setup_function)
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
