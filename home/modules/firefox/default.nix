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
      };
      userChrome = (builtins.readFile ./config/userChrome.css);
    };
  };
}
