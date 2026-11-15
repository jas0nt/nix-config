{
  hostname,
  ...
}:

{
  networking.hostName = hostname;
  services.openssh.enable = true;
}
