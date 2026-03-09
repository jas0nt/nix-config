inputs@{
  self,
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  nix-darwin,
  ...
}:

let
  mkConfig =
    {
      hostname,
    }:
    inputs.nix-darwin.lib.darwinSystem (
      let
        systemConfig = import ../common/system-config.nix {
          inherit inputs nixpkgs-unstable hostname;
          constFile = ../common/const/darwin.nix;
          homeManagerModule = home-manager.darwinModules.home-manager;
          systemType = "darwin";
          extraConfig = {
            nixpkgs.config.allowUnsupportedSystem = true;
          };
        };
      in
      {
        inherit (systemConfig) system specialArgs modules;
      }
    );
in
{
  darwinConfigurations.mbp2018 = mkConfig {
    hostname = "mbp2018";
  };
}
