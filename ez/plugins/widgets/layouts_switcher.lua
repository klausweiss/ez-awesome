local awful = require("awful")

local stdlib  = require("ez.stdlib")
local ez      = require("ez")
local layouts = ez.layouts
local mouse   = ez.mouse


return function (screen)
    local layoutbox_buttons = stdlib.jointables(
	awful.button({}, mouse._buttons_numbers.left_click,  layouts.next_layout),
	awful.button({}, mouse._buttons_numbers.right_click, layouts.prev_layout),
	awful.button({}, mouse._buttons_numbers.wheel_up,    layouts.next_layout),
	awful.button({}, mouse._buttons_numbers.wheel_down,  layouts.prev_layout)
    )
    local layoutbox = awful.widget.layoutbox(screen)
    layoutbox:buttons(layoutbox_buttons)
    return layoutbox
end
