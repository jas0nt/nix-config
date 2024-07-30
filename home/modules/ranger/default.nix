{ pkgs, ... }:

{
  home.packages = [ pkgs.ranger ];

  home.file = {
    ".config/ranger" = {
      recursive = true;
      source = ./config;
    };
  };

}
