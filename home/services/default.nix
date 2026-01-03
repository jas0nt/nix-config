{ config, pkgs, ... }:

{

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        after_sleep_cmd = "loginctl lock-session"; 
      };

      listener = [
        {
          timeout = 1800;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1830;
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
      ];
    };
  };

  systemd.user.services = {

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
        ExecStartPost = "${pkgs.libnotify}/bin/notify-send -i wayland xwayland started";
        ExecStopPost = "${pkgs.libnotify}/bin/notify-send -i wayland xwayland stopped";
        Restart = "on-failure";
      };
    };

    fuckgfw = {
      Unit = {
        Description = "fuckgfw";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.mihomo}/bin/mihomo -f .config/fuckgfw/config.yaml";
        ExecStopPost = "${pkgs.libnotify}/bin/notify-send fuckgfw stopped";
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

  };
}
