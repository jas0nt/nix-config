{
  const,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

{
  imports = [
    ./minimal/sys-pkgs.nix
  ]
  ++ lib.optionals const.is-darwin [ ./packages-darwin.nix ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    [
      # Modern unix tools
      xcp # cp
      rclone
      htop
      progress
      choose # cut
      dust
      dua # du
      gdu
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

      # GUI apps
      kitty
      qview
      firefox
    ]
    ++ lib.optionals const.is-linux [
      systemctl-tui
      bluez
      bluetuith
      libnotify
      feh
      pcmanfm
    ];
}
// lib.optionalAttrs const.is-linux {
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
