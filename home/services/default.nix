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
          on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 1830;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  systemd.user.services = {

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
      };
    };

    mybt = {
      Unit = {
        Description = "Bluetooth device";
        Requires = [ "pulseaudio.service" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.bluez}/bin/bluetoothctl connect D8:37:3B:66:E2:64";
        ExecStartPost = "${pkgs.pulsemixer}/bin/pulsemixer --mute";
        Restart = "on-failure";
      };
    };

    waybar = {
      Unit = {
        Description = "Waybar";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "on-failure";
        RestartSec = "15s";
      };
    };

  };
}
