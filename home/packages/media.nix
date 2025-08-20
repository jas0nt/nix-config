{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    ffmpeg
    pasystray

    playerctl
    vlc
    puddletag # mp3 tag editor
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

    cava = {
      enable = true;
      settings = {
        general.framerate = 60;
        input.method = "pulse";
        input.source = "auto";
        smoothing.noise_reduction = 88;
        color = {
          gradient = 1;
          gradient_color_1 = "'#8BE9FD'";
          gradient_color_2 = "'#9AEDFE'";
          gradient_color_3 = "'#CAA9FA'";
          gradient_color_4 = "'#BD93F9'";
          gradient_color_5 = "'#FF92D0'";
          gradient_color_6 = "'#FF79C6'";
          gradient_color_7 = "'#FF6E67'";
          gradient_color_8 = "'#FF5555'";
        };
      };
    };
  };

  services = {
    playerctld.enable = true;
  };
}
