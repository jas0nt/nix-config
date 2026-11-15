{
  lib,
  const,
  tools,
  ...
}:

{
  imports = [
    ../starship
  ];

  programs.nushell = {
    enable = true;
    extraEnv = tools.substitute-file ./config/env.nu;
    extraConfig =
      (builtins.readFile ./config/config.nu)
      + lib.optionalString const.is-linux ("\n" + builtins.readFile ./config/linux.nu);
    shellAliases = {
      la = "ls -a";
      ll = "ls -l";
      lla = "ls -la";
      tree = "eza --icons --tree";
      fuckgfw = "load-env { 'http_proxy': '${const.http-proxy}', 'https_proxy': '${const.http-proxy}', 'all_proxy': '${const.socks-proxy}' }";
      proxyoff = "hide-env --ignore-errors http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY";
      icat = "kitten icat";
    }
    // lib.optionalAttrs const.is-linux {
      lock = "bash ~/scripts/desktop.sh lock";
      logout = "bash ~/scripts/desktop.sh logout";
      showcert = "nmap -p 443 --script ssl-cert";
      dota = "steam steam://rungameid/570";
      ipy = "python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'";
      venv = "sh -i -c $'source (gum file --directory ~/.venv)/bin/activate; nu'";
    };
  };

}
