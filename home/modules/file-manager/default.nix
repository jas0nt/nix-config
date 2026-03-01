{ const, config, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    file
    ffmpegthumbnailer
    mediainfo
    poppler-utils
  ];

  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    initLua = ./init.lua;
    plugins = {
      smart-enter = pkgs-unstable.yaziPlugins.smart-enter;
      mediainfo = pkgs-unstable.yaziPlugins.mediainfo;
      projects = pkgs-unstable.yaziPlugins.projects;
      bookmarks = pkgs-unstable.yaziPlugins.bookmarks;
      lazygit = pkgs-unstable.yaziPlugins.lazygit;
      mount = pkgs-unstable.yaziPlugins.mount;
      compress = pkgs-unstable.yaziPlugins.compress;
      mime-ext = pkgs-unstable.yaziPlugins.mime-ext;
      task-queue = ./plugins/task-queue;
    };
    settings = {
      log = {
        enabled = false;
      };
      mgr = {
        show_hidden = false;
        linemode = "none";
        sort_by = "natural";
        sort_dir_first = true;
        sort_reverse = true;
      };
      preview = {
        cache_dir = config.home.homeDirectory + "/.cache/yazi";
        max_width = 1920;
        max_height = 1080;
        image_quality = 50;
        image_delay = 0;
      };
      tasks = {
        image_alloc = 1073741824; 
        file_workers = 4;
        preload_workers = 16;
        process_workers = 4;
        image_bound = [ 0 0 ];
      };
      plugin = {
        default_fetchers = [];
        append_fetchers = [];
        prepend_fetchers = [
          { id = "mime"; url = "local://*"; run = "mime-ext.local"; prio = "high"; }
          { id = "mime"; url = "remote://*"; run = "mime-ext.remote"; prio = "high"; }
        ];
        prepend_preloaders = [
          { mime = "{audio,video,image}/*"; run = "mediainfo"; }
          { mime = "application/subrip"; run = "mediainfo"; }
          { mime = "application/postscript"; run = "mediainfo"; }
        ];
        prepend_previewers = [
          { mime = "{audio,video,image}/*"; run = "mediainfo"; }
          { mime = "application/subrip"; run = "mediainfo"; }
          { mime = "application/postscript"; run = "mediainfo"; }
        ];
      };
    };
    keymap = {
      input.prepend_keymap = [
        { run = "close"; on = [ "<Esc>" ]; }
      ];
      mgr.prepend_keymap = [
        { run = "shell \"$SHELL\" --block"; on = [ "!" ]; }
        { run = "shell --orphan --confirm ${const.terminal}"; on = [ "T" ]; }
        { run = "shell 't=$(mktemp --suffix=.jpg); ffmpegthumbnailer -i \"$0\" -o \"$t\" -s 0 -c jpeg -f >/dev/null 2>&1; qview \"$t\" >/dev/null 2>&1; rm \"$t\"' --block"; on = [ "e" ]; }

        { run = "remove";                         on = [ "D" ]; }
        { run = "remove --permanently";           on = [ "d" ]; }
        { run = "shell 'dua i .' --block";        on = [ "m" "S" ]; }
        { run = "linemode size_and_mtime";        on = [ "m" "a" ]; }

        { run = "plugin task-queue insert";       on = [ "I" ]; }
        { run = "plugin --sync smart-enter";      on = [ "<Enter>" ]; }
        { run = "plugin zoxide";                  on = [ "z" ]; }
        { run = "plugin fzf";                     on = [ "Z" ]; }
        { run = "plugin lazygit";                 on = [ "g" "i" ]; }
        { run = "plugin mount";                   on = [ "M" ]; }

        { run = "plugin projects save";           on = [ "P" "s" ]; }
        { run = "plugin projects load_last";      on = [ "P" "p" ]; }
        { run = "plugin projects load";           on = [ "P" "l" ]; }
        { run = "plugin projects delete";         on = [ "P" "d" ]; }
        { run = "plugin projects delete_all";     on = [ "P" "D" ]; }

        { run = "plugin bookmarks jump";          on = [ "'" ]; }
        { run = "plugin bookmarks save";          on = [ "b" "b" ]; }
        { run = "plugin bookmarks delete";        on = [ "b" "d" ]; }
        { run = "plugin bookmarks delete_all";    on = [ "b" "D" ]; }

        { run = "plugin compress";                on = [ "C" "c" ]; desc = "Archive selected files"; }
        { run = "plugin compress -p";             on = [ "C" "p" ]; desc = "Archive selected files (password)"; }
        { run = "plugin compress -ph";            on = [ "C" "h" ]; desc = "Archive selected files (password+header)"; }
        { run = "plugin compress -phl";           on = [ "C" "l" ]; desc = "Archive selected files (password+header+level)"; }
      ];
    };
  };
}
