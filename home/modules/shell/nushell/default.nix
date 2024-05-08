{ lib, pkgs, ... }:

{
  imports = [
    ../starship
  ];

  programs.nushell = {
    enable = true;
    extraConfig = (builtins.readFile ./config/config.nu);
    extraEnv = (builtins.readFile ./config/env.nu);
    loginFile.text = "print 'Hello World'";
    shellAliases = {
      lock = "hyprlock";
      logout = "loginctl terminate-user $env.USER";
      fuckGFW = "load-env { 'http_proxy': 'http://127.0.0.1:7890', 'https_proxy': 'http://127.0.0.1:7890', 'all_proxy': 'socks5://127.0.0.1:7890' }";
      icat = "kitten icat";
      ll = "ls -l";
      la = "ls -la";
      showcert = "nmap -p 443 --script ssl-cert";
      dota = "steam steam://rungameid/570";
      vscode-wayland = "code --enable-features=UseOzonePlatform --ozone-platform=wayland";
      venv = "sh -i -c $'source (gum file --directory ~/.venv)/bin/activate; nu'";
    };
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship.enableNushellIntegration = true;

}
