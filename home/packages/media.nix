{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    ffmpeg

    playerctl
    vlc
    puddletag # mp3 tag editor
    tagger

    nomacs

    yt-dlp
    ytdownloader
    clipgrab
    media-downloader
    yutto # bilibili downloader
  ];

  programs.cmus = {
    enable = true;
    theme = "dracula";
  };

  programs = {
    mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
      };

      scripts = with pkgs.mpvScripts; [
        mpris
        webtorrent-mpv-hook
      ];
    };

    obs-studio.enable = true;
  };

  services = {
    playerctld.enable = true;
  };
}
