{
  programs.kitty = {
    enable = true;
    themeFile = "Dracula";
    font = {
      # name = "FiraCode Nerd Font";
      name = "Recursive Mono Casual Static";
      size = 16;
    };
    settings = {
      dynamic_background_opacity = "no";
      background_opacity = "0.8";
      background_blur = "0";

      cursor_shape = "block";
      cursor_blink_interval = "0";

      allow_hyperlinks = "no";
      confirm_os_window_close = 0;
      copy_on_select = "clipboard";
      detect_urls = "no";
      focus_follows_mouse = "yes";
      select_by_word_characters = "$}{/&@_.";
      strip_trailing_spaces = "smart";
    };
    extraConfig = ''
      mouse_map right press grabbed,ungrabbed no-op
      mouse_map right click grabbed,ungrabbed paste_from_clipboard
    '';
    keybindings = {
      "kitty_mod+c" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";
      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
    };
  };

}
