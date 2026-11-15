{ const, ... }:

{
  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = const.editor;
      BROWSER = const.browser;
      TERMINAL = const.terminal;
    };
  };

}
