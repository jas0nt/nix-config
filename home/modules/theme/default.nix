{ pkgs, ... }:

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
    font.name = "Fira Code";
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

}
