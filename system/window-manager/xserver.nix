{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "us";
    excludePackages = [ pkgs.xterm ];

    displayManager = {
      # Enable automatic login for the user.
      autoLogin.enable = true;
      autoLogin.user = "jason";
      sddm = {
        enable = true;
        theme = "where_is_my_sddm_theme";
      };
    };

  };

  environment.systemPackages = with pkgs; [ where-is-my-sddm-theme ];

}
