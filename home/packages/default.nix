{const, lib, ...}:

{
  imports = [
    ./fastfetch
    ./coding.nix
  ] ++ lib.optionals const.is-linux [
    ./xdg.nix
    ./common.nix
    ./media.nix
  ] ++ lib.optionals const.is-darwin [
    ./mac-apps.nix
  ];
}
