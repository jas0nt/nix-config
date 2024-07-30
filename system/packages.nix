{ pkgs, pkgs-unstable, ... }:

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
    silver-searcher
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
