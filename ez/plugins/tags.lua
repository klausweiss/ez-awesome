local awful = require("awful")


local functions = {
   show_only = function (tag) return tag:view_only() end,
   show_next = function (tag) return awful.tag.viewnext(tag.screen) end,
   show_prev = function (tag) return awful.tag.viewprev(tag.screen) end,
   toggle    = awful.tag.viewtoggle,
}
functions.show_previous = functions.show_prev

return {
   getter = functions,
}
