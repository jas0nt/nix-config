--      ████████╗ ██████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗
--      ╚══██╔══╝██╔═══██╗██╔══██╗    ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║
--         ██║   ██║   ██║██████╔╝    ██████╔╝███████║██╔██╗ ██║█████╗  ██║
--         ██║   ██║   ██║██╔═══╝     ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║
--         ██║   ╚██████╔╝██║         ██║     ██║  ██║██║ ╚████║███████╗███████╗
--         ╚═╝    ╚═════╝ ╚═╝         ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

-- import widgets
local vertical_sep = require("widgets.vertical-separator")
local task_list = require("widgets.task-list")
local cmus_widget = require("widgets.cmus")

-- define module table
local mybar = {}


-- ===================================================================
-- Bar Creation
-- ===================================================================


mybar.create = function(s)
    -- local panel = awful.wibar({
    s.panel = awful.wibar({
        screen = s,
        position = "bottom",
        ontop = true,
        height = beautiful.mybar_height,
        width = s.geometry.width,
    })

    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    s.panel:setup {
        expand = "none",
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            task_list.create(s),
        },
        require("widgets.calendar").create(s),
        {
            layout = wibox.layout.fixed.horizontal,
            cmus_widget {
                space = 5,
                timeout = 10,
            },
            vertical_sep,
            wibox.layout.margin(wibox.widget.systray(), dpi(0.1), dpi(0.1), dpi(0.1), dpi(0.1)),
            require("widgets.layout-box"),
        }
    }


    -- ===================================================================
    -- Functionality
    -- ===================================================================


    -- hide panel when client is fullscreen
    local function change_panel_visibility(client)
        if client.screen == s then
            s.panel.ontop = not client.fullscreen
        end
    end

    -- connect panel visibility function to relevant signals
    client.connect_signal("property::fullscreen", change_panel_visibility)
    client.connect_signal("focus", change_panel_visibility)
end

return mybar
