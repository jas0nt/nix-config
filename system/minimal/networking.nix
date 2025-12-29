{ pkgs, ... }:

{
  networking = {
    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          EnableNetworkConfiguration = true;
        };
      };
    };
    networkmanager = {
      enable = false;
      wifi.backend = "iwd";
    };
    hostName = "nixos"; # Define your hostname.
    firewall = {
      enable = false;
      allowedTCPPorts = [ 8080 ];
    };
  };

  environment.systemPackages = with pkgs; [
    mihomo
    net-tools
    dnsutils
    iwgtk
    impala  # TUI for managing wifi
  ];

}
