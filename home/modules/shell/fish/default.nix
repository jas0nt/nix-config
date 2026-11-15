{
  const,
  lib,
  ...
}:

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
    interactiveShellInit = ''
      bind alt-backspace backward-kill-path-component
      bind ctrl-w backward-kill-word
    '';
    shellAbbrs = {
      fuckgfw = "export http_proxy=${const.http-proxy}; and export https_proxy=${const.http-proxy}; and export all_proxy=${const.socks-proxy}";
      gfw = "set -e http_proxy; and set -e https_proxy; and set -e all_proxy";
      icat = "kitten icat";
      cd = "z";
    }
    // lib.optionalAttrs const.is-linux {
      lock = "bash ~/scripts/desktop.sh lock";
      logout = "bash ~/scripts/desktop.sh logout";
      showcert = "nmap -p 443 --script ssl-cert";
      dota = "steam steam://rungameid/570";
      ipy = "python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'";
    };
    shellAliases = {
      ls = "eza";
      ll = "eza --icons -l";
      la = "eza --icons -la";
      tree = "eza --icons --tree";
    };
  };

}
