{
  networking = {
    networkmanager.enable = true;
    hostName = "nixos"; # Define your hostname.
    firewall = {
      enable = false;
      allowedTCPPorts = [ 8080 ];
    };
  };

}
