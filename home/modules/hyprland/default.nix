{ pkgs, config, ... }:

{
  home.packages = with pkgs; [ calcure ];

  home.file = {
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

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "~/scripts/desktop.sh lock";
        text = "lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "~/scripts/desktop.sh logout";
        text = "logout";
        keybind = "q";
      }
      {
        label = "hibernate";
        action = "~/scripts/desktop.sh hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "reboot";
        action = "~/scripts/desktop.sh reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "~/scripts/desktop.sh shutdown";
        text = "Shutdown";
        keybind = "s";
      }
    ];
    style = (builtins.readFile ./config/wlogout/style.css);
  };

}
