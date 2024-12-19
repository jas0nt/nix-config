{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    ffmpeg

    spotify
    cmus
    playerctl
    mpc-cli
    vlc
    puddletag # mp3 tag editor

    imv
    pix
    nomacs

    yt-dlp
    ytdownloader
    clipgrab
    media-downloader
    yutto  # bilibili downloader
  ];

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = [ "gpu-hq" ];
      scripts = [ pkgs.mpvScripts.mpris ];
    };

    obs-studio.enable = true;
  };

  services = {
    playerctld.enable = true;
  };
}
