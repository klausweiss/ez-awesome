local awful = require("awful")
local wibox = require("wibox")


local wibar_config = {
   layout   = wibox.layout.align.horizontal,
   position = "bottom",
   left     = {},
   middle   = {},
   right    = {},
}

local make_widgets = function (screen, widget_factories, layout)
   local widgets = {
      layout = layout,
   }
   for _, widget_factory in pairs(widget_factories) do table.insert(widgets, widget_factory(screen)) end
   return widgets
end

local setup_wibar = function (screen)
   local wibar = awful.wibar({ position = wibar_config.position, screen = screen })

   local left   = make_widgets(screen, wibar_config.left,   wibox.layout.fixed.horizontal)
   local middle = make_widgets(screen, wibar_config.middle, wibox.layout.flex.horizontal)
   local right  = make_widgets(screen, wibar_config.right,  wibox.layout.fixed.horizontal)

   wibar:setup({
	 layout = wibar_config.layout,
	 left, middle, right,
   })
end

local setup = function () awful.screen.connect_for_each_screen(setup_wibar) end 
local setter = function (key, value) wibar_config[key] = value end

return {
   setter = setter,
   setup  = setup,
}
