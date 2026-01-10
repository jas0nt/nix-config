{ pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
      config.credential.helper = "store";
    };
  };

  environment.systemPackages = with pkgs; [
    libGL
    killall
    gnumake
    gcc
    libgccjit
    cmake
    openssl
    nmap

    zip
    unzip
    p7zip
    unrar
    vim
    wget
  ];

}
