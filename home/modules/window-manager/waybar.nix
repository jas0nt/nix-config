{
  tools,
  ...
}:

{
  stylix.targets.waybar = {
    enable = true;
    addCss = false;
    fonts.enable = true;
    colors.enable = true;
    opacity.enable = true;
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    style = tools.substitute-file ./config/waybar/style.css;
    settings = {
      mainBar = {
        output = [
          "HDMI-A-1"
        ];
        layer = "top";
        position = "bottom";
        height = 10;
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;

        modules-left = [
          "custom/launcher"
          "niri/workspaces"
          "wlr/taskbar"
          "niri/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "custom/playerlabel"
          "wireplumber"
          "tray"
          "network"
          "custom/notification"
        ];

        "custom/launcher" = {
          format = "";
          on-click = "niri msg action toggle-overview";
          on-click-right = "bash ~/scripts/desktop.sh logout-menu";
          on-scroll-up = "niri msg action focus-workspace-up";
          on-scroll-down = "niri msg action focus-workspace-down";
        };
        "niri/workspaces" = {
          current-only = false;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            browser = "";
            code = "";
            fm = "";
            download = "󰅢";
            game = "󰓓";
            chat = "󰭹";
            default = "";
            sort-by-number = true;
          };
          on-scroll-up = "niri msg action focus-column-left";
          on-scroll-down = "niri msg action focus-column-right";
        };
        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 25;
          tooltip-format = "{app_id} - {title}";
          on-click = "activate";
        };
        "niri/window" = {
          format = "{title}";
        };

        "clock" = {
          tooltip = false;
          format = "{:%H:%M %a %b %d}";
          on-click = "bash ~/scripts/desktop.sh calendar";
          on-click-right = "bash ~/scripts/desktop.sh record-screen";
        };
        "custom/playerlabel" = {
          format = "<span>{icon}{}</span>";
          return-type = "json";
          max-length = 48;
          exec = "playerctl -i firefox -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
          on-click = "playerctl -i firefox play-pause";
          on-scroll-up = "playerctl previous";
          on-scroll-down = "playerctl next";
          format-icons = {
            Playing = "<span foreground='#bd93f9'>▶</span>";
            Paused = "<span foreground='#6272a4'>⏸</span>";
          };
        };
        "wireplumber" = {
          format = "{volume}";
          format-muted = "{volume}";
          on-click = "bash ~/scripts/volume.sh mute";
          on-click-right = "bash ~/scripts/volume.sh gui";
          max-volume = 100;
          scroll-step = 1;
        };
        "pulseaudio" = {
          format = "{volume}";
          format-muted = "{volume}";
          format-icons = {
            default = [
              ""
              "󰔷"
              ""
              ""
            ];
          };
          on-click = "bash ~/scripts/volume.sh mute";
          on-click-right = "bash ~/scripts/volume.sh gui";
          on-scroll-up = "bash ~/scripts/volume.sh up";
          on-scroll-down = "bash ~/scripts/volume.sh down";
          scroll-step = 5;
        };
        "tray" = {
          icon-size = 25;
          spacing = 7;
          reverse-direction = true;
          icons = {
            blueman = "bluetooth";
            qBittorrent = "qbittorrent-tray";
            steam = "steam";
            obs = "obs";
            wechat = "wechat";
            QQ = "qq";
          };
        };
        "network" = {
          format = "{iframe}";
          format-wifi = "󰖩";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          tooltip-format = "{essid}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ifname} ";
          tooltip-format-disconnected = "Disconnected";
          on-click-right = "bash ~/scripts/desktop.sh network-manager";
        };
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{icon} {time}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "bash ~/scripts/desktop.sh notification-center";
          on-click-right = "bash ~/scripts/desktop.sh notification-dnd";
          escape = true;
        };

      };
    };
  };

}
