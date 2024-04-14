--      ██╗  ██╗███████╗██╗   ██╗███████╗
--      ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
--      █████╔╝ █████╗   ╚████╔╝ ███████╗
--      ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
--      ██║  ██╗███████╗   ██║   ███████║
--      ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Define mod keys
local modkey = "Mod4"
local altkey = "Mod1"

-- define module table
local keys = {}


-- ===================================================================
-- Movement Functions (Called by some keybinds)
-- ===================================================================


-- Move given client to given direction
local function move_client(c, direction)
    -- If client is floating, move to edge
    if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
        local workarea = awful.screen.focused().workarea
        if direction == "up" then
            c:geometry({ nil, y = workarea.y + beautiful.useless_gap * 2, nil, nil })
        elseif direction == "down" then
            c:geometry({
                nil,
                y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 2 -
                    beautiful.border_width * 2,
                nil,
                nil
            })
        elseif direction == "left" then
            c:geometry({ x = workarea.x + beautiful.useless_gap * 2, nil, nil, nil })
        elseif direction == "right" then
            c:geometry({
                x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 2 -
                    beautiful.border_width * 2,
                nil,
                nil,
                nil
            })
        end
        -- Otherwise swap the client in the tiled layout
    elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
        if direction == "up" or direction == "left" then
            awful.client.swap.byidx(-1, c)
        elseif direction == "down" or direction == "right" then
            awful.client.swap.byidx(1, c)
        end
    else
        awful.client.swap.bydirection(direction, c, nil)
    end
end


-- Resize client in given direction
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating or (c and c.floating) then
        if direction == "up" then
            c:relative_move(0, 0, 0, -floating_resize_amount)
        elseif direction == "down" then
            c:relative_move(0, 0, 0, floating_resize_amount)
        elseif direction == "left" then
            c:relative_move(0, 0, -floating_resize_amount, 0)
        elseif direction == "right" then
            c:relative_move(0, 0, floating_resize_amount, 0)
        end
    else
        if direction == "up" then
            awful.client.incwfact(-tiling_resize_factor)
        elseif direction == "down" then
            awful.client.incwfact(tiling_resize_factor)
        elseif direction == "left" then
            awful.tag.incmwfact(-tiling_resize_factor)
        elseif direction == "right" then
            awful.tag.incmwfact(tiling_resize_factor)
        end
    end
end


-- raise focused client
local function raise_client()
    if client.focus then
        client.focus:raise()
    end
end


-- ===================================================================
-- Mouse bindings
-- ===================================================================


-- Mouse buttons on the client
keys.clientbuttons = gears.table.join(
-- Raise client
    awful.button({}, 1,
        function(c)
            client.focus = c
            c:raise()
        end
    ),

    -- Move and Resize Client
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)


-- ===================================================================
-- Desktop Key bindings
-- ===================================================================


keys.globalkeys = gears.table.join(
-- =========================================
-- SPAWN APPLICATION KEY BINDINGS
-- =========================================

-- Spawn terminal
    awful.key({ modkey }, "Return",
        function()
            awful.spawn(apps.terminal)
        end,
        { description = "open a terminal", group = "launcher" }
    ),
    -- launch rofi
    awful.key({ modkey }, "d",
        function()
            awful.spawn(apps.launcher)
        end,
        { description = "application launcher", group = "launcher" }
    ),

    awful.key({ modkey }, "s",
        function()
            awful.spawn(apps.switcher)
        end,
        { description = "application switcher", group = "launcher" }
    ),
    awful.key({ modkey }, "r",
        function()
            awful.spawn(apps.cmdrunner)
        end,
        { description = "cmd runner", group = "launcher" }
    ),
    awful.key({ modkey }, "e",
        function()
            awful.spawn(apps.filemngr_cli)
        end,
        { description = "file manager", group = "launcher" }
    ),
    awful.key({ modkey }, "p",
        function()
            awful.spawn(apps.audio_cli)
        end,
        { description = "file manager", group = "launcher" }
    ),

    -- =========================================
    -- FUNCTION KEYS
    -- =========================================

    -- Brightness
    awful.key({}, "XF86MonBrightnessUp",
        function()
            awful.spawn("xbacklight -inc 10", false)
        end,
        { description = "+10%", group = "hotkeys" }
    ),
    awful.key({}, "XF86MonBrightnessDown",
        function()
            awful.spawn("xbacklight -dec 10", false)
        end,
        { description = "-10%", group = "hotkeys" }
    ),

    -- ALSA volume control
    awful.key({}, "XF86AudioRaiseVolume",
        function()
            awful.spawn("fish -c 'my_audio_up'", false)
            awesome.emit_signal("volume_change")
        end,
        { description = "volume up", group = "hotkeys" }
    ),
    awful.key({}, "XF86AudioLowerVolume",
        function()
            awful.spawn("fish -c 'my_audio_down'", false)
            awesome.emit_signal("volume_change")
        end,
        { description = "volume down", group = "hotkeys" }
    ),
    awful.key({}, "XF86AudioMute",
        function()
            awful.spawn("fish -c 'my_audio_mute'", false)
            awesome.emit_signal("volume_change")
        end,
        { description = "toggle mute", group = "hotkeys" }
    ),
    awful.key({}, "XF86AudioNext",
        function()
            awful.spawn("mpc next", false)
        end,
        { description = "next music", group = "hotkeys" }
    ),
    awful.key({}, "XF86AudioPrev",
        function()
            awful.spawn("mpc prev", false)
        end,
        { description = "previous music", group = "hotkeys" }
    ),
    awful.key({}, "XF86AudioPlay",
        function()
            awful.spawn("mpc toggle", false)
        end,
        { description = "play/pause music", group = "hotkeys" }
    ),

    -- Screenshot on prtscn using scrot
    awful.key({}, "Print",
        function()
            awful.util.spawn(apps.screenshot, false)
        end
    ),
    awful.key({ modkey, "Shift" }, "s",
        function()
            awful.util.spawn(apps.screenshot, false)
        end
    ),

    -- =========================================
    -- RELOAD / QUIT AWESOME
    -- =========================================

    -- Reload Awesome
    awful.key({ modkey, "Shift" }, "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),

    -- Quit Awesome
    awful.key({ modkey }, "z",
        function()
            awful.screen.focused().panel.visible = not awful.screen.focused().panel.visible
        end,
        { description = "toggle wibar", group = "awesome" }
    ),
    awful.key({ modkey, "Shift" }, "q",
        function()
            -- emit signal to show the exit screen
            awesome.emit_signal("show_exit_screen")
        end,
        { description = "toggle exit screen", group = "hotkeys" }
    ),

    awful.key({}, "XF86PowerOff",
        function()
            -- emit signal to show the exit screen
            awesome.emit_signal("show_exit_screen")
        end,
        { description = "toggle exit screen", group = "hotkeys" }
    ),

    -- =========================================
    -- CLIENT FOCUSING
    -- =========================================

    -- Focus client by direction (hjkl keys)
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.byidx(1)
            raise_client()
        end,
        { description = "focus down", group = "client" }
    ),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.byidx(-1)
            raise_client()
        end,
        { description = "focus up", group = "client" }
    ),
    awful.key({ modkey }, "h",
        function()
            awful.tag.incmwfact(-0.05)
            raise_client()
        end,
        { description = "focus left", group = "client" }
    ),
    awful.key({ modkey }, "l",
        function()
            awful.tag.incmwfact(0.05)
            raise_client()
        end,
        { description = "focus right", group = "client" }
    ),

    -- Focus client by direction (arrow keys)
    awful.key({ modkey }, "Down",
        function()
            awful.client.focus.bydirection("down")
            raise_client()
        end,
        { description = "focus down", group = "client" }
    ),
    awful.key({ modkey }, "Up",
        function()
            awful.client.focus.bydirection("up")
            raise_client()
        end,
        { description = "focus up", group = "client" }
    ),
    awful.key({ modkey }, "Left",
        function()
            awful.client.focus.bydirection("left")
            raise_client()
        end,
        { description = "focus left", group = "client" }
    ),
    awful.key({ modkey }, "Right",
        function()
            awful.client.focus.bydirection("right")
            raise_client()
        end,
        { description = "focus right", group = "client" }
    ),

    -- Focus client by index (cycle through clients)
    awful.key({ modkey }, "Tab",
        awful.tag.history.restore,
        { description = "switch", group = "client" }
    ),
    awful.key({ modkey }, "Escape",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "switch in tag", group = "client" }
    ),

    -- =========================================
    -- CLIENT RESIZING
    -- =========================================

    awful.key({ modkey, "Control" }, "Down",
        function(c)
            resize_client(client.focus, "down")
        end
    ),
    awful.key({ modkey, "Control" }, "Up",
        function(c)
            resize_client(client.focus, "up")
        end
    ),
    awful.key({ modkey, "Control" }, "Left",
        function(c)
            resize_client(client.focus, "left")
        end
    ),
    awful.key({ modkey, "Control" }, "Right",
        function(c)
            resize_client(client.focus, "right")
        end
    ),
    awful.key({ modkey, "Control" }, "j",
        function(c)
            resize_client(client.focus, "down")
        end
    ),
    awful.key({ modkey, "Control" }, "k",
        function(c)
            resize_client(client.focus, "up")
        end
    ),
    awful.key({ modkey, "Control" }, "h",
        function(c)
            resize_client(client.focus, "left")
        end
    ),
    awful.key({ modkey, "Control" }, "l",
        function(c)
            resize_client(client.focus, "right")
        end
    ),

    -- =========================================
    -- LAYOUT SELECTION
    -- =========================================

    -- select next layout
    awful.key({ modkey }, "space",
        function()
            awful.layout.inc(1)
        end,
        { description = "select next", group = "layout" }
    ),
    -- select previous layout
    awful.key({ modkey, "Shift" }, "space",
        function()
            awful.layout.inc(-1)
        end,
        { description = "select previous", group = "layout" }
    ),

    -- =========================================
    -- CLIENT MINIMIZATION
    -- =========================================

    -- restore minimized client
    awful.key({ modkey, "Shift" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        { description = "restore minimized", group = "client" }
    )
)


-- ===================================================================
-- Client Key bindings
-- ===================================================================


keys.clientkeys = gears.table.join(
-- Move to edge or swap by direction
    awful.key({ modkey }, "a",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        { description = "move to master", group = "client" }
    ),
    awful.key({ modkey, "Shift" }, "Down",
        function(c)
            move_client(c, "down")
        end
    ),
    awful.key({ modkey, "Shift" }, "Up",
        function(c)
            move_client(c, "up")
        end
    ),
    awful.key({ modkey, "Shift" }, "Left",
        function(c)
            move_client(c, "left")
        end
    ),
    awful.key({ modkey, "Shift" }, "Right",
        function(c)
            move_client(c, "right")
        end
    ),

    -- toggle floating
    awful.key({ modkey }, "f",
        function(c)
            c.floating = not c.floating
        end,
        { description = "toggle floating", group = "client" }
    ),

    -- close client
    awful.key({ modkey }, "w",
        function(c)
            c:kill()
        end,
        { description = "close", group = "client" }
    ),

    -- Minimize
    awful.key({ modkey }, "n",
        function(c)
            c.minimized = true
        end,
        { description = "minimize", group = "client" }
    ),

    -- Maximize
    awful.key({ modkey }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }
    ),
    -- Fullscreen
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    )
)

-- Bind all key numbers to tags
for i = 1, 9 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        -- Switch to tag
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }
        ),
        -- Move client to tag
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }
        )
    )
end

return keys
