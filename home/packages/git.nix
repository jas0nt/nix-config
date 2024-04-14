{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jas0nT";
    userEmail = "taoeta@gmail.com";
    delta.enable = true;
  };

  home.packages = with pkgs; [
    lazygit
    tig
  ];
}
