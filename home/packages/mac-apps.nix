{ pkgs, ... }:

{
  home.packages = with pkgs; [
    just
    krabby
    iterm2
    iina
    the-unarchiver
    qbittorrent
  ];
}
