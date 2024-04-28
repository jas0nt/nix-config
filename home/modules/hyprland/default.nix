{ pkgs, config, ... }:

{
  home.packages = with pkgs; [ calcure ];

  home.file = {
    ".config/hypr" = {
      recursive = true;
      source = ./config/hypr;
    };
    ".config/waybar" = {
      recursive = true;
      source = ./config/waybar;
    };
  };

}
