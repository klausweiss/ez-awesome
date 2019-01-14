local awful    = require("awful")
local gears_wp = require("gears.wallpaper")
local stdlib   = require("ez.stdlib")

local config = {
   wallpaper = nil,
}

local set_wallpaper = function ()
   if config.wallpaper then
      awful.screen.connect_for_each_screen(function (s)
	    gears_wp.fit(config.wallpaper, s)
      end)
   end
end

local setter = {
   wallpaper = function (wallpaper)
      config.wallpaper = stdlib.expandhome(wallpaper)
   end
}

local setters = function (key, value) return setter[key](value) end

local setup = function ()
   set_wallpaper()
end

return {
   setup  = setup,
   setter = setters,
}
