{ pkgs, ... }:

{
  programs.neovide = {
    enable = true;
    settings = {
      theme = "auto";
      title-hidden = true;
      font = {
        normal = [ "FiraCode Nerd Font" ];
        size = 12.0;
      };
    };
  };

  programs.neovim = {
    enable = true;
  };

  home.file = {
    ".config/nvim" = {
      recursive = true;
      source = ./config/nvim;
    };
  };

}
