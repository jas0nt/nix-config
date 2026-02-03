{ const, config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    settings = {
      log = {
        enabled = false;
      };
      tasks.image_alloc = 1073741824;
      mgr = {
        show_hidden = false;
        linemode = "mtime";
        sort_by = "mtime";
        sort_dir_first = true;
        sort_reverse = true;
      };
      preview = {
        cache_dir = config.home.homeDirectory + "/.cache/yazi";
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
      lazygit = pkgs.yaziPlugins.lazygit;
      mediainfo = pkgs.yaziPlugins.mediainfo;
      mount = pkgs.yaziPlugins.mount;
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          run = "shell --orphan --confirm ${const.terminal}";
          on = [ "T" ];
        }
        {
          run = "plugin zoxide";
          on = [ "z" ];
        }
        {
          run = "plugin fzf";
          on = [ "Z" ];
        }
        {
          run = "plugin lazygit";
          on = [ "g" "i" ];
        }
        {
          run = "plugin mount";
          on = [ "M" ];
        }
      ];
    };
  };
}
