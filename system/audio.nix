{ pkgs, lib, ... }:

{

  security.rtkit.enable = true; # PulseAudio uses this
  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
  };

  services = {
    pipewire = { # Enable sound with pipewire.
      enable = false;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    pasystray
    pulsemixer
    pavucontrol
  ];

}
