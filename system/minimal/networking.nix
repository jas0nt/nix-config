{ pkgs, ... }:

{
  services.resolved.enable = true;

  networking = {
    # iwd 已经接管 wlan0 的 DHCP/网络配置，系统层只为有线口开 DHCP。
    useDHCP = false;
    interfaces.enp4s0.useDHCP = true;

    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          # Network config: https://wiki.archlinux.org/title/Iwd#WPA-PSK
          EnableNetworkConfiguration = true;
        };
      };
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 8080 ];
    };
  };

  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };

  environment.systemPackages = with pkgs; [
    mihomo
    net-tools
    dnsutils
    impala # TUI for managing wifi
  ];

}
