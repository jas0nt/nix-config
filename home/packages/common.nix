{ pkgs, ... }:

{

  programs = {

    bat = {
      enable = true;
      themes = {
        dracula = {
          src = pkgs.fetchFromGitHub {
            owner = "dracula";
            repo = "sublime"; # Bat uses sublime syntax for its themes
            rev = "456d3289827964a6cb503a3b0a6448f4326f291b";
            sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
          };
          file = "Dracula.tmTheme";
        };
      };
      config = {
        theme = "dracula";
        pager = "less -FR";
      };
    };

    btop = {
      enable = true;
      settings = {
        color_theme = "dracula";
        proc_tree = true;
      };
    };

    jq = {
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
    freerdp3
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
  ];

}
