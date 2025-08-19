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
    wpaperd
    calcure
    # snipaste
    wl-clipboard
  ];

  programs.niri = { 
    enable = true; 
    package = pkgs.niri;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = [
        {
          monitor = "";
          path = "$HOME/wallpaper/sekiro.png";
          blur_passes = 0;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          position = "0, 60";
          dots_size = 0.26;
          dots_spacing = 0.64;
          dots_center = true;
          fade_on_empty = true;
          font_color = "rgb(40, 42, 54)";
          inner_color = "rgb(248, 248, 242)";
          outer_color = "rgb(248, 248, 242)";
          outline_thickness = 3;
          placeholder_text = "<i>Password...</i>";
          shadow_passes = 2;
          halign = "center";
          valign = "bottom";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<b><big> $(date +\"%H:%M:%S\") </big></b>\"";
          font_family = "Recursive Mono Casual Static";
          font_size = 96;
          color = "rgb(40, 42, 54)";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:18000000] echo \"<b> \"$(date +'%A, %-d %B %Y')\" </b>\"";
          font_family = "Recursive Mono Casual Static";
          font_size = 40;
          color = "rgb(40, 42, 54)";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

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
