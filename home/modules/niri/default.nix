{
  pkgs,
  tools,
  config,
  inputs,
  ...
}:

{
  imports = [
    inputs.niri.homeModules.niri
    ../swaync
  ];

  home.file = {
    ".config/code-flags.conf" = {
      source = ./config/code-flags.conf;
    };
    ".config/wlogout/icons" = {
      recursive = true;
      source = ./config/wlogout/icons;
    };
  };

  home.packages = with pkgs; [
    xwayland-satellite
    pecita
    calcure
    # snipaste
    wl-clipboard
    wev
    libsForQt5.qt5.qttools
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    config = (builtins.readFile ./config/config.kdl);
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
          format-alt = "{bandwidthTotalBytes}";
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

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = [
        {
          monitor = "";
          path = "$HOME/wallpaper/dune.jpg";
          blur_passes = 0;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          position = "0, 60";
          dots_size = 0.26;
          dots_spacing = 0.64;
          dots_center = true;
          fade_on_empty = true;
          font_color = "rgb(40, 42, 54)";
          inner_color = "rgb(243, 156, 54)";
          outer_color = "rgb(243, 156, 54)";
          outline_thickness = 3;
          placeholder_text = "<i>Password...</i>";
          shadow_passes = 2;
          halign = "center";
          valign = "bottom";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<b><big> $(date +\"%H:%M:%S\") </big></b>\"";
          font_family = "Pecita";
          font_size = 110;
          color = "rgb(0, 0, 0)";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:18000000] echo \"<b> \"$(date +'%A, %-d %B %Y')\" </b>\"";
          font_family = "Pecita";
          font_size = 50;
          color = "rgb(0, 0, 0)";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "bash ~/scripts/desktop.sh lock";
        text = "lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "bash ~/scripts/desktop.sh logout";
        text = "logout";
        keybind = "q";
      }
      {
        label = "hibernate";
        action = "bash ~/scripts/desktop.sh hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "reboot";
        action = "bash ~/scripts/desktop.sh reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "bash ~/scripts/desktop.sh shutdown";
        text = "Shutdown";
        keybind = "s";
      }
    ];
    style = tools.substitute-file ./config/wlogout/style.css;
  };

}
