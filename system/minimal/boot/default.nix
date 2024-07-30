{ pkgs, ... }:

{
  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader = {
    efi = { canTouchEfiVariables = true; };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      theme = ./sekiro_grub_theme;
      splashImage = ./sekiro_grub_theme/sekiro_2560x1440.png;
    };
  };

  console = {
    earlySetup = true;
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-114n.psf.gz";
    keyMap = "us";
    colors = [
      "282a36"
      "ff5555"
      "50fa7b"
      "f1fa8c"
      "bd93f9"
      "ff79c6"
      "8be9fd"
      "f8f8f2"
      "6272a4"
      "ff7777"
      "70fa9b"
      "ffb86c"
      "cfa9ff"
      "ff88e8"
      "97e2ff"
      "ffffff"
    ];
  };

}

