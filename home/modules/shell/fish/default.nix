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
      fuckGFW  = "export http_proxy=http://127.0.0.1:7890; and export https_proxy=http://127.0.0.1:7890; and export all_proxy=socks5://127.0.0.1:7890";
      icat = "kitten icat";
      showcert = "nmap -p 443 --script ssl-cert";
      dota = "steam steam://rungameid/570";
      ipy = "python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'";
      te = "trans en:zh";
      tc = "trans zh:en";
      venv = "source (gum file --directory ~/.venv)/bin/activate.fish";
      tree = "eza --icons --tree";
      cd = "z";
    };
    shellAliases = {
      ls = "eza";
      ll = "eza --icons -l";
      la = "eza --icons -la";
    };
    functions = {
      gpu_fan.body           = "sudo nvidia-settings --display :1.0 -a \"[gpu:0]/GPUFanControlState=1\" -a \"[fan:0]/GPUTargetFanSpeed=$argv[1]\"";
      fish_greeting.body     = "krabby random --no-title";
      rgc.body               = "rg --json $argv | delta";
      win.body               = "docker compose -f ~/dkr/compose.yaml up --detach\nsleep 5\nxfreerdp /u:docker /p: /size:2560x1440 /v:127.0.0.1:3389";
    };
  };

  programs.thefuck.enable = true;

  programs.starship.enableFishIntegration = true;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.broot = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.mcfly = {
    enable = true;
    fzf.enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

}
