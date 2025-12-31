{
  networking.hostName = "pc";
  imports =
    [
      ./hardware-configuration.nix
      ../hardware/nvidia-config.nix
    ];
}
