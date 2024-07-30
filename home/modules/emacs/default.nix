{ pkgs, ... }:

{
  home.file = {
    ".emacs.d" = { recursive = true; source = ./config/.emacs.d; };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs: [
      epkgs.lsp-bridge
      epkgs.acm-terminal
    ];
  };

}
