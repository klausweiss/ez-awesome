local awful = require("awful")


return {
   getter = {
      focus_left  = function () awful.screen.focus_bydirection("left",  awful.screen.focused()) end,
      focus_right = function () awful.screen.focus_bydirection("right", awful.screen.focused()) end,
      move_client = function (client_) c:move_to_screen() end,
   }
}
