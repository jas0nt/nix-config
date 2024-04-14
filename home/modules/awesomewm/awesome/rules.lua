--      ██████╗ ██╗   ██╗██╗     ███████╗███████╗
--      ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
--      ██████╔╝██║   ██║██║     █████╗  ███████╗
--      ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
--      ██║  ██║╚██████╔╝███████╗███████╗███████║
--      ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local beautiful = require("beautiful")

-- define screen height and width
local screen_height = awful.screen.focused().geometry.height
local screen_width = awful.screen.focused().geometry.width

-- define module table
local rules = {}


-- ===================================================================
-- Rules
-- ===================================================================


-- return a table of client rules including provided keys / buttons
function rules.create(clientkeys, clientbuttons)
  return {
    -- All clients will match this rule.
    {
      rule = {},
      properties = {
        titlebars_enabled = beautiful.titlebars_enabled,
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.centered
      },
    },
    -- Floating clients.
    {
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
      properties = { floating = true }
    },

    -- Fullscreen clients
    {
      rule_any = {
        class = {
          "Terraria.bin.x86",
        },
      },
      properties = { fullscreen = true }
    },
    {
      rule_any = {
        type = { "normal", "dialog" }
      },
      properties = { titlebars_enabled = false }
    },
    {
      rule = { class = "Emacs" },
      properties = { screen = 1, tag = "7", switchtotag = true }
    },
    {
      rule = { class = "kitty" },
      properties = { screen = 1, tag = "1", switchtotag = true }
    },
    {
      rule = { class = "Microsoft-edge" },
      properties = { screen = 1, tag = "2", switchtotag = true }
    },
    {
      rule = { class = "firefox" },
      properties = { screen = 1, tag = "2", switchtotag = true }
    },
    {
      rule = { class = "fm" },
      properties = { screen = 1, tag = "3", switchtotag = true }
    },
    {
      rule = { class = "pcmanfm" },
      properties = { screen = 1, tag = "3", switchtotag = true }
    },
    {
      rule = { class = "steam" },
      properties = { screen = 1, tag = "8", switchtotag = true }
    },
    {
      rule = { class = "dota2" },
      properties = { screen = 1, tag = "8", switchtotag = true }
    },
    {
      rule_any = {
        class = {
          "qBittorrent", "qbittorrent",
          "motrix", "Motrix",
        }
      },
      properties = { screen = 1, tag = "9" }
    },

    -- File chooser dialog
    {
      rule_any = { role = { "GtkFileChooserDialog" } },
      properties = { floating = true, width = screen_width * 0.55, height = screen_height * 0.65 }
    },

    {
      rule_any = {
        class = {
          "myfloating",
          "Pavucontrol",
          "pwvucontrol",
          "pulsemixer",
          "qview", "qView",
        },
        name = { "Bluetooth Devices" }
      },
      properties = { floating = true, width = screen_width * 0.55, height = screen_height * 0.55 }
    },
    {
      rule_any = {
        class = {
          "myfloatingl",
        },
      },
      properties = { floating = true, width = screen_width * 0.80, height = screen_height * 0.80 }
    },
  }
end

-- return module table
return rules
