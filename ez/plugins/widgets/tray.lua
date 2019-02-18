local wibox = require("wibox")

local common = require("ez.plugins.widgets.common")


return function (_screen)
   if ez_tray_visible then return nil else ez_tray_visible = true end

   return common.mkwidget(
      common.texticon_box("",
			  wibox.widget.systray()
      )
   )
end
