{ pkgs, ... }:

{
  programs.neovide = {
    enable = true;
    settings = {
      theme = "auto";
      title-hidden = true;
      font = {
        normal = [ "Recursive Mono Casual Static" ];
        size = 18.0;
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
