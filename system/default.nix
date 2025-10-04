{ pkgs, ... }:

{
  imports = [
    ./minimal
    ./security.nix
    ./i18n.nix
    ./audio.nix
    ./device.nix
    ./packages.nix
    ./virtualisation.nix
    ./display-manager.nix
    # ./window-manager/hyprland.nix
  ];

}
