local wibox = require("wibox")


return function (_screen)
   return wibox.widget.textclock("%H:%M")
end
