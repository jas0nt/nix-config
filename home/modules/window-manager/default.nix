{
  pkgs,
  tools,
  config,
  inputs,
  ...
}:

{
  imports = [
    inputs.niri.homeModules.niri
    ../swaync
    ./waybar.nix
    ./swaylock.nix
    ./wlogout.nix
  ];

  xdg.configFile = {
    "code-flags.conf" = {
      source = ./config/code-flags.conf;
    };
  };

  home.packages = with pkgs; [
    xwayland-satellite
    calcure
    wl-clipboard
    wev
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    config = (builtins.readFile ./config/config.kdl);
  };

}
