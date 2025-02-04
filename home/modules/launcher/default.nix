{ pkgs, inputs, ... }:

{
  # programs.rofi.enable = true;

  home.file = {
    ".config/fuzzel/fuzzel.ini" = {
      recursive = true;
      source = ./config/fuzzel.ini;
    };
  };

  home.packages = with pkgs; [
    inputs.rauncher.defaultPackage."${pkgs.system}"
    fuzzel
  ];

}
