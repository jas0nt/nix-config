{ config, pkgs, ... }:

{

  imports = [
    ./services
    ./modules/theme
    ./modules/awesomewm
    ./modules/rofi
    ./modules/kitty
    ./modules/shell
    ./modules/ranger
    ./modules/input-method
    ./modules/lunarvim
    ./modules/helix
    ./modules/cava
    ./modules/dunst
    ./packages
  ];

  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.11";

    username = "jason";
    homeDirectory = "/home/jason";

    sessionVariables = {
      EDITOR = "lvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
