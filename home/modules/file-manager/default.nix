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

  satchel = cmd: "plugin dired-satchel ${cmd}";

  videoRule = {
    mime = "video/*";
    run = "video-shared";
  };
  mediainfoRules =
    map
      (mime: {
        inherit mime;
        run = "mediainfo";
      })
      [
        "{audio,image}/*"
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
      dired-satchel = ./plugins/dired-satchel;
      video-shared = ./plugins/video-shared;
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
        prepend_preloaders = [ videoRule ] ++ mediainfoRules;
        prepend_previewers = [ videoRule ] ++ mediainfoRules;
      };
    };

    keymap = {
      input.prepend_keymap = [
        (k "<Esc>" "close" "")
      ];

      mgr.prepend_keymap = [
        (k "`" "shell --orphan --confirm ${const.terminal}" "")
        (k "q" "escape" "")
        (k [ "m" "S" ] "shell 'dua i .' --block" "")
        (k [ "m" "a" ] "linemode size_and_mtime" "")

        # ---- tabs / history / visual ----
        (k [ "t" "t" ] "tab_create --current" "New tab")
        (k [ "t" "c" ] "tab_close" "Close tab")
        (k "H" "tab_switch -1 --relative" "Previous tab")
        (k "L" "tab_switch 1 --relative" "Next tab")
        (k "<A-h>" "back" "History back")
        (k "<A-l>" "forward" "History forward")
        (k "V" "visual_mode" "Visual mode")
        (k "<A-v>" "visual_mode --unset" "Visual mode (unset)")

        # ---- dired-satchel ----
        (k "y" (satchel "pack") "Pack (SCRIPT) / yank (LIVE)")
        (k "x" (satchel "cut") "Pack (SCRIPT) / cut (LIVE)")
        (k "Y" (satchel "unpack") "Empty satchel")
        (k "X" (satchel "unpack") "Empty satchel")
        (k "p" (satchel "paste") "Paste (asks before overwriting)")
        (k "d" (satchel "delete") "Delete permanently")

        # ---- `v` menu (stands in for satchel-transient) ----
        (k [ "v" "x" ] (satchel "run") "Run queue / leftover script")
        (k [ "v" "s" ] (satchel "preview") "Preview script")
        (k [ "v" "v" ] (satchel "status") "Queue status / progress")
        (k [ "v" "u" ] (satchel "undo") "Undo last queued op")
        (k [ "v" "r" ] (satchel "unqueue") "Remove selected/hovered files from queue and satchel")
        (k [ "v" "c" ] (satchel "clear") "Clear queue and script")
        (k [ "v" "y" ] (satchel "unpack") "Empty satchel")
        (k [ "v" "t" ] (satchel "toggle") "Toggle SCRIPT / LIVE mode")
        (k [ "v" "i" ] (satchel "insert") "Queue Yazi's yank buffer here")

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
