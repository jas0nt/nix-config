{ pkgs, ... }:

{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-configtool
      fcitx5-chinese-addons
    ];
  };

  home.file = {
    ".config/fcitx5/profile".source                                        = ./fcitx5/conf/profile;
    ".config/fcitx5/conf/classicui.conf".source                            = ./fcitx5/conf/classicui.conf;
    ".local/share/fcitx5/themes/dracula"                                   = { recursive = true; source = ./fcitx5/themes/dracula; };
    ".local/share/fcitx5/rime/default.custom.yaml".source                  = ./fcitx5/rime/default.custom.yaml;
    ".local/share/fcitx5/rime/double_pinyin_flypy.schema.yaml".source      = ./fcitx5/rime/double_pinyin_flypy.schema.yaml;
  };
}
