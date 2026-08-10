{
  services.mako = {
    enable = true;
    settings = {
      width = 500;
      height = 250;
      margin = 15;
      padding = 15;
      border-size = 2;
      border-radius = 20;
      default-timeout = 5000;
      sort = "-time";
      anchor = "bottom-right";
      max-visible = 5;
    };

  };

  wayland.windowManager.sway.config.startup = [
    { command = "mako"; }
  ];
}
