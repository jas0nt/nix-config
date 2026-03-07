{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    maple-mono.NF
    maple-mono.CN
    krabby
    iterm2
    iina
  ];
}
