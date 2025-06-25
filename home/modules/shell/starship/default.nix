{ pkgs, ... }:

{

  programs.starship = {
    package = pkgs.starship;
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    settings = pkgs.lib.importTOML ./config/starship.toml;
  };

}
