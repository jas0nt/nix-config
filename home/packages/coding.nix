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
    rustfmt
    pkg-config

    jdk
    lua
    lua-language-server

    dprint
    # lsp
    nil
    nixfmt-rfc-style

  ];
}
