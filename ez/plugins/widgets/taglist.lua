local awful     = require("awful")

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
    return awful.widget.taglist(screen,
				awful.widget.taglist.filter.all,
				taglist_buttons)
end
