{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    spotify
    cmus
    playerctl
    mpc-cli
    vlc
    puddletag # mp3 tag editor

    imv
    cinnamon.pix
    nomacs
  ];

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = [ "gpu-hq" ];
      scripts = [ pkgs.mpvScripts.mpris ];
    };

    obs-studio.enable = true;
  };

  services = { playerctld.enable = true; };
}
