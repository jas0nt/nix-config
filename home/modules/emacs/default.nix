{ lib, pkgs, ... }:

{
  home.file = {
    ".emacs.d" = { recursive = true; source = ./config/.emacs.d; };
  };

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
      epkgs.vertico
      epkgs.orderless

      epkgs.bufler
      epkgs.dirvish
      epkgs.dashboard
      epkgs.deadgrep
      epkgs.ace-window

      # lsp
      epkgs.yasnippet
      epkgs.yasnippet-snippets
      epkgs.lsp-bridge
      epkgs.acm-terminal
      # python
      epkgs.python-mode
      epkgs.pyvenv
      # nix
      epkgs.nix-mode
      epkgs.nixos-options

      epkgs.magit
      epkgs.ace-pinyin
      epkgs.pyim
      epkgs.bing-dict
      epkgs.fanyi
      epkgs.google-this
      epkgs.undo-tree
      epkgs.treemacs
      epkgs.projectile
      epkgs.treemacs-projectile
      epkgs.rainbow-mode
      epkgs.rainbow-delimiters
      epkgs.try
    ];
  };

}
