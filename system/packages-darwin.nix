{pkgs, ...}:

{
  fonts = {
    packages = with pkgs; [
      maple-mono.NF
      maple-mono.CN
      noto-fonts-color-emoji
    ];
  };

  homebrew = {
    enable = true;
    #enableFishIntegration = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # 'zap': Uninstalls any brew app not listed here. 
      # This enforces that your Nix config is the single source of truth.
      cleanup = "zap"; 
    };
    brews = [
      "cmus"
    ];

    casks = [
      "visual-studio-code"
      "motrix"
    ];
  };

}