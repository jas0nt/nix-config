{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  home.packages = with pkgs; [
    devcontainer
    direnv
    devbox
    gh
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
