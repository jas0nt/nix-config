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
    ./window-manager/login-manager.nix
    # ./window-manager/hyprland.nix
    # ./window-manager/awesomewm.nix
  ];

}
