{
  inputs,
  specialArgs,
  system,
  const,
  commonModules,
  ...
}:
{
  mbp2018 = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = specialArgs;
    modules = commonModules ++ [
      ../hosts/mbp2018
    ];
  };
}
