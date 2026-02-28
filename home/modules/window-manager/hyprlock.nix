{
  config,
  ...
}:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = [
        {
          monitor = "";
          path = "${config.home.homeDirectory}/wallpaper/dune.jpg";
          blur_passes = 0;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          position = "0, 60";
          dots_size = 0.26;
          dots_spacing = 0.64;
          dots_center = true;
          fade_on_empty = true;
          font_color = "rgb(40, 42, 54)";
          inner_color = "rgb(243, 156, 54)";
          outer_color = "rgb(243, 156, 54)";
          outline_thickness = 3;
          placeholder_text = "<i>Password...</i>";
          shadow_passes = 2;
          halign = "center";
          valign = "bottom";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<b><big> $(date +\"%H:%M:%S\") </big></b>\"";
          font_family = "Pecita";
          font_size = 110;
          color = "rgb(0, 0, 0)";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:18000000] echo \"<b> \"$(date +'%A, %-d %B %Y')\" </b>\"";
          font_family = "Pecita";
          font_size = 50;
          color = "rgb(0, 0, 0)";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
