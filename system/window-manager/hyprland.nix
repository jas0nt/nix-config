{ pkgs, inputs, ... }:

{
  imports = [ ./xserver.nix ];

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

  services = {
    displayManager = {
      sddm.wayland.enable = true;
      defaultSession = "hyprland";
    };
  };
  services.xserver.displayManager.setupCommands = "Hyprland";

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpicker
    sway-launcher-desktop
    grim # screenshot wayland
    slurp
    wl-clipboard
  ];
}
