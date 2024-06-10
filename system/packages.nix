{ pkgs, pkgs-unstable, lib, ... }:

{
  imports = [ ./minimal/sys-pkgs.nix ];

  programs = {
    mosh.enable = true;
    clash-verge.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Modern unix tools
    btop
    htop
    bottom
    glances
    bat # cat
    choose # cut
    du-dust
    dua # du
    duf # df
    eza # ls
    fd # find
    httpie # curl
    procs # ps
    ripgrep # grep
    jq
    fx # json
    tree
    cht-sh
    tmux
    byobu
    systemctl-tui
    bluez
    bluetuith
    libnotify

    # GUI apps
    kitty
    qview
    dmenu
    firefox-bin
    pcmanfm
    networkmanagerapplet
    nwg-look
  ];

}
