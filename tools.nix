let
  const = import ./const.nix;
in
{
  substitute-file =
    file:
    let
      keys = builtins.attrNames const;
      patterns = map (k: "@${k}@") keys;
      replacements = map (k: const.${k}) keys;
    in
    builtins.replaceStrings patterns replacements (builtins.readFile file);
}
