{ pkgs, ... }:

{
  services.dunst = {
    enable = true;
    package = pkgs.dunst;
    settings = pkgs.lib.importTOML ./config/dunstrc;
  };

}
