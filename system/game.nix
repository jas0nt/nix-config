{ pkgs, pkgs-unstable, ... }:

{
  programs = {
    steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      extraPackages = with pkgs; [
        libkrb5
        keyutils
      ];
    };

  };

}
