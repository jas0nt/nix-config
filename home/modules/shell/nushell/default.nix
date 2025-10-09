{ lib, const, pkgs, ... }:

{
  imports = [
    ../starship
  ];

  programs.nushell = {
    enable = true;
    extraEnv = builtins.replaceStrings [ "@TERM@" ] [ const.terminal ] (builtins.readFile ./config/env.nu);
    extraConfig = (builtins.readFile ./config/config.nu);
    extraLogin = (builtins.readFile ./config/login.nu);
    shellAliases = {
      tree = "eza --icons --tree";

      lock = "bash ~/scripts/desktop.sh lock";
      logout = "bash ~/scripts/desktop.sh logout";
      fuckgfw = "load-env { 'http_proxy': 'http://127.0.0.1:7890', 'https_proxy': 'http://127.0.0.1:7890', 'all_proxy': 'socks5://127.0.0.1:7890' }";
      icat = "kitten icat";
      showcert = "nmap -p 443 --script ssl-cert";
      dota = "steam steam://rungameid/570";
      ipy = "python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'";
      venv = "sh -i -c $'source (gum file --directory ~/.venv)/bin/activate; nu'";
    };
  };

  programs.starship.enableNushellIntegration = true;
  programs.yazi.enableNushellIntegration = true;

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.fzf = {
    enable = true;
  };

  programs.broot = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      icon_theme = "nerdfont";
    };
  };

}
