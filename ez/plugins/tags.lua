local awful = require("awful")


local config_tags = {
   tags = {"1", "2", "3", "4", "5", "6", "7", "8", "9"},
}

local functions = {
   show_only = function (tag) return tag:view_only() end,
   show_next = function (tag) return awful.tag.viewnext(tag.screen) end,
   show_prev = function (tag) return awful.tag.viewprev(tag.screen) end,
   toggle    = awful.tag.viewtoggle,
}
functions.show_previous = functions.show_prev

local setters = {
   tags = function (value) config_tags.tags = value end
}

local setup_tags = function (screen)
   -- awful.layout.layouts should be configured now
   awful.tag(config_tags.tags, screen, awful.layout.layouts[1])
end

local setup = function () awful.screen.connect_for_each_screen(setup_tags) end 
local setter = function (key, value) return setters[key](value) end

return {
   getter = functions,
   setter = setter,
   setup  = setup,
}
