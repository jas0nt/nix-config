{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    waybar
  ];

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      };

      listener = [
        {
          timeout = 1800;
          on-timeout = "niri msg action power-off-monitors";
        }
        {
          timeout = 3600;
          on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
        }
      ];
    };
  };

  services.wpaperd = {
    enable = false;
    settings = {
      default = {
        path = config.home.homeDirectory + "/wallpaper";
        duration = "30m";
      };
    };
  };

  systemd.user.services = {

    fcitx5 = {
      Unit = {
        Description = "fcitx5";
        After = "graphical-session.target";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "fcitx5";
        Restart = "on-failure";
      };
    };

    mute_on_start = {
      Unit = {
        Description = "mute";
        After = "graphical-session.target";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 1";
        Restart = "on-failure";
      };
    };

    xwayland = {
      Unit = {
        Description = "xwayland";
        After = "graphical-session.target";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
        ExecStartPost = "${pkgs.libnotify}/bin/notify-send xwayland started";
        ExecStopPost = "${pkgs.libnotify}/bin/notify-send xwayland stopped";
        Restart = "on-failure";
      };
    };

    clash = {
      Unit = {
        Description = "fuckGFW";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.clash-meta}/bin/clash-meta -f .config/clash/config.yaml";
        ExecStopPost = "${pkgs.libnotify}/bin/notify-send clash stopped";
      };
    };

    # mybt = {
    #   Unit = {
    #     Description = "Bluetooth device";
    #     After = [ "pulseaudio.service" ];
    #     Requires = [ "pulseaudio.service" ];
    #   };
    #   Install = {
    #     WantedBy = [ "default.target" ];
    #   };
    #   Service = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.bluez}/bin/bluetoothctl connect D8:37:3B:66:E2:64";
    #     ExecStartPost = "${pkgs.pulsemixer}/bin/pulsemixer --mute";
    #     Restart = "on-failure";
    #     RestartSec = "5s";
    #   };
    # };

    waybar = {
      Unit = {
        Description = "Waybar";
        After = "graphical-session.target";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "on-failure";
      };
    };

  };
}
