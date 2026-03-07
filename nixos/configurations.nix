{
  inputs,
  specialArgs,
  system,
  const,
  commonModules,
  ...
}:
{
  pc = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = specialArgs;
    modules = commonModules ++ [
      ../hosts/pc
      # ../system/proxy.nix
    ];
  };
}
