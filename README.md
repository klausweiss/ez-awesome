# awesome-ez

Lua library that simplifies [awesome](https://awesomewm.org/) configuration. It comes preconfigured with some settings. 
Targeted at people who prefer more declarative way of configuration than using the Lua language.

## Installation

```bash
git clone https://github.com/klausweiss/awesome-ez ~/.config/awesome/awesome-ez --depth 1
```

## Usage

`awesome-ez` is meant to be used alone. It shouldn't be used as an additional way of configuration.
When imported, `awesome-ez` tampers with global names scope overriding some variables (so that `alt` can be used instead of `"Mod1"`).

Separate `awesome-ez` plugins are responsible for each group of configuration tasks, e.g. `ez.keyboard` handles setting keyboard shortcuts, `ez.wibar` can be used to set wibar widgets. They also export some functions and variables to be used in the configuration.

To configure the window manager, import the `awesome-ez` module and after the configuration is done, call it's `setup` function:

```lua
local ez = require('awesome-ez')

...

ez.setup()
```

## Example

Example configuration:

```lua
local ez = require("awesome-ez")

ez.layout.layouts = {
   tile,
   max,
   floating,
}

ez.tags.tags = {"1", "2", "3", "4", "5", "6", "7"}

ez.mouse.client_click[{alt}]       = move_client
ez.mouse.client_right_click[{alt}] = resize_client

ez.keyboard.global[{alt,        tab}] = focus_next_client
ez.keyboard.global[{alt, shift, tab}] = focus_prev_client
ez.keyboard.client[{alt, shift, "f"}] = toggle_fullscreen_client
ez.keyboard.client[{alt, shift, "m"}] = toggle_maximize_client
ez.keyboard.tags[{     ctrl       }]  = show_tag_by_index
ez.keyboard.tags[{     ctrl, shift}]  = move_focused_client_to_tag

local terminal         = "xterm"
local screen_lock      = "slock"
ez.keyboard.global[{alt, ctrl, enter}] = run(terminal)
ez.keyboard.global[{alt, shift, "l"}]  = run(screen_lock)

ez.wibar.left = {
   launcher_menu,
   taglist,
}
ez.wibar.middle = {
   tasklist,
}
ez.wibar.right = {
   tray,
   clock,
   layouts_switcher,
}

ez.setup()
```
