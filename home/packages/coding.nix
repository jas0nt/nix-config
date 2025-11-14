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
    pkgs.rustPlatform.rustcSrc
    pkg-config

    jdk

    dprint
  ];
}
