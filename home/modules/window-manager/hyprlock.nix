{
  config,
  ...
}:

{
  stylix.targets.hyprlock = {
    enable = false;
    colors.enable = true;
    image.enable = true;
  };

  programs.hyprlock = {
    enable = true;
  };
}
