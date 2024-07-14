{ pkgs, ... }:

let
  awesome-git = pkgs.awesome.overrideAttrs (oa: {
    version = "git-ad0290b";
    src = pkgs.fetchFromGitHub {
      owner = "awesomeWM";
      repo = "awesome";
      rev = "ad0290b";
      hash = "sha256-uaskBbnX8NgxrprI4UbPfb5cRqdRsJZv0YXXshfsxFU=";
    };

    patches = [ ];

    postPatch = ''
      patchShebangs tests/examples/_postprocess.lua
    '';
  });
in
{
  imports = [ ./xserver.nix ];

  services.xserver = {
    windowManager.awesome = {
      enable = true;
      package = awesome-git;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };

    xautolock = {
      enable = true;
      locker = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 5 3";
      nowlocker = "${pkgs.i3lock-fancy-rapid}/bin/i3-lock-fancy-rapid 5 3";
      time = 30;
    };
  };

  services.displayManager = {
    defaultSession = "none+awesome";
  };


  environment.systemPackages = with pkgs; [
    feh
    picom
    i3lock-fancy-rapid
    shutter # screenshot
    xclip
  ];

}
