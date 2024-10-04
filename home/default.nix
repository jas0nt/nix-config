{ config, pkgs, ... }:

{
  imports = [
    ./services
    ./modules/theme
    # ./modules/awesomewm
    ./modules/hyprland
    ./modules/firefox
    ./modules/btop
    ./modules/rofi
    ./modules/kitty
    ./modules/fastfetch
    ./modules/scripts
    ./modules/shell/bash
    ./modules/shell/nushell
    # ./modules/shell/fish
    ./modules/ranger
    ./modules/input-method
    ./modules/emacs
    ./modules/lunarvim
    ./modules/helix
    ./modules/cava
    ./packages
  ];
  
  home = {
    stateVersion = "24.05";

    username = "jason";
    homeDirectory = "/home/jason";

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
