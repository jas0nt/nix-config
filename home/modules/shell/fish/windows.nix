{
  programs.fish = {
    functions = {
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
