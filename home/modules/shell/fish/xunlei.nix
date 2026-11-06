{
  programs.fish = {
    functions = {
      xl.body = ''
        set -l compose ~/dkr/xunlei.yaml
        set -l url http://127.0.0.1:2345

        switch "$argv[1]"
            case stop
            docker compose -f $compose stop
            return
            case logs
            docker compose -f $compose logs -f --tail 50
            return
            case status
            docker compose -f $compose ps
            return
        end

        mkdir -p ~/Documents/xunlei/data ~/Downloads/xunlei

        docker compose -f $compose up --detach
        or begin
            echo "xl: 容器启动失败" >&2
            return 1
        end

        # 等待网页控制台就绪，最多 60 秒
        # 带密码认证时会返回 401，只要有 HTTP 响应就算就绪
        set -l tries 0
        while not curl -s -o /dev/null -m 2 --noproxy '*' $url
            set tries (math $tries + 1)
            if test $tries -ge 60
            echo "xl: 等待控制台超时，用 xl logs 查看日志" >&2
            return 1
            end
            sleep 1
        end

        xdg-open $url >/dev/null 2>&1 &
        disown
        echo "xl: $url"
      '';
    };
  };
}
