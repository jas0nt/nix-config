{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  home.packages = with pkgs; [
    direnv
    devbox
    code-cursor
    tree-sitter
    virtualenv
    nodejs

    rustc
    cargo
    rust-analyzer
    pkgs.rustPlatform.rustcSrc
    rustfmt
    pkg-config

    jdk

    dprint
    # lsp
    nil
    nixfmt-rfc-style
    pyright
    ruff

  ];
}
