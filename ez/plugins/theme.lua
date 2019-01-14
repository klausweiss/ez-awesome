local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local stdlib    = require("ez.stdlib")

local config = {
   gaps      = nil,
   theme     = gears.filesystem.get_themes_dir() .. "default/theme.lua",
   wallpaper = nil,
}

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
	    gears.wallpaper.fit(config.wallpaper, s)
      end)
   end
end

local config_setter = function (property_name)
   return function (value) config[property_name] = value end
end

local path_config_setter = function(property_name)
   local _config_setter = config_setter(property_name)
   return function (value)
      _config_setter(stdlib.expandhome(value))
   end
end

local setter = {
   gaps      = config_setter("gaps"),
   theme     = path_config_setter("theme"),
   wallpaper = path_config_setter("wallpaper"),
}

local setters = function (key, value) return setter[key](value) end

local setup = function ()
   init_theme()

   init_gaps()
   init_wallpaper()
end

return {
   setup  = setup,
   setter = setters,
}
