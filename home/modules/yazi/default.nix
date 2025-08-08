{ pkgs, ... }:

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
      mgr = {
        show_hidden = false;
        linemode = "mtime";
        sort_by = "mtime";
        sort_dir_first = true;
        sort_reverse = true;
      };
    };
    plugins = {
      lazygit = pkgs.yaziPlugins.lazygit;
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          run = "shell --orphan --confirm kitty";
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
      ];
    };
  };
}
