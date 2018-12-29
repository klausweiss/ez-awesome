local submodule = require("ez.submodule")
local config_module = require("ez.config_module")

local load_default_plugins = function(ez_)
   -- prevent recursively calling this function
   if __ez_started_loading_plugins then return end
   __ez_started_loading_plugins = true

   local _
   _ = ez_.client
   _ = ez_.errors_handler
   _ = ez_.keyboard
   _ = ez_.layout
   _ = ez_.mouse
   _ = ez_.run
   _ = ez_.screens
   _ = ez_.tags
   _ = ez_.wibar
   _ = ez_.widgets
end

local ez = submodule(config_module)
load_default_plugins(ez)

return ez
