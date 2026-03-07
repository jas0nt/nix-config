inputs@{
  self,
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  ...
}:

let
  systemConfig = import ../common/system-config.nix {
    inherit inputs nixpkgs-unstable;
    constFile = ../common/const/nixos.nix;
    homeManagerModule = home-manager.nixosModules.home-manager;
    systemType = "nixos";
    hostname = "pc";
    extraModules = [
      {
        nixpkgs.config.permittedInsecurePackages = [
          "qtwebengine-5.15.19"
        ];
      }
    ];
  };

in
{
  nixosConfigurations.pc = inputs.nixpkgs.lib.nixosSystem {
    inherit (systemConfig) system specialArgs modules;
  };
}