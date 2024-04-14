--      ██╗    ██╗ █████╗ ██╗     ██╗     ██████╗  █████╗ ██████╗ ███████╗██████╗
--      ██║    ██║██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
--      ██║ █╗ ██║███████║██║     ██║     ██████╔╝███████║██████╔╝█████╗  ██████╔╝
--      ██║███╗██║██╔══██║██║     ██║     ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
--      ╚███╔███╔╝██║  ██║███████╗███████╗██║     ██║  ██║██║     ███████╗██║  ██║
--       ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝

-- ===================================================================
-- Imports
-- ===================================================================


local awful = require("awful")
local gears = require("gears")


-- ===================================================================
-- Initialization
-- ===================================================================


local is_blurred = false;

local wallpaper_dir = os.getenv("HOME") .. "/wallpaper"
local wallpaper = wallpaper_dir .. "/wallpaper.jpg"
local blurred_wallpaper = wallpaper_dir .. "/blurredWallpaper.png"

awful.spawn.with_shell("feh --bg-fill " .. wallpaper)

--- Check if a file or directory exists in this path
local function exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

-- ===================================================================
-- Functionality
-- ===================================================================


-- changes to blurred wallpaper
local function blur()
   if not is_blurred then
      awful.spawn.with_shell("feh --bg-fill " .. blurred_wallpaper)
      is_blurred = true
   end
end

-- changes to normal wallpaper
local function unblur()
   if is_blurred then
      awful.spawn.with_shell("feh --bg-fill " .. wallpaper)
      is_blurred = false
   end
end

-- blur / unblur on tag change
tag.connect_signal("property::selected", function(t)
   -- check if tag has any clients
   for _ in pairs(t:clients()) do
      blur()
      return
   end
   -- unblur if tag has no clients
   unblur()
end)

-- check if wallpaper should be blurred on client open
client.connect_signal("manage", function(c)
   blur()
end)

-- check if wallpaper should be unblurred on client close
client.connect_signal("unmanage", function(c)
   local t = awful.screen.focused().selected_tag
   -- check if tag has any clients
   for _ in pairs(t:clients()) do
      return
   end
   -- unblur if tag has no clients
   unblur()
end)
