{
  config,
  ...
}:

{
  stylix.targets.swaylock = {
    enable = true;
    colors.enable = true;
  };

  programs.swaylock = {
    enable = true;
  };
}
