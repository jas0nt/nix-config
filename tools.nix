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

  scale = pkgs: pkg: factor: pkgs.symlinkJoin {
    name = "${pkg.name}-scaled";
    paths = [ pkg ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for f in $out/bin/*; do
        wrapProgram $f \
          --set QT_SCALE_FACTOR "${toString factor}" \
          --set GDK_DPI_SCALE "${toString factor}"
      done
    '';
  };

}
