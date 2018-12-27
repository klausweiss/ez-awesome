local awful  = require("awful")
local stdlib = require("ez.stdlib")


local global_keys_table = {}
local client_keys_table = {}

local create_key = function (combo, callback)
   local modifiers  = stdlib.slice(combo, 1, #combo - 1)
   local key_symbol = combo[#combo]
   return awful.key(modifiers, key_symbol, callback)
end 

-- returns setter table, e.g. ez.keyboard.global:
--
-- ez.keyboard.global[{alt, shift, "m"}] = maximize
--
local new_keys_setter = function (keys_table)
   return stdlib.settertable(function (combo, callback)
	 -- TODO: allow setting a table with a callback, category and descriptionn
	 local key = create_key(combo, callback)
	 stdlib.extendtable(keys_table, key)
   end)
end

local set_global_keys = function ()
   root.keys(global_keys_table)
end

local set_client_keys = function ()
   -- add rules
   local client_rules = {
      {
	 rule       = {}, -- for all clients
	 properties = {
	    keys = client_keys_table,
	 },
      },
   }
   stdlib.extendtable(awful.rules.rules, client_rules)
end

local getters = {
   -- private interface
   __get_client_keys = get_client_keys,

   -- public interface
   global = new_keys_setter(global_keys_table),
   client = new_keys_setter(client_keys_table),

   ctrl    = "Control",
   alt     = "Mod1",
   super   = "Mod4",
   shift   = "Shift",
   tab     = "Tab",
   return_ = "Return",
   enter   = "Return",
}

local getter = function (key) return getters[key] end
local setup = function ()
   set_global_keys()
   set_client_keys()
end

return {
   getter = getter,
   setup  = setup,
}
