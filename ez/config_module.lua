local awful         = require("awful")
local plugin_loader = require("ez.plugins._loader")


-- Setup functions need to be called in order (ez.theme needs to be loaded first)
local ordered_setup_functions = {}
local cached_plugins = {}


local reapply_client_rules = function ()
   for _, client_ in ipairs(client.get()) do
      awful.rules.apply(client_)
   end
end

local getters = {
   setup = function()
      for _, setup_function in ipairs(ordered_setup_functions) do
	 setup_function()
      end
      reapply_client_rules()
   end,
}

local add_setup_function = function (setup_function)
   -- Loaded plugins are cached, so each setup functions is added exactly once
   table.insert(ordered_setup_functions, setup_function)
end

-- Lazily loads plugin
local plugin_getter = function (key)
   if cached_plugins[key] then return cached_plugins[key] end

   local submodule_, submodule_metadata
   local status, error_ = pcall(function()
	 submodule_, submodule_metadata = plugin_loader(key)
   end)
   if status then
      if submodule_metadata.setup then
	 add_setup_function(submodule_metadata.setup)
      end
      local plugin = {
	 submodule = submodule_,
	 default_setter = submodule_metadata.default_setter,
      }
      cached_plugins[key] = plugin
      return plugin
   else
      error("Couldn't load plugin " .. key .. ". Cause:\n" .. error_)
   end
end

local getter = function (key)
   return getters[key] or plugin_getter(key).submodule
end

local setter = function (key, value)
   local plugin = plugin_getter(key)
   plugin.default_setter(value)
end

return {
   setter = setter,
   getter = getter,
}
