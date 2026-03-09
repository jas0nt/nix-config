{
  const,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./minimal
    ./packages
  ]
  ++ lib.optionals const.is-linux [
    ./security.nix
    ./i18n.nix
    ./audio.nix
    ./device.nix
    ./virtualisation.nix
    ./display-manager.nix
    ./game.nix
  ];
}
