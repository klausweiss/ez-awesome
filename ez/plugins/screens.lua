local awful = require("awful")


return {
   getter = {
      focus_left_screen  = function () awful.screen.focus_bydirection("left",  awful.screen.focused()) end,
      focus_right_screen = function () awful.screen.focus_bydirection("right", awful.screen.focused()) end,
      move_client_to_another_screen = function () client.focus:move_to_screen() end,
   },
   export = {
      "focus_left_screen",
      "focus_right_screen",
      "move_client_to_another_screen",
   }
}
