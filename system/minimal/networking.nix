{ pkgs, ... }:

{
  networking = {
    wireless.iwd = {
      enable = false;
      settings = {
        General = {
          EnableNetworkConfiguration = true;
        };
      };
    };
    networkmanager = {
      enable = true;
      # wifi.backend = "iwd";
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
    impala  # TUI for managing wifi
  ];

}
