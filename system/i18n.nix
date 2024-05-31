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
      source-han-sans
      fira-code
      fira-code-nerdfont
      noto-fonts-emoji
    ];

    fontconfig = {
      defaultFonts = let my-fonts = [
        "Source Han Sans"
        "Fira Code"
      ];
      in {
        serif = my-fonts;
        sansSerif = my-fonts;
        monospace = my-fonts;
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

}
