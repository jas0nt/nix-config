{ const, lib, ... }:

{
  imports = [
    ./user.nix
    ./sys-pkgs.nix
  ]
  ++ lib.optionals const.is-linux [
    ./linux.nix
    ./boot
    ./networking.nix
  ]
  ++ lib.optionals const.is-darwin [
    ./darwin.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [ "https://cache.nixos.org" ];
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    builders-use-substitutes = true;
  };

  nixpkgs.config.allowUnfree = true;

}
