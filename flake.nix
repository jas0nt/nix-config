{
  description = "My NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    {
      nixosConfigurations =
        let
          system = "x86_64-linux";
          mysys = "x86_64-linux";
          special-args = {
            inherit inputs;
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [];
              config = {
                allowUnfree = true;
                permittedInsecurePackages = [ "openssl-1.1.1w" ];
              };
            };
            pkgs-unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };
          };
        in
        {
          minimal = nixpkgs.lib.nixosSystem rec {
            system = mysys;
            specialArgs = special-args;
            modules = [
              ./hardware/pc
              ./system/minimal
            ];
          };

          nixos = nixpkgs.lib.nixosSystem rec {
            system = mysys;
            specialArgs = special-args;
            modules = [
              ./hardware/pc
              ./system
              # ./system/proxy.nix

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = special-args;
                home-manager.backupFileExtension = "backup";
                home-manager.users.jason = import ./home;
              }
            ];
          };

        };
    };
}
