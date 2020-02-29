local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local stdlib  = require("ez.stdlib")
local ez      = require("ez")
local client  = ez.client
local mouse   = ez.mouse


return function (screen)
   local select_client_instance = nil
   local toggle_select_client_menu = function ()
      if select_client_instance and select_client_instance.wibox.visible then
	 select_client_instance:hide()
	 select_client_instance = nil
      else
	 select_client_instance = awful.menu.clients({ theme = { width = 250 } })
      end
   end

   local tasklist_buttons = stdlib.jointables(
      awful.button({}, mouse._buttons_numbers.left_click,  client.toggle_focus_minimize_client),
      awful.button({}, mouse._buttons_numbers.right_click, toggle_select_client_menu),
      awful.button({}, mouse._buttons_numbers.wheel_up,    client.focus_previous_client),
      awful.button({}, mouse._buttons_numbers.wheel_down,  client.focus_next_client))

   tasklist_args = {
      screen = screen,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = tasklist_buttons,
      widget_template = {
	 {
	    {
	       {
		  {
		     {
			{
			   id = "icon_role",
			   widget = wibox.widget.imagebox,
			},
			bg = "black",
			left = 5,
			right = 5,
			top = 5,
			bottom = 5,
			widget = wibox.container.margin,
		     },
		     bg = "#565656",
		     shape = gears.shape.circle,
		     widget = wibox.container.background,
		  },
		  {
		     top = 10,
		     left = 5,
		     right = 5,
		     widget = wibox.container.margin,
		  },
		  {
		     id = "text_role",
		     widget = wibox.widget.textbox,
		  },
		  layout = wibox.layout.fixed.horizontal,
	       },
	       left = 10,
	       right = 18,
	       top = 5,
	       bottom = 5,
	       widget = wibox.container.margin,
	    },
	    id = "background_role",
	    widget = wibox.container.background,
	 },
	 forced_width = 300,
	 widget = wibox.container.constraint,
      },
   }
   return awful.widget.tasklist(tasklist_args)
end
