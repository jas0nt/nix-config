{ const, config, pkgs, ... }:

{
  imports = [
    ./services
    ./modules/theme
    # ./modules/awesomewm
    ./modules/docker
    ./modules/niri
    # ./modules/hyprland
    ./modules/firefox
    ./modules/kitty
    ./modules/launcher
    ./modules/yazi
    ./modules/scripts
    ./modules/shell
    ./modules/input-method
    ./modules/git
    ./modules/emacs
    ./modules/vim
    ./modules/helix
    ./packages
  ];
  
  home = {
    stateVersion = "25.05";

    username = const.username;
    homeDirectory = "/home/${const.username}";

    sessionVariables = {
      EDITOR = "vim";
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
