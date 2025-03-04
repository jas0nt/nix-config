{
  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "default";
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
        "svg.context-properties.content.enabled" = true;
        "layout.css.devPixelsPerPx" = 1.25;
      };
      userChrome = (builtins.readFile ./config/userChrome.css);
    };
  };
}
