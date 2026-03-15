{ pkgs, ... }:

{
  stylix.targets.starship = {
    enable = true;
    colors.enable = true;
  };

  programs.starship = {
    package = pkgs.starship;
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    settings = pkgs.lib.importTOML ./config/starship.toml;
  };

}
