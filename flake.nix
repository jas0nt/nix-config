{
  description = "My NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprlock.url = "github:hyprwm/hyprlock/main";
    hypridle.url = "github:hyprwm/hypridle/main";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }: {
    nixosConfigurations = let
      system = "x86_64-linux";
      mysys = "x86_64-linux";
      special-args = {
        inherit inputs;
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [ "openssl-1.1.1w" ];
          };
        };
      };
    in {
      minimal = nixpkgs.lib.nixosSystem rec {
        system = mysys;
        specialArgs = special-args;
        modules = [ ./hardware/pc ./system/minimal ];
      };

      minimal-proxy = nixpkgs.lib.nixosSystem rec {
        system = mysys;
        specialArgs = special-args;
        modules = [ ./hardware/pc ./system/minimal ./system/proxy.nix ];
      };

      nixos = nixpkgs.lib.nixosSystem rec {
        system = mysys;
        specialArgs = special-args;
        modules = [
          ./hardware/pc
          ./system

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = special-args;
            home-manager.users.jason = import ./home;
          }
        ];
      };

    };
  };
}
