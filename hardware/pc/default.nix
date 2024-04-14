{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../nvidia-config.nix
    ];

}
