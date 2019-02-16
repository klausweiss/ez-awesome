local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local stdlib    = require("ez.stdlib")

local config = {
   gaps      = nil,
   theme     = gears.filesystem.get_themes_dir() .. "default/theme.lua",
   wallpaper = nil,
}

local config_override = {}

local init_theme = function ()
   beautiful.init(config.theme)
end

local init_gaps = function ()
   if not config.gaps then return end

   local client_rules = {
      {
	 rule_any = {
	    type = {"normal", "dialog"},
	 },
	 properties = {
	    size_hints_honor = false,
	 },
      }
   }
   beautiful.useless_gap = config.gaps
   stdlib.extendtable(awful.rules.rules, client_rules)
end

local init_wallpaper = function ()
   if config.wallpaper then
      awful.screen.connect_for_each_screen(function (s)
	    gears.wallpaper.maximized(config.wallpaper, s)
      end)
   end
end

local override_settings = function ()
   for key, value in pairs(config_override) do
      beautiful.get()[key] = value
   end
end

local config_setter = function (property_name)
   return function (value) config[property_name] = value end
end

local override_setter = function (property_name)
   return function (value) config_override[property_name] = value end
end

local path_config_setter = function(property_name)
   local _config_setter = config_setter(property_name)
   return function (value)
      _config_setter(stdlib.expandhome(value))
   end
end

local theme_setter = function (value)
   local path_candidates = {
      stdlib.expandhome("~/.config/awesome/themes/" .. value .. "/theme.lua"),
      gears.filesystem.get_themes_dir() .. value .. "/theme.lua",
      value .. "/theme.lua",
      value,
   }
   local _config_setter = config_setter("theme")

   for _, path in ipairs(path_candidates) do
      if stdlib.fileexists(path) then
	 _config_setter(path)
	 return
      end
   end

   io.stderr:write("theme " .. value .. " not found\n")
end

local setters = {
   gaps      = config_setter("gaps"),
   theme     = theme_setter,
   wallpaper = path_config_setter("wallpaper"),
}

local setter = function (key, value)
   local setter = setters[key] or override_setter(key)
   return setter(value)
end

local setup = function ()
   init_theme()

   init_gaps()
   init_wallpaper()
   override_settings()
end

return {
   setup  = setup,
   setter = setter,
   default_setter = setters.theme,
}
