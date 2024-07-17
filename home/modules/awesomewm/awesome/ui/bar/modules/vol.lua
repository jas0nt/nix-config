local awful     = require("awful")
local wibox     = require("wibox")
local watch     = require("awful.widget.watch")
local colors    = require("theme.colorsheme")
local helpers   = require("helpers")
local user      = require("config.user")
local mod       = require("binds.mod")

local arc_vol = {}

local text = wibox.widget {
  align = "center",
  valign = "center",
  widget = wibox.widget.textbox
}

local textbg = wibox.widget {
  text,
  widget = wibox.container.background
}

arc_vol = wibox.widget {
  textbg,
  mix_value = 0,
  max_value = 100,
  rounded_edge = false,
  thickness = 6,
  start_angle = 4.71238898,
  forced_height = 22,
  forced_width = 22,
  bg = "#363a4f",
  widget = wibox.container.arcchart
}

local function update_widget(widget, stdout, _, _, code)
    if code == 0 then
      local mute_status, vol_value = stdout:match("(%d+)%s+(%d+)")
      if mute_status == "1" then
        widget.value = 100
        widget.colors = { widget.bg }
      else
        widget.value = tonumber(vol_value)
        widget.colors = { colors.purple }
      end
    else
        widget.visible = false
    end
end

local function refresh()
  awful.spawn.easy_async(user.config.home .. "/.config/awesome/config/vol.sh",
  function(stdout, _, _, code)
    update_widget(arc_vol, stdout, _, _, code)
  end)
end

arc_vol:buttons(
  awful.util.table.join(
    awful.button({}, mod.leftclick, function() 
      awful.spawn("bash " .. os.getenv("HOME") .. "/scripts/volume.sh mute", false)
      refresh()
    end),
    awful.button({}, mod.scrollup, function() 
      awful.spawn("bash " .. os.getenv("HOME") .. "/scripts/volume.sh up", false)
      refresh()
    end),
    awful.button({}, mod.scrolldown, function() 
      awful.spawn("bash " .. os.getenv("HOME") .. "/scripts/volume.sh down", false)
      refresh()
    end)
  )
)

-- watch(user.config.home .. "/.config/awesome/config/vol.sh", 5, update_widget, arc_vol)

refresh()
awesome.connect_signal("volume::change", function(stdout)
    refresh()
end)


return helpers.cbackground(helpers.margin(arc_vol, 4, 4, 0, 0), helpers.rrect(4), colors.crust)
