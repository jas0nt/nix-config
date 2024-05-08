{ pkgs, lib, ... }:

let username = "jason";
in {
  imports = [
    ./boot
    ./networking.nix
    ./i18n.nix
    ./audio.nix
    ./device.nix
    ./packages.nix
    ./virtualisation.nix
    ./window-manager/awesomewm.nix
    ./window-manager/hyprland.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  users.users.jason = {
    isNormalUser = true;
    description = "jason";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.nushell;
  };

  nix.settings.trusted-users = [ username ];
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];

    trusted-public-keys =
      [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    builders-use-substitutes = true;
  };

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  time.timeZone = "Asia/Shanghai";

  services = {
    openssh.enable = true; # Enable the OpenSSH daemon.
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    printing.enable = true; # Enable CUPS to print documents.
    # services.xserver.libinput.enable = true;  Enable touchpad support.
    aria2 = {
      enable = true;
      extraArguments = "--rpc-listen-all --rpc-allow-origin-all=true";
    };
    
  };

}
