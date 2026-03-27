{
  security.pam.services = {
    swaylock = {
      unixAuth = true;
      rootOK = true;
    };
  };

  programs.fuse.userAllowOther = true;
}
