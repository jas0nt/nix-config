{
  const,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

{
  imports = lib.optionals const.is-linux [
    ./linux.nix
  ]
  ++ lib.optionals const.is-darwin [
    ./darwin.nix
  ];

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
    ];
}
