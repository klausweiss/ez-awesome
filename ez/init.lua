local submodule     = require("ez.submodule")
local config_module = require("ez.config_module")


local load_default_plugins = function(ez_)
   local _
   -- Needs to be loaded first
   _ = ez_.theme

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

local init_ez = function (ez_)
   -- prevent recursively calling this function while importing module
   if __ez_initiated then return end
   __ez_initiated = true

   load_default_plugins(ez_)
   awesome.connect_signal("startup", ez_.setup)
end

local ez = submodule(config_module)
init_ez(ez)

return ez
