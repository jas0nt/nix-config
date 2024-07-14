local awful     = require("awful")
local wibox   = require("wibox")
local helpers = require("helpers")
local colors  = require("theme.colorsheme")
local user    = require("config.user")
local mod     = require("binds.mod")

local logo = wibox.widget {
  image = helpers.recolor_image(user.config.home .. "/.config/awesome/theme/assets/logos/nix.svg", colors.blue),
  valign = "center",
  halign = "center",
  forced_height = 28,
  forced_width = 28,
  resize = true,
  widget = wibox.widget.imagebox,
}
local mylogo = helpers.cbackground(helpers.margin(logo, 0, 0, 0, 0), helpers.rrect(4), colors.crust)

mylogo:buttons(
  awful.util.table.join(
    awful.button({}, mod.leftclick, function() 
      awful.spawn(user.apps.monitor)
    end),
    awful.button({}, mod.rightclick, function() 
      awesome.emit_signal("show_exit_screen")
    end)
  )
)


return mylogo
