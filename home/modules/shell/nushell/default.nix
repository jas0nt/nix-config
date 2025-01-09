{ lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../starship
  ];

  programs.nushell = {
    enable = true;
    extraConfig = (builtins.readFile ./config/config.nu);
    extraEnv = (builtins.readFile ./config/env.nu);
    shellAliases = {
      lock = "bash ~/scripts/desktop.sh lock";
      logout = "bash ~/scripts/desktop.sh logout";
      fuckGFW = "load-env { 'http_proxy': 'http://127.0.0.1:7890', 'https_proxy': 'http://127.0.0.1:7890', 'all_proxy': 'socks5://127.0.0.1:7890' }";
      icat = "kitten icat";
      ll = "ls -l";
      la = "ls -la";
      showcert = "nmap -p 443 --script ssl-cert";
      dota = "steam steam://rungameid/570";
      vscode-wayland = "code --enable-features=UseOzonePlatform --ozone-platform=wayland";
      venv = "sh -i -c $'source (gum file --directory ~/.venv)/bin/activate; nu'";
      ipy = "python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'";
      te = "trans en:zh";
      tc = "trans zh:en";
      win_docker = "docker compose -f ~/dkr/compose.yaml up";
      win_rdp = "xfreerdp /u:docker /p: /size:2560x1440 /v:127.0.0.1:3389";
    };
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.fzf = {
    enable = true;
  };

  programs.broot = {
    enable = true;
    settings = {
      icon_theme = "nerdfont";
    };
  };

  programs.starship.enableNushellIntegration = true;

  programs.translate-shell = {
    enable = true;
    settings = {
      hl = "en";
      tl = "zh";
      verbose = true;
    };
  };

}
