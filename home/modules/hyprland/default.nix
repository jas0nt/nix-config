{ pkgs, config, ... }:

{

  home.file = {
    ".config/hypr" = {
      recursive = true;
      source = ./config/hypr;
    };
    ".config/waybar" = {
      recursive = true;
      source = ./config/waybar;
    };
    ".config/swaylock" = {
      recursive = true;
      source = ./config/swaylock;
    };
  };

}
