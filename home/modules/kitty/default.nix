{
  programs.kitty = {
    enable = true;
    theme = "Dracula";
    font = {
      name = "FiraCode Nerd Font";
      size = 15.0;
    };
    settings = {
      confirm_os_window_close = 0;
    };
    keybindings = {
      "kitty_mod+c" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";
      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
    };
  };

  # home.file = {
  #   ".config/kitty" = { recursive = true; source = ./config; };
  # };

}
