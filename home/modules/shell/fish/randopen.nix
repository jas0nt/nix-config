{
  programs.fish = {
    functions = {
      randopen = {
        description = "Randomly open a file from a directory (including subdirectories)";
        body = ''
          argparse h/help a/all n/dry-run 'e/ext=+' 'x/exclude=+' -- $argv
          or return 1

          if set -q _flag_help
              echo "Usage: randopen [-a] [-n] [-e EXT]... [-x EXT]... [DIR]"
              echo "  -a, --all          Include hidden files and directories"
              echo "  -n, --dry-run      Only print the selected file, don't open it"
              echo "  -e, --ext EXT      Only include these extensions, repeatable (e.g. -e jpg -e png)"
              echo "  -x, --exclude EXT  Exclude these extensions, repeatable (e.g. -x txt -x md)"
              return 0
          end

          set -l shuf_cmd
          if type -q shuf
              set shuf_cmd shuf
          else if type -q gshuf
              set shuf_cmd gshuf
          else
              echo "shuf not found (on macOS: brew install coreutils)" >&2
              return 1
          end

          set -l dir .
          set -q argv[1]; and set dir $argv[1]
          if not test -d "$dir"
              echo "Not a valid directory: $dir" >&2
              return 1
          end

          set -l expr
          if not set -q _flag_all
              set expr '(' -name '.*' -prune ')' -o
          end

          set -l typeexpr -type f

          # Include: match any one of the extensions
          if set -q _flag_ext
              set -l names
              for i in (seq (count $_flag_ext))
                  test $i -gt 1; and set -a names -o
                  set -a names -iname "*.$_flag_ext[$i]"
              end
              set -a typeexpr '(' $names ')'
          end

          # Exclude: none of the extensions may match
          for e in $_flag_exclude
              set -a typeexpr -not -iname "*.$e"
          end

          set -a expr '(' $typeexpr -print0 ')'

          set -l file (find $dir -mindepth 1 $expr 2>/dev/null | $shuf_cmd -z -n 1 | string split0)

          if test -z "$file"
              echo "No files found" >&2
              return 1
          end

          echo "→ $file"
          set -q _flag_dry_run; and return 0

          set -l opener
          switch (uname)
              case Darwin
                  set opener open
              case '*'
                  set opener xdg-open
          end
          if not type -q $opener
              echo "$opener not found" >&2
              return 1
          end

          command $opener "$file"
        '';
      };
    };
  };
}
