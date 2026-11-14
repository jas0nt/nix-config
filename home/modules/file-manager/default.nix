{
  const,
  tools,
  config,
  pkgs,
  lib,
  ...
}:

let
  # Keymap helper: k <keys> <run> <desc>   (desc = "" omits the desc field)
  k =
    on: run: desc:
    {
      inherit run;
      on = lib.toList on;
    }
    // lib.optionalAttrs (desc != "") { inherit desc; };

  mediainfoRules =
    map
      (mime: {
        inherit mime;
        run = "mediainfo";
      })
      [
        "{audio,video,image}/*"
        "application/subrip"
        "application/postscript"
      ];
in
{
  home.packages =
    with pkgs;
    [
      file
      ffmpegthumbnailer
      mediainfo
      poppler-utils
    ]
    ++ lib.optionals const.is-linux [
      (tools.scale pkgs pcmanfm 1.6)
    ];

  stylix.targets.yazi = {
    enable = true;
    colors.enable = true;
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    initLua = ./init.lua;

    plugins = {
      inherit (pkgs.yaziPlugins)
        smart-enter
        mediainfo
        projects
        bookmarks
        lazygit
        mount
        compress
        mime-ext
        ;
    };

    settings = {
      mgr = {
        linemode = "mtime";
        sort_by = "natural";
      };
      preview = {
        cache_dir = "${config.xdg.cacheHome}/yazi";
        max_width = 3840;
        max_height = 2160;
        image_quality = 90;
        image_delay = 0;
      };
      tasks = {
        image_alloc = 1073741824;
        file_workers = 4;
        micro_workers = 16;
        preload_workers = 16;
        process_workers = 4;
      };
      plugin = {
        prepend_fetchers = [
          {
            group = "default";
            id = "mime";
            url = "local://*";
            run = "mime-ext.local";
            prio = "high";
          }
          {
            group = "default";
            id = "mime";
            url = "remote://*";
            run = "mime-ext.remote";
            prio = "high";
          }
        ];
        prepend_preloaders = mediainfoRules;
        prepend_previewers = mediainfoRules;
      };
    };

    keymap = {
      input.prepend_keymap = [
        (k "<Esc>" "close" "")
      ];

      mgr.prepend_keymap = [
        (k "j" "arrow 1" "Next")
        (k "k" "arrow -1" "Prev")

        (k "`" "shell --orphan --confirm ${const.terminal}" "")
        (k "q" "escape" "")
        (k [ "m" "S" ] "shell 'dua i .' --block" "")
        (k [ "m" "a" ] "linemode size_and_mtime" "")

        (k "H" "tab_switch -1 --relative" "Previous tab")
        (k "L" "tab_switch 1 --relative" "Next tab")
        (k "<A-h>" "back" "History back")
        (k "<A-l>" "forward" "History forward")

        # ---- plugins ----
        (k "<Enter>" "plugin smart-enter" "")
        (k "z" "plugin zoxide" "")
        (k "Z" "plugin fzf" "")
        (k [ "g" "i" ] "plugin lazygit" "")
        (k "M" "plugin mount" "")

        # projects
        (k [ "P" "s" ] "plugin projects save" "")
        (k [ "P" "p" ] "plugin projects load_last" "")
        (k [ "P" "l" ] "plugin projects load" "")
        (k [ "P" "d" ] "plugin projects delete" "")
        (k [ "P" "D" ] "plugin projects delete_all" "")

        (k "'" "plugin bookmarks jump" "")
        (k [ "b" "b" ] "plugin bookmarks save" "")
        (k [ "b" "d" ] "plugin bookmarks delete" "")
        (k [ "b" "D" ] "plugin bookmarks delete_all" "")

        (k [ "C" "c" ] "plugin compress" "Archive selected files")
        (k [ "C" "p" ] "plugin compress -p" "Archive selected files (password)")
        (k [ "C" "h" ] "plugin compress -ph" "Archive selected files (password+header)")
        (k [ "C" "l" ] "plugin compress -phl" "Archive selected files (password+header+level)")
      ];
    };
  };
}
