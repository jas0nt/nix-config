local beautiful = require("beautiful")
local user = require("config.user")

beautiful.init(user.config.home .. "/.config/awesome/theme/theme.lua")

require("awful").spawn.with_shell("xwallpaper --zoom " .. os.getenv("HOME") .. "/wallpaper/dk.jpg")
