{pkgs, ...}:

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

  programs.zellij = {
    enable = true;
    # enableFishIntegration = true;
  };

  stylix.targets.fzf = {
    enable = true;
    colors.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  programs.navi = {
    enable = true;
    enableFishIntegration = true;
  };

}
