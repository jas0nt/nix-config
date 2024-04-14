local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi


local vertical_separator = wibox.widget {
    orientation = "vertical",
    forced_width = dpi(16),
    opacity = 0.20,
    widget = wibox.widget.separator
}

return vertical_separator
