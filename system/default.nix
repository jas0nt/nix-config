{ const, pkgs, lib, ... }:

{
  imports = [
    ./packages.nix
  ]
  ++ lib.optionals const.is-linux [
    ./minimal
    ./security.nix
    ./i18n.nix
    ./audio.nix
    ./device.nix
    ./virtualisation.nix
    ./display-manager.nix
    ./game.nix
  ]
  ++ lib.optionals const.is-darwin [
    ./minimal/darwin-basic.nix
  ];

}
