{ const, pkgs, lib, ... }:

{
  # environment.systemPackages = with pkgs; [ nushell ];
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
  };
}
