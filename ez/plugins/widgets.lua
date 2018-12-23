local awful     = require("awful")
local beautiful = require("beautiful")

local stdlib = require("ez.stdlib")
local ez     = require("ez")
local mouse  = ez.mouse
local tags   = ez.tags


local widget_factories = {
   launcher = function (_screen)
      local awesome_menu = {
	 { "restart", awesome.restart },
	 { "quit",    awesome.quit },
      }
      local menu = awful.menu({
	    items = awesome_menu,
      })
      local launcher = awful.widget.launcher({
	    image = beautiful.awesome_icon,
	    menu = menu,
      })
      return launcher
   end,

   taglist = function (screen)
      local taglist_buttons = stdlib.jointables(
	 awful.button({}, mouse._buttons_numbers.left_click,  tags.show_only),
	 awful.button({}, mouse._buttons_numbers.right_click, tags.toggle),
	 awful.button({}, mouse._buttons_numbers.wheel_up,    tags.show_next),
	 awful.button({}, mouse._buttons_numbers.wheel_down,  tags.show_previous)
      )
      return awful.widget.taglist(screen,
				  awful.widget.taglist.filter.all,
				  taglist_buttons)
   end,
}


local getter = function (key) return widget_factories[key] end

return {
   getter = getter,
}
