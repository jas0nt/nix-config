{ lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  home.file = {
    ".config/swaync" = { recursive = true; source = ./config; };
  };

}
