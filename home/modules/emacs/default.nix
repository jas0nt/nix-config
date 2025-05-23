{ pkgs, ... }:

{
  home.file = {
    ".emacs.d" = { recursive = true; source = ./config/.emacs.d; };
  };

  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
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
        watchdog
        packaging

        pyright
        ipython
      ]))

      vips
      ffmpegthumbnailer
  ];

}
