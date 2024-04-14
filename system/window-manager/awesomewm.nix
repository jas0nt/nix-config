{ pkgs, ... }:

{
  imports = [ ./xserver.nix ];

  services.xserver = {
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };
    displayManager = {
      sddm.wayland.enable = false;
      defaultSession = "none+awesome";
    };

    xautolock = {
      enable = true;
      locker = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -gp";
      nowlocker = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -gp";
      time = 15;
    };
  };

  environment.systemPackages = with pkgs; [
    feh
    picom
    i3lock-fancy
    shutter # screenshot
    xclip
  ];

}
