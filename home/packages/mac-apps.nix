{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    maple-mono.NF
    maple-mono.CN
    just
    krabby
    iterm2
    iina
  ];
}
