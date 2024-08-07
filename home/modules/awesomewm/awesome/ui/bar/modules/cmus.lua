local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local gears = require("gears")
local beautiful = require('beautiful')

local function ellipsize(text, length)
    -- utf8 only available in Lua 5.3+
    if utf8 == nil then
        return text:sub(0, length)
    end
    return (utf8.len(text) > length and length > 0)
        and text:sub(0, utf8.offset(text, length - 2) - 1) .. '...'
        or text
end

local cmus_widget = {}

local function worker(user_args)

    local args = user_args or {}
    local font = args.font or beautiful.font

    local ICON_DIR = gears.filesystem.get_configuration_dir() .. "/theme/assets/icons/media/"
    local path_to_icons = args.path_to_icons or ICON_DIR
    local timeout = args.timeout or 10
    local max_length = args.max_length or 30
    local space = args.space or 3

    cmus_widget.widget = wibox.widget {
        {
            {
                id = "playback_icon",
                resize = false,
                widget = wibox.widget.imagebox,
            },
            layout = wibox.container.place
        },
        {
            id = "text",
            font = font,
            widget = wibox.widget.textbox
        },
        spacing = space,
        layout = wibox.layout.fixed.horizontal,
        update_icon = function(self, name)
            self:get_children_by_id("playback_icon")[1]:set_image(path_to_icons .. name)
        end,
        set_title = function(self, title)
            self:get_children_by_id("text")[1]:set_text(title)
        end
    }

    local function update_widget(widget, stdout, _, _, code)
        if code == 0 then
            local cmus_info = {}

            for s in stdout:gmatch("[^\r\n]+") do
                local key, val = string.match(s, "^tag (%a+) (.+)$")

                if key and val then
                    cmus_info[key] = val
                else
                    key, val = string.match(s, "^set (%a+) (.+)$")

                    if key and val then
                        cmus_info[key] = val
                    else
                        key, val = string.match(s, "^(%a+) (.+)$")
                        if key and val then
                            cmus_info[key] = val
                        end
                    end
                end
            end

            local title = cmus_info.title

            if not title and cmus_info.file then
                title = cmus_info.file:gsub("%..-$", "")
                title = title:gsub("^.+/", "")
            end

            if title then
                if cmus_info["status"] == "playing" then
                    widget:update_icon("media-playback-start-symbolic.svg")
                elseif cmus_info["status"] == "paused" then
                    widget:update_icon("media-playback-pause-symbolic.svg")
                else
                    widget:update_icon("media-playback-stop-symbolic.svg")
                end

                widget:set_title(ellipsize(title, max_length))
                widget.visible = true
            else
                widget.visible = false
            end
        else
            widget.visible = false
        end
    end

    function cmus_widget:update()
        spawn.easy_async("cmus-remote -Q",
        function(stdout, _, _, code)
            update_widget(cmus_widget.widget, stdout, _, _, code)
        end)
    end

    function cmus_widget:play_pause()
        spawn("cmus-remote -u")
        cmus_widget.update()
    end

    function cmus_widget:pause()
        spawn("cmus-remote -U")
        cmus_widget.update()
    end

    function cmus_widget:play()
        spawn("cmus-remote -p")
        cmus_widget.update()
    end

    function cmus_widget:next_track()
        spawn("cmus-remote -n")
        cmus_widget.update()
    end

    function cmus_widget:prev_track()
        spawn("cmus-remote -r")
        cmus_widget.update()
    end

    function cmus_widget:stop()
        spawn("cmus-remote -s")
        cmus_widget.update()
    end

    cmus_widget.widget:buttons(
            awful.util.table.join(
                    awful.button({}, 1, function() cmus_widget:play_pause() end),
                    awful.button({}, 4, function() cmus_widget:prev_track() end),
                    awful.button({}, 5, function() cmus_widget:next_track() end)
            )
    )

    watch("cmus-remote -Q", timeout, update_widget, cmus_widget.widget)

    return cmus_widget.widget
end

return setmetatable(cmus_widget, { __call = function(_, ...)
    return worker(...)
end })
