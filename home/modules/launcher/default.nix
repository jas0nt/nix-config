{ pkgs, const, inputs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        font = "${const.font}:size=16";
        lines = 15;
        width = 50;
        horizontal-pad = 40;
        vertical-pad = 10;
        inner-pad = 10;
        image-size-ratio = 0.8;
        icon-theme = "BeautyLine";
        exit-on-keyboard-focus-loss = "yes";
      };
      colors = {
        background = "282a36dd";
        text = "f8f8f2ff";
        match = "8be9fdff";
        selection-match = "8be9fdff";
        selection = "ff79c6dd";
        selection-text = "f8f8f2ff";
        border = "bd93f9ff";
      };
      border = {
        width = 2;
        radius = 15;
      };
    };
  };
}
