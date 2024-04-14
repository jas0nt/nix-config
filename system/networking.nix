{ pkgs, lib, ... }:

{
  networking = {
    networkmanager.enable = true;
    hostName = "nixos"; # Define your hostname.
    # proxy.default = "http://127.0.0.1:7890";
    # proxy.allProxy = "socks5://127.0.0.1:7890";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    firewall = {
      enable = false;
      allowedTCPPorts = [ 8080 ];
    };
    # extraHosts =
    #   ''
    #     185.199.108.133 raw.githubusercontent.com
    #   '';
  };

}
