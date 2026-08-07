{ hostname, lib, ... }:
let
  hostDir = ./. + "/${hostname}";

  hostFiles =
    if builtins.pathExists hostDir then
      lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (
        builtins.readDir hostDir
      )
    else
      { };

  hostModules = lib.mapAttrsToList (name: _: hostDir + "/${name}") hostFiles;
in
{
  imports = hostModules;
}
