local awful         = require("awful")
local plugin_loader = require("ez.plugins._loader")


local cached_plugins = {}
-- Setup functions need to be called in particular order
-- (ez.theme needs to be loaded first)
local cached_plugins_ordered = {}


-- Lazily loads plugin
local plugin_getter = function (key)
   if cached_plugins[key] then return cached_plugins[key] end

   local submodule_, submodule_metadata
   local status, error_ = pcall(function()
	 submodule_, submodule_metadata = plugin_loader(key)
   end)
   if status then
      local plugin = {
	 submodule = submodule_,
	 metadata  = submodule_metadata,
      }
      cached_plugins[key] = plugin
      table.insert(cached_plugins_ordered, plugin)
      return plugin
   else
      error("Couldn't load plugin " .. key .. ". Cause:\n" .. error_)
   end
end

local reapply_client_rules = function ()
   for _, client_ in ipairs(client.get()) do
      awful.rules.apply(client_)
   end
end

-- if plugin exports /setup/ function, it will be called
-- after configuration is done
local setup = function()
   for _, plugin in ipairs(cached_plugins_ordered) do
      if plugin.metadata.setup then
	 plugin.metadata.setup()
      end
   end
   reapply_client_rules()
end

local getter = function (key)
   return plugin_getter(key).submodule
end

-- if plugin exports /default_setter/ function, it will be called
-- when assigning value to the plugin:
--
--   ez.plugin = value
--
local setter = function (key, value)
   local plugin = plugin_getter(key)
   plugin.metadata.default_setter(value)
end

return {
   getter = getter,
   setter = setter,
   setup  = setup,
}
