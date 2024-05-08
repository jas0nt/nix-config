{ lib, pkgs, ... }:

{

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "lvim";
      BROWSER = "firefox";
      TERM = "kitty";
      TERMINAL = "kitty";
    };
  };

}
