{ lib, pkgs, ... }:

{

  programs.kitty.enable = true;

  home.file = {
    ".config/kitty" = { recursive = true; source = ./config; };
  };

}
