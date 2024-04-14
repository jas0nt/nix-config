--       █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
--      ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
--      ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗
--      ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝
--      ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
--      ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝


-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")


-- ===================================================================
-- User Configuration
-- ===================================================================

local theme = "pastel"
local theme_config_dir = gears.filesystem.get_configuration_dir() .. "/configuration/" .. theme .. "/"

-- define default apps (global variable so other components can access it)
apps = {
    network_manager = "networkmanagerapplet", -- recommended: nm-connection-editor
    power_manager = "",                       -- recommended: xfce4-power-manager
    terminal = "kitty",
    filemngr_cli = "kitty --class fm -e ranger",
    audio_cli = "kitty --class pulsemixer -e pulsemixer",
    filebrowser = "pcmanfm",
    launcher = "rofi -show drun",
    switcher = "rofi -show window",
    cmdrunner = "rofi -show run",
    lock = "i3lock-fancy -gp",
    screenshot = "shutter -s",
}


-- ===================================================================
-- Initialization
-- ===================================================================

-- Run all the apps listed in run_on_start_up
awful.spawn.with_shell(os.getenv("HOME") .. "/.config/autostart/autostart.sh")

-- List of apps to run on start-up
local run_on_start_up = {
    -- "picom",
    -- "fcitx5",
}
for _, app in ipairs(run_on_start_up) do
    local findme = app
    local firstspace = app:find(" ")
    if firstspace then
        findme = app:sub(0, firstspace - 1)
    end
    -- pipe commands to bash to allow command to be shell agnostic
    awful.spawn.with_shell(string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -", findme, app), false)
end

-- Import theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" .. theme .. "-theme.lua")

-- Initialize theme
local selected_theme = require(theme)
selected_theme.initialize()

-- Import Keybinds
local keys = require("keys")
root.keys(keys.globalkeys)

-- Import rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- Define layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.floating,
}

-- remove gaps if layout is set to max
tag.connect_signal('property::layout', function(t)
    local current_layout = awful.tag.getproperty(t, 'layout')
    if (current_layout == awful.layout.suit.max) then
        t.gap = 0
    else
        t.gap = beautiful.useless_gap
    end
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the window as a slave (put it at the end of others instead of setting it as master)
    -- if not awesome.startup then
    --     awful.client.setslave(c)
    -- end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", { raise = false })
    end
)

client.connect_signal(
    "focus",
    function(c)
        c.border_color = beautiful.border_focus
    end
)
client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)

-- switch to parent after closing child window
local function backham()
    local s = awful.screen.focused()
    local c = awful.client.focus.history.get(s, 0)
    if c then
        client.focus = c
        c:raise()
    end
end

-- attach to minimized state
client.connect_signal("property::minimized", backham)
-- attach to closed state
client.connect_signal("unmanage", backham)
-- ensure there is always a selected client during tag switching or logins
tag.connect_signal("property::selected", backham)

-- }}}


-- ===================================================================
-- Client Focusing
-- ===================================================================


-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- ===================================================================
-- Screen Change Functions (ie multi monitor)
-- ===================================================================


-- Reload config when screen geometry changes
screen.connect_signal("property::geometry", awesome.restart)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal(
    "arrange",
    function(s)
        local only_one = #s.tiled_clients == 1
        for _, c in pairs(s.clients) do
            if only_one and not c.floating or c.maximized or c.fullscreen then
                c.border_width = 0
            else
                c.border_width = beautiful.border_width
            end
        end
    end
)


-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================


collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
