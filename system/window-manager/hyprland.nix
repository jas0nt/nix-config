{ pkgs, inputs, ... }:

{
  imports = [ ./login-manager.nix ];

  programs.xwayland.enable = true;

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpicker
    grim # screenshot wayland
    slurp
    snipaste
    wl-clipboard
  ];
}
