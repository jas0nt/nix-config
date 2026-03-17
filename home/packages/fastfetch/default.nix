{ pkgs, ... }:

{
  home.packages = with pkgs; [ fastfetch ];

  xdg.configFile = {
    "fastfetch" = {
      recursive = true;
      source = ./config;
    };
  };

}
