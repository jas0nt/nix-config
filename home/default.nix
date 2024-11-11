{ const, config, pkgs, ... }:

{
  imports = [
    ./services
    ./modules/theme
    # ./modules/awesomewm
    ./modules/hyprland
    ./modules/firefox
    ./modules/kitty
    ./modules/yazi
    ./modules/scripts
    ./modules/shell
    ./modules/input-method
    ./modules/emacs
    ./modules/lunarvim
    ./packages
  ];
  
  home = {
    stateVersion = "24.05";

    username = const.username;
    homeDirectory = "/home/${const.username}";

    sessionVariables = {
      EDITOR = "lvim";
      BROWSER = "firefox";
      TERM = "kitty";
      TERMINAL = "kitty";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  home.packages = with pkgs; [
    home-manager
  ];

}
