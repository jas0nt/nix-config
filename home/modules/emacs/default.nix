{ pkgs, ... }:

{
  home.file = {
    ".emacs.d" = { recursive = true; source = ./config/.emacs.d; };
  };

  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs: [
      epkgs.lsp-bridge
      epkgs.acm-terminal
    ];
  };

}
