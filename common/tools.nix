{ const }:
{
  substitute-file =
    file:
    let
      text = builtins.readFile file;
      keys = builtins.attrNames const;
      from = map (k: "@${k}@") keys;
      to = map (k: toString const.${k}) keys;
    in
    builtins.replaceStrings from to text;

  scale =
    pkgs: pkg: factor:
    pkgs.symlinkJoin {
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
