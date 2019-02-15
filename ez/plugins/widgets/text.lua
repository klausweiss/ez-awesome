local wibox = require("wibox")


return function (text_)
    return function (_screen)
	return wibox.widget.textbox(text_)
    end
end
