local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")

local stdlib  = require("ez.stdlib")
local ez      = require("ez")
local client  = ez.client
local layouts = ez.layouts
local mouse   = ez.mouse
local tags    = ez.tags


local widget_factories = {
   launcher_menu = function (_screen)
      local awesome_menu = {
	 { "restart", awesome.restart },
	 { "quit",    function () awesome.quit() end },
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
	 awful.button({}, mouse._buttons_numbers.left_click,  tags.show_only_tag),
	 awful.button({}, mouse._buttons_numbers.right_click, tags.toggle_tag),
	 awful.button({}, mouse._buttons_numbers.wheel_up,    tags.show_next_tag),
	 awful.button({}, mouse._buttons_numbers.wheel_down,  tags.show_previous_tag)
      )
      return awful.widget.taglist(screen,
				  awful.widget.taglist.filter.all,
				  taglist_buttons)
   end,

   tasklist = function (screen)
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
	 awful.button({}, mouse._buttons_numbers.wheel_up,    client.focus_next_client),
	 awful.button({}, mouse._buttons_numbers.wheel_down,  client.focus_previous_client))
      return awful.widget.tasklist(screen,
				   awful.widget.tasklist.filter.currenttags,
				   tasklist_buttons)
   end,

   tray = function (_screen) return wibox.widget.systray() end,

   time = function (_screen) return wibox.widget.textclock("%H:%M") end,

   layouts_switcher = function (screen)
      local layoutbox_buttons = stdlib.jointables(
	 awful.button({}, mouse._buttons_numbers.left_click,  layouts.next_layout),
	 awful.button({}, mouse._buttons_numbers.right_click, layouts.prev_layout),
	 awful.button({}, mouse._buttons_numbers.wheel_up,    layouts.next_layout),
	 awful.button({}, mouse._buttons_numbers.wheel_down,  layouts.prev_layout)
      )
      local layoutbox = awful.widget.layoutbox(screen)
      layoutbox:buttons(layoutbox_buttons)
      return layoutbox
   end,
}


local getter = function (key) return widget_factories[key] end

return {
   getter = getter,
   export = {
      "launcher_menu",
      "taglist",
      "tasklist",
      "tray",
      "time",
      "layouts_switcher",
   }
}
