{
  pkgs,
  pkgs-unstable,
  tools,
  config,
  ...
}:

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

    broot = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      settings = {
        icon_theme = "nerdfont";
      };
    };

  };

  stylix.targets = {
    bat = {
      enable = true;
      colors.enable = true;
    };
    btop = {
      enable = true;
      colors.enable = true;
      opacity.enable = true;
    };
  };

  home.packages = with pkgs; [
    krabby
    figlet
    genact
    lolcat
    nms
    freerdp
    just
    wlrctl
    tray-tui
    sshfs
    axel

    gparted
    snipaste
    wpsoffice-cn
    qq
    wechat
    xunlei-uos
    (tools.scale pkgs qbittorrent 1.3)
    (tools.scale pkgs motrix 1.4)
    localsend
    tigervnc
  ];

}
