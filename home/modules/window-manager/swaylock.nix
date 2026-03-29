{
  pkgs,
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
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      
      datestr = "%a, %B %e";
      timestr = "%H:%M";
    };
  };
}
