{ const, config, pkgs, ... }:

{
  imports = [
    ./services
    ./modules/theme
    # ./modules/awesomewm
    ./modules/docker
    ./modules/hyprland
    ./modules/firefox
    ./modules/kitty
    ./modules/yazi
    ./modules/scripts
    ./modules/shell
    ./modules/input-method
    ./modules/emacs
    ./modules/vim
    ./packages
  ];
  
  home = {
    stateVersion = "24.11";

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
