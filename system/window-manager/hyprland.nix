{ pkgs, pkgs-unstable, inputs, ... }:

{
  imports = [ ./login-manager.nix ];

  programs.xwayland.enable = true;

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    hyprlock.enable = true;

    waybar = {
      enable = true;
      package = pkgs.waybar;
    };
  };

  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpicker
    sway-launcher-desktop
    grim # screenshot wayland
    slurp
    wl-clipboard
  ];
}
