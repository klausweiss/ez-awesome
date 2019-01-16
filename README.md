# awesome-ez

Lua library that simplifies [awesome](https://awesomewm.org/) configuration. It comes preconfigured with some settings. 
Targeted at people who prefer more declarative way of configuration than using the Lua language.

## Installation

```bash
git clone https://github.com/klausweiss/ez ~/.config/awesome/ez --depth 1
```

## Usage

**Warning!** When imported, `ez` tampers with global names scope overriding some variables (see below).

Separate `ez` plugins are responsible for each group of configuration tasks, e.g. `ez.keyboard` handles setting keyboard shortcuts, `ez.wibar` can be used to set wibar widgets. They also export some functions and variables to be used in the configuration.

To configure the window manager, import the `ez` module and set the relevant configuration.

```lua
local ez = require('ez')

...
```

## Example

Example configuration:

```lua
local ez = require("ez")

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
```

## Documentation

### Configuration setters

The following properties can be used to configure awesomewm:

Setter | Parameters | Value | Description
---    | ---        | ---   | --- 
`ez.client.focus_follow_mouse` | | `bool` | If true, clients (X11 windows) will be focused when under the mouse pointer. 
`ez.keyboard.global[keys_combo]` | `keys_combo` should be a table with _modifiers_ as the first elements and non-_modifier_ as the last one. |`fun () -> ()` | `fun` will be called after the `keys_combo` was pressed.
`ez.keyboard.client[keys_combo]` | `keys_combo` should be a table with _modifiers_ as the first elements and non-_modifier_ as the last one. |`fun (client) -> ()` | `fun` will be called with the target client as a parameter after the `keys_combo` was pressed.
`ez.keyboard.tags[keys_combo]` | `keys_combo` should be a table with _modifiers_ only. function `fun` should take a tag number as a parameter and return a new function taking no parameters. |`fun (index) -> () -> ()` | For each tag number (1-9) a keyboard shortcut is generated. Press `keys_combo` + tag number (1-9) to trigger it.
`ez.layout.layouts` | | `table[layout]` | Layouts in the table will be used for each tag.
`ez.mouse.desktop_BUTTON` | `BUTTON` can be `wheel_up`, `wheel_down`, `wheel_click`, `click`, `left_click` or `right_click` | `fun () -> ()` | `fun` will be called after the button has been clicked on the desktop.
`ez.mouse.client_BUTTON` | `BUTTON` can be `wheel_up`, `wheel_down`, `wheel_click`, `click`, `left_click` or `right_click` | `fun (client) -> ()` | `fun` will be called after the button has been clicked on the client.
`ez.mouse.desktop_BUTTON[keys_combo]` | `BUTTON` can be `wheel_up`, `wheel_down`, `wheel_click`, `click`, `left_click` or `right_click`. `keys_combo` should be a table with _modifiers_ | `fun () -> ()` | `fun` will be called after the button has been clicked on the desktop while pressing `keys_combo` modifiers.
`ez.mouse.client_BUTTON[keys_combo]` | `BUTTON` can be `wheel_up`, `wheel_down`, `wheel_click`, `click`, `left_click` or `right_click`. `keys_combo` should be a table with _modifiers_ | `fun (client) -> ()` | `fun` will be called after the button has been clicked on the client while pressing `keys_combo` modifiers.
`ez.rules[WINDOW_CLASS].PROPERTY` | `WINDOW_CLASS` is an X11 class that should match, `PROPERTY` is property to be set (as in `awful.rules`) | `any` | Adds a rule for a window of the given class to set the property to the given value.
`ez.tags.tags` | | `table[string]` | Strings in `table` will be names of tags.
`ez.theme.gaps` | | `int` | Sets gaps between clients. Ignores size hints given by windows as a side effect.
`ez.theme.theme` | | `string` | Sets theme (accepts path to it's `.lua` file).
`ez.theme.wallpaper` | | `string` | Sets wallpaper for each screen to an image under given path.
`ez.wibar.position` | | `position` | Position, where `wibar` will be placed.
`ez.wibar.left` | | `table[widget_factory]` | Widgets on the left part of `wibar`. `widget_factory` is a function taking `screen`, returning a widget.
`ez.wibar.middle` | | `table[widget_factory]` | Widgets on the middle part of `wibar`. `widget_factory` is a function taking `screen`, returning a widget.
`ez.wibar.right` | | `table[widget_factory]` | Widgets on the right part of `wibar`. `widget_factory` is a function taking `screen`, returning a widget.

### Exported functions

Function | Signature | Description
---      | ---       | ---
`toggle_focus_minimize_client`                 | `(client) -> ()` | If client is focused, minimizes it. If it's not, it focuses it. If it's minimized, it is unminimized.
`toggle_fullscreen_client`                     | `(client) -> ()` | Toggles fullscreen on client.
`toggle_maximize_client`                       | `(client) -> ()` | Toggles maximize on client.
`close_client`                                 | `(client) -> ()` | Closes client.
`focus_client`                                 | `(client) -> ()` | Focuses client.
`focus_next_client`                            | `() -> ()` | Focuses client right after the focused one.
`focus_previous_client` or `focus_prev_client` | `() -> ()` | Focuses client right before the focused one.
`move_client`                                  | `(client) -> ()` | Starts moving client.
`resize_client`                                | `(client) -> ()` | Starts resizing client.
`restore_random_client`                        | `(client) -> ()` | Unminimizes random client.
`restore_and_focus_random_client`              | `(client) -> ()` | Unminimizes and focuses random client.
`run` | `(command) -> () -> ()` | Creates a function running `command` when called.
`focus_left_screen`          | `() -> ()` | Focuses screen to the left of currently selected screen.
`focus_right_screen`         | `() -> ()` | Focuses screen to the right of currently selected screen.
`move_client_to_next_screen`   | `() -> ()` | Moves focused client to the next screen.
`show_only_tag`                | `(tag) -> ()` | Shows only tag passed as argument.
`toggle_tag`                   | `(tag) -> ()` | Toggle tag passed as argument.
`show_next_tag`                | ` () -> ()` | Shows only tag right after the selected one.
`show_prev_tag`                | ` () -> ()` | Shows only tag right before the selected one.
`show_tag_by_index`            | `(index) -> () -> ()` | Shows only tag with given index.
`toggle_tag_by_index`          | `(index) -> () -> ()` | Toggles tag with given index.
`move_focused_client_to_tag`   | `(index) -> () -> ()` | Moves focused client to tag with given index.
`toggle_tag_on_focused_client` | `(index) -> () -> ()` | Toggle showing focused client on tag with given index.

### Exported variables

Variable | Type | Description
---      | ---  | ---
`ctrl`               | modifier | Ctrl key.
`alt`                | modifier | Alt key.
`super`              | modifier | Super key.
`shift`              | modifier | Shift key.
`tab`                | modifier | Tab key.
`return_` or `enter` | modifier | Enter key.
`tile`               | layout | `awful.layout.suit.tile`
`tile_right`         | layout | `awful.layout.suit.tile_right`
`tile_left`          | layout | `awful.layout.suit.tile_left`
`tile_up`            | layout | `awful.layout.suit.tile_up`
`tile_bottom`        | layout | `awful.layout.suit.tile_b`
`fair`               | layout | `awful.layout.suit.fair`
`fair_vertical`      | layout | `awful.layout.suit.fair_vertical`
`fair_horizontal`    | layout | `awful.layout.suit.fair_horizontal`
`spiral`             | layout | `awful.layout.suit.spiral`
`spiral_dwindle`     | layout | `awful.layout.suit.spiral_dwindle`
`magnifier`          | layout | `awful.layout.suit.magnifier`
`floating`           | layout | `awful.layout.suit.floating`
`max`                | layout | `awful.layout.suit.max`
`fullscreen`         | layout | `awful.layout.suit.fullscreen`
`ne`                 | layout | `awful.layout.suit.ne`
`se`                 | layout | `awful.layout.suit.se`
`sw`                 | layout | `awful.layout.suit.sw`
`nw`                 | layout | `awful.layout.suit.nw`
`next_layout`        | layout | `awful.layout.suit.next_layout`
`prev_layout`        | layout | `awful.layout.suit.prev_layout`
`previous_layout`    | layout | `awful.layout.suit.previous_layout`
`select_main_client` | layout | `awful.layout.suit.select_main_client`
`bottom` | position | Bottom.
`top`    | position | Top.
`launcher_menu`    | widget_factory | Widget showing awesome menu.
`taglist`          | widget_factory | Allows to switch and toggle tags.
`tasklist`         | widget_factory | Allows to minimize and focus clients.
`tray`             | widget_factory | System tray.
`clock`            | widget_factory | Clock with date.
`layouts_switcher` | widget_factory | Shows currently selected layout and allows to switch it.
