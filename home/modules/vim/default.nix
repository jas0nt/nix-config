{ const, pkgs, ... }:

{
  stylix.targets.neovide = {
    enable = true;
    fonts.enable = true;
    opacity.enable = true;
  };

  programs.neovide = {
    enable = true;
    settings = {
      theme = "auto";
      title-hidden = true;
    };
  };

  stylix.targets.neovim = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    plugins = [
      pkgs.vimPlugins.base16-nvim
    ];
  };

  home.file = {
    ".config/nvim" = {
      recursive = true;
      source = ./config/nvim;
    };
  };

}
