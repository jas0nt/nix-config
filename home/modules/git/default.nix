{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jas0nT";
    userEmail = "taoeta@gmail.com";
    delta.enable = true;
    includes = [
      { path = ./config/theme; }
    ];
  };

  home.packages = with pkgs; [
    lazygit
    tig
  ];
}
