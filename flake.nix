{
  description = "My NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
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
    rauncher.url = "github:jas0nt/Rauncher";
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
      my-username = "jason";
      my-system = "x86_64-linux";
    in
    {
      nixosConfigurations =
        let
          system = my-system;
          special-args = {
            const.username = my-username;
            const.terminal = "kitty";
            inherit inputs;
            pkgs-unstable = import inputs.nixpkgs-unstable {
              inherit system;
              # overlays = [ ];
              config = {
                allowUnfree = true;
              };
            };
          };
        in
        {
          minimal = nixpkgs.lib.nixosSystem rec {
            system = my-system;
            specialArgs = special-args;
            modules = [
              ./hardware/pc
              ./system/minimal
              ./system/proxy.nix
            ];
          };

          nixos = nixpkgs.lib.nixosSystem rec {
            system = my-system;
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
