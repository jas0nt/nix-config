{ pkgs, ... }:

{
  xdg.configFile = {
    "mpv/scripts" = {
      recursive = true;
      source = ./scripts;
    };
  };

  stylix.targets.mpv = {
    enable = true;
    fonts.enable = true;
    colors.enable = true;
  };

  programs = {
    mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        slang = "zh-Hans,zh-CN,zh-cn,sc,Chinese (Simplified),chi,zh,zho,tc,en,eng";
        sub-auto = "all";

        gpu-context = "wayland";
        vo = "gpu-next";

        save-position-on-quit = "yes";
        watch-later-directory = "~~/watch_later";
        directory-mode = "playlist";
      };
      scripts = with pkgs.mpvScripts; [
        mpris
        webtorrent-mpv-hook
      ];
    };
  };

  xdg.configFile."mpv/scripts/autoload.lua".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/lua/autoload.lua";
    hash = "sha256-wO9awsko9qDTRkwUpAMQSWjXM5yx7XzaZClF+EINh0Q=";
  };
}
