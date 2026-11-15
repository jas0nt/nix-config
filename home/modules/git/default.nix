{ pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "Jas0nT";
          email = "taoeta@gmail.com";
        };
        credential.helper = "store";
      };
      includes = [
        { path = ./config/theme; }
      ];
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    lazygit = {
      enable = true;
    };
  };

  stylix.targets.lazygit = {
    enable = true;
    colors.enable = true;
  };

  home.packages = with pkgs; [
    tig
  ];

  xdg.configFile = {
    "tig/config" = {
      source = ./config/tigrc;
    };
  };

}
