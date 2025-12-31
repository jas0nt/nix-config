{ config, pkgs, inputs, ... }:

{
  networking.hostName = "pc";
  imports =
    [
      ./hardware-configuration.nix
      # ../hardware/nvidia-config.nix
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
