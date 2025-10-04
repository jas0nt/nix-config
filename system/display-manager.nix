{ const, config, pkgs, ... }:

let
  theme = "--theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red";
  options = "--time --remember --remember-user-session --asterisks";
  cmd = "${pkgs.niri}/bin/niri-session";
in
{

  services.displayManager = {
    enable = true;
    sessionPackages = [ pkgs.niri ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet ${theme} ${options}";
        user = "greeter";
      };
      initial_session = {
        command = "${cmd}";
        user = const.username;
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
