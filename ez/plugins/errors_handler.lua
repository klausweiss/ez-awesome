local naughty = require("naughty")


local naughty_handler = function (err)
   naughty.notify({
	 preset = naughty.config.presets.critical,
	  title = "Oops, an error happened!",
	   text = tostring(err),
   })
end

local errors_handler_config = {
   handler = naughty_handler,
}

local setup = function ()
  awesome.in_error = false
  awesome.connect_signal("debug::error", function (err)
			    -- Make sure we don't go into an endless error loop
			    if awesome.in_error then return end
			    awesome.in_error = true
			    errors_handler_config.handler(err)
			    awesome.in_error = false
  end)
end

return {
   setup = setup,
}
