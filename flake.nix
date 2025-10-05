{
  description = "My NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      const = import ./const.nix;
      my-username = const.username;
      special-args = {
        const = const;
        inherit inputs;
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      };
    in
    {
      nixosConfigurations = {
        minimal = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = special-args;
          modules = [
            ./hardware/pc
            ./system/minimal
            ./system/proxy.nix
          ];
        };

        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
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
              home-manager.users.${my-username} = import ./home;
            }
          ];
        };
      };
    };
}
