{ pkgs, ... }:

{
  services.resolved.enable = true;

  networking = {
    useDHCP = false;
    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          # Network config: https://wiki.archlinux.org/title/Iwd#WPA-PSK
          EnableNetworkConfiguration = true;
        };
      };
    };
    networkmanager = {
      enable = false;
      wifi.backend = "iwd";
    };
    firewall = {
      enable = false;
      allowedTCPPorts = [ 8080 ];
    };
  };

  environment.systemPackages = with pkgs; [
    mihomo
    net-tools
    dnsutils
    impala  # TUI for managing wifi
  ];

}
