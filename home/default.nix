{
  const,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./modules/file-manager
    ./modules/kitty
    ./modules/shell
    ./modules/git
    ./modules/emacs
    ./modules/vim
    ./modules/docker
    ./packages
  ]
  ++ lib.optionals const.is-linux [
    ./modules/firefox
    ./services
    ./modules/theme
    ./modules/window-manager
    ./modules/launcher
    ./modules/scripts
    ./modules/input-method
    ./modules/player
  ]
  ++ lib.optionals const.is-darwin [ ];

  home = {
    stateVersion = "25.11";

    username = const.username;

    # Use mkForce to prevent Home Manager from trying to guess the home directory
    homeDirectory = lib.mkForce const.home;

    sessionVariables = {
      EDITOR = const.editor;
      BROWSER = const.browser;
      TERM = const.terminal;
      TERMINAL = const.terminal;
      http_proxy = const.http-proxy;
      https_proxy = const.http-proxy;
      all_proxy = const.socks-proxy;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    home-manager
  ];

}
