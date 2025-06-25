{ const, pkgs, lib, ... }:

{
  # programs.fish.enable = true;
  nix.settings.trusted-users = [ const.username ];
  users.users.${const.username} = {
    shell = pkgs.nushell;
    isNormalUser = true;
    description = const.username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    uid = 1000;
  };
}
