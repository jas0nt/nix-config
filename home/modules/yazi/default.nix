{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    enableFishIntegration = true;
    settings = {
      log = {
        enabled = false;
      };
      manager = {
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
      manager.prepend_keymap = [
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
