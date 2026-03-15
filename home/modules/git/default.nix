{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Jas0nT";
        email = "taoeta@gmail.com";
      };
    };
    includes = [
      { path = ./config/theme; }
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.lazygit = {
    enable = true;
  };

  stylix.targets.lazygit = {
    enable = true;
    colors.enable = true;
  };

  home.packages = with pkgs; [
    tig
  ];

  home.file = {
    ".config/tig/config" = { source = ./config/tigrc; };
  };

}
