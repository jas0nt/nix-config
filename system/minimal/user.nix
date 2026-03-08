{ const, pkgs, lib, ... }:

{
  programs.fish.enable = true;
  nix.settings.trusted-users = [ const.username ];
  users.users.${const.username} = {
    shell = pkgs.fish;
    description = const.username;
    uid = 1000;
  } // lib.optionalAttrs const.is-linux {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };
}
