{ const, pkgs, ... }:

{
  programs.dconf.enable = true;

  users.users.${const.username}.extraGroups = [ "libvirtd" ];

  systemd.services.docker.environment = {
    HTTP_PROXY = "http://127.0.0.1:7890";
    HTTPS_PROXY = "http://127.0.0.1:7890";
    NO_PROXY = "localhost,127.0.0.1";
  };

  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    virtiofsd
    lazydocker
  ];

  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
