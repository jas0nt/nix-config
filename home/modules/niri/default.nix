{ pkgs, config, inputs, ... }:

{
  imports = [
    inputs.niri.homeModules.niri
    ../swaync
  ];

  home.file = {
    ".config/niri/config.kdl" = {
      source = ./config/config.kdl;
    };
    ".config/code-flags.conf" = {
      source = ./config/code-flags.conf;
    };
    ".config/hypr" = {
      recursive = true;
      source = ./config/hypr;
    };
    ".config/waybar" = {
      recursive = true;
      source = ./config/waybar;
    };
    ".config/wlogout" = {
      recursive = true;
      source = ./config/wlogout;
    };
  };

  home.packages = with pkgs; [
    xwayland-satellite
    calcure
    snipaste
    wl-clipboard
  ];

  programs.niri = { 
    enable = true; 
  };

  programs.hyprlock.enable = true;

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "bash ~/scripts/desktop.sh lock";
        text = "lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "bash ~/scripts/desktop.sh logout";
        text = "logout";
        keybind = "q";
      }
      {
        label = "hibernate";
        action = "bash ~/scripts/desktop.sh hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "reboot";
        action = "bash ~/scripts/desktop.sh reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "bash ~/scripts/desktop.sh shutdown";
        text = "Shutdown";
        keybind = "s";
      }
    ];
    style = (builtins.readFile ./config/wlogout/style.css);
  };

}
