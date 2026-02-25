{
  security.pam.services = {
    hyprlock = {
      unixAuth = true;
      rootOK = true;
    };
  };

  programs.fuse.userAllowOther = true;
}
