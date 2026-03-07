{
  pkgs,
  const,
  lib,
  ...
}:

{
  programs = lib.optionalAttrs const.is-linux {
    git = {
      enable = true;
      package = pkgs.gitFull;
      config.credential.helper = "store";
    };
  };

  environment.systemPackages =
    with pkgs;
    [
      killall
      gnumake
      cmake
      openssl
      nmap

      zip
      unzip
      p7zip
      unrar
      vim
      wget
    ]
    ++ lib.optionals const.is-linux [
      libGL
      gcc
      libgccjit
    ];

}
