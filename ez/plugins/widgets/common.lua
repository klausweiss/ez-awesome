local beautiful = require("beautiful")
local wibox     = require("wibox")


local with_border = function (color, widget)
   return {
      widget,

      margins = 2,
      color   = color,
      widget  = wibox.container.margin,
   }
end

local with_padding = function (paddings, widget)
   local top = paddings.top or 0
   local right = paddings.right or 0
   local bottom = paddings.bottom or 0
   local left = paddings.left or 0
   return {
      widget,

      top = top,
      right = right,
      bottom = bottom,
      left = left,
      widget = wibox.container.margin,
   }
end

local with_bg = function (bgcolor, widget)
   return {
      widget,

      bg = bgcolor,
      widget = wibox.container.background,
   }
end


local texticon_box = function (texticon, widget)
   local primary_color = (beautiful.bg_primary or
			     beautiful.bg_focus)
   local secondary_color = (beautiful.bg_secondary or
			       beautiful.bg_normal)
   local texticon_widget = {
      markup = texticon,
      widget = wibox.widget.textbox,
   }
   local icon = with_bg(primary_color,
			with_padding(
			   {
			      top = 2,
			      right = 8,
			      bottom = 2,
			      left = 8,
			   }, texticon_widget))
   local widget = with_bg(secondary_color,
			  with_padding(
			     {
				top = 2,
				right = 8,
				bottom = 2,
				left = 8,
			     }, widget))
   return with_border(primary_color,
		      {
			 icon,
			 widget,

			 layout = wibox.layout.fixed.horizontal,
		      }
   )
end

return {
   texticon_box = texticon_box,
   mkwidget = function (widget) return wibox.widget.base.make_widget(wibox.widget(widget)) end
}
