{ lib, const, pkgs, ... }:

{

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = const.editor;
      BROWSER = const.browser;
      TERM = const.terminal;
      TERMINAL = const.terminal;
    };
  };

}
