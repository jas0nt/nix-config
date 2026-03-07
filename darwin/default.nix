inputs@{
  self,
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  nix-darwin,
  ...
}:
let
  constCommon = import ../common/const/common.nix;
  const = constCommon // import ../common/const/darwin.nix;
  system = const.system;
  tools = (import ../common/tools.nix) { const = const; };

  specialArgs = {
    inherit inputs const tools;
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  my-username = const.username;
  commonModules = [
    ../system
    home-manager.darwinModules.home-manager
    {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnsupportedSystem = true;
      system.stateVersion = 6;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.backupFileExtension = "backup";
      home-manager.users.${my-username} = import ../home;
    }
  ];

  darwinConfigurations = import ./configurations.nix {
    inherit
      inputs
      specialArgs
      system
      const
      commonModules
      ;
  };

in
{
  inherit darwinConfigurations;
}
