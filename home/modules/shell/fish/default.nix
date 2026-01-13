{ const, lib, pkgs, ... }:

{
  imports = [
    ../starship
  ];

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
    functions = {
      va.body = ''
        set venv_dir "$HOME/.venv"
        set selected (ls -1 "$venv_dir" | fzf --height=20% --layout=reverse --border --prompt="Activate venv > ")
        if test -n "$selected"
            set activate_script "$venv_dir/$selected/bin/activate.fish"
            if test -f "$activate_script"
                source "$activate_script"
                echo "Activated $selected"
            else
                echo "Error: Not a valid venv (missing activate.fish)"
            end
        end
        '';
      gpu_fan.body = "sudo nvidia-settings --display :1.0 -a \"[gpu:0]/GPUFanControlState=1\" -a \"[fan:0]/GPUTargetFanSpeed=$argv[1]\"";
      fish_greeting.body = "krabby random --no-title";
      rgc.body = "rg --json $argv | delta";
      win.body = "niri msg action move-window-to-workspace download\ndocker compose -f ~/dkr/compose.yaml up --detach\nsleep 5\nxfreerdp /u:docker /p:\"\" /size:3456x1944 /v:127.0.0.1:3389 /cert:ignore /sec:tls";
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
    settings = {
      icon_theme = "nerdfont";
    };
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
