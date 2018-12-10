local submodule = require("ez.submodule")

return function (plugin_name)
   local plugin_path = "ez.plugins." .. plugin_name
   local plugin_module = require(plugin_path)
   return submodule(plugin_module)
end
