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

    qq
    wechat-uos
    qbittorrent
    motrix
    axel
    localsend

    steam
    wqy_zenhei
    wqy_microhei
  ];

}
