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
    # wechat-uos
    qbittorrent
    motrix
    axel
    localsend
    libsForQt5.kdeconnect-kde
    steam
  ];

}
