{
  lib,
  const,
  pkgs,
  ...
}:

{
  imports = [
    ../starship
  ];

  programs.nushell = {
    enable = true;
    extraEnv =
      builtins.replaceStrings
        [ "@TERM@" "@HTTP_PROXY@" "@SOCKS_PROXY@" ]
        [ const.terminal const.my-http-proxy const.my-socks-proxy ]
        (builtins.readFile ./config/env.nu);
    extraConfig = (builtins.readFile ./config/config.nu);
    extraLogin = (builtins.readFile ./config/login.nu);
    shellAliases = {
      tree = "eza --icons --tree";
      lock = "bash ~/scripts/desktop.sh lock";
      logout = "bash ~/scripts/desktop.sh logout";
      fuckgfw = "load-env { 'http_proxy': '${const.my-http-proxy}', 'https_proxy': '${const.my-http-proxy}', 'all_proxy': '${const.my-socks-proxy}' }";
      proxyoff = "hide-env --ignore-errors http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY";
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
