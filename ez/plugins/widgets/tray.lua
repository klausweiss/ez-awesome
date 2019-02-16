local wibox = require("wibox")

local common = require("ez.plugins.widgets.common")


return function (_screen)
   return common.mkwidget(
      common.texticon_box("",
			  wibox.widget.systray()
      )
   )
end
