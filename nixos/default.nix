inputs@{
  self,
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  ...
}:
let
  constCommon = import ../common/const/common.nix;
  const = constCommon // import ../common/const/nixos.nix;
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
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.backupFileExtension = "backup";
      home-manager.users.${my-username} = import ../home;
    }
    {
      nixpkgs.config.permittedInsecurePackages = [
        "qtwebengine-5.15.19"
      ];
    }
  ];

  nixosConfigurations = import ./configurations.nix {
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
  inherit nixosConfigurations;
}
