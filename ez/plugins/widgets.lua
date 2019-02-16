local getter = function (key)
   return require("ez.plugins.widgets." .. key)
end

return {
   getter = getter,
   export = {
      "common", -- TODO: add volume and battery widgets and do not export
      "launcher_menu",
      "taglist",
      "tasklist",
      "tray",
      "time",
      "date",
      "text",
      "layouts_switcher",
   }
}
