{ pkgs, ... }:

{
  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
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

  home.file = {
    ".emacs.d" = {
        source = pkgs.fetchFromGitHub {
          owner = "jas0nt";
          repo = ".emacs.d";
          rev = "cc17c3327fb1653c680930ef8dcc91cc7d4a9d4a";
          sha256 = "sha256-iWevge1YcAPJkTrgsp3J2Q+DsYfhAd5i8OiJ1cJmFfE=";
        };
        recursive = true;
      };
  };

}
