{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    ffmpeg

    spotify
    playerctl
    vlc
    puddletag # mp3 tag editor

    pix
    nomacs

    yt-dlp
    ytdownloader
    clipgrab
    media-downloader
    yutto  # bilibili downloader
  ];

  programs.cmus = {
    enable = true;
    theme = "dracula";
  };

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
