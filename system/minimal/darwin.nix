{const, ...}:

{
  system.stateVersion = 6;
  system.primaryUser = const.username;

  nix.gc = {
    automatic = true;
    interval = [
      {
        Hour = 3;
        Minute = 15;
        Weekday = 7;
      }
    ];
  };

}
