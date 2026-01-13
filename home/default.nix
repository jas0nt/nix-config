{
  const,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./services
    ./modules/theme
    ./modules/niri
    # ./modules/hyprland
    ./modules/firefox
    ./modules/kitty
    ./modules/launcher
    ./modules/file-manager
    ./modules/scripts
    ./modules/shell
    ./modules/input-method
    ./modules/git
    ./modules/emacs
    ./modules/vim
    ./modules/docker
    ./modules/player
    ./packages
  ];

  home = {
    stateVersion = "25.11";

    username = const.username;
    homeDirectory = "/home/${const.username}";

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
