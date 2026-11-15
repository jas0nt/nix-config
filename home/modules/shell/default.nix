{
  imports = [
    ./bash
    ./fish
    ./nushell
  ];

  stylix.targets.zellij = {
    enable = true;
    colors.enable = true;
  };

  stylix.targets.fzf = {
    enable = true;
    colors.enable = true;
  };

  programs = {
    zellij = {
      enable = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    navi = {
      enable = true;
      enableFishIntegration = true;
    };
  };

}
