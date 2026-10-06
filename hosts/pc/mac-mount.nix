{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.sshfs ];

  fileSystems."/run/media/jason/mac" = {
    device = "jasontao@192.168.1.108:/Users/jasontao/Downloads";
    fsType = "fuse.sshfs";
    options = [
      "noauto"
      "x-systemd.automount"            # 第一次访问时才挂载
      "x-systemd.idle-timeout=600"     # 闲置 10 分钟自动卸载
      "x-systemd.mount-timeout=15"     # Mac 不在线时 15 秒后放弃
      "_netdev"                        # 等网络就绪
      "allow_other"
      "default_permissions"
      "auto_cache"
      "reconnect"
      "ServerAliveInterval=15"
      "uid=1000"                       # 用 `id -u jason` 确认
      "gid=100"                        # 用 `id -g jason` 确认
      "IdentityFile=/home/jason/.ssh/id_ed25519"
      "StrictHostKeyChecking=accept-new"
    ];
  };

}
