{ pkgs, ... }:

{
  imports = [
    ./minimal
    ./i18n.nix
    ./audio.nix
    ./device.nix
    ./packages.nix
    ./virtualisation.nix
    ./window-manager/hyprland.nix
    # ./window-manager/awesomewm.nix
  ];

  users.users.jason = { shell = pkgs.nushell; };
  environment.systemPackages = with pkgs; [ nushell ];

  services = {
    openssh.enable = true; # Enable the OpenSSH daemon.
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    printing.enable = true; # Enable CUPS to print documents.
    # services.xserver.libinput.enable = true;  Enable touchpad support.
  };

}
