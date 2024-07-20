{ lib, pkgs, ... }:

{

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  home.packages = with pkgs; [
    (python3.withPackages (ps:
      with ps; [
        pip
        virtualenv
        epc
        orjson
        sexpdata
        six
        setuptools
        paramiko
        rapidfuzz
        pyright
      ]))
    nodejs
    rustc
    cargo
    rustfmt
    jdk
    lua

    librime

    dprint
    # lsp
    nil
    nixfmt-rfc-style

  ];
}
