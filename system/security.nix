{
  security.pam.services.hyprlock = {
    unixAuth = true;
    rootOK = false;
  };

  programs.fuse.userAllowOther = true;
}
