local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local stdlib  = require("ez.stdlib")
local ez      = require("ez")
local mouse   = ez.mouse
local tags    = ez.tags


return function (screen)
   local taglist_buttons = stdlib.jointables(
      awful.button({}, mouse._buttons_numbers.left_click,  tags.show_only_tag),
      awful.button({}, mouse._buttons_numbers.right_click, tags.toggle_tag),
      awful.button({}, mouse._buttons_numbers.wheel_up,    tags.show_previous_tag),
      awful.button({}, mouse._buttons_numbers.wheel_down,  tags.show_next_tag)
   )
   taglist_args = {
      screen = screen,
      filter = awful.widget.taglist.filter.all,
      buttons = taglist_buttons,
      widget_template = {
	 {
	    {
	       {
		  id = "text_role",
		  widget = wibox.widget.textbox,
	       },
	       layout = wibox.layout.fixed.horizontal
	    },
	    left = 18,
	    right = 18,
	    top = 5,
	    bottom = 5,
	    widget = wibox.container.margin
	 },
	 id  = 'background_role',
	 widget = wibox.container.background,
      }
   }
   return awful.widget.taglist(taglist_args)
end
