{ pkgs, ... }:

{

  home.packages = with pkgs; [
    steam
    adwsteamgtk
    gamemode
    wqy_zenhei
    wqy_microhei
  ];

}
