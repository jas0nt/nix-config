inputs@{
  self,
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  ...
}:

let
  mkConfig =
    {
      hostname,
    }:
    inputs.nixpkgs.lib.nixosSystem (
      let
        systemConfig = import ../common/system-config.nix {
          inherit inputs nixpkgs-unstable hostname;
          constFile = ../common/const/nixos.nix;
          homeManagerModule = home-manager.nixosModules.home-manager;
          systemType = "nixos";
          extraModules = [ ];
        };
      in
      {
        inherit (systemConfig) system specialArgs modules;
      }
    );
in
{
  nixosConfigurations.pc = mkConfig {
    hostname = "pc";
  };
}
