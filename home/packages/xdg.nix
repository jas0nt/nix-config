{ config, pkgs, ... }:
let
  browser = [ "firefox.desktop" ];

  # XDG MIME types
  associations = {
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "application/json" = browser;
    "application/pdf" = browser;
    "text/html" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;
    "x-scheme-handler/magnet" = [ "qbittorrent.desktop" ];

    "audio/*" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
    "image/gif" = [ "com.interversehq.qView.desktop" ];
    "image/png" = [ "com.interversehq.qView.desktop" ];
    "image/jpg" = [ "com.interversehq.qView.desktop" ];
    "image/jpeg" = [ "com.interversehq.qView.desktop" ];
    "image/webp" = [ "com.interversehq.qView.desktop" ];
    "image/*" = [ "com.interversehq.qView.desktop" ];
    "text/*" = [ "vim.desktop" ];
    "inode/directory" = [ "yazi.desktop" ];
    "text/plain" = [ "vim.desktop" ];

    "application/x-bittorrent" = [ "qbittorrent.desktop" ];
  };
in
{
  xdg = {
    enable = true;

    # niri-flake points NIX_XDG_DESKTOP_PORTAL_DIR at the user profile,
    # hiding system portals; install gtk here so FileChooser = gtk works
    # (the gnome portal delegates to nautilus, which isn't available).
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    desktopEntries = {
      yazi = {
        name = "yazi";
        icon = "yazi";
        genericName = "File Manager";
        exec = "kitty --class fm yazi %f";
        terminal = false;
        mimeType = [
          "inode/directory"
        ];
      };

    };

    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };
}
