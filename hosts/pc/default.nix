{ config, pkgs, inputs, hostname, ... }:

{
  networking.hostName = hostname;
  imports =
    [
      ./hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    ];


  hardware.nvidia = {
    open = false; 
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia-container-toolkit.enable = true;
}
