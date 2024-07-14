{ pkgs, config, ... }:

{
  imports = [ ../dunst ];

  home.packages = with pkgs; [
    xdotool
    xwallpaper
  ];


  home.file = {
    ".config/awesome"             = { recursive = true; source = ./awesome; };
    ".config/autostart"           = { recursive = true; source = ./autostart; };
    ".config/picom.conf".source   = ./picom.conf;
  };

}
