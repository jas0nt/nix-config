{ lib, pkgs, ... }:

{

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs: [ epkgs.rime ];
  };

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
    # nodePackages."@microsoft/inshellisense"
    rustc
    cargo
    rustfmt
    jdk
    lua

    librime

    # lsp
    nil
    nixfmt

  ];
}
