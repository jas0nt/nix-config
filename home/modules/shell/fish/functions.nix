{
  imports = [
    ./windows.nix
    ./xunlei.nix
    ./randopen.nix
  ];

  programs.fish = {
    functions = {
      fish_greeting.body = "krabby random --no-title";

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

      rgc.body = "rg --json $argv | delta";

    };
  };

}
