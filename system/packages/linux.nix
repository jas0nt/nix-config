{
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    systemctl-tui
    bluez
    bluetuith
    libnotify
    feh
    kitty
    qview
    pcmanfm
  ];
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    configPackages = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  services.flatpak.enable = true;

  programs = {
    mosh.enable = true;
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld;
    };
    clash-verge = {
      enable = true;
      package = pkgs.clash-verge-rev;
    };
  };
}
