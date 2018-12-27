local awful = require("awful")

local stdlib = require("ez.stdlib")


local config_tags = {
   tags = {"1", "2", "3", "4", "5", "6", "7", "8", "9"},
}

local focused_screen = function () return awful.screen.focused() end

local with_current_tag = function (f)
   return function (tag)
      if not tag then tag = focused_screen().selected_tag end
      return f(tag)
   end
end

local by_index = function (f)
   return function (index)
      return function ()
	local tag = focused_screen().tags[index]
	 return f(tag)
      end
   end
end

local functions = {
   show_only       = function (tag) tag:view_only() end,
   show_by_index   = by_index(function (tag) tag:view_only() end),
   show_next       = with_current_tag(function (tag) awful.tag.viewnext(tag.screen) end),
   show_prev       = with_current_tag(function (tag) awful.tag.viewprev(tag.screen) end),
   toggle          = awful.tag.viewtoggle,
   toggle_by_index = by_index(awful.tag.viewtoggle),

   move_focused_client_to_tag   = by_index(function (tag)
	 if client.focus then client.focus:move_to_tag(tag) end
   end),
   toggle_tag_on_focused_client = by_index(function (tag)
	 if client.focus then client.focus:toggle_tag(tag) end
   end),
}
functions.show_previous = functions.show_prev

local setters = {
   tags = function (value) config_tags.tags = value end
}

local setup_tags = function (screen)
   -- awful.layout.layouts should have been configured by now
   awful.tag(config_tags.tags, screen, awful.layout.layouts[1])
end

local setup = function () awful.screen.connect_for_each_screen(setup_tags) end 
local setter = function (key, value) return setters[key](value) end
local getter = function (key)
   if key == "tags" then return config_tags.tags end
   return functions[key]
end

return {
   getter = getter,
   setter = setter,
   setup  = setup,
}
