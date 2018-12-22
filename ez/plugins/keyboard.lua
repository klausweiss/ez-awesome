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

local get_client_keys = function ()
   return client_keys_table
end

local getters = {
   -- private interface
   __get_client_keys = get_client_keys,

   -- public interface
   global = new_keys_setter(global_keys_table),
   client = new_keys_setter(client_keys_table),
}

local getter = function (key) return getters[key] end

return {
   getter = getter,
   setup  = set_global_keys,
}
