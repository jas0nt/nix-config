{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    fortune
    pokemonsay
    genact
    lolcat
    nms

    neofetch
    miniserve
    freerdp
    just

    wpsoffice
    qq
    qbittorrent
    motrix
    axel
    aria2
    localsend
    libsForQt5.kdeconnect-kde
    steam
  ];

}
