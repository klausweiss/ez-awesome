local awful = require("awful")
local a_layouts = awful.layout.suit

local stdlib = require("ez.stdlib")


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

local setters = {
   layouts = function (layouts_)
      awful.layout.layouts = stdlib.map(stdlib.getter(layouts), layouts_)
   end
}

local setter = function (key, value) return setters[key](value) end

local functions = {
   next_layout        = function () awful.layout.inc( 1) end,
   prev_layout        = function () awful.layout.inc(-1) end,
   select_main_client = function (client_) client_:swap(awful.client.getmaster()) end,
}
functions.previous_layout = functions.prev_layout

local properties = stdlib.joindicts(stdlib.keys(layouts),
				    functions)

return {
   setter = setter,
   default_setter = setters.layouts,
   getter = properties,
   -- tags.lua depends on this module not exporting a setup function
   export = stdlib.joindicts(stdlib.keys(layouts),
			     stdlib.keys(functions)),
}
