{ pkgs, ... }:

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

  systemd.user.services = {

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
