{ pkgs, pkgs-unstable, ... }:

{
  imports = [ ./minimal/sys-pkgs.nix ];

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
    clash-verge = {
      enable = true;
      package = pkgs.clash-verge-rev;
    };

    nix-ld = {
      enable = true;
      package = pkgs.nix-ld;
    };

  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Modern unix tools
    htop
    progress
    choose # cut
    dust
    dua # du
    duf # df
    eza # ls
    fd # find
    httpie # curl
    procs # ps
    silver-searcher
    ripgrep # grep
    fx # json
    hyperfine # time
    tree
    systemctl-tui
    bluez
    bluetuith
    libnotify

    # GUI apps
    kitty
    feh
    qview
    firefox
    pcmanfm
    networkmanagerapplet
  ];

}
