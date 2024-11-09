{ pkgs, ... }:

{
  imports = [
    ./minimal
    ./user.nix
    ./i18n.nix
    ./audio.nix
    ./device.nix
    ./packages.nix
    ./virtualisation.nix
    ./window-manager/hyprland.nix
    # ./window-manager/awesomewm.nix
  ];

}
