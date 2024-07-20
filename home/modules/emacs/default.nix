{ lib, pkgs, ... }:

let
  config-files = [
    ./config/init.el
    ./config/init-theme.el
    ./config/init-meow.el
    ./config/init-keys.el
    ./config/init-completion.el
    ./config/init-edit.el
    ./config/init-dired.el
    ./config/init-dashboard.el
  ];

  emacs-configs = builtins.concatStringsSep "\n" (map builtins.readFile config-files);
in
{

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs: [
      epkgs.meow
      epkgs.dracula-theme
      epkgs.all-the-icons
      epkgs.doom-modeline
      epkgs.general
      epkgs.consult
      epkgs.consult-ag
      epkgs.consult-projectile
      epkgs.projectile
      epkgs.vertico
      epkgs.orderless

      epkgs.bufler
      epkgs.dirvish
      epkgs.dashboard
      epkgs.deadgrep
      epkgs.ace-window

      epkgs.bing-dict
      epkgs.fanyi
      epkgs.google-this
      epkgs.undo-tree
      epkgs.rainbow-delimiters
      epkgs.try
    ];
    extraConfig = emacs-configs;
  };

}
