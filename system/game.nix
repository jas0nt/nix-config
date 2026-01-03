{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraProfile = ''
      ## PULSE_LATENCY_MSEC=60 %command% -sdlaudiodriver pulse -perfectworld
      # 1. Force PulseAudio driver (equivalent to -sdlaudiodriver pulse)
      export SDL_AUDIODRIVER=pulse
      
      # 2. Increase Audio Latency (equivalent to PULSE_LATENCY_MSEC=60)
      export PULSE_LATENCY_MSEC=60
    '';
    };
  };

}
