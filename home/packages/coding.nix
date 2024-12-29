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

    jetbrains.rust-rover
    rustc
    cargo
    rust-analyzer
    pkgs.rustPlatform.rustcSrc
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
