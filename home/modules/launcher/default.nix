{ pkgs, const, config, inputs, ... }:

{
  stylix.targets.fuzzel = {
    enable = true;
    fonts.enable = true;
    colors.enable = true;
    opacity.enable = true;
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        lines = 15;
        width = 50;
        horizontal-pad = 40;
        vertical-pad = 10;
        inner-pad = 10;
        image-size-ratio = 0.8;
        exit-on-keyboard-focus-loss = "yes";
      };
      border = {
        width = 2;
        radius = 15;
      };
    };
  };
}
