local awful  = require("awful")
local stdlib = require("ez.stdlib")


local noop = stdlib.noop

local buttons_numbers = {
   wheel_up    = 4,
   wheel_down  = 5,

   wheel_click = 2,
    left_click = 1,
         click = 1,
   right_click = 3,
}

-- returns map containing callbacks for each mouse button
-- assigned to keyboard combos
local new_buttons_map = function (prefix)
    local buttons_map = {}
    for button, number in pairs(buttons_numbers) do
	local key = prefix .. "_" .. button
	buttons_map[key] = {}
    end 
    return buttons_map
end

local buttons_maps = {
   desktop = new_buttons_map("desktop"),
   client  = new_buttons_map("client"),
}

-- transforms a buttons_map to a buttons_table
-- understandable by awful
local to_buttons_table = function (prefix)
   local buttons_map = buttons_maps[prefix]
   local buttons_table = {}
   for button_name, button_number in pairs(buttons_numbers) do
      local key = prefix .. "_" .. button_name
      for combo, callback in pairs(buttons_map[key]) do
	 local button = awful.button(combo, button_number, callback)
	 stdlib.extendtable(buttons_table, button)
      end
   end
   return buttons_table
end

-- default setters:
--
--   ez.mouse.desktop_click = show_menu
--   ...
--
local setters = {}
for button_name, number in pairs(buttons_numbers) do
   for prefix, table_ in pairs(buttons_maps) do
      local key = prefix .. "_" .. button_name
      setters[key] = function (callback)
	 table_[key][{}] = callback
      end
   end
end

local getters = {}
-- combo setters:
--
--   ez.mouse.desktop_click[{alt, ctrl}] = show_menu
--   ...
--
for button_name, number in pairs(buttons_numbers) do
   for prefix, table_ in pairs(buttons_maps) do
      local key = prefix .. "_" .. button_name
      getters[key] = stdlib.settertable(function (combo, callback)
	    table_[key][combo] = callback
      end)
   end
end


local set_client_buttons = function ()
   local buttons_table = to_buttons_table("client")
   -- add rules
   local client_rules = {
      {
	 rule       = {}, -- for all clients
	 properties = {
	    buttons = buttons_table,
	 },
      },
   }
   stdlib.extendtable(awful.rules.rules, client_rules)
end

local set_desktop_buttons = function ()
   local buttons_table = to_buttons_table("desktop")
   root.buttons(buttons_table)
end


local setter = function (key, value) return setters[key](value) end 
local getter = function (key) return getters[key] end
local setup  = function ()
   set_desktop_buttons()
   set_client_buttons()
end

return {
   setter = setter,
   getter = getter,
   setup  = setup,
}
