local awful     = require("awful")
local beautiful = require("beautiful")


return function (_screen)
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
end
