local awful   = require("awful")
local helpers = require("helpers")
local colors  = require("theme.colorsheme")
local user    = require("config.user")
local mod     = require("binds.mod")

local screenshot = awful.widget.button {
  image = "/home/jason/.config/awesome/theme/assets/icons/screenshot.png",
  buttons = {
    awful.button({}, mod.leftclick, nil, function ()
      awful.spawn(user.apps.screnshoot, false)
    end),
  }
}
local myscreenshot = helpers.cbackground(helpers.margin(screenshot, 5, 5, 0, 0), helpers.rrect(4), colors.crust)

return myscreenshot
