local awful = require("awful")
local a_layouts = awful.layout.suit

local stdlib = require("ez.stdlib")


local setters = {
   layouts = function (value)
      awful.layout.layouts = value
   end
}

local setter = function (key, value) return setters[key](value) end

local layouts = {
   tile        = a_layouts.tile,
   tile_right  = a_layouts.tile,
   tile_left   = a_layouts.tile.left,
   tile_up     = a_layouts.tile.up,
   tile_bottom = a_layouts.tile.bottom,

   fair            = a_layouts.fair,
   fair_vertical   = a_layouts.fair,
   fair_horizontal = a_layouts.fair.horizontal,

   spiral         = a_layouts.spiral,
   spiral_dwindle = a_layouts.spiral.dwindle,

   magnifier = a_layouts.magnifier,

   floating = a_layouts.floating,

   max        = a_layouts.max,
   fullscreen = a_layouts.max.fullscreen,

   ne = a_layouts.corner.ne,
   se = a_layouts.corner.se,
   sw = a_layouts.corner.sw,
   nw = a_layouts.corner.nw,
}

local functions = {
   next_layout        = function () awful.layout.inc( 1) end,
   prev_layout        = function () awful.layout.inc(-1) end,
   select_main_client = function (client_) c:swap(awful.client.getmaster()) end,
}

local properties = stdlib.jointables(layouts,
				     functions)

return {
   setter = setter,
   getter = properties,
   -- tags.lua depends on this module not exporting a setup function
}
