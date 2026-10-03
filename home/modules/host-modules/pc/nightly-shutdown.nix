{ pkgs, ... }:

let
  nightlyShutdown = pkgs.writeShellScript "nightly-shutdown" ''
    notify() {
      ${pkgs.libnotify}/bin/notify-send -u critical -i system-shutdown "$1" "$2" || true
    }

    notify "Shutdown Warning" "The system will shut down in 5 minutes (22:45)."
    sleep 240
    notify "Shutdown Warning" "The system will shut down in 1 minute. Please save your work."
    sleep 60
    exec ${pkgs.systemd}/bin/systemctl poweroff
  '';
in
{
  systemd.user.services.nightly-shutdown = {
    Unit.Description = "Nightly shutdown with warning";
    Service = {
      Type = "oneshot";
      ExecStart = "${nightlyShutdown}";
    };
  };

  systemd.user.timers.nightly-shutdown = {
    Unit.Description = "Warn at 22:40, shutdown at 22:45";
    Timer = {
      OnCalendar = "*-*-* 22:40:00";
      Persistent = false;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
