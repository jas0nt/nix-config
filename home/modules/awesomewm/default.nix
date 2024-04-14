{ pkgs, config, ... }:

{

  home.file = {
    ".config/awesome"             = { recursive = true; source = ./awesome; };
    ".config/autostart"           = { recursive = true; source = ./autostart; };
    ".config/picom.conf".source   = ./picom.conf;
  };

  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 192;
  # };

}
