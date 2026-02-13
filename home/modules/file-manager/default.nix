{ const, config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    initLua = ./init.lua;
    settings = {
      log = {
        enabled = false;
      };
      mgr = {
        show_hidden = false;
        linemode = "size_and_mtime";
        sort_by = "mtime";
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
        image_alloc = 536870912;
        file_workers = 5;
        preload_workers = 8;
        process_workers = 5;
        image_bound = [ 0 0 ];
      };
      plugin = {
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
    plugins = {
      smart-enter = pkgs.yaziPlugins.smart-enter;
      mediainfo = pkgs.yaziPlugins.mediainfo;
      projects = pkgs.yaziPlugins.projects;
      bookmarks = pkgs.yaziPlugins.bookmarks;
      lazygit = pkgs.yaziPlugins.lazygit;
      mount = pkgs.yaziPlugins.mount;
    };
    keymap = {
      input.prepend_keymap = [
        { run = "close"; on = [ "<Esc>" ]; }
      ];
      mgr.prepend_keymap = [
        { run = "plugin --sync smart-enter"; on = [ "<Enter>" ]; }
        { run = "linemode size_and_mtime"; on = [ "m" "a" ]; }
        { run = "shell 'dua i .' --block"; on = [ "m" "S" ]; }
        { run = "shell --orphan --confirm ${const.terminal}"; on = [ "T" ]; }
        { run = "shell 't=$(mktemp --suffix=.jpg); ffmpegthumbnailer -i \"$0\" -o \"$t\" -s 0 -c jpeg -f >/dev/null 2>&1; qview \"$t\" >/dev/null 2>&1; rm \"$t\"' --block"; on = [ "e" ]; }

        { run = "plugin projects save"; on = [ "P" "s" ]; }
        { run = "plugin projects load_last"; on = [ "P" "p" ]; }
        { run = "plugin projects load"; on = [ "P" "l" ]; }
        { run = "plugin projects delete"; on = [ "P" "d" ]; }
        { run = "plugin projects delete_all"; on = [ "P" "D" ]; }

        { run = "plugin bookmarks jump"; on = [ "'" ]; }
        { run = "plugin bookmarks save"; on = [ "b" "b" ]; }
        { run = "plugin bookmarks delete"; on = [ "b" "d" ]; }
        { run = "plugin bookmarks delete_all"; on = [ "b" "D" ]; }

        { run = "plugin zoxide"; on = [ "z" ]; }
        { run = "plugin fzf"; on = [ "Z" ]; }
        { run = "plugin lazygit"; on = [ "g" "i" ]; }
        { run = "plugin mount"; on = [ "M" ]; }
      ];
    };
  };
}
