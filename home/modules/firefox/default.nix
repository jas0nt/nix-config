{
  stylix.targets.firefox = {
    enable = true;
    colors.enable = true;
    fonts.enable = true;
    profileNames = [ "default" ];
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      name = "default";
      settings = {
        # Customization
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        
        # Rendering & Performance
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
        "gfx.hardware-webrender.enabled" = true;
        "svg.context-properties.content.enabled" = true;
        "dom.ipc.processCount" = -1;  # Auto-detect based on CPU cores
        "browser.cache.disk.enable" = true;
        
        # Wayland-specific
        "widget.wayland.enabled" = true;
        "widget.wayland.fractional-scale.enabled" = true;
        "widget.wayland.vsync.enabled" = true;
        "gfx.wayland.dmabuf-textures.enabled" = true;
        
        # Privacy
        "privacy.trackingprotection.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "network.dns-over-https" = true;
        "network.trr.mode" = 3;
        
        # UI/UX
        "layout.css.devPixelsPerPx" = 1.30;
        "browser.tabs.drawInTitlebar" = true;
        "browser.sessionstore.max_tabs_undo" = 10;
        "browser.urlbar.suggest.searches" = false;
        "mousewheel.default.delta_multiplier_y" = 100;
        
        # Security
        "security.sandbox.content.level" = 4;
        "security.ssl.require_safe_negotiation" = true;
        
        # Other
        "browser.startup.homepage_override.mstone" = "ignore";
      };
      userChrome = (builtins.readFile ./config/userChrome.css);
    };
  };
}
