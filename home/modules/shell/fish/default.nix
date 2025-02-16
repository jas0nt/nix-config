{ lib, pkgs, ... }:

{
  imports = [
    ../starship
  ];

  programs.fish = {
    enable = true;
    shellAbbrs = {
      lock = "bash ~/scripts/desktop.sh lock";
      logout = "bash ~/scripts/desktop.sh logout";
      fuckgfw = "export http_proxy=http://127.0.0.1:7890; and export https_proxy=http://127.0.0.1:7890; and export all_proxy=socks5://127.0.0.1:7890";
      gfw = "set -e http_proxy; and set -e https_proxy; and set -e all_proxy";
      icat = "kitten icat";
      showcert = "nmap -p 443 --script ssl-cert";
      dota = "steam steam://rungameid/570";
      ipy = "python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'";
      te = "trans en:zh";
      tc = "trans zh:en";
      venv = "source (gum file --directory ~/.venv)/bin/activate.fish";
      cd = "z";
      tmuxsesh = "sesh connect $(sesh list | fzf)";
    };
    shellAliases = {
      ls = "eza";
      ll = "eza --icons -l";
      la = "eza --icons -la";
      tree = "eza --icons --tree";
    };
    functions = {
      gpu_fan.body = "sudo nvidia-settings --display :1.0 -a \"[gpu:0]/GPUFanControlState=1\" -a \"[fan:0]/GPUTargetFanSpeed=$argv[1]\"";
      fish_greeting.body = "krabby random --no-title";
      rgc.body = "rg --json $argv | delta";
      win.body = "niri msg action move-window-to-workspace download\ndocker compose -f ~/dkr/compose.yaml up --detach\nsleep 5\nxfreerdp /u:docker /p:\"\" /size:2460x1340 /v:127.0.0.1:3389 /cert:ignore /sec:tls";
    };
  };

  programs.starship.enableFishIntegration = true;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.broot = {
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
