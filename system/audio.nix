{ pkgs, ... }:

{
  security.rtkit.enable = true;
  services = {
    pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
    };
    pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    pwvucontrol
    pw-volume
  ];

}
