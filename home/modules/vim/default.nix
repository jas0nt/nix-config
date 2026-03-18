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
    enable = false;
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      LazyVim
    ];
    extraPackages = with pkgs; [
      nixd
      nixfmt
      statix # nix linting
      lua-language-server
      stylua
      pyright
      ruff
      rust-analyzer
      rustfmt
    ];
    extraLuaConfig = ''
      require("config.lazy")
    '';
  };

  xdg.configFile = {
    "nvim/lua/config" = {
      source = ./config/nvim/lua/config;
      recursive = true;
    };
    "nvim/lua/plugins" = {
      source = ./config/nvim/lua/plugins;
      recursive = true;
    };
  };

}
