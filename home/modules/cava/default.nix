{ lib, pkgs, ... }:

{

  home.packages = with pkgs; [ cava ];

  home.file.".config/cava/config".source = ./config/config;

}
