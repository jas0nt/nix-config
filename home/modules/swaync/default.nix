{ pkgs, ... }:

{
  services.swaync = {
    enable = true;
    style = builtins.readFile ./config/style.css;
    settings = {
      positionX = "right";
      positionY = "bottom";
      control-center-positionX = "none";
      control-center-positionY = "none";
      control-center-margin-top = 8;
      control-center-margin-bottom = 8;
      control-center-margin-right = 8;
      control-center-margin-left = 8;
      control-center-width = 600;
      control-center-height = 1000;
      fit-to-screen = false;
      layer-shell-cover-screen = true;

      layer-shell = true;
      layer = "overlay";
      control-center-layer = "overlay";
      cssPriority = "user";
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      notification-inline-replies = true;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "always";
      transition-time = 200;
      hide-on-clear = true;
      hide-on-action = true;
      script-fail-notify = true;

      widgets = [
        "inhibitors"
        "dnd"
        "mpris"
        "volume"
        "notifications"
      ];
      widget-config = {
        notifications = {
          vexpand = false;
        };
        inhibitors = {
          text = "Inhibitors";
          button-text = "Clear All";
          clear-all-button = true;
        };
        title = {
          text = "Notifications";
          clear-all-button = false;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        label = {
          max-lines = 5;
          text = "Label Text";
        };
        mpris = {
          autohide = true;
          show-album-art = "always";
          blacklist = [ "firefox" ];
        };
      };
    };
  };

}
