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

      win.body = ''
        set -l compose ~/dkr/windows.yaml
        set -l host 127.0.0.1
        set -l port 3389
        mkdir -p ~/Documents/win/storage
        mkdir -p ~/Documents/win/shared

        niri msg action move-window-to-workspace download

        docker compose -f $compose up --detach --wait
        or begin
          echo "win: 容器启动失败" >&2
          return 1
        end

        # 清掉代理变量，本地连接不走代理
        set -l rdp env -u http_proxy -u https_proxy -u all_proxy \
                       -u HTTP_PROXY -u HTTPS_PROXY -u ALL_PROXY \
                       xfreerdp

        # 等待 RDP 真正可用（握手成功），最多 5 分钟
        set -l tries 0
        echo "win: 等待 Windows 就绪..."
        while not $rdp /u:docker "/p:admin" /v:$host:$port \
                /cert:tofu /sec:tls /auth-only >/dev/null 2>&1
          set tries (math $tries + 1)
          if test $tries -ge 150
            echo "win: 等待 RDP 超时，请打开 http://127.0.0.1:8006 查看状态" >&2
            return 1
          end
          sleep 2
        end

        $rdp /u:docker /p:admin /v:$host:$port \
          /f /dynamic-resolution \
          /cert:tofu /sec:tls \
          +clipboard +auto-reconnect \
          $argv
      '';

    };
  };

}
