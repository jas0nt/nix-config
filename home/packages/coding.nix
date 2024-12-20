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

    (python3.withPackages (ps:
      with ps; [
        pip
        epc
        orjson
        sexpdata
        six
        setuptools
        paramiko
        rapidfuzz
        pyright
        ipython
      ]))
    virtualenv
    nodejs

    gcc
    rustc
    cargo
    rustfmt

    jdk
    lua

    dprint
    # lsp
    nil
    nixfmt-rfc-style

  ];
}
