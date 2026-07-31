{ pkgs, lib, ... }:
{
  xdg.desktopEntries.macmag = let
    openMagnetOnMac = pkgs.writeShellScript "open-magnet-mac" ''
      exec ssh mac "open '$1'"
    '';
  in {
    name = "macmag";
    icon = "uget";
    genericName = "open magnet";
    exec = "${openMagnetOnMac} %u";
    terminal = false;
    mimeType = [ "x-scheme-handler/magnet" ];
  };

  xdg.mimeApps.defaultApplications."x-scheme-handler/magnet" =
    lib.mkForce [ "macmag.desktop" "qbittorrent.desktop" ];
}
