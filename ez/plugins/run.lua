local awful = require("awful")


return {
   getter = {
      run = function (program)
	 return function ()
	    awful.spawn(program)
	 end
      end
   },
   export = {
      "run",
   }
}
