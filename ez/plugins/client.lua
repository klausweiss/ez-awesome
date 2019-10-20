local awful = require("awful")
local wibox = require("wibox")

local stdlib = require("ez.stdlib")
local ez     = require("ez")
local mouse  = ez.mouse


local widgets = {
   close    = awful.titlebar.widget.closebutton,
   icon     = awful.titlebar.widget.iconwidget,
   floating = awful.titlebar.widget.floatingbutton,
   maximize = awful.titlebar.widget.maximizedbutton,
   minimize = awful.titlebar.widget.minimizebutton,
   ontop    = awful.titlebar.widget.ontopbutton,
   sticky   = awful.titlebar.widget.stickybutton,
   title    = function (c) return { align = "center", widget = awful.titlebar.widget.titlewidget(c) } end,
}

local titlebar_config = {
   left_widgets_factories = {
      "icon",
   },
   middle_widgets_factories = {
      "title",
   },
   right_widgets_factories = {
      "minimize",
      "maximize",
      "close",
   },
}

local focus_next  = function () awful.client.focus.byidx( 1) end
local focus_prev  = function () awful.client.focus.byidx(-1) end
local focus_up    = function () awful.client.focus.bydirection("up") end
local focus_right = function () awful.client.focus.bydirection("right") end
local focus_down  = function () awful.client.focus.bydirection("down") end
local focus_left  = function () awful.client.focus.bydirection("left") end

local functions = {
   toggle_focus_minimize_client = function (client_)
      if client_ == client.focus then
	 client_.minimized = true
      else
	 client_.minimized = false
	 if not client_:isvisible() and client_.first_tag then
	    client_.first_tag:view_only()
	 end
	 client.focus = client_
	 client_:raise()
      end
   end,

   toggle_fullscreen_client = function (client_)
      client_.fullscreen = not client_.fullscreen
      client_:raise()
   end,

   toggle_maximize_client = function (client_)
      client_.maximized = not client_.maximized
      client_:raise()
   end,

   close_client = function (client_)
      client_:kill()
   end,

   focus_client          = function (client_) client.focus = client_; client_:raise() end, 
   focus_next_client     = focus_next,
   focus_prev_client     = focus_prev,
   focus_previous_client = focus_prev,
   focus_up_client       = focus_up,
   focus_right_client    = focus_right,
   focus_down_client     = focus_down,
   focus_left_client     = focus_left,

   move_client   = awful.mouse.client.move,
   resize_client = awful.mouse.client.resize,

   restore_random_client = awful.client.restore,
   restore_and_focus_random_client = function ()
      local client_ = awful.client.restore()
      if client_ then
	 client.focus = client_
      end
   end,
}


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

   local left = stdlib.joindicts(
      {
	 buttons = titlebar_mouse_handlers,
	 layout  = wibox.layout.fixed.horizontal,
      },
      stdlib.map(function (factory) return factory(client_) end,
	 stdlib.map(stdlib.getter(widgets), titlebar_config.left_widgets_factories)
      )
   )

   local middle = stdlib.joindicts(
      {
	 buttons = titlebar_mouse_handlers,
	 layout  = wibox.layout.flex.horizontal,
      },
      stdlib.map(function (factory) return factory(client_) end,
	 stdlib.map(stdlib.getter(widgets), titlebar_config.middle_widgets_factories)
      )
   )

   local right = stdlib.joindicts(
      {
	 layout  = wibox.layout.fixed.horizontal,
      },
      stdlib.map(function (factory) return factory(client_) end,
	 stdlib.map(stdlib.getter(widgets), titlebar_config.right_widgets_factories)
      )
   )

   awful.titlebar(client_):setup {
      layout = wibox.layout.align.horizontal,
      left,
      middle,
      right,
				 }
end

local signals = stdlib.settertable(function (signal, handler)
      client.connect_signal(signal, handler)
end)

local setup_focus_follow_mouse = function ()
   require("awful.autofocus")
   signals["mouse::enter"] = handler_mouse_enter
end

local add_client_rules = function ()
   local client_rules = {
      {
	 rule_any = {
	    type = {"normal", "dialog"},
	 },
	 properties = {
	    focus = awful.client.focus.filter,
	    titlebars_enabled = true,
	    screen = awful.screen.preferred,
	 },
      }
   }
   stdlib.extendtable(awful.rules.rules, client_rules)
end

local setup = function ()
   signals["manage"]             = handler_manage
   signals["focus"]              = handler_focus
   signals["unfocus"]            = handler_unfocus
   signals["request::titlebars"] = handler_request_titlebars

   if clients_config.focus_follow_mouse then
      setup_focus_follow_mouse()
   end

   add_client_rules()
end

local setter = {
   focus_follow_mouse = function (value)
      clients_config.focus_follow_mouse = value
   end,
   titlebar_left = function (value)
      titlebar_config.left_widgets_factories = value
   end,
   titlebar_middle = function (value)
      titlebar_config.middle_widgets_factories = value
   end,
   titlebar_right = function (value)
      titlebar_config.right_widgets_factories = value
   end,
}

local nested_setters = {
   titlebar = stdlib.settertable(function (key, value)
	 setter["titlebar_" .. key](value)
   end),
}

local setters = function (key, value) return setter[key](value) end

return {
   getter = stdlib.joindicts(stdlib.keys(widgets),
			     functions,
			     nested_setters),
   setter = setters,
   setup  = setup,
   export = stdlib.joindicts(stdlib.keys(widgets),
			     stdlib.keys(functions),
			     stdlib.keys(nested_setters))
}
