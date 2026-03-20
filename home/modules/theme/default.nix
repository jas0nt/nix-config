{
  inputs,
  pkgs,
  config,
  const,
  lib,
  ...
}:

{
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  stylix = {
    enable = true;
    autoEnable = true;
    image = ./wallpaper/dune.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

    fonts = {
      monospace = {
        name = const.font;
        package = pkgs.maple-mono.NF;
      };
      sansSerif = {
        name = const.font;
        package = pkgs.maple-mono.NF;
      };
      sizes = {
        desktop = 18;
        applications = 12;
        terminal = 19;
        popups = 18;
      };
    };

    opacity = {
      desktop = 1.0;
      applications = 1.0;
      terminal = 0.7;
      popups = 1.0;
    };
  }
  // lib.optionalAttrs const.is-linux {
    cursor = {
      package = pkgs.fuchsia-cursor;
      name = "Fuchsia";
      size = 26;
    };

    icons = {
      enable = true;
      package = pkgs.beauty-line-icon-theme;
      dark = "BeautyLine";
      light = "BeautyLine";
    };

    targets = {
      gtk.enable = true;
      hyprpaper.enable = true;
    };
  };

  home.file = {
    "wallpaper" = {
      recursive = true;
      source = ./wallpaper;
    };
  };
}
// lib.optionalAttrs const.is-linux {
  services.hyprpaper = {
    enable = true;
  };
}
