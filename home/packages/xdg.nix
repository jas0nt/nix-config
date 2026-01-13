{ config, ... }:
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
    "x-scheme-handler/discord" = [ "discordcanary.desktop" ];
    "x-scheme-handler/magnet" = [ "qbittorrent.desktop" ];
    "x-scheme-handler/spotify" = [ "spotify.desktop" ];
    "x-scheme-handler/tg" = [ "telegramdesktop.desktop" ];

    "audio/*" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
    "text/vnd.trolltech.linguist" = [ "mpv.desktop" ];
    "image/gif" = [ "com.interversehq.qView.desktop" ];
    "image/png" = [ "com.interversehq.qView.desktop" ];
    "image/jpg" = [ "com.interversehq.qView.desktop" ];
    "image/jpeg" = [ "com.interversehq.qView.desktop" ];
    "image/webp" = [ "com.interversehq.qView.desktop" ];
    "image/*" = [ "com.interversehq.qView.desktop" ];
    "text/*"  = [ "vim.desktop" ];
    "inode/directory" = [ "yazi.desktop" ];
    "text/plain"  = [ "vim.desktop" ];

    "application/x-bittorrent" = [ "qbittorrent.desktop" ];
  };
in
{
  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";

    desktopEntries = {
      yazi = {
        name = "yazi";
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
