{
  pkgs,
  ...
}:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    systemctl-tui
    bluez
    libnotify
    qview
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      common.default = "gtk";
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Access" = [ "gtk" ];
        "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        # 用 gtk 的 file chooser，避免额外依赖 nautilus
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };

  services.flatpak.enable = true;

  programs = {
    mosh.enable = true;
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld;
    };
  };
}
