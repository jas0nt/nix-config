{
  config,
  const,
  ...
}:

let
  inherit (config.lib.stylix.colors) base05;
in
{
  stylix.targets.hyprlock = {
    enable = true;
    colors.enable = true;
    image.enable = true;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        blur_passes = 3;
        blur_size = 8;
      };
      label = [
        {
          monitor = "";
          text = "$TIME";
          font_size = 90;
          font_family = const.font;
          color = "rgb(${base05})";
          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        {
          monitor = "";
          text = ''cmd[update:60000] date +"%A, %d %B %Y"'';
          font_size = 25;
          font_family = const.font;
          color = "rgb(${base05})";
          position = "-30, -150";
          halign = "right";
          valign = "top";
        }
      ];
    };
  };
}
