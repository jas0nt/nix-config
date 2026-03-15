{ const, config, ... }:

{
  i18n.inputMethod = {
    fcitx5 = {
      themes = {
        "dracula" = {
          panelImage = ./imgs/panel.png;
          theme =
            let
              color-brown = "#${config.lib.stylix.colors.brown}";
              color-pink = "#${config.lib.stylix.colors.magenta}";
              color-green = "#${config.lib.stylix.colors.green}";
              color-selection = "#${config.lib.stylix.colors.base02}";
              color-comment = "#${config.lib.stylix.colors.base03}";
              color-foreground = "#${config.lib.stylix.colors.base07}";
              color-background = "#${config.lib.stylix.colors.base00}";
            in
            {
              "Metadata" = {
                Name = "dracula";
                Version = "1.0";
                Desc = "Dracula Fcitx5 Theme";
              };
              "InputPanel" = {
                Font = "${const.font-cn} 16";
                NormalColor = color-brown;
                HighlightCandidateColor = color-foreground;
                HighlightColor = color-green;
                HighlightBackgroundColor = "#00000000";
                Spacing = 3;
                borderRadius = 10;
              };
              "InputPanel/TextMargin" = {
                Left = 20;
                Right = 20;
                Top = 10;
                Bottom = 10;
              };
              "InputPanel/Background" = {
                Image = "panel.svg";
              };
              "InputPanel/Background/Margin" = {
                Left = 2;
                Right = 2;
                Top = 2;
                Bottom = 2;
              };
              "InputPanel/Highlight" = {
                Color = color-pink;
              };
              "InputPanel/Highlight/Margin" = {
                Left = 20;
                Right = 20;
                Top = 10;
                Bottom = 10;
              };
              "Menu" = {
                Font = "${const.font-cn} 15";
                NormalColor = color-green;
                Spacing = 3;
              };
              "Menu/Background" = {
                Color = color-background;
              };
              "Menu/Background/Margin" = {
                Left = 2;
                Right = 2;
                Top = 2;
                Bottom = 2;
              };
              "Menu/ContentMargin" = {
                Left = 2;
                Right = 2;
                Top = 2;
                Bottom = 2;
              };
              "Menu/Highlight" = {
                Color = color-selection;
              };
              "Menu/Highlight/Margin" = {
                Left = 10;
                Right = 10;
                Top = 5;
                Bottom = 5;
              };
              "Menu/Separator" = {
                Color = color-comment;
              };
              "Menu/CheckBox" = {
                Image = "radio.svg";
              };
              "Menu/SubMenu" = {
                Image = "arrow.svg";
              };
              "Menu/TextMargin" = {
                Left = 5;
                Right = 5;
                Top = 5;
                Bottom = 5;
              };
            };
        };
      };
    };
  };

}
