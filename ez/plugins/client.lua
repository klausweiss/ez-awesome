local awful = require("awful")
local wibox = require("wibox")

local stdlib = require("ez.stdlib")
local ez     = require("ez")
local mouse  = ez.mouse


local clients_config = {
   focus_follow_mouse = true,
}

-- called after a new client appears
local handler_manage = function (client_)
  -- Prevent clients from being unreachable after screen count changes.
   if awesome.startup and
      not client_.size_hints.user_position and
      not client_.size_hints.program_position
   then
      awful.placement.no_offscreen(client_)
   end
end

local handler_focus = function (client_)
   -- TODO: visual feedback
end

local handler_unfocus = function (client_)
   -- TODO: visual feedback
end

local handler_mouse_enter = function (client_)
  if awful.layout.get(client_.screen) ~= awful.layout.suit.magnifier
    and awful.client.focus.filter(client_) then
    client.focus = client_
  end
end

local handler_request_titlebars = function (client_)
   local focus         = function () client.focus = client_ client_:raise() end
   local move_client   = function () focus() awful.mouse.client.move(client_) end
   local resize_client = function () focus() awful.mouse.client.resize(client_) end

   local titlebar_mouse_handlers = stdlib.jointables(
      awful.button({}, mouse._buttons_numbers.left_click,  move_client),
      awful.button({}, mouse._buttons_numbers.right_click, resize_client)
   )

   -- TODO: allow configuration
  awful.titlebar(client_):setup {
    layout = wibox.layout.align.horizontal,
    { -- Left
      buttons = titlebar_mouse_handlers,
      layout  = wibox.layout.fixed.horizontal,
      awful.titlebar.widget.iconwidget(client_),
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(client_)
      },
      buttons = titlebar_mouse_handlers,
      layout  = wibox.layout.flex.horizontal,
    },
    { -- Right
      layout = wibox.layout.fixed.horizontal,
      awful.titlebar.widget.floatingbutton (client_),
      awful.titlebar.widget.maximizedbutton(client_),
      awful.titlebar.widget.stickybutton   (client_),
      awful.titlebar.widget.ontopbutton    (client_),
      awful.titlebar.widget.closebutton    (client_),
    },
  }
end

local signals = {}
signals["manage"]             = handler_manage
signals["focus"]              = handler_focus
signals["unfocus"]            = handler_unfocus
signals["request::titlebars"] = handler_request_titlebars

local setup_focus_follow_mouse = function ()
    require("awful.autofocus")
    client.connect_signal("mouse::enter", handler_mouse_enter)
end

local setup = function ()
   for signal, handler in pairs(signals) do
      client.connect_signal(signal, handler)
   end
   if clients_config.focus_follow_mouse then
      setup_focus_follow_mouse()
   end
end

local setter = {
   focus_follow_mouse = function (value)
      clients_config.focus_follow_mouse = value
   end
}

local setters = function (key, value) return setter[key](value) end

return {
   setter = setters,
   setup  = setup,
}
