local awful = require("awful")

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
    return awful.widget.tasklist(screen,
				 awful.widget.tasklist.filter.currenttags,
				 tasklist_buttons)
end
