{ const, lib, ... }:

{
  imports = [
    ./user.nix
    ./sys-pkgs.nix
  ]
  ++ lib.optionals const.is-linux [
    ./linux.nix
    ./boot
    ./networking.nix
  ]
  ++ lib.optionals const.is-darwin [
    ./darwin.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    builders-use-substitutes = true;
  };

}
