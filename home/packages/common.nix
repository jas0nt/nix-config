{ pkgs, pkgs-unstable, tools, config, ... }:

{

  programs = {

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };

    btop = {
      enable = true;
      settings = {
        proc_tree = true;
      };
    };

    jq = {
      enable = true;
    };

    aria2 = {
      enable = true;
    };

  };

  home.packages = with pkgs; [
    krabby
    figlet
    genact
    lolcat
    nms

    miniserve
    freerdp
    just
    wlrctl
    gparted
    tray-tui
    sshfs

    snipaste
    wpsoffice-cn
    qq
    wechat
    xunlei-uos
    (tools.scale pkgs qbittorrent 1.5)
    qbittorrent-cli
    (tools.scale pkgs motrix 1.4)
    axel
    localsend
    tigervnc
  ];

}
