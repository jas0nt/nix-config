inputs@{
  self,
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  nix-darwin,
  ...
}:

let
  systemConfig = import ../common/system-config.nix {
    inherit inputs nixpkgs-unstable;
    constFile = ../common/const/darwin.nix;
    homeManagerModule = home-manager.darwinModules.home-manager;
    systemType = "darwin";
    hostname = "mbp2018";
    extraConfig = {
      nixpkgs.config.allowUnsupportedSystem = true;
    };
  };

in
{
  darwinConfigurations.mbp2018 = inputs.nix-darwin.lib.darwinSystem {
    inherit (systemConfig) system specialArgs modules;
  };
}