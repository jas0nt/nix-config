{ lib, const, pkgs, ... }:

{

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "vim";
      BROWSER = "firefox";
      TERM = const.terminal;
      TERMINAL = const.terminal;
    };
  };

}
