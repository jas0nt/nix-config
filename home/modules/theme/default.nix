{
  pkgs,
  config,
  const,
  ...
}:

{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    # package = pkgs.bibata-cursors;
    package = pkgs.fuchsia-cursor;
    name = "Fuchsia";
    size = 34;
  };

  gtk = {
    enable = true;
    font = {
      name = const.font;
      size = 12;
    };
    cursorTheme = {
      package = pkgs.fuchsia-cursor;
      name = "Fuchsia";
      size = 26;
    };
    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };
    iconTheme = {
      package = pkgs.beauty-line-icon-theme;
      name = "BeautyLine";
    };
  };

  home.file = {
    "wallpaper" = {
      recursive = true;
      source = ./wallpaper;
    };
  };

  services.hyprpaper = {
    enable = true;
    settings =
      let
        dune = "${config.home.homeDirectory}/wallpaper/dune.jpg";
        mojave = "${config.home.homeDirectory}/wallpaper/mojave.png";
      in
      {
        preload = [
          dune
          mojave
        ];
        wallpaper = [
          "HDMI-A-1,${dune}"
        ];
      };
  };

  services.wpaperd = {
    enable = false;
    settings = {
      default = {
        path = "./wallpaper";
        duration = "30m";
      };
    };
  };

}
