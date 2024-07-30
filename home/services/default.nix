{ pkgs, ... }:

{
  systemd.user.services = {

    clash = {
      Unit = { Description = "fuckGFW"; };
      Install = { WantedBy = [ "default.target" ]; };
      Service = {
        Type = "simple";
        ExecStart =
          "${pkgs.clash-meta}/bin/clash-meta -f .config/clash/config.yaml";
      };
    };

    mybt = {
      Unit = {
        Description = "Bluetooth device";
        Requires = [ "pulseaudio.service" ];
      };
      Install = { WantedBy = [ "default.target" ]; };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.bluez}/bin/bluetoothctl connect D8:37:3B:66:E2:64";
        Restart = "on-failure";
      };
    };

  };
}
