{ pkgs, config, ... }:

{
  imports = [ ../dunst ];

  home.file = {
    ".config/awesome"             = { recursive = true; source = ./awesome; };
    ".config/autostart"           = { recursive = true; source = ./autostart; };
    ".config/picom.conf".source   = ./picom.conf;
  };

}
