{ pkgs, ... }:

{
  services = {

    xserver = {
      enable = true;
      xkb.layout = "us";
      excludePackages = [ pkgs.xterm ];

      displayManager.lightdm = {
        greeters.mini = {
          enable = true;
          user = "jason";
          extraConfig = ''
            [greeter]
            show-password-label = false
            show-sys-info = true
            [greeter-theme]
            background-image = ""
            [greeter-hotkeys]
            mod-key = meta
            shutdown-key = s
            restart-key = r
            hibernate-key = h
            suspend-key = u
            session-key = e
          '';
        };
      };

    };

    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "jason";
    };

  };

  environment.systemPackages = with pkgs; [
    wmctrl
  ];

}
