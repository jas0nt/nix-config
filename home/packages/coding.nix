{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  home.packages = with pkgs; [
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
      ]))
    virtualenv
    nodejs
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
