{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fortune
    pokemonsay
    genact
    lolcat
    nms

    miniserve
    freerdp
    just
    wlrctl

    wineWowPackages.waylandFull
    winePackages.fonts
    winetricks
    bottles

    qq
    wechat-uos
    qbittorrent
    motrix
    axel
    localsend

    steam
    gamemode
    wqy_zenhei
    wqy_microhei
  ];

}
