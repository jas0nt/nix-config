{ const, lib, pkgs, ... }:

{
  imports = [
    ../starship
    ./functions.nix
  ];

  # Ensure fish has access to system and user profiles on Darwin
  home.sessionPath = lib.optionals const.is-darwin [
    "/run/current-system/sw/bin"
    "/etc/profiles/per-user/${const.username}/bin"
  ];

  stylix.targets.fish = {
    enable = true;
    colors.enable = true;
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      lock = "bash ~/scripts/desktop.sh lock";
      logout = "bash ~/scripts/desktop.sh logout";
      fuckgfw = "export http_proxy=${const.http-proxy}; and export https_proxy=${const.http-proxy}; and export all_proxy=${const.socks-proxy}";
      gfw = "set -e http_proxy; and set -e https_proxy; and set -e all_proxy";
      icat = "kitten icat";
      showcert = "nmap -p 443 --script ssl-cert";
      dota = "steam steam://rungameid/570";
      ipy = "python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'";
      cd = "z";
      tmuxsesh = "sesh connect $(sesh list | fzf)";
    };
    shellAliases = {
      ls = "eza";
      ll = "eza --icons -l";
      la = "eza --icons -la";
      tree = "eza --icons --tree";
    };
  };

  programs.starship.enableFishIntegration = true;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.navi = {
    enable = true;
    enableFishIntegration = true;
  };

  home.packages = with pkgs; [
    television
  ];

}
