{ pkgs, lib, ... }:

{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      wqy_zenhei # steam font
      # nerdfonts
      fira-code-nerdfont
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif CJK SC" ];
        sansSerif = [ "Noto Sans CJK SC" ];
        monospace = [ "FiraCode Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

}
