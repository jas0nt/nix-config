{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ollama
    aichat
    oterm
  ];
}
