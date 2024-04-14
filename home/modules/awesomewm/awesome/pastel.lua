--      ██████╗  █████╗ ███████╗████████╗███████╗██╗
--      ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║
--      ██████╔╝███████║███████╗   ██║   █████╗  ██║
--      ██╔═══╝ ██╔══██║╚════██║   ██║   ██╔══╝  ██║
--      ██║     ██║  ██║███████║   ██║   ███████╗███████╗
--      ╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local gears = require("gears")
local mytable = awful.util.table or gears.table -- 4.{0,1} compatibility

local pastel = {}


-- ===================================================================
-- Pastel setup
-- ===================================================================

awful.util.taglist_buttons =
    mytable.join(
       awful.button(
          {},
          1,
          function(t)
             t:view_only()
          end
       ),
       awful.button(
          { modkey },
          1,
          function(t)
             if client.focus then
                client.focus:move_to_tag(t)
             end
          end
       ),
       awful.button({}, 3, awful.tag.viewtoggle),
       awful.button(
          { modkey },
          3,
          function(t)
             if client.focus then
                client.focus:toggle_tag(t)
             end
          end
       ),
       awful.button(
          {},
          4,
          function(t)
             awful.tag.viewnext(t.screen)
          end
       ),
       awful.button(
          {},
          5,
          function(t)
             awful.tag.viewprev(t.screen)
          end
       )
    )


pastel.initialize = function()
   -- Import components
   require("components.pastel.wallpaper")
   require("components.exit-screen")

   -- Import panels
   local mybar = require("components.pastel.mybar")

   -- Set up each screen (add tags & panels)
   awful.screen.connect_for_each_screen(function(s)
      for i = 1, 9, 1
      do
         awful.tag.add(i, {
            layout = awful.layout.suit.tile,
            screen = s,
            selected = i == 1
         })
      end

      -- Add the top panel to every screen
      mybar.create(s)
   end)
end

return pastel
