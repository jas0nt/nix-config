{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    settings = {
      log = {
        enabled = false;
      };
      manager = {
        show_hidden = false;
        linemode = "mtime";
        sort_by = "modified";
        sort_dir_first = true;
        sort_reverse = true;
      };
    };
  };
}
