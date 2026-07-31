{ const, lib, ... }:

{
  imports = [
    ./fastfetch
  ]
  ++ lib.optionals const.is-linux [
    ./xdg.nix
    ./common.nix
    ./coding.nix
    ./media.nix
  ]
  ++ lib.optionals const.is-darwin [
    ./mac-apps.nix
  ];
}
