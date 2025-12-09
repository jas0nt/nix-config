{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  programs.uv = {
    enable = true;
  };

  home.packages = with pkgs; [
    devcontainer
    devenv
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
