{ pkgs, const, ... }:

{
  home.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-rime
        qt6Packages.fcitx5-configtool
      ];
      settings = {
        globalOptions = {
          Behavior = {
            ActiveByDefault = false;
          };
          Hotkey = {
            ActivateKeys = "";
            AltTriggerKeys = "";
            DeactivateKeys = "";
            EnumerateBackwardKeys = "";
            EnumerateForwardKeys = "";
            EnumerateGroupBackwardKeys = "";
            EnumerateGroupForwardKeys = "";
            EnumerateSkipFirst = "False";
            EnumerateWithTriggerKeys = "True";
            ModifierOnlyKeyTimeout = "250";
            NextCandidate = "";
            NextPage = "";
            PrevCandidate = "";
            PrevPage = "";
            TogglePreedit = "";
            TriggerKeys = "";
          };
        };
        addons = {
          classicui.globalSection = {
            "Vertical Candidate List" = "False";
            PerScreenDPI = "True";
            Font = "${const.font-cn} 15";
            Theme = "dracula";
          };
        };
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "rime";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "rime";
        };
      };
      themes = {
        "dracula" = {
          panelImage = ./fcitx5/theme/imgs/panel.png;
          theme =
            let
              color-purple = "#bd93f9";
              color-pink = "#ff79c6";
              color-green = "#50fa7b";
              color-selection = "#44475a";
              color-comment = "#6272a4";
              color-foreground = "#f8f8f2";
              color-background = "#282a36";
            in
            {
              "Metadata" = {
                Name = "dracula";
                Version = "1.0";
                Desc = "Dracula Fcitx5 Theme";
              };
              "InputPanel" = {
                Font = "${const.font-cn} 16";
                NormalColor = color-purple;
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

  home.file = {
    ".local/share/fcitx5/rime" =
      let
        grammar-model = pkgs.fetchurl {
          url = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
          sha256 = "sha256-WnIdOzF9FYyzVs+waD+DHKvAaAI8EQTIYwMD4I9jhVE=";
        };
      in
      {
        source = pkgs.fetchFromGitHub {
          owner = "jas0nt";
          repo = "rime-ice";
          rev = "11fa56f4f4568198ab40847b2ec470bde91c864b";
          sha256 = "sha256-JFCIltaKc8eIYjpBvOVfZTyOpOqxGAZii14fJ1pPbx8=";
          postFetch = ''
            rm $out/default.yaml
            cp ${fcitx5/rime/default.yaml} $out/default.yaml
            cp ${fcitx5/rime/double_pinyin_flypy.custom.yaml} $out/double_pinyin_flypy.custom.yaml
            cp ${fcitx5/rime/custom_phrase_double.txt} $out/custom_phrase_double.txt
            cp ${grammar-model} $out/wanxiang-lts-zh-hans.gram
          '';
        };
        recursive = true;
      };
  };

}
