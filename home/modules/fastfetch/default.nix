{ lib, pkgs, ... }:

{

  home.packages = with pkgs; [ fastfetch ];

  home.file = {
    ".config/fastfetch" = {
      recursive = true;
      source = ./config;
    };
  };

}
