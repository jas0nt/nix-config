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
    ./modules/helix
    ./modules/docker
    ./modules/player
    ./packages
  ];

  home = {
    stateVersion = "25.05";

    username = const.username;
    homeDirectory = "/home/${const.username}";

    sessionVariables = {
      EDITOR = "vim";
      BROWSER = "firefox";
      TERM = const.terminal;
      TERMINAL = const.terminal;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    home-manager
  ];

}
