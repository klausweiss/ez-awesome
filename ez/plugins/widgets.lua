local getter = function (key)
   return require("ez.plugins.widgets." .. key)
end

return {
   getter = getter,
   export = {
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
