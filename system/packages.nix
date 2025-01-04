{ pkgs, pkgs-unstable, ... }:

{
  imports = [ ./minimal/sys-pkgs.nix ];

  programs = {
    mosh.enable = true;
    clash-verge = {
      enable = true;
      package = pkgs.clash-verge-rev;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Modern unix tools
    htop
    choose # cut
    du-dust
    dua # du
    duf # df
    eza # ls
    fd # find
    httpie # curl
    procs # ps
    silver-searcher
    ripgrep # grep
    fx # json
    tree
    systemctl-tui
    bluez
    bluetuith
    libnotify

    # GUI apps
    kitty
    feh
    qview
    dmenu
    firefox
    pcmanfm
    networkmanagerapplet
    nwg-look
  ];

}
