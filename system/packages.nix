{ pkgs, pkgs-unstable, lib, ... }:

{
  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
      config.credential.helper = "store";
    };
    mosh.enable = true;
    clash-verge.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nushell
    libGL
    killall
    gnumake
    libgccjit
    cmake
    openssl
    nmap
    clash-meta
    libnotify

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
    vim
    wget
    unzip
    p7zip

    # GUI apps
    kitty
    qview
    dmenu
    firefox-bin
    pcmanfm
    networkmanagerapplet
    nwg-look
    pkgs-unstable.wechat-uos
  ];

}
