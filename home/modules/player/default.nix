{ pkgs, ... }:

{
  home.file = {
    ".config/mpv/scripts" = {
      recursive = true;
      source = ./scripts;
    };
  };

  programs = {
    mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        slang = "zh-Hans,zh-CN,zh-cn,sc,Chinese (Simplified),chi,zh,zho,tc,en,eng";
      };
      scripts = with pkgs.mpvScripts; [
        mpris
        webtorrent-mpv-hook
      ];
    };
  };
}
