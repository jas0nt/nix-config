{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [ gum ];

  home.file = {
    "scripts" = {
      recursive = true;
      source = ./config;
      executable = true;
    };
  };

}
