{ lib, pkgs, ... }:

{

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "vim";
      BROWSER = "firefox";
      TERM = "kitty";
      TERMINAL = "kitty";
    };
  };

}
