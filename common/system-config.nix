{
  inputs,
  nixpkgs-unstable,
  constFile,
  extraModules ? [ ],
  extraConfig ? { },
  homeManagerModule,
  systemType,
  hostname,
  ...
}:

let
  constCommon = import ./const/common.nix;
  const = constCommon // import constFile;
  system = const.system;
  tools = (import ./tools.nix) { const = const; };

  pkgConfig = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "qtwebengine-5.15.19"
    ];
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
      config.allowUnfree = true;
    };
  };

  commonModules = [
    ../system
    homeManagerModule
    {
      home-manager.useGlobalPkgs = false;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = specialArgs // {
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = pkgConfig;
        };
      };
      home-manager.backupFileExtension = "backup";
      home-manager.users.${const.username} = import ../home;
    }
  ]
  ++ extraModules;

  config = {
    nixpkgs.config = pkgConfig;
  }
  // extraConfig;

  commonModulesWithConfig = commonModules ++ [ config ];

in
{
  system = system;
  specialArgs = specialArgs;
  modules = commonModulesWithConfig ++ [
    ../hosts/${hostname}
  ];
}
