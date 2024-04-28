{ pkgs, inputs, ... }:

{
  imports = [ ./xserver.nix ];

  programs = {
    hyprland = {
      enable = true;
      enableNvidiaPatches = true;
      xwayland.enable = true;
    };

    waybar = {
      enable = true;
      package = pkgs.waybar;
    };

  };

  services.xserver = {
    displayManager = {
      sddm.wayland.enable = true;
      defaultSession = "hyprland";
      setupCommands = "Hyprland";
    };

  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpicker
    inputs.hyprlock.packages."${pkgs.system}".hyprlock
    inputs.hypridle.packages."${pkgs.system}".hypridle
    swaynotificationcenter
    wlogout
    sway-launcher-desktop
    grimblast # screenshot wayland
    wl-clipboard
  ];

}
