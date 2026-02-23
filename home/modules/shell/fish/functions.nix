{
  programs.fish = {
    functions = {
      fish_greeting.body = "krabby random --no-title";

      rcp.body = ''
        if test (count $argv) -lt 2
            echo "Usage: rcp <source> <destination>"
            echo "Example: rcp ~/Videos/ /mnt/nas/Videos/"
            return 1
        end
        rsync -avh --progress --no-compress --inplace $argv
      '';

      rmv.body = ''
        if test (count $argv) -lt 2
            echo "Usage: rmv <source> <destination>"
            echo "Example: rmv ~/Downloads/bigfile.iso /mnt/ssd/"
            return 1
        end

        rsync -avh --progress --no-compress --inplace --remove-source-files $argv

        # Clean up empty source directories (rsync doesn't delete dirs by default)
        set source $argv[1]
        if test -d $source
            rmdir -p $source 2>/dev/null  # -p deletes parent dirs if empty; suppress errors
        end

        echo "✅ Moved: $source → $argv[2]"
      '';

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

      win.body = "niri msg action move-window-to-workspace download\ndocker compose -f ~/dkr/compose.yaml up --detach\nsleep 5\nxfreerdp /u:docker /p:\"\" /size:3456x1944 /v:127.0.0.1:3389 /cert:ignore /sec:tls";

    };
  };

}
