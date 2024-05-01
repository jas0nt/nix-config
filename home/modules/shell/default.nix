{ lib, pkgs, ... }:

{

  programs.fish = {
    enable = true;
    shellAliases = {
      lock = "i3lock-fancy -gp";
      logout = "loginctl terminate-user $USER";
      fuckGFW  = "export http_proxy=http://127.0.0.1:7890; and export https_proxy=http://127.0.0.1:7890; and export all_proxy=socks5://127.0.0.1:7890";
    };
    shellAbbrs = {
      icat = "kitten icat";
      ll = "eza --icons -l";
      la = "eza --icons -la";
      showcert = "nmap -p 443 --script ssl-cert";
      dota = "steam steam://rungameid/570";
    };
    functions = {
      my_audio_notify.body   = "notify-send -r 1 -t 2000 -i volume \"Vol: $(pulsemixer --get-volume)\"";
      my_audio_mute.body     = "pulsemixer --toggle-mute";
      my_audio_up.body       = "pulsemixer --change-volume +1\nmy_audio_notify";
      my_audio_down.body     = "pulsemixer --change-volume -1\nmy_audio_notify";
      my_launcher.body       = "sway-launcher-desktop";
      my_locker.body         = "hyprlock";
      my_file_manager.body   = "ranger";
      my_screenshot.body     = "grimblast copysave area";
      gpu_fan.body           = "sudo nvidia-settings --display :1.0 -a \"[gpu:0]/GPUFanControlState=1\" -a \"[fan:0]/GPUTargetFanSpeed=$argv[1]\"";

      fish_greeting.body     = "fortune -s | pokemonsay -N";
      rgc.body               = "rg --json $argv | delta";
    };
  };

  programs.navi = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.broot = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    package = pkgs.starship;
    enable = true;
    enableFishIntegration = true;
    settings = pkgs.lib.importTOML ./config/starship.toml;
  };

}
