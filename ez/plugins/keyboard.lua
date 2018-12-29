local awful  = require("awful")
local stdlib = require("ez.stdlib")

local ez = require("ez")


local global_keys_table = {}
local client_keys_table = {}
local tags_keys = {}

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

-- returns tags setter table
--
-- ez.keyboard.tags[{alt, shift}] = show_tag_by_index
--
local new_tags_keys_setter = function (keys_table)
   return stdlib.settertable(function (combo, callback)
	 table.insert(keys_table, {combo, callback})
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

local set_tags_keys = function ()
   for _, combo_callback in ipairs(tags_keys) do
      local combo = combo_callback[1]
      local callback = combo_callback[2]
      for i, tag in ipairs(ez.tags.tags) do
	 local tag_key = "#" .. (tonumber(i) + 9)
	 local key = stdlib.jointables(combo, {tag_key})
	 ez.keyboard.global[key] = callback(i)
      end
   end
end

local getters = {
   -- private interface
   __get_client_keys = get_client_keys,

   -- public interface
   global = new_keys_setter(global_keys_table),
   client = new_keys_setter(client_keys_table),
   tags   = new_tags_keys_setter(tags_keys),

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
   set_tags_keys() -- needs to be run before set_global_keys
   set_global_keys()
   set_client_keys()
end

return {
   getter = getter,
   setup  = setup,
   export = {
      "ctrl",
      "alt",
      "super",
      "shift",
      "tab",
      "return_",
      "enter",
   }
}
