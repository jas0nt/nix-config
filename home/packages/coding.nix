{ lib, pkgs, ... }:

{
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
      ]))
    nodejs
    # nodePackages."@microsoft/inshellisense"
    rustc
    cargo
    rustfmt
    jdk
    lua

    emacs
    librime
    emacsPackages.rime
    vscode-fhs
    nixfmt

  ];
}
