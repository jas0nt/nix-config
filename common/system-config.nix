{
  inputs,
  nixpkgs-unstable,
  constFile,
  extraModules ? [ ],
  extraConfig ? { },
  homeManagerModule,
  hostname,
  ...
}:

let
  const = import ./const/common.nix // import constFile;
  inherit (const) system;
  tools = import ./tools.nix { inherit const; };

  pkgConfig = {
    allowUnfree = true;
    permittedInsecurePackages = [ ];
  };

  specialArgs = {
    inherit
      inputs
      const
      tools
      hostname
      ;
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = pkgConfig;
    };
  };
in
{
  inherit system specialArgs;

  modules = [
    ../system
    homeManagerModule
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = specialArgs;
        backupFileExtension = "backup";
        users.${const.username} = import ../home;
      };
      nixpkgs.config = pkgConfig;
    }
  ]
  ++ extraModules
  ++ [
    extraConfig
    ../hosts/${hostname}
  ];
}
