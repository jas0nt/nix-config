{ pkgs, pkgs-unstable, ... }:

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
    libgccjit
    cmake
    openssl
    nmap

    clash-meta
    unzip
    p7zip
    vim
    wget
  ];

}
