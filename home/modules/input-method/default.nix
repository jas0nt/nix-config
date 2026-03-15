{ pkgs, ... }:

{
  home.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  stylix.targets.fcitx5 = {
    enable = true;
    fonts.enable = true;
    colors.enable = true;
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
          };
          clipboard.globalSection = {
            "TriggerKey" = "";
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
