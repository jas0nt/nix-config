{ lib, pkgs, ... }:

{
  programs.pywal.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };

  gtk = {
    enable = true;
    font.name = "Fira Code";
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 20;
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
