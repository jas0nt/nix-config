{ pkgs, config, tools, ... }:

{
  home.packages = with pkgs; [
    ffmpeg
    pasystray

    playerctl
    vlc
    (tools.scale pkgs puddletag 1.4)
    nomacs
    (tools.scale pkgs pix 1.6)

    yt-dlp
    ytdownloader
    clipgrab
    media-downloader
    yutto # bilibili downloader
    slurp
    wf-recorder
  ];

  programs.cmus = {
    enable = true;
    theme = "dracula";
  };

  programs = {
    obs-studio.enable = true;

    cava = {
      enable = true;
      settings = {
        general.framerate = 60;
        input.method = "pipewire";
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
