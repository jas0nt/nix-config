{ const, config, pkgs, ... }:

let
  theme = "--theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red";
  options = "--time --remember --remember-user-session --asterisks";
  sessions = "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
  xsessions = "--xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions";
  cmd = "niri-session";
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet ${theme} ${options} ${sessions} ${xsessions} --cmd ${cmd}";
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
