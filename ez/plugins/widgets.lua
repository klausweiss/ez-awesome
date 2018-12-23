local awful     = require("awful")
local beautiful = require("beautiful")


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
   end
}


local getter = function (key) return widget_factories[key] end

return {
   getter = getter,
}
