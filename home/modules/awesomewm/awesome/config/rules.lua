local awful = require("awful")
local ruled = require("ruled")

local screen_height = awful.screen.focused().geometry.height
local screen_width = awful.screen.focused().geometry.width

--
-- [[ Rules to apply to new clients ]]
--
ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.
  ruled.client.append_rule {
    id         = "global",
    rule       = { },
    properties = {
      focus     = awful.client.focus.filter,
      raise     = true,
      screen    = awful.screen.preferred,
      -- placement = awful.placement.no_overlap+awful.placement.no_offscreen
      placement = awful.placement.centered
    }
  }

  ruled.client.append_rule {
    rule_any = {
        instance = {
          "DTA",
          "copyq",
        },
        class = {
          "Nm-connection-editor",
          "Arandr",
          "Blueman-manager",
          "launcher",
          ".shutter-wrapped",
        },
        name = {
          "Event Tester",
          "Steam Guard - Computer Authorization Required"
        },
        role = {
          "pop-up",
          "GtkFileChooserDialog"
        },
        type = {
          "dialog"
        }
      },
      properties = { floating = true },
  }

  ruled.client.append_rule {
    rule_any = {
        class = {
          "myfloating",
          "Pavucontrol",
          "pwvucontrol",
          "pulsemixer",
          "qview", "qView",
          "imv",
        },
      },
      properties = { floating = true, width = screen_width * 0.55, height = screen_height * 0.55 },
  }

  ruled.client.append_rule {
    rule       = { class = "firefox" },
    properties = { screen = 1, tag = "1" }
  }

  ruled.client.append_rule {
    rule_any   = { class = {"emacs", "Emacs", "code", "Code",} },
    properties = { screen = 1, tag = "2", switchtotag = true },
  }

  ruled.client.append_rule {
    rule_any   = { class = {"fm", "pcmanfm"} },
    properties = { screen = 1, tag = "3", switchtotag = true },
  }

  ruled.client.append_rule {
    rule       = { class = "kitty" },
    properties = { screen = 1, tag = "7", switchtotag = true },
  }

  ruled.client.append_rule {
    rule       = { class = "steam" },
    properties = { screen = 1, tag = "8", switchtotag = true },
  }

  ruled.client.append_rule {
    rule_any = { class = { "qBittorrent", "qbittorrent", "motrix", "Motrix", } },
    properties = { screen = 1, tag = "9" },
  }

end)
