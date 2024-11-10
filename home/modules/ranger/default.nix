{
  programs.ranger = {
    enable = true;
    settings = {
      column_ratios = "1,3,3";
      confirm_on_delete = "never";
      preview_files = false;
      preview_directories = false;
      preview_images = true;
      preview_images_method = "kitty";
      sort = "mtime";
      sort_reverse = false;
      default_linemode = "sizemtime";
    };
    rifle = [
      # https://github.com/ranger/ranger/blob/master/ranger/config/rifle.conf
      { condition = "ext x?html?, X, flag f"; command = "firefox -- \"$@\""; }
      { condition = "ext x?pdf?, X, flag f"; command = "firefox -- \"$@\""; }

      { condition = "ext torrent"; command = "qbittorrent \"$1\""; }

      # Misc settings for text files
      { condition = "mime ^text, label editor"; command = "vim -- \"$@\""; }
      { condition = "mime ^text, label pager"; command = "$PAGER -- \"$@\""; }
      { condition = "!mime ^text, label editor, ext xml|json|csv|tex|py|pl|rb|js|sh|php"; command = "vim -- \"$@\""; }
      { condition = "!mime ^text, label pager, ext xml|json|csv|tex|py|pl|rb|js|sh|php"; command = "$PAGER -- \"$@\""; }

      # Manpages and executables
      { condition = "ext 1"; command = "man \"$1\""; }
      { condition = "ext s[wmf]c, has zsnes, X"; command = "zsnes \"$1\""; }
      { condition = "ext s[wmf]c, has snes9x-gtk, X"; command = "snes9x-gtk \"$1\""; }
      { condition = "ext nes, has fceux, X"; command = "fceux \"$1\""; }
      { condition = "ext exe"; command = "wine \"$1\""; }

      # Scripting languages
      { condition = "ext py"; command = "python -- \"$1\""; }
      { condition = "ext pl"; command = "perl -- \"$1\""; }
      { condition = "ext rb"; command = "ruby -- \"$1\""; }
      { condition = "ext js"; command = "node -- \"$1\""; }
      { condition = "ext sh"; command = "sh -- \"$1\""; }

      # Audio without X
      { condition = "mime ^audio|ogg$, terminal, has mpv"; command = "mpv -- \"$@\""; }

      # Video/audio with GUI
      { condition = "mime ^video, has mpv, X, flag f"; command = "mpv -- \"$@\""; }
      { condition = "mime ^video, has mpv, X, flag f"; command = "mpv --fs -- \"$@\""; }
      { condition = "mime ^video|audio, has vlc, X, flag f"; command = "vlc -- \"$@\""; }

      # Images
      { condition = "mime ^image/svg, has qview, X, flag f"; command = "qview -- \"$@\""; }
      { condition = "mime ^image, has qview, X, flag f"; command = "qview -- \"$@\""; }
      { condition = "mime ^image, has imv, X, flag f"; command = "imv -- \"$@\""; }
      { condition = "mime ^image, has gimp, X, flag f"; command = "gimp -- \"$@\""; }
      { condition = "ext xcf, X, flag f"; command = "gimp -- \"$@\""; }

      # Fonts
      { condition = "mime ^font, has fontforge, X, flag f"; command = "fontforge \"$@\""; }
      
      # Terminal emulators
      { condition = "mime ^ranger/x-terminal-emulator, has kitty"; command = "kitty -- \"$@\""; }
      { condition = "mime ^ranger/x-terminal-emulator, has alacritty"; command = "alacritty -e \"$@\""; }

      # Generic openers
      { condition = "label open, has xdg-open"; command = "xdg-open -- \"$@\""; }
      { condition = "label open, has open"; command = "open -- \"$@\""; }
    ];
  };

}
