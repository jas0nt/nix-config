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

  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        # lightTheme = true;
        activeBorderColor = [ "#FF79C6" "bold" ];
        inactiveBorderColor = [ "#BD93F9" ];
        searchingActiveBorderColor = [ "#8BE9FD" "bold" ];
        optionsTextColor = [ "#6272A4" ];
        selectedLineBgColor = [ "#6272A4" ];
        inactiveViewSelectedLineBgColor = [ "bold" ];
        cherryPickedCommitFgColor = [ "#6272A4" ];
        cherryPickedCommitBgColor = [ "#8BE9FD" ];
        markedBaseCommitFgColor = [ "#8BE9FD" ];
        markedBaseCommitBgColor = [ "#F1FA8C" ];
        unstagedChangesColor = [ "#FF5555" ];
        defaultFgColor = [ "#F8F8F2" ];
      };
    };
  };

  home.packages = with pkgs; [
    tig
  ];

  home.file = {
    ".config/tig/config" = { source = ./config/tigrc; };
  };

}
