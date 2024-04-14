{ lib, pkgs, ... }:

{

  programs.helix.enable = true;

  home.file = {
    ".config/helix" = { recursive = true; source = ./config; };
  };
}
