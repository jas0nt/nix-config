{
  const,
  lib,
  ...
}:

{
  imports = [
    ./modules/theme
    ./modules/file-manager
    ./modules/kitty
    ./modules/shell
    ./modules/git
    ./modules/vim
    ./modules/docker
    ./packages
  ]
  ++ lib.optionals const.is-linux [
    ./modules/emacs
    ./modules/firefox
    ./services
    ./modules/window-manager
    ./modules/launcher
    ./modules/scripts
    ./modules/input-method
    ./modules/player
    ./modules/host-modules
  ]
  ++ lib.optionals const.is-darwin [ ];

  home = {
    stateVersion = "26.05";

    inherit (const) username;

    # Use mkForce to prevent Home Manager from trying to guess the home directory
    homeDirectory = lib.mkForce const.home;

    sessionVariables = {
      EDITOR = const.editor;
      BROWSER = const.browser;
      TERMINAL = const.terminal;
      http_proxy = const.http-proxy;
      https_proxy = const.http-proxy;
      all_proxy = const.socks-proxy;
    };
  };

  # nix-darwin 下 man 由系统提供，HM 的 man cache 生成没有意义
  programs.man.generateCaches = lib.mkIf const.is-darwin false;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
