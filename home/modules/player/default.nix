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
      };
      scripts = with pkgs.mpvScripts; [
        mpris
        webtorrent-mpv-hook
      ];
    };
  };
}
