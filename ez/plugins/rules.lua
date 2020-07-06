local awful  = require("awful")
local stdlib = require("ez.stdlib")

local rules_config = stdlib.defaulttable(stdlib.tablefactory)

local property_setter = function (name)
   return stdlib.settertable(function (key, value)
	 rules_config[name][key] = value
   end)
end

local setup = function ()
   for client_class, properties in pairs(rules_config) do
      rule = client_class
      if type(client_class) == "string" then
        rule = { class = client_class }
      end
      table.insert(awful.rules.rules, {
		      rule = rule,
		      properties = properties })
   end
end

local getter = function (key) return property_setter(key) end

return {
   getter = getter,
   setup  = setup,
   export = {
   	no_offscreen = awful.placement.no_offscreen
   }
}
