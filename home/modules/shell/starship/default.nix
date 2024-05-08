{ lib, pkgs, ... }:

{

  programs.starship = {
    package = pkgs.starship;
    enable = true;
    enableFishIntegration = true;
    settings = pkgs.lib.importTOML ./config/starship.toml;
  };

}
